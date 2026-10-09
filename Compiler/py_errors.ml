[@@@module {%unfold|~/u/topcore/prgpy-parse|}]
[@@@module {%unfold|~/u/topcore/prgpy-compile|}]
[@@@module {%unfold|~/u/topcore/prgpy-sym|} [@prefixed? "prgpy-"]]
[@@@module {%unfold|~/u/topcore/prgpy-stdlib|} [@prefixed? "prg"]]
[@@@module {%unfold|~/u/topcore/prgpy-interp|} [@prefixed? "prg"]]
[@@@module {%unfold|~/u/topcore/import|}]
open Prgpy_parse
open Prgpy_compile

let reset = "\x1B[0m"

let purple = "\x1B[0;35m"

let bold_red = "\x1B[1;31m"

let bold_purple = "\x1B[1;35m"

let number_charlen d =
  if d = 0 then 1 else
  Float.to_int @@ Float.floor ((Float.log10 (Float.of_int d)) +. 1.)

let print_preview fmt ~filename ~linenum ~col ~col_range ~text =
  Format.fprintf fmt "Traceback (most recent call last):\n";
  Format.fprintf fmt "  File \x1B[0;35m\"%s\"\x1B[0m, line \x1B[0;35m%d\x1B[0m, in \x1B[0;35m%s\x1B[0m\n" filename linenum "<module>";
  let line = List.nth (text |> String.split_on_char '\n') (linenum - 1) in
  let line_highlighted =
    let buffer = Buffer.create (String.length line) in
    String.to_seqi line |> Seq.iter (fun (i, c) ->
      if i = col then begin
        Buffer.add_string buffer "\x1B[1;31m"
      end else if i = (col + col_range) then begin
        Buffer.add_string buffer "\x1B[0m"
      end;
      Buffer.add_char buffer c
    );
    Buffer.contents buffer
  in
  Format.fprintf fmt "    %s\n" line_highlighted;
  Format.fprintf fmt "    %s\x1B[1;31m%s\x1B[0m\n" (String.init col (fun _ -> ' ')) (String.init col_range (fun _ -> '^'))

let similar_compare' against_arr ref_arr =
  let against_ptr = ref 0 in
  let against_len = Array.length against_arr in
  let ref_ptr = ref 0 in
  let ref_len = Array.length ref_arr in
  let score = ref 0 in
  while (!against_ptr < against_len) && (!ref_ptr < ref_len) do
    if Char.equal against_arr.(!against_ptr) ref_arr.(!ref_ptr) then begin
      ref_ptr := !ref_ptr + 1;
      against_ptr := !against_ptr + 1;
      score := !score + 1;
    end else begin
      ref_ptr := !ref_ptr + 1;
      score := Int.max (!score - 1) 0;
    end
  done;
  (Int.to_float !score) /. (Int.to_float ref_len)

type _ Effect.t +=
  | GetSourcemap : ([`file of string] * string) Effect.t

let get_sourcemap () = Effect.perform GetSourcemap

let with_sourcemap fmt (mktext : string -> string) (`file filename) f =
  let text =
    try mktext filename with
    | Sys_error msg as exn ->
      Format.fprintf fmt "\x1B[1;31mError\x1B[0m: I/O error: %s\n" msg;
      raise exn
  in
  match f text with v -> v | effect GetSourcemap, k -> Effect.Deep.continue k (`file filename, text)

let report_error fmt exn =
  let `file filename, text = get_sourcemap () in
  match exn with
  | Py_stdlib.Hashtbl.Tbl_not_found (requested_name, `meta (lazy (Py_interp.Closure (heap, `meta (lazy textobj))))) ->
    let linenum, col = match Prgpy_compile.unlock_closure_meta Prgpy_compile.pexpr textobj with Sym.Pexp_var (_, `meta (lazy (linenum, col))) -> linenum, col | _ -> failwith "MABNN" in
    print_preview fmt ~filename ~linenum ~col ~col_range:(String.length requested_name) ~text;
    let name = requested_name in
    let name' = name |> String.to_seq |> Array.of_seq in
    let keys = Hashtbl.fold (fun key _ acc -> ((similar_compare' (key |> String.to_seq |> Array.of_seq) name'), key) :: acc) heap [] in
    let keys = keys |> List.sort (fun (a, _) (b, _) -> Float.compare a b) |> List.filter (fun (x, _) -> x > 0.4) |> List.rev |> List.map (fun (_, x) -> x) in
    let suggestion = match keys with [] -> None | xs -> Some xs in
    Format.fprintf fmt "\x1B[1;35mNameError\x1B[0m: \x1B[0;35mname '%s' is not defined" requested_name;
    (
      match suggestion with
      | Some (hintvar :: []) -> Format.fprintf fmt ". Did you mean: '%s'?\x1B[0m\n" hintvar
      | Some (hintvar1 :: hintvar2 :: _) -> Format.fprintf fmt ". Did you mean: '%s' or '%s'?\x1B[0m\n" hintvar1 hintvar2
      | Some [] | None -> Format.fprintf fmt "\x1B[0m\n"
    )
  | exn ->
    Format.fprintf fmt "%s\n" (Printexc.to_string exn)

let report_effects fmtwarn mkeff =
  let `file filename, _ = get_sourcemap () in
  match mkeff () with
  | v -> v
  | effect Py_stdlib.Hashtbl.Tbl_unused (name, `meta _), k ->
    Format.fprintf fmtwarn "%s:?: " filename;
    Format.fprintf fmtwarn "UnusedVarWarning: unused variable %s.\n" name;
    Effect.Deep.continue k ()

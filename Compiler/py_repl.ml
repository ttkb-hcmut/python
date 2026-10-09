[@@@module (
  Out_channel.with_open_text "/tmp/py_repl__sys.ml" @@ fun c -> output_string c {|let ocaml_release = Sys.ocaml_release|};
  "/tmp/py_repl__sys.ml"
)]

open Eio

let welcome_msg =
  "Python ?.?.? () [OCaml "^ Int.to_string Py_repl__sys.ocaml_release.major ^"] on linux\nType \"help\", \"copyright\", \"credits\" or \"license\" for more information."

let main env =
  let to_stderr = Stdenv.stderr env in
  let from_stdin = Stdenv.stdin env in
  Flow.copy_string welcome_msg to_stderr;
  Flow.copy_string "\n\x1B[1;35m>>>\x1B[0m " to_stderr;
  let s = Flow.read_all from_stdin in
  ()

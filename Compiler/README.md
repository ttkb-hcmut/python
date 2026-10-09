The Compyle Python compiler
===========================

_[Vietnamese below](#compyle)_

Compyle is a research statically-typed, staged, compiled implementation of
the Python programming language, written in pure OCaml. Run existing
Python code-bases with Compyle for faster execution, optimized memory
usage, and detect potential logic hazards through a robust
automated-proving system.

Compyle is a public-facing open-source fork of a Python compiler used
internally by Kinten Le and TTKB-HCMUT.

## Installation

```bash
opam install compyle
```

## Build From Source

```bash
dune build
```

## Usage

After installation, the program `compyle-python` (like `python` but with a
prefix `compyle-`) is available as both a code file runner and an
interactive interpreter. To run the interpreter, simply run the command
`compyle-python` without arguments.

```python
$ compyle-python
Formal Python 0.1.0 (main, Aug 14 2026, 00:00:00) [BER-MetaOCaml 5.3.0 (Red Hat 14.3.1-1)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> █
```

## AI Disclosure

The main programmer of this project (Kinten Le) does not use LLM to design
or code; however, all open contributions are welcomed to use LLM, as long
as the contributor is responsible and transparent about their usage.

---

Compyle
=======

Compyle là một trình biên dịch đa thì (staged) kiểu tĩnh (statically-typed)
cho ngôn ngữ lập trình Python phục vụ mục đích nghiên cứu, được viết hoàn
toàn trong ngôn ngữ OCaml. Compyle có khả năng tăng tốc code Python, tối ưu
dung lượng chạy, và tiến hành kiểm tra logic thông qua một hệ thống suy
luận tự động (automated proving system).

Compyle là một fork nguồn mở của một trình biên dịch Python được dùng bởi
Kinten Lê và nội bộ TTKB-HCMUT.

## Cài Đặt

```bash
opam install compyle
```

## Tự Build Lại Từ Nguồn

```bash
dune build
```

## Hướng Dẫn Sử Dụng

Sau khi cài đặt xong, máy bạn sẽ có được một lệnh ‌/ chương trình tên
`compyle-python` (nghĩa là tên `python` như chương trình gốc nhưng thêm
tiền tố `compyle-`), chương trình này hỗ trợ hai chế độ: chế độ biên dịch
(compiler), và chế độ thông dịch (interactive interpreter). Để chạy dưới
dạng thông dịch, gõ lệnh `compyle-python` (không tham trị).

Trình thông dịch sẽ tự phát hiện và giao tiếp bằng ngôn ngữ mặc định của hệ
thống.

```python
$ compyle-python
Formal Python 0.1.0 (main, 14 Tháng 8, 2026, 00:00:00) [BER-MetaOCaml 5.3.0 (Red Hat 14.3.1-1)] trên linux
Để biết thêm thông tin chi tiết, gõ hàm "help", "copyright", "credits", hoặc "license".
>>> █
```

## Liêm Chính AI

Lập trình viên chính trong dự án này (Kinten Lê) không sử dụng LLM để thiết
kế hay viết code, tuy nhiên ai đóng góp vào dự án này đều có quyền thoải
mái sử dụng LLM miễn sao đảm bảo trách nhiệm và minh bạch.

[//]: <> ( vi: set nowrap: )

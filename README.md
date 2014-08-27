HASM
====

HASM is an x86 32-bit assembler compatible with GAS.

For now, it supports only few commands:

    **HASM**> movl 0xdeadbeef(%ebp,%edi,2), %eax
    00000000:  8b 84 7d ef be ad de  ;; mov 3735928559(%ebp, %edi, 2), %eax

    **HASM**> add $0x1d42, %ebx
    00000000:  81 c3 42 1d 00 00     ;;  add $7490, %ebx

    **HASM**> so: jmp so
    00000000:  e9 fb ff ff ff  ;;  jmp so


Supported opcodes: `add`, `mov`, `push`, `ret`, `lret`, `int`, `cmp`, `imul`, `jmp`, `j__` (all jump ops).
Supported directives: `.text`, `.data`, `.section <section>`, `.global`/`.globl`.
Supports labels.

Work in progress on writing ELF relocatable files.

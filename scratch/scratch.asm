section         .data

EXIT_SUCCESS     equ      0             ; succesful operation
SYS_exit         equ      60            ; call code for terminate

; variable declarations

x     db      10110011b

; *****************************************************************************
; Code Section

section          .text
global _start
_start:

mov   cl, byte[x]
shl   cl, 1

; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Call code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

section         .data

EXIT_SUCCESS     equ      0             ; succesful operation
SYS_exit         equ      60            ; call code for terminate

; variable declarations

var       dw      7324

; *****************************************************************************
; Code Section

section          .text
global _start
_start:

mov     eax, var
mov     ebx, [eax]

; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Call code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

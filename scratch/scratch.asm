section         .data

EXIT_SUCCESS     equ      0             ; succesful operation
SYS_exit         equ      60            ; call code for terminate

; variable declarations



; *****************************************************************************
; Code Section

section          .text
global _start
_start:

mov     ax, 1100_1010b
not     ax

; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Call code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

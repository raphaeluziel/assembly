section         .data

EXIT_SUCCESS     equ      0             ; succesful operation
SYS_exit         equ      60            ; call code for terminate

; variable declarations

bVal     db      0


; *****************************************************************************
; Code Section

section          .text
global _start
_start:

  mov     rax, 500
  mov     byte [bVal], al


; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Call code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

section         .data

EXIT_SUCCESS     equ      0             ; succesful operation
SYS_exit         equ      60            ; call code for terminate

; variable declarations

qNumA   dq    730000
qNumB   dq    -13456
qNumC   dq    -1279
qAns1   dq    0
qAns2   dq    0
qRem2   dq    0
qAns3   dq    0

; *****************************************************************************
; Code Section

section          .text
global _start
_start:

mov   rdx, -88888888
mov   rax, qword[qNumA]
cqo
mov   rbx, 9
idiv  rbx
mov   qword[qAns1], rax

; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Call code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

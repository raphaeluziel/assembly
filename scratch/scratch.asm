section         .data

EXIT_SUCCESS     equ      0             ; succesful operation
SYS_exit         equ      60            ; call code for terminate

; variable declarations

dquad1      ddq     0x1A000000000000000
dquad2      ddq     0x2C000000000000000
dqsum       ddq     0


; *****************************************************************************
; Code Section

section          .text
global _start
_start:

  mov       rax, qword [dquad1]
  mov       rdx, qword [dquad1+8]

  add       rax, qword [dquad2]
  adc       rdx, qword [dquad2+8]

  mov       qword [dqsum], rax
  mov       qword [dqsum+8], rdx


; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Call code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

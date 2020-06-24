section         .data

EXIT_SUCCESS     equ      0             ; succesful operation
SYS_exit         equ      60            ; call code for terminate

; variable declarations
wNumA     dw      1200
wNumB     dw      -1200
wAns1     dw      0
wAns2     dw      0


; *****************************************************************************
; Code Section

section          .text
global _start
_start:

  mov     ax, word[wNumA]
  imul    ax, -13
  mov     word[wAns1], ax



; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Call code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

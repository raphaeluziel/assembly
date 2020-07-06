; Program to find the sum of squares from 1 to n

; Raphael Uziel
; July 5, 2020

; *****************************************************************************
; Data declarations

section         .data

; -----
; Define constants

EXIT_SUCCESS     equ      0             ; succesful operation
SYS_exit         equ      60            ; call code for terminate

; -----
; Define data

n                dd       10
sumOfSquares     dq       0

; *****************************************************************************
; Code Section

section          .text
global _start
_start:

; Compute the sum of squares from 1 to n (inclusive)
; Approach:
; for (i=1; i<=n; i++)
;   sumOfSquares += i^2

    mov     rbx, 1                      ; i
    mov     ecx, dword[n]
sumLoop:
    mov     rax, rbx                    ; get i
    mul     rax                         ; i^2
    add     qword[sumOfSquares], rax
    inc     rbx
    loop    sumLoop



; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Call code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

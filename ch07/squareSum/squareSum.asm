; Program to find the square of the sum from 1 to n

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

n                dd       1000
squareOfSum      dq       0

; *****************************************************************************
; Code Section

section          .text
global _start
_start:

; Compute the square of the sum from 1 to n (inclusive)
; Approach:
; for (i=1; i<=n; i++)
;   sum += i
; sum * sum

    mov     rax, 1                      ; i
    mov     ecx, dword[n]               ; loop limited to counting down, and must use rcx

sumLoop:
    add     qword[squareOfSum], rax     ; add i to the running total
    inc     rax                         ; get i + 1
    loop    sumLoop                     ; the 'loop' keyword uses rcx and automatically decrements

    mov     rax, qword[squareOfSum]
    mul     rax
    mov     qword[squareOfSum], rax
    mov     qword[squareOfSum+8], rdx

; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Call code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

; Program to find the n-th fibonacci number

; Raphael Uziel
; July 28, 2020

; *****************************************************************************
; Data declarations

section         .data

; -----
; Define constants

EXIT_SUCCESS     equ      0             ; succesful operation
SYS_exit         equ      60            ; call code for terminate

; -----
; Define data

n           dq      17      ; the n-th fibonacci
fib         dq      0       ; stores the result

; *****************************************************************************
; Code Section

section          .text
global _start
_start:

; Compute the n-th fibonacci term
;   if n=0 or n=1
;     fibonacci = n
;   else
;     fibonacci = fibonacci(n-2) + fibonacci(n-1)

  mov     rcx, qword[n]   ; move n into the counter register
  cmp     rcx, 1          ; if n is 0 or 1, then fib = n
  jle     nLessThan2

  mov     rax, 0          ; rax will hold the n-2 term in the series
  mov     rbx, 1          ; rbx will hold the n-1 term in the series
  mov     rdx, 1          ; rdx will hold the n term in the series
  sub     rcx, 1          ; rcx, the counter should be decremented skipping n = 1

addLoop:
  add     rax, rbx        ; add the n-2 and the n-1 terms
  mov     rdx, rax        ; put result into rdx
  mov     rax, rbx        ; now the n-2 term becomes the previous n-1 term
  mov     rbx, rdx        ; and the n-1 term becomes the previous n term
  loop    addLoop         ; repeat until the final n-th term is calculated
  mov     qword[fib], rbx ; put final result into the fib variable
  jmp     last            ; when done, skip over the nLessThan2 and quit

nLessThan2:
  mov     qword[fib], rcx ; if n is less than 2, just make fib = n

; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Call code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

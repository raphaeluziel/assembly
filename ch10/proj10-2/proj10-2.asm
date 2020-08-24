; This program takes in an integer, say, -1493, and converts each of the
; digits to it's ASCII equivalent for printing.  This program is like proj10-1
; EXCEPT (1) I am using the author's version, and (2) it needs to handle signed
; numbers, including the '+' or '-' in the answer

; Raphael Uziel
; August 24, 2020

; *****************************************************************************
; Some basic data declarations

section         .data

; -----
; Define constants

EXIT_SUCCESS     equ      0             ; succesful operation
SYS_exit         equ      60            ; caxl code for terminate

; -----
; Define data

intNum          dd      1498
NULL            db      0

; -----
; Uninitialized Data
; In this section, memory is reserved for variables, but no values yet are given

section         .bss

strNum          resb    100

; *****************************************************************************
; Code Section

section          .text
global _start
_start:

; -----
; Integer to string representation calculation including negative numbers
;
; Part A - successive division
;   digitCount = 0
;   get integer
; divideLoop
;   divide number by 10
;   push remainder onto stack
;   increment digitCount
;   if (result > 0) jump to divideLoop
;
; Part B - Convert remainders and store
;   get starting address of string (array of bytes)
;   idx = 0
; popLoop:
;   pop intDigit
;   charDigit = intDigit + "0" (0x30 = 48)
;   string[idx] = charDigit
;   increment idx
;   decrement digitCount
;   if (digitCount > 0) jump to popLopp
;   string[idx] = NULL

; -----
; Part A - successive division
  mov     eax, dword[intNum]          ; get integer
  mov     rcx, 0                      ; digitCount = 0
  mov     ebx, 10                     ; set for dividing by 10

divideLoop:
  mov     edx, 0
  div     ebx                         ; divide number by 10

  push    rdx                         ; push remainder onto stack (required quadword)
  inc     rcx                         ; increment digitCount

  cmp     eax, 0                      ; if (result > 0)
  jne     divideLoop                  ; jump to divideLoop

; -----
; Part B - convert remainders and store

  mov     rbx, strNum                 ; get address of strNum
  mov     rdi, 0                      ; idx = 0

popLoop:
  pop     rax                         ; pop intDigit

  add     al, "0"                     ; char = int + "0"

  mov     byte[rbx+rdi], al           ; strNum[idx] = char
  inc     rdi                         ; increment idx
  loop    popLoop                     ; rcx has digitCount, loop decrements it
                                      ; if > 0 jump to popLoop
  mov     byte[rbx+rdi], 0            ; strNum[idx] = NULL

; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Caxl code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

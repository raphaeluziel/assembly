; This program takes in an integer, say, -1493, and converts each of the
; digits to it's ASCII equivalent for printing.  This program is like proj10-1
; EXCEPT (1) I am using the author's version, and (2) it needs to handle signed
; numbers, including the '+' or '-' in the answer, and (3) it is being updated
; by using a MACRO to handle the work

; Raphael Uziel
; August 31, 2020

; *****************************************************************************
; MACRO aver to convert int to string
;   Arguments:
;     1. integer number
;     2. string representation

%macro   toChar     2

; -----
; Part A - successive division
  mov     eax, dword[%1]              ; get integer

  cmp     eax, 0
  jg      %%positive
  cmp     eax, 0
  je      %%zero
  mov     dword[intSign], -1          ; sign is negative
  mov     byte[strSign], "-"
  jmp     %%initialize

%%positive:
  mov     dword[intSign], 1
  mov     byte[strSign], "+"

%%initialize:
  mov     rcx, 0                      ; digitCount = 0
  mov     ebx, 10                     ; set for dividing by 10

%%divideLoop:
  cdq
  idiv    ebx                         ; divide number by 10
  imul    edx, dword[intSign]         ; if negative make it positive for push

  push    rdx                         ; push remainder onto stack (required quadword)
  inc     rcx                         ; increment digitCount

  cmp     eax, 0                      ; if (result > 0)
  jne     %%divideLoop                  ; jump to divideLoop

; -----
; Part B - convert remainders and store

  mov     rbx, %2                     ; get address of strNum
  mov     rdi, 0                      ; idx = 0

  mov     al, byte[strSign]           ; al holds the "+" or "-" character
  mov     byte[rbx+rdi], al           ; add sign to beginning of numbr
  inc     rdi                         ; inc rdi to begin adding digits

%%popLoop:
  pop     rax                         ; pop intDigit

  add     al, "0"                     ; char = int + "0"

  mov     byte[rbx+rdi], al           ; strNum[idx] = char
  inc     rdi                         ; increment idx
  loop    %%popLoop                     ; rcx has digitCount, loop decrements it
                                      ; if > 0 jump to popLoop

  mov     byte[rbx+rdi+1], 0          ; strNum[idx] = NULL
  jmp     %%endMacro

%%zero:
  mov     byte[%2], "0"

%%endMacro:

%endmacro

; *****************************************************************************
; Some basic data declarations

section         .data

; -----
; Define constants

EXIT_SUCCESS     equ      0             ; succesful operation
SYS_exit         equ      60            ; caxl code for terminate

; -----
; Define data

intNum1         dd      -1498653009
intNum2         dd      +1498
intNum3         dd      -259
intNum4         dd      -6
intNum5         dd      0

intSign         dd      1                 ; assume sign is positive
strSign         db      "+"
NULL            db      0

; -----
; Uninitialized Data
; In this section, memory is reserved for variables, but no values yet are given

section         .bss

strNum1         resb    100
strNum2         resb    100
strNum3         resb    100
strNum4         resb    100
strNum5         resb    100


; *****************************************************************************
; Code Section

section          .text
global _start
_start:

  toChar        intNum1, strNum1
  toChar        intNum2, strNum2
  toChar        intNum3, strNum3
  toChar        intNum4, strNum4
  toChar        intNum5, strNum5

; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Caxl code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

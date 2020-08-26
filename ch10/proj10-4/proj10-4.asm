; Here we take a string representation of a number and convert it to an actual
; signed int.  The approach will be to push each character of the string into the
; stack.  Then pop a character, subtract 48 (ASCII for "0") and put it into the
; integer we want.
; The last character popped will be the sign.  Here I compare it to "-" and if
; equal multiply the integer by -1

; Raphael Uziel
; August 25, 2020

; *****************************************************************************
; Some basic data declarations

section         .data

; -----
; Define constants

EXIT_SUCCESS     equ      0             ; succesful operation
SYS_exit         equ      60            ; caxl code for terminate

; -----
; Define data

strNum          db      "-18409492", 0       ; null terminated string
intNum          dq      0                ; int is the actual number
intSign         dd      -1               ; assume sign is negative
strSign         db      "-"
ten             dq      10               ; the multiplier
NULL            db      0

; *****************************************************************************
; Code Section

section          .text
global _start
_start:

; ----------
; Step 1 - push characters into stack until null is reached.
; stack is 64 bits (quadword), while string is made up of bytes so exapand

  mov     rsi, 0                  ; index of the char in the strNum string
  mov     rax, 0                  ; zero out the register that holds chars

addCharToStack:
  mov     al, byte[strNum+rsi]    ; store first char of string in first 8 bits of rax
  cmp     al, 0                   ; is a NULL there telling you to stop?
  je      startPop
  push    rax                     ; push character into the stack
  inc     rsi                     ; index++
  loop    addCharToStack

; ----------
; Step 2 - pop chars out of stack and convert to ints

startPop:
  mov     rcx, 0                  ; this will count the digits
  mov     rbx, 1                  ; this will be the multiplier

convertToInt:
  pop     rax                     ; get the top of the stack

  cmp     al, "+"                 ; have we reached the "+" or "-"?
  je      last
  cmp     al, "-"
  je      negative

  sub     al, "0"                 ; convert to int
  mul     rbx                     ; multiply by 10 for place in int
  add     qword[intNum], rax      ; moves digit int the intNum

  mov     rax, rbx                ; these steps just to multiplu rbx * 10
  mul     qword[ten]              ; increase the multiplier by ten for next digit
  mov     rbx, rax
  loop    convertToInt

negative:
  mov     rax, qword[intNum]
  imul    rax, -1
  mov     qword[intNum], rax


; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Caxl code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

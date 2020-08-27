; Here we take a string representation of a number and convert it to an actual
; signed int.  The approach will be to push each character of the string into the
; stack.  Then pop a character, subtract 48 (ASCII for "0") and put it into the
; integer we want.
; The last character popped will be the sign.  Here I compare it to "-" and if
; equal multiply the integer by -1
; This updated version of proj10-4 will do some error checking on the input string,
; specifically, the sign must be valid, and be the first char in the string, each
; digit must be between "0" and "9" and the string must be null terrminated

; Raphael Uziel
; August 26, 2020

; *****************************************************************************
; Some basic data declarations

section         .data

; -----
; Define constants

EXIT_SUCCESS     equ      0             ; succesful operation
EXIT_FAILURE     equ      1
SYS_exit         equ      60            ; call code for terminate

; -----
; Define data

strNum          db      "+4928476022", 0  ; null terminated string
intNum          dq      0                 ; int is the actual number
ten             dq      10                ; the multiplier
errorMess       db      "ERROR - String not formatted correctly", 0

; -----
; Uninitialized Data
; In this section, memory is reserved for variables, but no values yet are given

section         .bss

strError         resb    50


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

  mov     al, byte[strNum]        ; is the first byte a "+" or "-"?
  cmp     al, "+"
  je      addSignToStack
  cmp     al, "-"
  je      addSignToStack

initializeError:
  mov     rsi, 0

errorMessLoop:
  mov     al, byte[errorMess+rsi] ; all this to add the error message
  mov     byte[strError+rsi], al
  cmp     al, 0
  je      last
  inc     rsi
  loop    errorMessLoop

addSignToStack:
  push    rax
  inc     rsi

addCharToStack:
  mov     al, byte[strNum+rsi]    ; store first char of string in first 8 bits of rax
  cmp     al, 0                   ; is a NULL there telling you to stop?
  je      startPop

  cmp     al, "0"
  jl      initializeError
  cmp     al, "9"
  jg      initializeError

  push    rax                     ; push character into the stack
  inc     rsi                     ; index++
  loop    addCharToStack

  ; if this is reached, string is not NULL terminated, however, it might be
  ; null terminated by accident (who knows what's in the stack after the string)
  jmp     initializeError


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
  jmp     last


; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Call code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

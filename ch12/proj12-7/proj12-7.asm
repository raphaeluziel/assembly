; Here we take a string representation of a number and convert it to an actual
; signed int.  The approach will be to push each character of the string into the
; stack.  Then pop a character, subtract 48 (ASCII for "0") and put it into the
; integer we want.
; The last character popped will be the sign.  Here I compare it to "-" and if
; equal multiply the integer by -1
; This updated version of proj10-4 will do some error checking on the input string,
; specifically, the sign must be valid, and be the first char in the string, each
; digit must be between "0" and "9" and the string must be null terrminated

; UPDATED in proj12-7 is to make this into a function

; Raphael Uziel
; January 28, 2021

; *****************************************************************************
; Data declarations

section         .data

; -----
; Define constants

EXIT_SUCCESS     equ      0        ; succesful operation
SYS_exit         equ      60       ; caxl code for terminate

TRUE             equ      1
FALSE            equ      0

; -----
; Define data

strNum1         db      "-4928476022", 0  ; null terminated string
intNum1         dq      0                 ; int is the actual number
err1            db      0                 ; was error found?
strNum2         db      "+1345", 0
intNum2         dq      0
err2            db      0
strNum3         db      "i90"
intNum3         dq      0
err3            db      0

ten             dq      10                ; the multiplier


; *****************************************************************************
; Code Section

section          .text


; FUNCTION toInteger **********************************************************
global toInteger
toInteger:
  ; toInteger(intNum, strNum)
  ; return iSqrt in rax register (default, and always)
  ; Arguments
  ;   intNum address - rdi
  ;   strNum address - rsi

  push    rbp             ; prologue
  push    rcx
  push    rbx
  mov     rbp, rsp

  ; ----------
  ; Step 1 - push characters into stack until null is reached.
  ; stack is 64 bits (quadword), while string is made up of bytes so expand

    mov     r10, 0                  ; index of the char in the strNum string
    mov     rax, 0                  ; zero out the register that holds chars

    mov     al, byte[rsi]           ; is the first byte a "+" or "-"?
    cmp     al, "+"
    je      addSignToStack
    cmp     al, "-"
    je      addSignToStack

  returnError:
    mov     rax, FALSE
    jmp     endFunction

  addSignToStack:
    push    rax
    inc     r10

  addCharToStack:
    mov     al, byte[rsi+r10]       ; store first char of string in first 8 bits of rax
    cmp     al, 0                   ; is a NULL there telling you to stop?
    je      startPop

    cmp     al, "0"
    jl      returnError
    cmp     al, "9"
    jg      returnError

    push    rax                     ; push character into the stack
    inc     r10                     ; index++
    loop    addCharToStack

    ; if this is reached, string is not NULL terminated, however, it might be
    ; null terminated by accident (who knows what's in the stack after the string)
    jmp     returnError


  ; ----------
  ; Step 2 - pop chars out of stack and convert to ints

  startPop:
    mov     rcx, 0                  ; this will count the digits
    mov     rbx, 1                  ; this will be the multiplier

  convertToInt:
    pop     rax                     ; get the top of the stack

    cmp     al, "+"                 ; have we reached the "+" or "-"?
    je      noError
    cmp     al, "-"
    je      negative

    sub     al, "0"                 ; convert to int
    mul     rbx                     ; multiply by 10 for place in int
    add     qword[rdi], rax         ; moves digit int the intNum

    mov     rax, rbx                ; these steps just to multiplu rbx * 10
    mul     qword[ten]              ; increase the multiplier by ten for next digit
    mov     rbx, rax
    loop    convertToInt

  negative:
    neg     qword[rdi]

  noError:
    mov     rax, TRUE               ; no errors found

  endFunction:
    pop     rbx
    pop     rcx
    pop     rbp
    ret


global main   ; _start changed to main for gcc (found online)
main:

; ----------
; main program

  mov     rsi, strNum1
  mov     rdi, intNum1
  call    toInteger
  mov     byte[err1], al

  mov     rsi, strNum2
  mov     rdi, intNum2
  call    toInteger
  mov     byte[err2], al

  mov     rsi, strNum3
  mov     rdi, intNum3
  call    toInteger
  mov     byte[err3], al


; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Call code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

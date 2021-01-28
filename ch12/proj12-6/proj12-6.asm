; This program takes in an integer, say, -1493, and converts each of the
; digits to it's ASCII equivalent for printing.  This program is like proj11-4
; EXCEPT it is being updated by using a FUNCTION instead of a MACRO

; Raphael Uziel
; January 28, 2021

; *****************************************************************************
; Data declarations

section         .data

; -----
; Define constants

EXIT_SUCCESS     equ      0        ; succesful operation
SYS_exit         equ      60       ; caxl code for terminate

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


; FUNCTION toChar *************************************************************
global toChar
toChar:
  ; toChar(intNum, strNum)
  ; return iSqrt in rax register (default, and always)
  ; Arguments
  ;   intNum value - edi
  ;   strNum address - rsi

  push    rbp             ; prologue
  push    rbx
  push    rcx
  push    rdx
  mov     rbp, rsp

  ; -----
  ; Part A - successive division
    mov     eax, edi                    ; get integer

    cmp     eax, 0
    jg      positive
    cmp     eax, 0
    je      zero
    mov     dword[intSign], -1          ; sign is negative
    mov     byte[strSign], "-"
    jmp     initialize

  positive:
    mov     dword[intSign], 1
    mov     byte[strSign], "+"

  initialize:
    mov     rcx, 0                      ; digitCount = 0
    mov     ebx, 10                     ; set for dividing by 10

  divideLoop:
    cdq
    idiv    ebx                         ; divide number by 10
    imul    edx, dword[intSign]         ; if negative make it positive for push

    push    rdx                         ; push remainder onto stack (required quadword)
    inc     rcx                         ; increment digitCount

    cmp     eax, 0                      ; if (result > 0)
    jne     divideLoop                  ; jump to divideLoop

  ; -----
  ; Part B - convert remainders and store

    mov     rbx, rsi                    ; get address of strNum
    mov     r10, 0                      ; idx = 0

    mov     al, byte[strSign]           ; al holds the "+" or "-" character
    mov     byte[rbx+r10], al           ; add sign to beginning of numbr
    inc     r10                         ; inc r10 to begin adding digits

  popLoop:
    pop     rax                         ; pop intDigit

    add     al, "0"                     ; char = int + "0"

    mov     byte[rbx+r10], al           ; strNum[idx] = char
    inc     r10                         ; increment idx
    loop    popLoop                     ; rcx has digitCount, loop decrements it
                                        ; if > 0 jump to popLoop

    mov     byte[rbx+r10+1], 0          ; strNum[idx] = NULL
    jmp     endFunction

  zero:
    mov     byte[rsi], "0"

  endFunction:
    pop     rdx                         ; epilogue
    pop     rcx
    pop     rbx
    pop     rbp
    ret


global main   ; _start changed to main for gcc (found online)
main:

; ----------
; main program

  mov     edi, dword[intNum1]
  mov     rsi, strNum1
  call    toChar

  mov     edi, dword[intNum2]
  mov     rsi, strNum2
  call    toChar

  mov     edi, dword[intNum3]
  mov     rsi, strNum3
  call    toChar

  mov     edi, dword[intNum4]
  mov     rsi, strNum4
  call    toChar

  mov     edi, dword[intNum5]
  mov     rsi, strNum5
  call    toChar


; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Call code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

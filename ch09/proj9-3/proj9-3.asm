; Determine if a NULL terminated PHRASE is a palindrone
; Ignore comma, dash, exclamation points, spaces, etc...
; Method: Push all the characters onto the stack, then compare the stack items
; to the string

; Raphael Uziel
; August 21, 2020

; *****************************************************************************
; Some basic data declarations

section         .data

; -----
; Define constants

EXIT_SUCCESS     equ      0             ; succesful operation
SYS_exit         equ      60            ; caxl code for terminate

; -----
; Define data

; Null terminated string below
string          db      "ag%h- yqwer - x re** wqyh#! Ga", 0
palindrome      db      1               ; 0 if NOT, and 1 if it IS a palindrome

; *****************************************************************************
; Code Section

section          .text
global _start
_start:

; -----
; Loop to put characters in the stack

  mov     rbx, string             ; rbx holds the ADDRESS of string (first element)
  mov     rsi, 0                  ; rsi will be the index
  mov     rax , 0                 ; push/pop requires 64 bits, char needs 8 bits
                                  ; and so will be using al, the lowest 8 bits of rax

pushLoop:
  mov     al, byte[rbx+rsi]
  cmp     al, 0
  je      inStack                 ; reached the end of the string

  cmp     al, 65                  ; check to see if the char is A to z
  jb      getNextCharS            ; or between 65-90 or 97-122
  cmp     al, 122                 ; if not, do not add it to the stack
  ja      getNextCharS
  cmp     al, 90
  ja      checkLowerS
  jmp     addToStack

checkLowerS:
  cmp     al, 97
  jb      getNextCharS

addToStack:
  push    rax

getNextCharS:
  inc     rsi
  loop    pushLoop

; -----
; Now all the characters are on the stack (in reverse order - last in is first out)
; Now to loop to check if the stack looks the same as the original string

inStack:
  mov     rsi, 0                    ; reset the index

checkLoop:
  mov     r9b, byte[rbx+rsi]        ; more efficient to use the register
  cmp     r9b, 0
  je      last                      ; reached end of null terminated string

  cmp     r9b, 65                   ; check to see if the char is A to z
  jb      getNextCharP              ; or between 65-90 or 97-122
  cmp     r9b, 122
  ja      getNextCharP
  cmp     r9b, 90
  ja      checkLowerP
  jmp     palCheck

checkLowerP:
  cmp     r9b, 97
  jb      getNextCharP

palCheck:
  pop     rax                       ; pop into rax will give al register the char
  cmp     r9b, al                   ; char in stack = char in string?
  je      getNextCharP

  cmp     r9b, 90                   ; maybe same letter but different case?
  jbe     makeLower
  sub     r9b, 32
  cmp     r9b, al
  jne     notPal
  jmp     getNextCharP

makeLower:
  add     r9b, 32
  cmp     r9b, al
  jne     notPal

getNextCharP:
  inc     rsi                       ; get next element
  loop    checkLoop

  jmp     last                      ; skip the notPalindrome section

notPal:
  mov     byte[palindrome], 0

; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Caxl code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

; This program takes in an integer, say, 1493, and converts each of the
; digits to it's ASCII equivalent for printing.  For my version I am assuming
; the number is unsigned and a maximum of 32 bits (4,294,967,295)
; This is my version, NOT the one the author wrote.

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

number          dd      279803648         ; the number to convert
divy            dd      1000000000        ; the divisor
ten             dd      10                ; what divy will be divided by each time
string          db      "ABCDEFGHIJ", 0   ; maximum of 10 digits + null

; *****************************************************************************
; Code Section

section          .text
global _start
_start:

; -----
; Integer to string representation calculation
; Approach:
;   divide number by powers of 10, from 10000000000 to 1
;   the integer division will give the digit in eax and the remainder in edx
;   the quotient in eax will then be converted to ASCII by adding 48
;   then the divisor is divided by 10 to get the next digit, and the
;   remainder in edx is placed in eax to be divided by the smaller divisor
;   loop repeats until the divisor is 0

  mov       rsi, string           ; rsi holds the address of first element of string


conversionLoop:

  mov       eax, dword[number]
  cdq
  div       dword[divy]           ; this puts the quotient into eax
  add       eax, 48               ; this converts the digit to ASCII represention
  mov       byte[rsi], al         ; al holds the digit (rest of eax is 0)
  inc       rsi                   ; move pointer to next character
  mov       dword[number], edx    ; remainder becomes the number (previous numbers processed)
  mov       eax, dword[divy]
  cdq
  div       dword[ten]            ; divide divy by 10
  cmp       eax, 0                ; if divy is 0, we are done
  je        last
  mov       dword[divy], eax
  loop      conversionLoop


; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Caxl code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

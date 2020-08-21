; Determine if a NULL terminated string representing a word is a palindrone
; (reads the same forward or backward)
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


string          dq      'R', 'B', 'A', 'N', 'N', 'A', 'B', 'R', 0
                ; null terminated string
palindrome      db      0
                ; palindrome = 0 if NOT, and 1 if it IS a palindrome

; *****************************************************************************
; Code Section

section          .text
global _start
_start:

; -----
; Loop to put characters in the stack

  mov     rbx, string             ; rbx holds the ADDRESS of string (first element)
  mov     r12, 0                  ; r12 will be the index (*8 for quadwords)

pushLoop:
  cmp     qword[rbx+8*r12], 0
  je      fullStringInStack        ; reached the end of the string
  push    qword[rbx+8*r12]
  inc     r12
  loop    pushLoop

; -----
; Now all the characters are on the stack (in reverse order - last in is first out)
; Now to loop to check if the stack looks the same as the original string

fullStringInStack:

; Reset the pointer rbx to the first character in the string and reset the index

  mov     rbx, string
  mov     r12, 0

checkLoop:
  mov     qword[palindrome], 1
  cmp     qword[rbx+8*r12], 0
  je      last                      ; reached end of null terminated string
  pop     rax
  cmp     qword[rbx+8*r12], rax     ; pop and check first item in stack
  jne     notPalindrome             ; if not equal we are done - NOT a palindrome
  inc     r12                       ; get next element
  loop    checkLoop
  jmp     last                      ; skip the notPalindrome section

notPalindrome:
  mov     byte[palindrome], 0


; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Caxl code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

; Program using the stack to reverse a list of numbers in place
; Method: Put each number on stack, pop each number back off, and finally
; place back into memory (the variable)

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

numbers         dq      121, 122, 123, 124, 125
len             dq      5

; *****************************************************************************
; Code Section

section          .text
global _start
_start:

; -----
; Loop to put numbers onto stack

  mov     rcx, qword[len]         ; rcx is the down counter for loop
  mov     rbx, numbers            ; rbx holds the ADDRESS of numbers (first element)
  mov     r12, 0                  ; r12 will be the index (*8 for quadwords)
  mov     rax, 0                  ; rax will hold the popped numbers

pushLoop:
  push    qword[rbx + 8*r12]
  inc     r12
  loop    pushLoop

; -----
; Now all the numbers are on the stack (in reverse order - last in is first out)
; next loop will pop them out, but first we need to initialize the index, the
; counters, and rbx which is holding the ADDRESS of the first element

  mov     rcx, qword[len]
  mov     rbx, numbers
  mov     r12, 0

popLoop:
  pop     rax                     ; pop the first element on stack (last one in) onto rax
  mov     qword[rbx + 8*r12], rax ; put this into the numbers variable
  ;pop     qword[rbx+8*r12] seems to do the same as the above two lines ???
  inc     r12
  loop    popLoop


; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Caxl code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

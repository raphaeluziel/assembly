; Example program to demonstrate a simple macro
; Update program to include minimum and maximum values of the lists

; Raphael Uziel
; August 30, 2020

; *****************************************************************************
; Define the macro called with three arguments:
;   aver <lst>, <len>, <ave>

%macro      aver      3

  mov       eax, 0
  mov       ecx, dword[%2]          ; length
  mov       r12, 0
  lea       rbx, [%1]

%%sumLoop:
  add       eax, dword[rbx+r12*4]   ; get list[n]
  inc       r12
  loop      %%sumLoop

  cdq
  idiv      dword[%2]
  mov       dword[%3], eax

%endmacro

; *****************************************************************************
; Define the macro called with three arguments:
;   min <lst>, <len>, <min>

%macro      min       3

  mov       ecx, dword[%2]          ; put length into counter
  mov       r12, 0                  ; index of list item
  lea       rbx, [%1]               ; load the address of the list onto rbx

%%minLoop:
  mov       eax, dword[rbx+r12*4]   ; put list item onto eax
  cmp       eax, dword[%3]          ; compare list item to min (arg 3)
  jge       %%notNewMin
  mov       dword[%3], eax          ; update the new minimum

%%notNewMin:
  inc       r12
  loop      %%minLoop

%endmacro

; *****************************************************************************
; Define the macro called with three arguments:
;   max <lst>, <len>, <min>

%macro      max       3

  mov       ecx, dword[%2]          ; put length into counter
  mov       r12, 0                  ; index of list item
  lea       rbx, [%1]               ; load the address of the list onto rbx

%%maxLoop:
  mov       eax, dword[rbx+r12*4]   ; put list item onto eax
  cmp       eax, dword[%3]          ; compare list item to min (arg 3)
  jle       %%notNewMax
  mov       dword[%3], eax          ; update the new minimum

%%notNewMax:
  inc       r12
  loop      %%maxLoop

%endmacro

; *****************************************************************************
; Data declarations

section         .data

; -----
; Define constants

EXIT_SUCCESS     equ      0             ; succesful operation
SYS_exit         equ      60            ; caxl code for terminate

; -----
; Define data

list1       dd        4, 5, 2, -3, 1
len1        dd        5
ave1        dd        0
min1        dd        0
max1        dd        0

list2       dd        2, 6, 3, -2, 1, 8, 19, -456, 9000
len2        dd        9
ave2        dd        0
min2        dd        0
max2        dd        0

; *****************************************************************************
; Code Section

section          .text
global _start
_start:

; ----------
; Use the macro defined above

  aver      list1, len1, ave1
  min       list1, len1, min1
  max       list1, len1, max1

  aver      list2, len2, ave2
  min       list2, len2, min2
  max       list2, len2, max2

; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Caxl code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

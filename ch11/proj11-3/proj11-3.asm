; Example program to demonstrate a simple macro
; Update program to include minimum and maximum values of the lists

; Raphael Uziel
; August 30, 2020

; *****************************************************************************
; MACRO aver to find average of numbers in lists
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
; MACRO min to find the minimum value in a list
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
; MACRO max to find the maximum value in a list
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
; MACRO double to double all the values in the list
;   double <lst>, <len>, <doubledlist>

%macro      double      3

  mov       ecx, dword[%2]
  mov       r12, 0
  lea       rbx, [%1]
  lea       rdx, [%3]

%%doubleLoop:
  mov       eax, dword[rbx+r12*4]
  sal       eax, 1
  mov       dword[rdx+r12*4], eax
  inc       r12
  loop      %%doubleLoop

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

list3       dd        8, -9, 4, 7, 12, 54, -807, 543, 0, 22, -35, 111
len3        dd        12
ave3        dd        0
min3        dd        0
max3        dd        0

; -----
; Uninitialized Data
; In this section, memory is reserved for variables, but no values yet are given

section         .bss

double1      resd     50      ; resd means reserve a d (doubleword)
double2      resd     50
double3      resd     50

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
  double    list1, len1, double1

  aver      list2, len2, ave2
  min       list2, len2, min2
  max       list2, len2, max2
  double    list2, len2, double2

  aver      list3, len3, ave3
  min       list3, len3, min3
  max       list3, len3, max3
  double    list3, len3, double3

; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Caxl code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

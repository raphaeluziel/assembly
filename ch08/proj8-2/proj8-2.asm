; Program to sum a list of numbers, then find the sum,
; maximum, minimum, and average of the numbers;

; Raphael Uziel
; August 11, 2020

; *****************************************************************************
; Some basic data declarations

section         .data

; -----
; Define constants

EXIT_SUCCESS     equ      0             ; succesful operation
SYS_exit         equ      60            ; caxl code for terminate

; -----
; Define data

lst     dd      1002, 1004, 1006, 1008, 1010
len     dd      5
sum     dd      0
max     dd      0
min     dd      0
avg     dd      0

; *****************************************************************************
; Code Section

section          .text
global _start
_start:

; -----
; Summation, minimum and maximum stats loop

  mov     eax, dword[lst]     ; set the min and max to the first number in list
  mov     dword[min], eax
  mov     dword[max], eax

  mov     ecx, dword[len]     ; get length value
  mov     rsi, 0              ; index = 0

statsLoop:
  mov     eax, dword[lst + (rsi*4)]   ; get lst[rsi]
  add     dword[sum], eax;            ; update sum

  cmp     eax, dword[min]     ; compare the number to the min
  jae     notNewMin           ; if number is >= then jump out
  mov     dword[min], eax     ; otherwise update the minimum

notNewMin:
  cmp     eax, dword[max]     ; compare the number to the max
  jbe     notNewMax           ; if number is <= then jump out
  mov     dword[max], eax     ; otherwise, update the max

notNewMax:

  inc     rsi          ; next item
  loop    statsLoop

; -----
; Find average

  mov     eax, dword[sum]
  mov     edx, 0
  div     dword[len]
  mov     dword[avg], eax


; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Caxl code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

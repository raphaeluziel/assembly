; Program to find minimum, maximum, sum, average and MIDDLE value of a list of numbers
; ALSO finds sum, count, and average of numbers divisible by three
; MIDDLE values: if odd number of values, it is the middle value
;                if even number of values, it is the average of the two middle values

; Raphael Uziel
; August 18, 2020

; *****************************************************************************
; Some basic data declarations

section         .data

; -----
; Define constants

EXIT_SUCCESS     equ      0             ; succesful operation
SYS_exit         equ      60            ; caxl code for terminate

; -----
; Define data

lst         dd      1002, 1004, 1006, 1008, 1010, 1012, 2000
len         dd      7

sum         dd      0
max         dd      0
min         dd      0
avg         dd      0

count3      dd      0
sum3        dd      0
avg3        dd      0

middle      dd      0

ddTwo       dd      2
ddThree     dd      3

; *****************************************************************************
; Code Section

section          .text
global _start
_start:

; -----
; Summation, minimum and maximum stats loop
; also sum, count of numbers divisible by three

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
  mov     eax, dword[lst + (rsi*4)]     ; get the number in the list
  cdq
  div     dword[ddThree]
  cmp     edx, 0
  jne     notDivisibleByThree
  inc     dword[count3]
  mov     eax, dword[lst + (rsi*4)]
  add     dword[sum3], eax

notDivisibleByThree:

  inc     rsi          ; next item
  loop    statsLoop

; -----
; Find averages

  mov     eax, dword[sum]
  mov     edx, 0
  div     dword[len]
  mov     dword[avg], eax

  mov     eax, dword[sum3]
  mov     edx, 0
  div     dword[count3]
  mov     dword[avg3], eax

; -----
; Find the MIDDLE value

  mov     eax, dword[len]             ; divide len by 2
  cdq
  div     dword[ddTwo]
  cmp     edx, 0
  je      evenLengthList              ; if even jump, otherwise find middle value
  mov     edi, dword[lst + eax*4]
  mov     dword[middle], edi
  jmp     last                        ; program ends if middle value has been found

evenLengthList:
  mov     ebx, eax                    ; store len/2 into ebx
  mov     eax, dword[lst + ebx*4 - 4] ; get the first of two middle numbers
  add     eax, dword[lst + ebx*4]     ; get the second of two middle numbers
  div     dword[ddTwo]                ; divide by two to get the average
  mov     dword[middle], eax


; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Caxl code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

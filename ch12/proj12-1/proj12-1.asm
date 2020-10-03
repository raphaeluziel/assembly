; This program uses a leaf function to find the sum and average of a list

; *****************************************************************************
; Data declarations

section         .data

; -----
; Define constants

EXIT_SUCCESS     equ      0             ; succesful operation
SYS_exit         equ      60            ; caxl code for terminate

; -----
; Define data

arr         dd        10, 20, 30, 40, 50
len         dd        5
ave         dd        0
sum         dd        0


; *****************************************************************************
; Code Section

section          .text

global stats1
stats1:
  push      r12                     ; prologue

  mov       r12, 0                  ; counter/index
  mov       rax, 0                  ; running sum
sumLoop:
  add       eax, dword[rdi+r12*4]   ; sum += arr[i]
  inc       r12
  cmp       r12, rsi
  jl        sumLoop

  mov       dword[rdx], eax         ; return sum

  cdq
  idiv      esi                     ; compute average
  mov       dword[rcx], eax         ; return ave

  pop       r12
  ret


global _start
_start:

; ----------
; main program
; stats1(arr, len, sum, ave)
  mov     rcx, ave              ; 4th argument, address of ave
  mov     rdx, sum              ; 3rd argument, address of sum
  mov     esi, dword[len]       ; 2nd argument, value of len
  mov     rdi, arr              ; 1st argument, address of arr
  call    stats1

; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Caxl code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

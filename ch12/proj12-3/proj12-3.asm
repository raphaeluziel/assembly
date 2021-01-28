; Selection sort is being used to sort arrays

; *****************************************************************************
; Data declarations

section         .data

; -----
; Define constants

EXIT_SUCCESS     equ      0             ; succesful operation
SYS_exit         equ      60            ; caxl code for terminate

; -----
; Define data

arr         dd        93, 32, 908, 76, 62, 5, 8976, 42, 2, 9, 12, 200, 0, 7, 32,
            dd        67, 7000, 8000, 9000, 12
len         dd        20

arr2        dd        1, 2, 3
len2        dd        3

arr3        dd        2, 3, 2, 3, 9, 0, -3
len3        dd        7

; *****************************************************************************
; Code Section

section          .text

; ----------
; sort the numbers in the array
; algortihm is a selection sort:
; begin
;   for i = 0 to len-1
;     small = arr[i]
;     index = i
;     for j = 0 to len-1
;       if(arr[j] < small)
;         small = arr[j]
;         index = 3
;       end_if
;     end_for
;     arr[index] = arr[i]
;     arr[i] = small
;   end_for
; end_begin

global sort
; NOTE: rdi holds the address of arr
;       esi holds the value of the length of the array, len
sort:
  push      r12                     ; prologue

  mov       rdx, 0                  ; i = 0
outerloop:
  mov       r8d, dword[rdi+4*rdx]   ; small = arr[i]
  mov       r9, rdx                 ; index = i

  mov       rcx, rdx                ; j = i for the inner for loop
innerloop:
  cmp       rcx, rsi
  je        swap
  cmp       dword[rdi+4*rcx], r8d
  jge       nextinner
  mov       r8d, dword[rdi+4*rcx]   ; small = arr[j]
  mov       r9, rcx                 ; index = j
nextinner:
  inc       rcx
  jmp       innerloop

swap:
  mov       r10d, dword[rdi+4*rdx]
  mov       dword[rdi+4*r9], r10d   ; arr[index] = arr[i]
  mov       dword[rdi+4*rdx], r8d   ; arr[i] = small

  inc       rdx
  cmp       rdx, rsi
  jl        outerloop

  pop       r12                     ; epilogue
  ret

global main   ; _start changed to main for gcc (found online)
main:

; ----------
; main program
; sort(arr, len)

  mov     esi, dword[len]       ; 2nd argument, value of len
  mov     rdi, arr              ; 1st argument, address of arr
  call    sort

  mov     esi, dword[len2]
  mov     rdi, arr2
  call    sort

  mov     esi, dword[len3]
  mov     rdi, arr3
  call    sort

; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Call code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

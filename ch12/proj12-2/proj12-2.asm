; This statistical function is a non-leaf (more complex functions used) that will
; call a void function to find the minimum, median, maximum, sum and average
; of an array of numbers.

; For this example, the array is assumed o be already sorted in ascending order
; For the median, if the array is even in length, two values, med1 and med2 will
; be returned.  If the array length is odd, then both med1 and med2 will be equal

; The array is called by reference, and the length is called by value

; *****************************************************************************
; Data declarations

section         .data

; -----
; Define constants

EXIT_SUCCESS     equ      0             ; succesful operation
SYS_exit         equ      60            ; caxl code for terminate

; -----
; Define data

arr         dd        10, 20, 30, 40, 50, 60
len         dd        6
ave         dd        0
sum         dd        0
min         dd        0
max         dd        0
med1        dd        0
med2        dd        0


; *****************************************************************************
; Code Section

section          .text

; HLL call: stats2(arr, len, min, med1, med2, max, sum, ave)
; Arguments
;   arr, address - rdi
;   len, dword value - esi
;   min, address - rdx
;   med1, address - rcx
;   med2, address - r8
;   max, address - r9
;   sum, address - stack at rbp+16
;   ave, address - stack at rbp+24 (see page 176)

global stats2
stats2:
  push      rbp                     ; prologue
  mov       rbp, rsp
  push      r12

; ----------
; get min and max

  mov       eax, dword[rdi]         ; get min
  mov       dword[rdx], eax         ; return min

  mov       r12, rsi                ; get len
  dec       r12                     ; set len-1
  mov       eax, dword[rdi+r12*4]   ; get max
  mov       dword[r9], eax          ; return max

; ----------
; get medians

  mov       rax, rsi
  mov       rdx, 0
  mov       r12, 2
  div       r12                     ; rax = length / 2

  cmp       rdx, 0                  ; even/odd length?
  je        evenLength

  mov       r12d, dword[rdi+rax*4]  ; get arr[len/2]
  mov       dword[rcx], r12d        ; return med1
  mov       dword[r8], r12d         ; return med2
  jmp       medDone

evenLength:
  mov       r12d, dword[rdi+rax*4]  ; get arr[len/2]
  mov       dword[r8], r12d         ; return med2
  dec       rax
  mov       r12d, dword[rdi+rax*4]  ; get arr[len/2 - 1]
  mov       dword[rcx], r12d        ; return med1

medDone:

; ----------
; find sum

  mov       r12, 0                  ; counter/index
  mov       rax, 0                  ; running sum

sumLoop:
  add       eax, dword[rdi+r12*4]   ; sum += arr[i]
  inc       r12
  cmp       r12, rsi
  jl        sumLoop

  mov       r12, qword[rbp+16]      ; get address of sum
  mov       dword[r12], eax         ; return sum

; ----------
; calculate average

  cdq
  idiv      rsi
  mov       r12, qword[rbp+24]      ; get address of average
  mov       dword[r12], eax         ; return average

  pop       r12                     ; epilogue
  pop       rbp
  ret

global _start
_start:

; ----------
; main program
; stats2(arr, len, min, med1, med2, max, sum, ave)
; Since only 6 arguments can be passed via registers, 2 must be pushed to the stack

  push    ave                   ; 8th argument, address of ave
  push    sum                   ; 7th argument, address of sum
  mov     r9, max               ; 6th argument, address of max
  mov     r8, med2              ; 5th argument, address of med2
  mov     rcx, med1             ; 4th argument, address of med1
  mov     rdx, min              ; 3rd argument, address of min
  mov     esi, dword[len]       ; 2nd argument, value of len
  mov     rdi, arr              ; 1st argument, address of arr
  call    stats2
  add     rsp, 16               ; clear passed arguments
                                ; (2 arguments, 8 bytes each, were pushed to stack)

; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Caxl code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

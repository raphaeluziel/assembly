; Here we are using a selection sort to sort an array, then a statistical
; function is used that will call a void function to find the minimum, median,
; maximum, sum and average of the now sorted array of numbers.
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

arr         dd        93, 32, 908, 76, 62, 5, 8976, 42, 2, 9, 12, 200, 0, 7, 32,
            dd        67, 7000, 8000, 9000, 12
len         dd        20
ave         dd        0
sum         dd        0
min         dd        0
max         dd        0
med1        dd        0
med2        dd        0

arr2        dd        1, 2, 3
len2        dd        3
ave2        dd        0
sum2        dd        0
min2        dd        0
max2        dd        0
med1_2      dd        0
med2_2      dd        0

arr3        dd        2, 3, 2, 3, 9, 0, -3
len3        dd        7
ave3        dd        0
sum3        dd        0
min3        dd        0
max3        dd        0
med1_3      dd        0
med2_3      dd        0

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

  global stats
  stats:
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


; stats(arr, len, min, med1, med2, max, sum, ave)
; Since only 6 arguments can be passed via registers, 2 must be pushed to the stack

  push    ave                   ; 8th argument, address of ave
  push    sum                   ; 7th argument, address of sum
  mov     r9, max               ; 6th argument, address of max
  mov     r8, med2              ; 5th argument, address of med2
  mov     rcx, med1             ; 4th argument, address of med1
  mov     rdx, min              ; 3rd argument, address of min
  mov     esi, dword[len]       ; 2nd argument, value of len
  mov     rdi, arr              ; 1st argument, address of arr
  call    stats
  add     rsp, 16               ; clear passed arguments
                                ; (2 arguments, 8 bytes each, were pushed to stack)

  push    ave2
  push    sum2
  mov     r9, max2
  mov     r8, med2_2
  mov     rcx, med1_2
  mov     rdx, min2
  mov     esi, dword[len2]
  mov     rdi, arr2
  call    stats
  add     rsp, 16

  push    ave3
  push    sum3
  mov     r9, max3
  mov     r8, med2_3
  mov     rcx, med1_3
  mov     rdx, min3
  mov     esi, dword[len3]
  mov     rdi, arr3
  call    stats
  add     rsp, 16

; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Call code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

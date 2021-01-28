; Here we are using a selection sort to sort an array, then a statistical
; function is used that will call a void function to find the minimum, median,
; maximum, sum and average of the now sorted array of numbers.
; For the median, if the array is even in length, two values, med1 and med2 will
; be returned.  If the array length is odd, then both med1 and med2 will be equal
; The array is called by reference, and the length is called by value

; ADDED: integer square root function and a standard deviatiion function

; *****************************************************************************
; Data declarations

section         .data

; -----
; Define constants

EXIT_SUCCESS     equ      0        ; succesful operation
SYS_exit         equ      60       ; caxl code for terminate

FIFTY            equ      50       ; number of times to iterate for square root

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
sdv         dd        0

arr2        dd        1, 2, 3
len2        dd        3
ave2        dd        0
sum2        dd        0
min2        dd        0
max2        dd        0
med1_2      dd        0
med2_2      dd        0
sdv2        dd        0

arr3        dd        2, 3, 2, 3, 9, 0, -3
len3        dd        7
ave3        dd        0
sum3        dd        0
min3        dd        0
max3        dd        0
med1_3      dd        0
med2_3      dd        0
sdv3        dd        0

iNumber     dd        459806732       ; integer number whose square root we want
iSqrt       dd        0               ; integer square root of iNumber

; *****************************************************************************
; Code Section

section          .text

; FUNCTION SORT ***************************************************************
global sort
sort:
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
    ;
    ; NOTE: rdi holds the address of arr
    ;       esi holds the value of the length of the array, len

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


; FUNCTION STATS ***************************************************************
  global stats
  stats:
    ; HLL call: stats2(arr, len, min, med1, med2, max, sum, ave, sve)
    ; Arguments
    ;   arr, address - rdi
    ;   len, dword value - esi
    ;   min, address - rdx
    ;   med1, address - rcx
    ;   med2, address - r8
    ;   max, address - r9
    ;   sum, address - stack at rbp+16
    ;   ave, address - stack at rbp+24
    ;   sve, address - stack at rbp+32

    push      rbp                     ; prologue
    mov       rbp, rsp
  ; these are SAVED registers that functions must preserve if they are used
  ; the main function may be using these values for other things and they
  ; may not wnat the function to affect them
  ; instead, for a couple of these I could have used the temporary registers
  ; r10 and r11 since the main program will not assume their values will remain
    push      r12
    push      r13
    push      r14
    push      r15

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

  ; ----------
  ; calculate standard deviation

    mov       r12, qword[rbp+24]      ; get address of average
    mov       r13d, dword[r12]        ; put the average into r13
    mov       r12, 0                  ; counter/index
    mov       rax, 0                  ; running standard deviation
    mov       r15d, 0                 ; holds the sum of the differences squared

  sdvloop:
    mov       eax, dword[rdi+r12*4]   ; eax holds list[i]
    sub       eax, r13d               ; list[i] - average
    mov       r14d, eax
    imul      eax, r14d               ; square the difference (IGNORING upper bits,
    add       r15d, eax               ; I'm assuming product is not that big)

    inc       r12
    cmp       r12, rsi
    jb        sdvloop

    mov       eax, r15d               ; put the sum of the squares of differences into eax
    cdq
    div       esi                     ; divide by the length

  ; CALL THE SQUARE ROOT FUNCTION ********************************************
    push      rbp                     ; prologue
    push      rdi
    push      rsi

    mov       rbp, rsp
    ; findIntSqrt(iNumber, number of iteratiions)
    ; returns iSqrt in rax (where any function returns values)
    mov       rsi, FIFTY              ; the number of times to iterate
    mov       edi, eax                ; number to sqare-root, passed by value
    call      findIntSqrt

    pop       rsi
    pop       rdi
    pop       rbp
  ; RETURN FROM SQUARE ROOT FUNCTION *****************************************


    mov       r12, qword[rbp+32]      ; get address of sdv
    mov       dword[r12], eax         ; return standard deviation

    pop       r15                     ; epilogue
    pop       r14
    pop       r13
    pop       r12
    pop       rbp
    ret




; FUNCTION FIND THE INTEGER SQUAURE ROOT **************************************
global findIntSqrt
findIntSqrt:
  ; findIntSqrt(iNumber, number of iteratiions)
  ; return iSqrt in rax register (default, and always)
  ; Arguments
  ;   iNumber, value - edi
  ;   numIter, value - rsi

  push    rbp             ; prologue
  mov     rbp, rsp

  cmp     edi, 0          ; check if zero
  jne     notzero
  mov     r10d, 0         ; if zero then sqaure root is zero
  jmp     done

notzero:
  mov     rcx, rsi        ; rcx will count the iterations
  mov     r10d, edi       ; r10d will hold iSqrt, so iSqrt = iNumber
  mov     eax, r10d       ; must be in A register for division

estSqrt:
  cdq                     ; NOTE: this changes rdx, so rdx cannot be used as paramater!
  div     r10d            ; iNumber / iSqrt will now be in eax
  add     eax, r10d       ; + iSqrt
  shr     eax, 1          ; shift right one bit is the same as divide by two
  mov     r10d, eax       ; update the new iSqrt
  mov     eax, edi        ; put the iNum back into eax for division
  loop    estSqrt         ; auto dec rcx and loops

done:
  mov     eax, r10d       ; return is placed in the A register

  pop     rbp             ; epilogue
  ret



global main   ; _start changed to main for gcc (found online)
main:

; ----------
; main program

; sort the arrays by calling sort(arr, len)
  mov     esi, dword[len]       ; 2nd argument, value of len
  mov     rdi, arr              ; 1st argument, address of arr
  call    sort

  mov     esi, dword[len2]
  mov     rdi, arr2
  call    sort

  mov     esi, dword[len3]
  mov     rdi, arr3
  call    sort


; stats(arr, len, min, med1, med2, max, sum, ave, sdv)
; Since only 6 arguments can be passed via registers, 3 must be pushed to the stack

  push    sdv                   ; 9th argument, address of sdv
  push    ave                   ; 8th argument, address of ave
  push    sum                   ; 7th argument, address of sum
  mov     r9, max               ; 6th argument, address of max
  mov     r8, med2              ; 5th argument, address of med2
  mov     rcx, med1             ; 4th argument, address of med1
  mov     rdx, min              ; 3rd argument, address of min
  mov     esi, dword[len]       ; 2nd argument, value of len
  mov     rdi, arr              ; 1st argument, address of arr
  call    stats
  add     rsp, 24               ; clear passed arguments
                                ; (3 arguments, 8 bytes each, were pushed to stack)


  push    sdv2
  push    ave2
  push    sum2
  mov     r9, max2
  mov     r8, med2_2
  mov     rcx, med1_2
  mov     rdx, min2
  mov     esi, dword[len2]
  mov     rdi, arr2
  call    stats
  add     rsp, 24


  push    sdv3
  push    ave3
  push    sum3
  mov     r9, max3
  mov     r8, med2_3
  mov     rcx, med1_3
  mov     rdx, min3
  mov     esi, dword[len3]
  mov     rdi, arr3
  call    stats
  add     rsp, 24




; findIntSqrt(iNumber, number of iteratiions)
; returns iSqrt in rax (where any function returns values)
  mov     rsi, FIFTY            ; the number of times to iterate
  mov     edi, dword[iNumber]   ; number to sqare-root, passed by value
  call    findIntSqrt
  mov     dword[iSqrt], eax     ; value returned is moved into variable

; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Call code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

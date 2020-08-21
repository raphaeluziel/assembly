; Program to sort a list of numbers using a bubble sort
; Raphael Uziel
; August 20, 2020

; *****************************************************************************
; Some basic data declarations

section         .data

; -----
; Define constants

EXIT_SUCCESS     equ      0             ; succesful operation
SYS_exit         equ      60            ; caxl code for terminate

; -----
; Define data

lst         dd      18, 97, 7, 2000, 9, 2, 35, 72, 6, 0, 4, 1, 99, 0
len         dd      14
swapped     db      0

; *****************************************************************************
; Code Section

section          .text
global _start
_start:

; -----
; The approach:
; for (i = [len-1] to 0){
;   swapped = false
;   for (j = 0 to i-1){
;     if (lst[j] > lst[j+1]){
;       tmp = lst[j]
;       lst[j] = lst[j+1]
;       lst[j+1] = temp
;       swapped = true
;     }
;   if (! swapped)
;     exit
;   }
; }

; I am using ecx, the default counter for the INNER loop since it runs
; more often, and rdi for the outer loop which I will control manually

  mov     ecx, dword[len]               ; counter for INNER loop
  mov     edi, dword[len]               ; counter for OUTER loop
  dec     ecx
  dec     edi
  mov     esi, 0                        ; index of array (j)

outerForLoop:

  cmp     edi, 0                        ; these two lines are not needed since it will jump
  jle     last                          ; out of loop anyway, but just in case
  mov     bl, 0
  mov     byte[swapped], bl             ; swapped = false

innerForLoop:

  mov     eax, dword[lst+esi*4]         ; get lst[j]
  cmp     eax, dword[lst+(esi+1)*4]     ; each doubleword is 4 bytes: compare lst[j] to lst[j+1]
  jle     notGreater                    ; if less than or equal, do not swap and exit inner loop
  mov     ebx, eax                      ; tmp[ebx] = lst[j]
  mov     eax, dword[lst+(esi+1)*4]     ; eax = lst[j+1]
  mov     dword[lst+esi*4], eax         ; lst[j] = lst[j+1]
  mov     dword[lst+(esi+1)*4], ebx     ; lst[j+1] = tmp
  mov     bl, 1
  mov     byte[swapped], bl             ; swapped = true

notGreater:

  inc     esi                           ; ++j
  loop    innerForLoop

nextPass:

  cmp     byte[swapped], 0
  je      last                          ; finished if no swapping took place (all in order)
  dec     edi                           ; i-- decrement OUTER loop counter
  mov     esi, 0                        ; reset j, the index back to 0
  mov     ecx, dword[len]               ; reset INNER loop counter
  dec     ecx                           ; again, INNER loop goes from 0 to i-1
  jmp     outerForLoop

; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Caxl code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

; Program to find the sum of squares from 1 to n

; Raphael Uziel
; July 5, 2020

; *****************************************************************************
; Data declarations

section         .data

; -----
; Define constants

EXIT_SUCCESS     equ      0             ; succesful operation
SYS_exit         equ      60            ; call code for terminate

; -----
; Define data

bNum1       db        78
bNum2       db        3
bNum3       db        14
bNum4       db        5
wNum1       dw        67

bAns1       db        0
bAns2       db        0
bAns3       db        0

bAns6       db        0
bAns7       db        0
bAns8       db        0

wAns11      dw        0
wAns12      dw        0
wAns13      dw        0

bAns16      db        0
bAns17      db        0
bAns18      db        0
bRem18      db        0


; *****************************************************************************
; Code Section

section          .text
global _start
_start:

; Compute the sum of squares from 1 to n (inclusive)
; Approach:
; for (i=1; i<=n; i++)
;   sumOfSquares += i^2

  mov     al, byte [bNum1]    ; bAns1 = bNum1 + bNum2 = 81
  add     al, byte [bNum2]
  mov     byte [bAns1], al

  mov     al, byte [bNum1]    ; bAns2 = bNum1 + bNum3 = 92
  add     al, byte [bNum3]
  mov     byte [bAns2], al

  mov     al, byte [bNum3]    ; bAns3 = bNum3 + bNum4 = 19
  add     al, byte [bNum4]
  mov     byte [bAns3], al

  mov     al, byte [bNum1]    ; bAns6 = bNum1 - bNum2 = 75
  sub     al, byte [bNum2]
  mov     byte [bAns6], al

  mov     al, byte [bNum1]    ; bAns7 = bNum1 - bNum3 = 64
  sub     al, byte [bNum3]
  mov     byte [bAns7], al

  mov     al, byte [bNum2]    ; bAns8 = bNum2 - bNum4 = -2
  sub     al, byte [bNum4]
  mov     byte [bAns8], al

  mov     al, byte [bNum1]    ; wAns11 = bNum1 * bNum3 = 1092
  mul     byte [bNum3]
  mov     word [wAns11], ax

  mov     al, byte [bNum2]    ; wAns12 = bNum2 * bNum2 = 9
  mul     byte [bNum2]
  mov     word [wAns12], ax

  mov     al, byte [bNum2]    ; wAns13 = bNum2 * bNum4 = 15
  mul     byte [bNum4]
  mov     word [wAns13], ax

  mov     al, byte [bNum1]    ; bAns16 = bNum1 / bNum2 = 26
  cbw                         ; widen byte to word can also use mov ah, 0
  ;mov     ah, 0
  div     byte [bNum2]
  mov     byte [bAns16], al

  mov     al, byte [bNum3]    ; bAns17 = bNum3 / bNum4 = 2 R 4
  cbw
  div     byte [bNum4]
  mov     byte [bAns17], al   ; The remainder would be in ah

  mov     ax, word [wNum1]    ; bAns18 = wNum1 / bNum4 = 13 R 2
  div     byte [bNum4]
  mov     byte [bAns18], al
  mov     byte [bRem18], ah


; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Call code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

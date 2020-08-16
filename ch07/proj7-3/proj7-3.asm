; Program to find the sum of squares from 1 to n

; Raphael Uziel
; July 5, 2020

; *****************************************************************************
; Data declarations

section         .data

; -----
; Define constants

EXIT_SUCCESS     equ      0             ; succesful operation
SYS_exit         equ      60            ; caxl code for terminate

; -----
; Define data

wNum1       dw        7800
wNum2       dw        20400
wNum3       dw        2146
wNum4       dw        57
dNum1       dd        67090

wAns1       dw        0
wAns2       dw        0
wAns3       dw        0

wAns6       dw        0
wAns7       dw        0
wAns8       dw        0

dAns11      dd        0
dAns12      dd        0
dAns13      dd        0

wAns16      dw        0
wAns17      dw        0
wAns18      dw        0
wRem18      dw        0


; *****************************************************************************
; Code Section

section          .text
global _start
_start:

; Compute the sum of squares from 1 to n (inclusive)
; Approach:
; for (i=1; i<=n; i++)
;   sumOfSquares += i^2

  mov     ax, word [wNum1]    ; wAns1 = wNum1 + wNum2 = 28,200
  add     ax, word [wNum2]
  mov     word [wAns1], ax

  mov     ax, word [wNum1]    ; wAns2 = wNum1 + wNum3 = 9,946
  add     ax, word [wNum3]
  mov     word [wAns2], ax

  mov     ax, word [wNum3]    ; wAns3 = wNum3 + wNum4 = 2,203
  add     ax, word [wNum4]
  mov     word [wAns3], ax

  mov     ax, word [wNum1]    ; wAns6 = wNum1 - wNum2 = -12,600
  sub     ax, word [wNum2]
  mov     word [wAns6], ax

  mov     ax, word [wNum1]    ; wAns7 = wNum1 - wNum3 = 5,654
  sub     ax, word [wNum3]
  mov     word [wAns7], ax

  mov     ax, word [wNum2]    ; wAns8 = wNum2 - wNum4 = 20,343
  sub     ax, word [wNum4]
  mov     word [wAns8], ax

  mov     ax, word [wNum1]    ; dAns11 = wNum1 * wNum3 = 159,120,000
  mul     word [wNum3]
  mov     word [dAns11], ax
  mov     word [dAns11+2], dx

  mov     ax, word [wNum2]    ; dAns12 = wNum2 * wNum2 = 416,160,000
  mul     word [wNum2]
  mov     word [dAns12], ax
  mov     word [dAns12+2], dx

  mov     ax, word [wNum2]    ; dAns13 = wNum2 * wNum4 = 1,162,800
  mul     word [wNum4]
  mov     word [dAns13], ax
  mov     word [dAns13+2], dx

  mov     ax, word [wNum1]    ; wAns16 = wNum1 / wNum2 = 0 R 7,800
  cwd                         ; widen word to double
  div     word [wNum2]
  mov     word [wAns16], ax

  mov     ax, word [wNum3]    ; wAns17 = wNum3 / wNum4 = 37 R 37
  cwd
  div     word [wNum4]
  mov     word [wAns17], ax   ; The remainder would be in dx

  mov     ax, word [dNum1]    ; wAns18 = dNum1 / wNum4 = 1,177 R 1
  mov     dx, word [dNum1+2]
  div     word [wNum4]
  mov     word [wAns18], ax
  mov     word [wRem18], dx


; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Caxl code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

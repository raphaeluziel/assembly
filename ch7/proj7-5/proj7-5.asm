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

dNum1       dd        9496729
dNum2       dd        20400000
dNum3       dd        2146723
dNum4       dd        5789
qNum1       dq        6709821

dAns1       dd        0
dAns2       dd        0
dAns3       dd        0

dAns6       dd        0
dAns7       dd        0
dAns8       dd        0

qAns11      dq        0
qAns12      dq        0
qAns13      dq        0

dAns16      dd        0
dAns17      dd        0
dAns18      dd        0
dRem18      dd        0


; *****************************************************************************
; Code Section

section          .text
global _start
_start:

; Compute the sum of squares from 1 to n (inclusive)
; Approach:
; for (i=1; i<=n; i++)
;   sumOfSquares += i^2

  mov     eax, dword [dNum1]    ; dAns1 = wdum1 + wdum2 = 29,896,729
  add     eax, dword [dNum2]
  mov     dword [dAns1], eax

  mov     eax, dword [dNum1]    ; dAns2 = dNum1 + dNum3 = 11,643,452
  add     eax, dword [dNum3]
  mov     dword [dAns2], eax

  mov     eax, dword [dNum3]    ; dAns3 = dNum3 + dNum4 = 2,152,512
  add     eax, dword [dNum4]
  mov     dword [dAns3], eax

  mov     eax, dword [dNum1]    ; dAns6 = dNum1 - dNum2 = -10,903,271
  sub     eax, dword [dNum2]
  mov     dword [dAns6], eax

  mov     eax, dword [dNum1]    ; dAns7 = wdum1 - dNum3 = 7,350,006
  sub     eax, dword [dNum3]
  mov     dword [dAns7], eax

  mov     eax, dword [dNum2]    ; dAns8 = wdum2 - dNum4 = 20,394,211
  sub     eax, dword [dNum4]
  mov     dword [dAns8], eax

  mov     eax, dword [dNum1]    ; qAns11 = dNum1 * dNum3 = 20,386,846,569,067
  mul     dword [dNum3]
  mov     dword [qAns11], eax
  mov     dword [qAns11+4], edx

  mov     eax, dword [dNum2]    ; qAns12 = dNum2 * wdum2 = 416,160,000,000,000
  mul     dword [dNum2]
  mov     dword [qAns12], eax
  mov     dword [qAns12+4], edx

  mov     eax, dword [dNum2]    ; qAns13 = wdum2 * dNum4 = 118,095,600,000
  mul     dword [dNum4]
  mov     dword [qAns13], eax
  mov     dword [qAns13+4], edx

  mov     eax, dword [dNum1]    ; wAns16 = wNum1 / wNum2 = 0 R 9,496,729
  cdq                           ; widen double word to quad word
  div     dword [dNum2]
  mov     dword [dAns16], eax

  mov     eax, dword [dNum3]    ; wAns17 = wNum3 / wNum4 = 370 R 4793
  cdq
  div     dword [dNum4]
  mov     dword [dAns17], eax    ; The remainder would be in edx

  mov     eax, dword [qNum1]     ; dAns18 = qNum1 / dNum4 = 1,159 R 370
  mov     edx, dword [qNum1+4]
  div     dword [dNum4]
  mov     dword [dAns18], eax
  mov     dword [dRem18], edx


; *****************************************************************************
; Done, terminate program.

last:
  mov             rax, SYS_exit         ; Caxl code for exit
  mov             rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

; Example program to demonstrate console output.
; This example will send some messages to the screen

; Raphael Uziel
; January 29, 2021

; *****************************************************************************
; Data declarations

section         .data

; -----
; Define constants

LF                equ     10      ; line fee ASCII code
NULL              equ     0       ; end of string
TRUE              equ     1
FALSE             equ     0

EXIT_SUCCESS      equ     0       ; succesful operation

STDIN             equ     0       ; standard input (see appendix C)
STDOUT            equ     1       ; standard output
STDERR            equ     2       ; standard error

SYS_read          equ     0       ; read
SYS_write         equ     1       ; write
SYS_open          equ     2       ; file open
SYS_close         equ     3       ; file close
SYS_fork          equ     57      ; fork
SYS_exit          equ     60      ; terminate
SYS_creat         equ     85      ; file open/create
SYS_time          equ     201     ; get time

; -----
; Define some strings

STRLEN            equ     50

pmpt              db      "Enter Answer: ", NULL
newLine           db      LF, NULL

section           .bss
chr               resb    1
inLine            resb    STRLEN+2 ; total of 52 (50 + LF + NULL)


; *****************************************************************************
; Code Section

section          .text
global main   ; _start changed to main for gcc (found online)
main:

; ----------
; Display prompt

  mov       rdi, pmpt
  call      printString

; ----------
; Read characters from user (one at a time)

  mov       rbx, inLine           ; inLine address
  mov       r12, 0                ; char count
readCharacters:
  mov       rax, SYS_read         ; system code for read
  mov       rdi, STDIN            ; standard in
  lea       rsi, byte[chr]        ; address of char
  mov       rdx, 1                ; count (how many to read)
  syscall                         ; do system call

  mov       al, byte[chr]         ; get character just read
  cmp       al, LF                ; if linefeed, input done
  je        readDone

  inc       r12                   ; count++
  cmp       r12, STRLEN           ; if # chars >= STRLEN
  jae       readCharacters        ;   stop placing in buffer

  mov       byte[rbx], al         ; inline[i] = chr
  inc       rbx                   ; update tmpStr address

  jmp       readCharacters
readDone:
  mov       byte[rbx], NULL       ; add NULL termination


; ----------
; Output the line to verify successful read

  mov       rdi, inLine
  call      printString

  mov       rdi, newLine
  call      printString


; *****************************************************************************
; Done, terminate program.

exampleDone:
  mov       rax, SYS_exit         ; Call code for exit
  mov       rdi, EXIT_SUCCESS     ; Exit program with success
  syscall

; *****************************************************************************
; Generic function to display a string to the screen.
; String must be NULL terminated
; Algorithm:
;   Count characters in string (excluding NULL)
;   Use syscall to output characters
; Arguments:
;   1) address, string
; Returns:
;   nothing

global printString
printString:
  push      rbx

; ----------
; Count characters in a string

  mov       rbx, rdi
  mov       rdx, 0
strCountLoop:
  cmp       byte[rbx], NULL
  je        strCountDone
  inc       rdx
  inc       rbx
  jmp       strCountLoop
strCountDone:

  cmp       rdx, 0
  je        prtDone

; ----------
; Call OS to output string

  mov       rax, SYS_write        ; system code for write()
  mov       rsi, rdi              ; address of chars to write
  mov       rdi, STDOUT           ; standard out. RDX=count to write, set above
  syscall                         ; system call

; ----------
; String printed, return to calling routinew

prtDone:
  pop       rbx
  ret

;=================================================
name: Josue Vargas
; Email: jvarg122@ucr.edu
; 
; Lab: lab 6, ex 1 & 2
; Lab section: 025
; TA: James Luo
; 
;=================================================

; test harness
.orig x3000
LD R4, BASE		 
LD R5, MAX		 
LD R6, TOS	
LD R2, POP_PTR
LD R3, SIZE

WHILE
GETC
OUT

LD R1, PUSH_PTR
JSRR R1

LD R0, NEWLINE
OUT

ADD R3, R3, #-1
BRp WHILE

ADD R3, R3, #8 ;change

SEC_WHILE
LD R1, POP_PTR
JSRR R1
OUT

LD R0, newline
OUT

ADD R3, R3, #-1
BRp SEC_WHILE				 
				 
halt
;-----------------------------------------------------------------------------------------------
; test harness local data:
BASE        .FILL xA000
MAX         .FILL xA005
TOS         .FILL xA000
SIZE        .FILL #6
PUSH_PTR    .FILL x3200
NEWLINE     .FILL x0A
POP_PTR     .FILL x3400

;===============================================================================================
.end

; subroutines:

;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_PUSH
; Parameter (R0): The value to push onto the stack
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has pushed (R0) onto the stack (i.e to address TOS+1). 
;		    If the stack was already full (TOS = MAX), the subroutine has printed an
;		    overflow error message and terminated.
; Return Value: R6 ← updated TOS
;------------------------------------------------------------------------------------------
.orig x3200
ST R7, BACKUP_R7
ST R0, BACKUP_R0
ST R4, BACKUP_R4
ST R2, BACKUP_R2

ADD R7, R6, #0
NOT R7, R7
ADD R7, R7, #1

AND R4, R4, x0
ADD R4, R5, R7
BRz ERROR_OVERFLOW
ADD R4, R5, R7

LD R2, NEGATIVE_48
ADD R6, R6, #1
AND R4, R4, x0
ADD R4, R0, R2
STR R4, R6, #0
BR PUSH

ERROR_OVERFLOW
LEA R0, OVERFLOW
PUTS
BR PUSH

PUSH
LD R7, BACKUP_R7
LD R0, BACKUP_R0
LD R4, BACKUP_R4
LD R2, BACKUP_R2
				 
ret
;-----------------------------------------------------------------------------------------------
; SUB_STACK_PUSH local data
OVERFLOW        .STRINGZ "\nError: overflow has occurred\n"
NEGATIVE_48     .FILL #-48

BACKUP_R7       .BLKW #1
BACKUP_R0       .BLKW #1
BACKUP_R4       .BLKW #1
BACKUP_R2       .BLKW #1

;===============================================================================================
.end

;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_POP
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available                      
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped MEM[TOS] off of the stack.
;		    If the stack was already empty (TOS = BASE), the subroutine has printed
;                an underflow error message and terminated.
; Return Value: R0 ← value popped off the stack
;		   R6 ← updated TOS
;------------------------------------------------------------------------------------------
.orig x3400
ST R7, BACKUP_R7_3400
ST R5, BACKUP_R5_3400
ST R2, BACKUP_R2_3400

ADD R7, R4, #0
NOT R7, R7
ADD R7, R7, #1

AND R5, R5, x0
ADD R5, R6, R7
BRnz ERROR_POP

LD R2, VAL_48
LDR R0, R6, #0
ADD R0, R0, R2
ADD R6, R6, #-1
BR POP

ERROR_POP
LEA R0, UNDERFLOW
PUTS
BR POP
				 
POP
LD R7, BACKUP_R7_3400
LD R5, BACKUP_R5_3400
LD R2, BACKUP_R2_3400	
				 
ret
;-----------------------------------------------------------------------------------------------
; SUB_STACK_POP local data
VAL_48      .FILL #48
UNDERFLOW   .STRINGZ "\nError: underflow has occurred\n"

BACKUP_R7_3400 .BLKW #1
BACKUP_R5_3400 .BLKW #1
BACKUP_R2_3400 .BLKW #1

;===============================================================================================
.end

.orig xA000
STACK .blkw #6
.end


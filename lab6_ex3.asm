;=================================================
name: Josue Vargas
; Email: jvarg122@ucr.edu
; 
; Lab: lab 6, ex 3
; Lab section: 025
; TA: James Luo
; 
;=================================================

; test harness
.orig x3000
LD R4, BASE
LD R5, MAX
LD R6, TOS

LEA R0, COMMAND_LINE
PUTS
LD R1, PUSH_PTR
GETC
OUT
JSRR R1

LD R0, NEWLINE
OUT

LEA R0, COMMAND_LINE
PUTS
GETC
OUT
JSRR R1

LD R0, NEWLINE
OUT

LEA R0, COMMAND_LINE2
PUTS
GETC
OUT
LD R1, MULT_PTR
JSRR R1

LD R0, NEWLINE
OUT

LD R1, POP_PTR
JSRR R1
OUT
		 
halt

;-----------------------------------------------------------------------------------------------
; test harness local data:
BASE        .FILL xA000
MAX         .FILL xA005
TOS         .FILL xA000
PUSH_PTR    .FILL x3200
MULT_PTR    .FILL x3600
POP_PTR     .FILL x3400

COMMAND_LINE    .STRINGZ "Enter a single digit number\n"
COMMAND_LINE2   .STRINGZ "Enter the * symbol\n"
NEWLINE         .STRINGZ "\n"

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

;------------------------------------------------------------------------------------------
; Subroutine: SUB_RPN_ADD
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped off the top two values of the stack,
;		    added them together, and pushed the resulting value back
;		    onto the stack.
; Return Value: R6 ← updated TOS address
;------------------------------------------------------------------------------------------
.orig x3600
ST R7, BACKUP_R7_3600
ST R0, BACKUP_R0_3600
ST R1, BACKUP_R1_3600
ST R2, BACKUP_R2_3600
ST R3, BACKUP_R3_3600

LD R1, POP_ADD ;pop address
JSRR R1

ADD R3, R0, #-12
ADD R3, R3, #-12
ADD R3, R3, #-12
ADD R3, R3, #-12
ST R3, ST_VAL

LD R1, POP_ADD
JSRR R1

ADD R2, R0, #-12
ADD R2, R2, #-12
ADD R2, R2, #-12
ADD R2, R2, #-12
ST R2, ST_VAL2

AND R0, R0, x0
WHILE
ADD R0, R0, R3
ADD R2, R2, #-1
BRp WHILE

ST R0, ST_VAL3
ADD R0, R0, #12
ADD R0, R0, #12
ADD R0, R0, #12
ADD R0, R0, #12

LD R1, PUSH_ADD ;push address
JSRR R1

LD R7, BACKUP_R7_3600
LD R0, BACKUP_R0_3600
LD R1, BACKUP_R1_3600
LD R2, BACKUP_R2_3600
LD R3, BACKUP_R3_3600

ret

;-----------------------------------------------------------------------------------------------
; SUB_RPN_MULTIPLY local data
POP_ADD     .FILL x3400
ST_VAL      .blkw #1
ST_VAL2     .blkw #1
ST_VAL3     .blkw #1
PUSH_ADD    .FILL x3200

BACKUP_R7_3600 .blkw #1
BACKUP_R0_3600 .blkw #1
BACKUP_R1_3600 .blkw #1
BACKUP_R2_3600 .blkw #1
BACKUP_R3_3600 .blkw #1

;===============================================================================================
.end

.orig xA000
STACK .blkw #6
.end
;optional
; SUB_ADDED		
; SUB_GET_NUM		
; SUB_PRINT_DIGIT		Only needs to be able to print 1 digit numbers. 


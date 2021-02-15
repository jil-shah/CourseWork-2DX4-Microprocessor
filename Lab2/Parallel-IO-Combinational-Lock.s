	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Name: Jil Shah
; Lab Section: L09
; Description of Code: Switches D1 to D2 if button 3 (odd,odd,even)is pressed 
 
; Original: Copyright 2014 by Jonathan W. Valvano, valvano@mail.utexas.edu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ADDRESS DEFINTIONS
;The EQU directive gives a symbolic name to a numeric constant, a register-relative value or a program-relative value
SYSCTL_RCGCGPIO_R            EQU 0x400FE608  ;General-Purpose Input/Output Run Mode Clock Gating Control Register (RCGCGPIO Register)
GPIO_PORTN_DIR_R             EQU 0x40064400  ;GPIO Port N Direction Register address 
GPIO_PORTN_DEN_R             EQU 0x4006451C  ;GPIO Port N Digital Enable Register address
GPIO_PORTN_DATA_R            EQU 0x400643FC  ;GPIO Port N Data Register address
	
GPIO_PORTM_DIR_R             EQU 0x40063400  ;GPIO Port M Direction Register Address 
GPIO_PORTM_DEN_R             EQU 0x4006351C  ;GPIO Port M Direction Register Address 
GPIO_PORTM_DATA_R            EQU 0x400633FC  ;GPIO Port M Data Register Address      


COMBINATION EQU 2_001
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Do not alter this section
        AREA    |.text|, CODE, READONLY, ALIGN=2 ;code in flash ROM
        THUMB                                    ;specifies using Thumb instructions
        EXPORT Start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Function PortN_Init 
PortN_Init 
    ;STEP 1
    LDR R1, =SYSCTL_RCGCGPIO_R 
    LDR R0, [R1]   
    ORR R0,R0, #0x1000        ;12th bit is 1   				          
    STR R0, [R1]               
    NOP 
    NOP   
   
    ;STEP 5
    LDR R1, =GPIO_PORTN_DIR_R   
    LDR R0, [R1] 
    ORR R0,R0, #0x3         ;0011 because this is an output port
	STR R0, [R1]   
    
    ;STEP 7
    LDR R1, =GPIO_PORTN_DEN_R   
    LDR R0, [R1] 
    ORR R0, R0, #0x3       ;0011                           
    STR R0, [R1]  
    BX  LR                            
 
PortM_Init 
    ;STEP 1 
	LDR R1, =SYSCTL_RCGCGPIO_R       
	LDR R0, [R1]   
    ORR R0,R0, #0x800      
	STR R0, [R1]   
    NOP 
    NOP   
 
    ;STEP 5
    LDR R1, =GPIO_PORTM_DIR_R   
    LDR R0, [R1] 
    ORR R0,R0, #0x0      ; 0    because this is in an input
	STR R0, [R1]   
    
	;STEP 7
    LDR R1, =GPIO_PORTM_DEN_R   
    LDR R0, [R1] 
    ORR R0, R0, #0xF     ;1111 - four digit input
	                          
    STR R0, [R1]    
	BX  LR                     
State_Init LDR R5,=GPIO_PORTN_DATA_R  ;Locked is the Initial State
		   MOV R4,#2_00000001
	       STR R4,[R5]
	       BX LR 
Start                             
	BL  PortN_Init                
	BL  PortM_Init
	BL  State_Init
	LDR R0, = GPIO_PORTM_DATA_R  ; Inputs set pointer to the input 
	LDR R3, =COMBINATION         ;R3 stores our combination
	
Loop
			LDR R1,[R0]            
			AND R2,R1,#2_00001000    ;pin m4
			CMP R2, #2_00001000      ;check if button 4 is pressed
			IT EQ                    
			ANDEQ R6,R1,#2_00000111  ;take the input from the buttons
			ANDNE R6,R1,#2_00000000  ;ignore the inputs of the buttons
			CMP R6,R3                ;compare with the required combination
			IT EQ
			BEQ Unlocked_State       ;call the unlock state which would switch led d2 to d1
			BNE Locked_State         ;call the locked state which would keep the led d2 on
 
Locked_State                    
	LDR R5,=GPIO_PORTN_DATA_R
	MOV R4,#2_00000001     ;led d2 is on in the locked state
	STR R4,[R5]
	B Loop
	
Unlocked_State
	LDR R5, =GPIO_PORTN_DATA_R
	MOV R4,#2_00000010     ;led d1 turns on 
	STR R4, [R5]
	B Loop
	
	ALIGN   
    END  


; Name: Jil Shah
; Student Number: 400252316
; Lab Section: L09
; Description of Code: Turns on led d3 using an external button. 

 
; Original: Copyright 2014 by Jonathan W. Valvano, valvano@mail.utexas.edu



SYSCTL_RCGCGPIO_R             EQU     0x400FE608         ;General-Purpose Input/Output Run Mode Clock Gating Control Register

GPIO_PORTF_DATA_R             EQU     0x4005D3FC         ;GPIO Port N DATA Register 
GPIO_PORTF_DIR_R              EQU     0x4005D400         ;GPIO Port N DIR Register
GPIO_PORTF_DEN_R              EQU     0x4005D51C         ;GPIO Port N DEN Register

GPIO_PORTM_DATA_R             EQU     0x400633FC         ;GPIO Port N DATA Register 
GPIO_PORTM_DIR_R              EQU     0x40063400         ;GPIO Port N DIR Register
GPIO_PORTM_DEN_R              EQU     0x4006351C         ;GPIO Port N DEN Register


                              
        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT Start

;Function PortN_Init
PortF_Init
		 LDR R1, =SYSCTL_RCGCGPIO_R    		
		 LDR R0, [R1]						
		 ORR R0,R0, #0x820					
		 STR R0, [R1]						
		 NOP
		 NOP
		 
		 ;STEP 5
		 LDR R1, =GPIO_PORTF_DIR_R			
		 LDR R0, [R1]						
		 ORR R0,R0, #0x10					
		 STR R0, [R1]	

		;STEP 7
		 LDR R1, =GPIO_PORTF_DEN_R			
		 LDR R0, [R1]						
		 ORR R0,R0, #0x10					
		 STR R0, [R1]	
PortM_Init 
		;STEP 1 
		 LDR R1, =SYSCTL_RCGCGPIO_R    		
		 LDR R0, [R1]						
		 ORR R0,R0, #0x820					
		 STR R0, [R1]						
		 NOP
		 NOP
		
		;STEP 5				
		 
		 LDR R1, =GPIO_PORTM_DIR_R			
		 LDR R0, [R1]						
		 BIC R0,R0, #0x1					
		 STR R0, [R1]						
		 
		;STEP 7				
		 
		 LDR R1, =GPIO_PORTM_DEN_R			
		 LDR R0, [R1]						
		 ORR R0,R0, #0x1					
		 STR R0, [R1]						
		
        BX LR               ; return from function 

Start                                   ;Your program starts here
    BL  PortF_Init                      ;The BL instruction is a function call, the next instruction address is stored in the link register. This calls your initialize function 
    BL  PortM_Init                      ;The BL instruction is a function call, the next instruction address is stored in the link register. This calls your initialize function 


		LDR R1, =GPIO_PORTF_DATA_R			; load the data register for R1
		LDR R0, [R1]						; load Register 1 into Regiter 2 

LED  	LDR R2, =GPIO_PORTM_DATA_R			; load the data register for R2
		LDR R3, [R2]						; load Register 2 into Register 3
		 
		SUBS R3, #0x0						; subtract 0 from the register 3
		ITE EQ								; If-then Statement for the subtraction comparison above
		ORREQ R0,R0, #0x10                  ; if true then or will be used to turn on the led 
		ANDNE R0,R0, #0x0                   ; if false then and will be used to turn off the led
		 
		STR R0, [R1]                        ; Store what is in the register to the memory address
		B LED                               ; Loop to the of the branch
		
		ALIGN               ; directive for assembly			
        END                 ; End of function 

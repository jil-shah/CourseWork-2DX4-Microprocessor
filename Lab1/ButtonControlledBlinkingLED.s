SYSCTL_RCGCGPIO_R             EQU     0x400FE608         ;General-Purpose Input/Output Run Mode Clock Gating Control Register
GPIO_PORTF_DIR_R              EQU     0x4005D400         ;GPIO Port N DIR Register
GPIO_PORTF_DEN_R              EQU     0x4005D51C         ;GPIO Port N DEN Register
GPIO_PORTF_DATA_R             EQU     0x4005D3FC         ;GPIO Port N DATA Register 
GPIO_PORTM_DIR_R              EQU     0x40063400         ;GPIO Port N DIR Register
GPIO_PORTM_DEN_R              EQU     0x4006351C         ;GPIO Port N DEN Register
GPIO_PORTM_DATA_R             EQU     0x400633FC         ;GPIO Port N DATA Register 

                              
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

Start 
	    BL PortF_Init                       ; calls and executes the initializations for PortM and PortF
		BL PortM_Init    
	
		LDR R1, =GPIO_PORTF_DATA_R			; Set the data register for R1
		LDR R0, [R1]						; Store Register 1 into Regiter 2 

LED  	LDR R2, =GPIO_PORTM_DATA_R			; Set the data register for R2
		LDR R3, [R2]						; Store Register 2 into Register 3
		 
		SUBS R3, #0x0						; subtract 0 from the register 3
		ITE EQ								; If Sta
		ORREQ R0,R0, #0x10
		ANDNE R0,R0, #0x0
		 
		STR R0, [R1]
		B LED
		
		ALIGN               ; directive for assembly			
        END                 ; End of function 

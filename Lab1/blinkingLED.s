
; Written by Jil Shah

SYSCTL_RCGCGPIO_R            EQU 0x400FE608  ;General-Purpose Input/Output Run Mode Clock Gating Control Register (RCGCGPIO Register)
GPIO_PORTN_DATA_R            EQU 0x400643FC  
GPIO_PORTN_DIR_R             EQU 0x40064400
GPIO_PORTN_DEN_R             EQU 0x4006451C 

                     
DELAY						 EQU 2000000


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Do not alter this section

        AREA    |.text|, CODE, READONLY, ALIGN=2 ;code in flash ROM
        THUMB                                    ;specifies using Thumb instructions
        EXPORT Start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Define Functions in your code here 
;The function Port N_Init to configures the GPIO Port N 
PortN_Init
    ; STEP 1
    LDR R1, =SYSCTL_RCGCGPIO_R          
    LDR R0, [R1]                       
    ORR R0,R0, #0x1000                   
    STR R0, [R1]               
    NOP                              
	NOP                                 
  
   ; STEP 5
    LDR R1, =GPIO_PORTN_DIR_R        
    LDR R0, [R1]                      
    ORR R0,R0, #0x1                  
    STR R0, [R1]                        
    
	; STEP 7
    LDR R1, =GPIO_PORTN_DEN_R           
    LDR R0, [R1]                       
    ORR R0, R0, #0x1                 
    STR R0, [R1]	                     
    BX  LR                              ;return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Start
    BL  PortN_Init                      ;initialize the N port 
	;LDR R1, =0x0

LED_ON
    LDR R1, = GPIO_PORTN_DATA_R          ; load the register
	LDR R0,[R1]                          ;
    ORR R0,R0, #0x1                      ; use or and this will turn the led on
    STR R0, [R1]                    
	LDR R2, =DELAY                       ; there is a time delay
	
delay1 
	SUBS R2,#1                            ; time delay is added
	BNE delay1                            ; and repeated
	
LED_OFF
    LDR R1, =GPIO_PORTN_DATA_R            ; load the register
	LDR R0,[R1]                           
    AND R0,R0, #0x0                       ; compares with 0 using and 
    STR R0, [R1]
	LDR R2, =DELAY
	
delay2 
	SUBS R2,#1                            ; the delay is done once again using subtract
	BNE delay2                            ; and repeated

	B LED_ON                              ; repeat the loop turning the led on again
	
	ALIGN                               ;Do not touch this 
    END   

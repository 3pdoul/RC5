;
; AssemblerApplication3.asm
;
; Created: 4/15/2020 1:55:19 AM
; Author : dolcie
;r=8
;S.length=18
;
;
;
;
;
;
;



; Generating random key to verify my answer easily 
;Load
LDI R17,0x06
LDI R16,0x7C
LDI ZL,0x88; 0188 
LDI ZH,0x01

SLOOP: ; This loop is for generating the secret key only. 
		
		ST Z+, R16
		ST Z+, R16 
		ADD R16,R17 
		DEC R17

		BRNE SLOOP 
NOP



;Expansion key 
LDI ZL,0x0A; memory address 
LDI ZH,0x01; memory address 

LDI R19,0x11; counter 
LDI R18, 0x36

LDI R16,0x00; i
LDI R17, 0x00; j 




LDI R24, 0xE1; Low P
LDI R25, 0xB7; High P


;SecondStep
ST Z+, R25 
ST Z+, R24
LDI R28, 0x37; Low Q
LDI R29, 0x9E; High Q


Step2:
	LOOP:
		ADD R24, R28
		ADC R25, R29 
		ST Z+, R25
		ST Z+, R24
		DEC R19
		BRNE Step2
;#############################
;Step 3 
LDI ZL, 0x88; 0188 
LDI ZH, 0x01; L 

LDI XL, 0x0A; S
LDI XH, 0x01; 
LDI R16, 0x00; LOW A 
LDI R17, 0x00 ; High  A 
LDI R18, 0x06;counter 
LDI R19, 0x03; counter 
LDI R29, 0x03; counter 
LDI R20, 0x00; LOW S
LDI R21, 0x00; HIGH S 
LDI R22, 0x00; LOW L
LDI R23, 0x00; HIGH L 
LDI R24, 0x00; Low B
LDI R25, 0x00; High B


Step3: ; it contains three loops 3,3,6. the outer loop is to set the memory address for the (S). 
	LDI XL, 0x0A; S
	LDI XH, 0x01; 
	LDI R19, 0x03; counter 

	LOOP_2:
		LDI R18, 0x06;counter 
		LDI ZL, 0x88; 0188 
		LDI ZH, 0x01; L 
		LOOP_1: 
			LD R21,X+
			LD R20,X+
			ADD R16, R20 
			ADC R17, R21 
			ADD R16, R24 
			ADC R17, R25 

			CALL ROTATEL_3
			ST -X , R16
			ST -X , R17
			ADIW R26,2 

			ADD R24, R16 
			ADC R25, R17 
			MOV R28, R24
			ANDI R28, 0x0F 

			LD R23,Z+
			LD R22,Z+
			ADD R24, R22
			ADC R25, R23 


			CALL ROTATEL_AB
			ST -Z, R24
			ST -Z, R25 
			ADIW R30,2 


			DEC R18
			BRNE LOOP_1
			DEC R19 
			BRNE LOOP_2
			DEC R29 
			BRNE Step3	

			NOP
;##############


;Load
;LDI R17,0x12
;LDI R16,0x32

;LDI ZL,0x0A
;LDI ZH,0x01

;SLOOP: 
	;ST Z+, R16
	;ST Z+, R16 
	;ADD R16,R17 
	;DEC R17

	;BRNE SLOOP 

; // Encryption Algoritm

LDI ZL,0x0A
LDI ZH,0x01
LDI R19, 0x08; Counter 0-7  
LDI R24, 0xF3; Low A							#INPUT#
LDI R25, 0x22; High A
LDI R26, 0xF3; Low B 
LDI R27, 0x2C; High B


; // Encryption Algoritm
LD  R21,Z+
LD	R20, Z+ 
ADD R24, R20
ADC R25, R21

LD  R21,Z+
LD	R20, Z+ 
ADD R26, R20
ADC R27, R21


LOOP1:
	;XOR
	EOR R24,R26
	EOR R25,R27
	;Load Counter 
	MOV R23,R26 ; counter 
	ANDI R23,0x0F
	;ROTATE 
	CALL ROTATEL_A

	LD  R21,Z+
	LD	R20, Z+ 
	ADD R24, R20
	ADC R25, R21

	;XOR
	EOR R26,R24
	EOR R27,R25
	;Load Counter 
	MOV R23,R24
	ANDI R23,0x0F
	;ROTATE 
	CALL ROTATEL_B
	LD  R21, Z+
	LD	R20, Z+ 
	ADD R26, R20
	ADC R27, R21

 
	DEC R19

	BRNE LOOP1
NOP
NOP





; Dycreption Algorithm 
LDI R19, 0x08
;ADIW R30,1 
LOOP2:
	LD  R20,-Z
	LD	R21,-Z  
	SUB R26,R20 
	SBC R27,R21 

	MOV R23,R24
	ANDI R23,0x0F
	CALL ROTATER_B

	EOR R26,R24
	EOR R27,R25

	LD  R20,-Z
	LD	R21 ,-Z
	SUB R24,R20 
	SBC R25,R21 
	

	MOV R23,R26
	ANDI R23,0x0F
	CALL ROTATER_A

	EOR R24,R26
	EOR R25,R27







	DEC R19

	BRNE LOOP2

	LD  R20,-Z
	LD	R21 ,-Z
	SUB R26,R20 
	SBC R27,R21 

	LD  R20,-Z
	LD	R21 ,-Z
	SUB R24,R20 
	SBC R25,R21 

	NOP
	NOP



;ROTATIONS Algorthms 


ROTATEL_A:
	CLC
	SBRC R24,7
	SEC 
	ROL R25 
	ROL R24 
	
	DEC R23

	BRNE ROTATEL_A
	RET
	
	
	 
ROTATEL_B: 
	CLC
	SBRC R26,7
	SEC 
	ROL R27 
	ROL R26 
	
	DEC R23

	BRNE ROTATEL_B
	RET


ROTATER_A:
	CLC
	SBRC R25,0
	SEC 
	ROR R24 
	ROR R25 
	
	DEC R23 
	BRNE ROTATER_A
	RET
	
	 
ROTATER_B: 
	CLC
	SBRC R27,0
	SEC 
	ROR R26 
	ROR R27 
	
	DEC R23
	BRNE ROTATER_B
	RET



ROTATEL_3: 
	CLC
	SBRC R16,7
	SEC 
	ROL R17 
	ROL R16 
	
	CLC
	SBRC R16,7
	SEC 
	ROL R17 
	ROL R16 
	
	CLC
	SBRC R16,7
	SEC 
	ROL R17 
	ROL R16 
	RET

ROTATEL_AB: 
	CLC
	SBRC R24,7
	SEC 
	ROL R25 
	ROL R24 
	
	DEC R28

	BRNE ROTATEL_AB
	RET
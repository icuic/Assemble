;*****************************************************
;Company :
;File Name : FireLight.asm
;Author :
;Create Data : 2015-10-11
;Last Modified : 2015-10-11
;Description :
;Version : 1.0
;*****************************************************

USER	EQU	30H
USER2	EQU	31H

	ORG	0000H

	;TODO: Add your assembly code here

	JMP	RESET		;RESET ISP
	RTNI			;ADC INTERRUPT ISP
	RTNI			;TIMER0 ISP
	RTNI			;TIMER1 ISP
	RTNI			;PORTB/D ISP
	
RESET:
	NOP
	LDI	USER,	08H
	LDI	USER2,	09H
	LDA	USER,	00H
	
	ADI	USER2,	06H
	
	
	
	NOP
	NOP



	END

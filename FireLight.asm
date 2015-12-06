;*****************************************************
;Company :
;File Name : FireLight.asm
;Author :
;Create Data : 2015-10-11
;Last Modified : 2015-10-11
;Description :
;Version : 1.0
;*****************************************************

LIST P=69P48
ROMSIZE=4096

;*****************************************************
;ϵͳ�Ĵ��� ($000 ~ $02F, $380 ~ $38C)
;*****************************************************
IE	EQU	00H			;�ж�ʹ��/���ܿ���
IRQ	EQU	01H			;�ж������־

TM0	EQU	02H			;Timer0 ģʽ�Ĵ���
TM1	EQU	03H			;Timer1 ģʽ�Ĵ���

TL0	EQU	04H			;Timer0 ����ֵ��4λ
TH0	EQU	05H			;Timer0 ����ֵ��4λ

TL1	EQU	06H			;Timer1 ����ֵ��4λ
TH1	EQU	07H			;Timer1 ����ֵ��4λ

PORTA	EQU	08H			;PortA ���ݼĴ���
PORTB	EQU	09H			;PortB ���ݼĴ���
PORTC	EQU	0AH			;PortC ���ݼĴ���
PORTD	EQU	0BH			;PortD ���ݼĴ���
PORTE	EQU	0CH			;PortE ���ݼĴ���

					;0DH Reserved
				
TBR	EQU	0EH			;���Ĵ���
INX	EQU	0FH			;���Ѱַα�����Ĵ���
DPL	EQU	10H			;INX����ָ���4λ
DPM	EQU	11H			;INX����ָ����4λ
DPH	EQU	12H			;INX����ָ���4λ

TCTL1	EQU	13H			;Timer1 ���ƼĴ���

ADCCTL	EQU	14H			;ADC ʹ����ο���ѹ
ADCCFG	EQU	15H			;ADC configuration
ADCPORT	EQU	16H			;ADC PORT CONFIGURATION
ADCCHN	EQU	17H			;ADC channel selection

PACR	EQU	18H			;PortA ���ƼĴ���
PBCR	EQU	19H			;PortB ���ƼĴ���
PCCR	EQU	1AH			;PortC ���ƼĴ���
PDCR	EQU	1BH			;PortD ���ƼĴ���
PECR	EQU	1CH			;PortE ���ƼĴ���

PWMC0	EQU	20H			;PWM0 ���ƼĴ���
PWMC1	EQU	21H			;PWM1 ���ƼĴ���

PWMP00	EQU	22H			;PWM0 ���ڿ��ƼĴ�����4λ
PWMP01	EQU	23H			;PWM0 ���ڿ��ƼĴ�����4λ

PWMD00	EQU	24H			;PWM0 ռ�ձȿ��ƼĴ�����2λ
PWMD01	EQU	25H			;PWM0 ռ�ձȿ��ƼĴ�����4λ
PWMD02	EQU	26H			;PWM0 ռ�ձȿ��ƼĴ�����4λ

PWMP10	EQU	27H			;PWM1 ���ڿ��ƼĴ�����4λ
PWMP11	EQU	28H			;PWM1 ���ڿ��ƼĴ�����4λ

PWMD10	EQU	29H			;PWM1 ռ�ձȿ��ƼĴ�����2λ
PWMD11	EQU	2AH			;PWM1 ռ�ձȿ��ƼĴ�����4λ
PWMD12	EQU	2BH			;PWM1 ռ�ձȿ��ƼĴ�����4λ


AD_RET0	EQU	2DH			;ADC ת�������2λ
AD_RET1	EQU	2EH			;ADC ת�������4λ
AD_RET2	EQU	2FH			;ADC ת�������4λ


PPACR 	EQU 	388H 			;PORTA ������������ƼĴ��� 
PPBCR 	EQU 	389H 			;PORTB ������������ƼĴ��� 
PPCCR 	EQU 	38AH 			;PORTC ������������ƼĴ��� 
PPDCR 	EQU 	38BH 			;PORTD ������������ƼĴ��� 
PPECR 	EQU 	38CH 			;PORTE ������������ƼĴ��� 

;*****************************************************
;�û��Զ���Ĵ��� ($030 ~ $0EF)
;*****************************************************
;Bank0
;------------------------------------------------------------------
AC_BAK 	EQU 	30H 			;AC ֵ���ݼĴ���

SIMULATE_STA	EQU	31H		;bit0 = 1, ����"ģ��ͣ��"״̬
					;bit1 = 1, ����"�ֶ��¼�"״̬
					;bit2 = 1, ����"�ֶ����"״̬
					;bit3 = 1, ����"�ض�Ӧ�����"״̬

NORMAL_STA	EQU	32H		;bit0 = 1, ��ǰ����"����"״̬
ABNORMAL_STA	EQU	33H		;bit0 = 1, ��ǰ����"ͣ��"��"ģ��ͣ��"״̬
					;bit1 = 1, ��ǰ����"�¼�"��"�ֶ��¼�"״̬
					;bit2 = 1, ��ǰ����"���"��"�ֶ����"״̬

;--------------------------------------
; ����TIMER ��ʱ
F_BUTTON	EQU	35H		;���������ʹ�á�bit0=1, 496ms ��;
F_TIME 		EQU 	36H 		;bit0=1, 1s ��; bit1=1, 1�µ�; bit2=1, 1�굽��

CNT0 		EQU 	37H 		;CNT1,CNT0��ɵ�8BIT���ݴﵽ125ʱ����Timer0����125���жϺ󣬱�ʾ1S��ʱ�ѵ�
CNT1 		EQU 	38H 		;���ԣ�CNT1=07H, CNT0=0DH

SEC_CNT0	EQU	39H		;SEC_CNT0/1/2 ����Ϊ��λ��ʱ
SEC_CNT1	EQU	3AH		;����ֵ�ﵽ1Сʱ����3600(E10H)��ʱ����HOUR_CNT0/1��λ���������㡣
SEC_CNT2	EQU	3BH

HOUR_CNT0	EQU	3CH		;HOUR_CNT0/1 ��СʱΪ��λ��ʱ
HOUR_CNT1	EQU	3DH		;����ֵ�ﵽ1��ʱ����744(2EBH)Сʱʱ����MONTH_CNT0/1��λ��ͬʱ��F_TIME.1���������㡣
HOUR_CNT2	EQU	3EH		

MONTH_CNT	EQU	3FH		;MONTH_CNT0/1 ����Ϊ��λ��ʱ
					;����ֵ�ﵽ1��ʱ����12(0CH)��ʱ����ͬʱ��F_TIME.2���������㡣

TEMP_SUM_CY	EQU	40H		;�ӳ��������ʱ����



;������ؼĴ���
DELAY_TIMER2	EQU	71H		;��ʱ�ӳ���ʹ��
DELAY_TIMER1	EQU	72H		;��ʱ�ӳ���ʹ��
DELAY_TIMER0	EQU	73H		;��ʱ�ӳ���ʹ��
CLEAR_AC 	EQU 	74H 		;����ۼ���A ֵ�üĴ���
TEMP 		EQU 	75H 		;��ʱ�Ĵ���

CNT0_496MS	EQU	76H		;���ڶ�ʱ496MS
CNT1_496MS	EQU	77H

BTN_PRE_STA	EQU	78H		;bit0������һ�ΰ���״̬,0:����,1:δ����
BTN_PRESS_CNT	EQU	79H		;��������ʱ������λΪ496ms

CNT0_200MS	EQU	7AH		;���ڶ�ʱ200MS
CNT1_200MS	EQU	7BH
F_200MS		EQU	7CH		;ÿ200ms��bit0 = 1

;Bank1(���¼Ĵ�����ʵ��ַӦ����80H)
;------------------------------------------------------------------
CHN0_RET0_BAK0	EQU	00H		;ADC CHN0 ת�������2λ����
CHN0_RET1_BAK0	EQU	01H		;ADC CHN0 ת�������4λ����
CHN0_RET2_BAK0	EQU	02H		;ADC CHN0 ת�������4λ����

CHN0_RET0_BAK1	EQU	03H		;ADC CHN0 ת�������2λ����
CHN0_RET1_BAK1	EQU	04H		;ADC CHN0 ת�������4λ����
CHN0_RET2_BAK1	EQU	05H		;ADC CHN0 ת�������4λ����

CHN0_RET0_BAK2	EQU	06H		;ADC CHN0 ת�������2λ����
CHN0_RET1_BAK2	EQU	07H		;ADC CHN0 ת�������4λ����
CHN0_RET2_BAK2	EQU	08H		;ADC CHN0 ת�������4λ����

CHN0_RET0_BAK3	EQU	09H		;ADC CHN0 ת�������2λ����
CHN0_RET1_BAK3	EQU	0AH		;ADC CHN0 ת�������4λ����
CHN0_RET2_BAK3	EQU	0BH		;ADC CHN0 ת�������4λ����

CHN0_FINAL_RET0	EQU	0CH		;ͨ��0ƽ����Ľ��
CHN0_FINAL_RET1	EQU	0DH		;
CHN0_FINAL_RET2	EQU	0EH

DET0_CT		EQU	0FH		;ADC ͨ��0 ת���������

;------------------------------------------------------------------
CHN1_RET0_BAK0	EQU	10H		;ADC CHN1 ת�������2λ����
CHN1_RET1_BAK0	EQU	11H		;ADC CHN1 ת�������4λ����
CHN1_RET2_BAK0	EQU	12H		;ADC CHN1 ת�������4λ����

CHN1_RET0_BAK1	EQU	13H		;ADC CHN1 ת�������2λ����
CHN1_RET1_BAK1	EQU	14H		;ADC CHN1 ת�������4λ����
CHN1_RET2_BAK1	EQU	15H		;ADC CHN1 ת�������4λ����

CHN1_RET0_BAK2	EQU	16H		;ADC CHN1 ת�������2λ����
CHN1_RET1_BAK2	EQU	17H		;ADC CHN1 ת�������4λ����
CHN1_RET2_BAK2	EQU	18H		;ADC CHN1 ת�������4λ����

CHN1_RET0_BAK3	EQU	19H		;ADC CHN1 ת�������2λ����
CHN1_RET1_BAK3	EQU	1AH		;ADC CHN1 ת�������4λ����
CHN1_RET2_BAK3	EQU	1BH		;ADC CHN1 ת�������4λ����

CHN1_FINAL_RET0	EQU	1CH		;ͨ��1ƽ����Ľ��
CHN1_FINAL_RET1	EQU	1DH		;
CHN1_FINAL_RET2	EQU	1EH		;

DET1_CT		EQU	1FH		;ADC ͨ��1 ת���������

;------------------------------------------------------------------
CHN6_RET0_BAK0	EQU	20H		;ADC CHN6 ת�������2λ����
CHN6_RET1_BAK0	EQU	21H		;ADC CHN6 ת�������4λ����
CHN6_RET2_BAK0	EQU	22H		;ADC CHN6 ת�������4λ����

CHN6_RET0_BAK1	EQU	23H		;ADC CHN6 ת�������2λ����
CHN6_RET1_BAK1	EQU	24H		;ADC CHN6 ת�������4λ����
CHN6_RET2_BAK1	EQU	25H		;ADC CHN6 ת�������4λ����

CHN6_RET0_BAK2	EQU	26H		;ADC CHN6 ת�������2λ����
CHN6_RET1_BAK2	EQU	27H		;ADC CHN6 ת�������4λ����
CHN6_RET2_BAK2	EQU	28H		;ADC CHN6 ת�������4λ����

CHN6_RET0_BAK3	EQU	29H		;ADC CHN6 ת�������2λ����
CHN6_RET1_BAK3	EQU	2AH		;ADC CHN6 ת�������4λ����
CHN6_RET2_BAK3	EQU	2BH		;ADC CHN6 ת�������4λ����

CHN6_FINAL_RET0	EQU	2CH		;ͨ��6ƽ����Ľ��
CHN6_FINAL_RET1	EQU	2DH		;
CHN6_FINAL_RET2	EQU	2EH

DET6_CT		EQU	2FH		;ADC ͨ��6 ת���������

;------------------------------------------------------------------
CHN7_RET0_BAK0	EQU	30H		;ADC CHN7 ת�������2λ����
CHN7_RET1_BAK0	EQU	31H		;ADC CHN7 ת�������4λ����
CHN7_RET2_BAK0	EQU	32H		;ADC CHN7 ת�������4λ����

CHN7_RET0_BAK1	EQU	33H		;ADC CHN7 ת�������2λ����
CHN7_RET1_BAK1	EQU	34H		;ADC CHN7 ת�������4λ����
CHN7_RET2_BAK1	EQU	35H		;ADC CHN7 ת�������4λ����

CHN7_RET0_BAK2	EQU	36H		;ADC CHN7 ת�������2λ����
CHN7_RET1_BAK2	EQU	37H		;ADC CHN7 ת�������4λ����
CHN7_RET2_BAK2	EQU	38H		;ADC CHN7 ת�������4λ����

CHN7_RET0_BAK3	EQU	39H		;ADC CHN7 ת�������2λ����
CHN7_RET1_BAK3	EQU	3AH		;ADC CHN7 ת�������4λ����
CHN7_RET2_BAK3	EQU	3BH		;ADC CHN7 ת�������4λ����

CHN7_FINAL_RET0	EQU	3CH		;ͨ��7ƽ����Ľ��
CHN7_FINAL_RET1	EQU	3DH		;
CHN7_FINAL_RET2	EQU	3EH		;

DET7_CT		EQU	3FH		;ADC ͨ��7 ת���������
;------------------------------------------------------------------


;*****************************************************
;����
;*****************************************************
	ORG	0000H

	;�ж�������
	JMP	RESET			;RESET ISP
	JMP	ADC_ISP			;ADC INTERRUPT ISP
	JMP	TIMER0_ISP		;TIMER0 ISP
	RTNI				;TIMER1 ISP
	RTNI				;PORTB/D ISP

;*****************************************************
;Timer0 �жϷ������
;*****************************************************
TIMER0_ISP:
	STA 	AC_BAK,		00H 	;����AC ֵ
	ANDIM 	IRQ,		1011B 	;��TIMER0 �ж������־

J_200MS:
	SBIM	CNT0_200MS,	01H
	LDI	TBR,		00H
	SBCM	CNT1_200MS
	BC	J_496MS

	LDI	CNT0_200MS,	08H
	LDI	CNT1_200MS,	01H

	ORIM	F_200MS,	0001B
	
J_496MS:
	;--------------------------------------------------------------------------
	SBIM 	CNT0_496MS,	01H	;ÿ��Timer0�жϲ����󣬽�CNT0_496MS��1
	LDI	TBR,		00H	;���ۼ���A ��0
	SBCM	CNT1_496MS		;ÿ��CNT0-1������λʱ����CNT1_496MS��1
	BC	J1MS			;���δ������λ�����ʾ200MS��δ����

	LDI 	CNT0_496MS,	0DH 	;����496ms ������,496 = 8 * 62
	LDI 	CNT1_496MS,	03H 	;����496ms ������
	
	ORIM 	F_BUTTON,	0001B 	;���� "496ms ��"��־

J1MS:	
	;--------------------------------------------------------------------------
	SBIM 	CNT0,		01H	;ÿ��Timer0�жϲ����󣬽�CNT0��1
	BC 	TIMER0_ISP_END 		;CNT0�Դ���0, �����ISP
	SBIM	CNT1,		01H	;ÿ��CNT0-1������λʱ����CNT1��1
	BC	TIMER0_ISP_END
	
	LDI 	CNT0,		0CH 	;����1s ������
	LDI 	CNT1,		07H 	;����1s ������
	
	ORIM 	F_TIME,		0001B 	;���� "1s ��"��־
	;--------------------------------------------------------------------------
	

	;--------------------------------------------------------------------------
	SBIM	SEC_CNT0,	01H	;SEC_CNT0 ÿ���1
	BC	TIMER0_ISP_END		;SEC_CNT0�Դ���0�������ISP
	SBIM	SEC_CNT1,	01H	;ÿ��SEC_CNT0-1������λʱ����SEC_CNT1��1
	BC	TIMER0_ISP_END		;SEC_CNT1�Դ���0�������ISP
	SBIM	SEC_CNT2,	01H	;ÿ��SEC_CNT1-1������λʱ����SEC_CNT2��1
	BC	TIMER0_ISP_END		;SEC_CNT2��1������λʱ�����ʾ1Сʱ��ʱ�ѵ�
	
	LDI 	SEC_CNT0,	0FH 	;����SEC_CNT0/1/2 ΪE10H-1(3600-1)
	LDI 	SEC_CNT1,	00H
	LDI 	SEC_CNT2,	0EH
	;--------------------------------------------------------------------------
	
	
	;--------------------------------------------------------------------------
	SBIM 	HOUR_CNT0,	01H	;HOUR_CNT0 ÿСʱ��1
	BC 	TIMER0_ISP_END 		;HOUR_CNT0 �Դ���0, �����ISP
	SBIM	HOUR_CNT1,	01H	;ÿ�� HOUR_CNT0 ������λʱ���� HOUR_CNT1 ��1
	BC	TIMER0_ISP_END		;HOUR_CNT1 ��1������λʱ�����ʾ1�¼�ʱ�ѵ�
	
	LDI 	HOUR_CNT0,	07H 	;����HOUR_CNT0/1/2 Ϊ2E8H-1(744-1)
	LDI 	HOUR_CNT1,	0EH
	LDI	HOUR_CNT2,	02H
	
	ORIM 	F_TIME,		0010B 	;���� "1�µ�" ��־
	;--------------------------------------------------------------------------
	
	
	;--------------------------------------------------------------------------
	SBIM 	MONTH_CNT,	01H	;MONTH_CNT ÿ�¼�1
	BC 	TIMER0_ISP_END		;MONTH_CNT ��1������λʱ�����ʾ1���ʱ�ѵ�
	
	LDI 	MONTH_CNT,	0BH 	;����MONTH_CNT Ϊ0CH-1(12-1)
	
	ORIM 	F_TIME,		0100B 	;���� "1�굽" ��־
	;--------------------------------------------------------------------------

TIMER0_ISP_END:
	LDI 	IE,		1100B 	;��ADC,Timer0 �ж�
	LDA 	AC_BAK,		00H 	;ȡ��AC ֵ
	RTNI	
	
;*****************************************************
;ADC �жϷ������
;*****************************************************	
ADC_ISP:
	STA 	AC_BAK,		00H 	;����AC ֵ
	ANDIM 	IRQ,		0111B 	;��ADC �ж������־
	
	LDA	ADCCHN			
	BAZ	CHN0_VOL_1		;�˴�Ϊͨ��0 ת�����
	SBI	ADCCHN,		01H
	BAZ	CHN1_VOL_1		;�˴�Ϊͨ��1 ת�����	
	SBI	ADCCHN,		06H
	BAZ	CHN6_VOL_1		;�˴�Ϊͨ��6 ת�����
	SBI	ADCCHN,		07H
	BAZ	CHN7_VOL_1		;�˴�Ϊͨ��7 ת�����
	JMP	ADC_ISP_END		;��������²�Ӧִ�д����
	
;----------------------------------------------------------------	

;ת��ͨ��0 ת�����
;----------------------------------------------------------------
CHN0_VOL_1:
	LDI	TBR,		01H	;������һ
	ADDM	DET0_CT,	01H	

	LDI	TBR,		04H	;DET0_CT - 4 -> A
	SUB	DET0_CT,	01H
	BAZ 	CHN0_VOL_14		;��4��ת�����

	LDI	TBR,		03H	;DET0_CT - 3 -> A
	SUB	DET0_CT,	01H
	BAZ 	CHN0_VOL_13		;��3��ת�����

	LDI	TBR,		02H	;DET0_CT - 2 -> A
	SUB	DET0_CT,	01H
	BAZ 	CHN0_VOL_12		;��2��ת�����

CHN0_VOL_11:
	LDA 	AD_RET0,	00H 	;�����һ��A/D ת�����
	STA 	CHN0_RET0_BAK0,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN0_RET1_BAK0,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN0_RET2_BAK0,	01H
	JMP 	NEXT_CHN	

CHN0_VOL_12:
	LDA 	AD_RET0,	00H 	;����ڶ���A/D ת�����
	STA 	CHN0_RET0_BAK1,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN0_RET1_BAK1,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN0_RET2_BAK1,	01H
	JMP 	NEXT_CHN
	
CHN0_VOL_13:
	LDA 	AD_RET0,	00H 	;���������A/D ת�����
	STA 	CHN0_RET0_BAK2,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN0_RET1_BAK2,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN0_RET2_BAK2,	01H
	JMP 	NEXT_CHN	
	
CHN0_VOL_14:
	LDA 	AD_RET0,	00H 	;������Ĵ�A/D ת�����
	STA 	CHN0_RET0_BAK3,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN0_RET1_BAK3,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN0_RET2_BAK3,	01H

	LDI	TBR,		00H	;DET0_CT ��0
	STA	DET0_CT,	01H
	
	CALL	CAL_CHN0_ADCDATA
	
	JMP 	NEXT_CHN	
;----------------------------------------------------------------	

;ת��ͨ��1 ת�����
;----------------------------------------------------------------
CHN1_VOL_1:
	LDI	TBR,		01H	;������һ
	ADDM	DET1_CT,	01H	

	LDI	TBR,		04H	;DET1_CT - 4 -> A
	SUB	DET1_CT,	01H
	BAZ 	CHN1_VOL_14		;��4��ת�����

	LDI	TBR,		03H	;DET1_CT - 3 -> A
	SUB	DET1_CT,	01H
	BAZ 	CHN1_VOL_13		;��3��ת�����

	LDI	TBR,		02H	;DET1_CT - 2 -> A
	SUB	DET1_CT,	01H
	BAZ 	CHN1_VOL_12		;��2��ת�����

CHN1_VOL_11:
	LDA 	AD_RET0,	00H 	;�����һ��A/D ת�����
	STA 	CHN1_RET0_BAK0,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN1_RET1_BAK0,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN1_RET2_BAK0,	01H
	JMP 	NEXT_CHN	

CHN1_VOL_12:
	LDA 	AD_RET0,	00H 	;����ڶ���A/D ת�����
	STA 	CHN1_RET0_BAK1,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN1_RET1_BAK1,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN1_RET2_BAK1,	01H
	JMP 	NEXT_CHN
	
CHN1_VOL_13:
	LDA 	AD_RET0,	00H 	;���������A/D ת�����
	STA 	CHN1_RET0_BAK2,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN1_RET1_BAK2,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN1_RET2_BAK2,	01H
	JMP 	NEXT_CHN	
	
CHN1_VOL_14:
	LDA 	AD_RET0,	00H 	;������Ĵ�A/D ת�����
	STA 	CHN1_RET0_BAK3,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN1_RET1_BAK3,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN1_RET2_BAK3,	01H

	LDI	TBR,		00H	;DET1_CT ��0
	STA	DET1_CT,	01H
	
	CALL	CAL_CHN1_ADCDATA
	
	JMP 	NEXT_CHN	
;----------------------------------------------------------------	

;ת��ͨ��6 ת�����
;----------------------------------------------------------------
CHN6_VOL_1:
	LDI	TBR,		01H	;������һ
	ADDM	DET6_CT,	01H	

	LDI	TBR,		04H	;DET6_CT - 4 -> A
	SUB	DET6_CT,	01H
	BAZ 	CHN6_VOL_14		;��4��ת�����

	LDI	TBR,		03H	;DET6_CT - 3 -> A
	SUB	DET6_CT,	01H
	BAZ 	CHN6_VOL_13		;��3��ת�����

	LDI	TBR,		02H	;DET6_CT - 2 -> A
	SUB	DET6_CT,	01H
	BAZ 	CHN6_VOL_12		;��2��ת�����

CHN6_VOL_11:
	LDA 	AD_RET0,	00H 	;�����һ��A/D ת�����
	STA 	CHN6_RET0_BAK0,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN6_RET1_BAK0,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN6_RET2_BAK0,	01H
	JMP 	NEXT_CHN	

CHN6_VOL_12:
	LDA 	AD_RET0,	00H 	;����ڶ���A/D ת�����
	STA 	CHN6_RET0_BAK1,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN6_RET1_BAK1,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN6_RET2_BAK1,	01H
	JMP 	NEXT_CHN
	
CHN6_VOL_13:
	LDA 	AD_RET0,	00H 	;���������A/D ת�����
	STA 	CHN6_RET0_BAK2,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN6_RET1_BAK2,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN6_RET2_BAK2,	01H
	JMP 	NEXT_CHN	
	
CHN6_VOL_14:
	LDA 	AD_RET0,	00H 	;������Ĵ�A/D ת�����
	STA 	CHN6_RET0_BAK3,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN6_RET1_BAK3,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN6_RET2_BAK3,	01H

	LDI	TBR,		00H	;DET6_CT ��0
	STA	DET6_CT,	01H
	
	CALL	CAL_CHN6_ADCDATA
	
	JMP 	NEXT_CHN	
;----------------------------------------------------------------	

;ת��ͨ��7 ת�����
;----------------------------------------------------------------
CHN7_VOL_1:
	LDI	TBR,		01H	;������һ
	ADDM	DET7_CT,	01H	

	LDI	TBR,		04H	;DET7_CT - 4 -> A
	SUB	DET7_CT,	01H
	BAZ 	CHN7_VOL_14		;��4��ת�����

	LDI	TBR,		03H	;DET7_CT - 3 -> A
	SUB	DET7_CT,	01H
	BAZ 	CHN7_VOL_13		;��3��ת�����

	LDI	TBR,		02H	;DET7_CT - 2 -> A
	SUB	DET7_CT,	01H
	BAZ 	CHN7_VOL_12		;��2��ת�����

CHN7_VOL_11:
	LDA 	AD_RET0,	00H 	;�����һ��A/D ת�����
	STA 	CHN7_RET0_BAK0,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN7_RET1_BAK0,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN7_RET2_BAK0,	01H
	JMP 	NEXT_CHN	

CHN7_VOL_12:
	LDA 	AD_RET0,	00H 	;����ڶ���A/D ת�����
	STA 	CHN7_RET0_BAK1,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN7_RET1_BAK1,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN7_RET2_BAK1,	01H
	JMP 	NEXT_CHN
	
CHN7_VOL_13:
	LDA 	AD_RET0,	00H 	;���������A/D ת�����
	STA 	CHN7_RET0_BAK2,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN7_RET1_BAK2,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN7_RET2_BAK2,	01H
	JMP 	NEXT_CHN	
	
CHN7_VOL_14:
	LDA 	AD_RET0,	00H 	;������Ĵ�A/D ת�����
	STA 	CHN7_RET0_BAK3,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN7_RET1_BAK3,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN7_RET2_BAK3,	01H

	LDI	TBR,		00H	;DET7_CT ��0
	STA	DET7_CT,	01H
	
	CALL	CAL_CHN7_ADCDATA
	
	JMP 	NEXT_CHN	
;----------------------------------------------------------------
	
;----------------------------------------------------------------	
NEXT_CHN:
	LDA	ADCCHN
	BAZ	NEXT_CHN1
	SBI	ADCCHN,		01H
	BAZ	NEXT_CHN6
	SBI	ADCCHN,		06H
	BAZ	NEXT_CHN7
	SBI	ADCCHN,		07H
	BAZ	NEXT_CHN0
	
	JMP 	ADC_ISP_END		;������ִ����һ��

NEXT_CHN0:
	LDI	ADCCHN,		00H	;�趨ΪCHN0
	JMP 	ADC_ISP_END

NEXT_CHN1:
	LDI	ADCCHN,		01H	;�趨ΪCHN1
	JMP 	ADC_ISP_END
	
NEXT_CHN6:
	LDI 	ADCCHN,		06H 	;�趨ΪCHN6
	JMP	ADC_ISP_END

NEXT_CHN7:
	LDI	ADCCHN,		07H	;�趨ΪCHN7
;----------------------------------------------------------------	

	
ADC_ISP_END:
	ORIM 	ADCCFG,		1000B 	;����A/D ת��

	LDI 	IE,		1100B 	;��ADC,Timer0 �ж�
	LDA 	AC_BAK,		00H 	;ȡ��AC ֵ
	RTNI	
	
	
;*****************************************************
; ������
;*****************************************************
RESET:
	NOP	
	
	;LDI	70H,		07H
	;LDI	71H,		01H
	
LOOP:	
	;SBIM	70H, 		01H
	;LDI	TBR,		00H
	;SBCM	71H
	;BC 	LOOP
	
	LDI 	IE,		0000B
	
 	NOP
	NOP
;------------------------------------------------
;���û��Ĵ���($030 ~ $0EF)
;-------------------------------------------------
POWER_RESET:
	LDI 	DPL,		00H
	LDI 	DPM,		03H
	LDI 	DPH,		00H	;��$30 ��ʼ
	
POWER_RESET_1:
	LDI 	INX,		00H	;��DPH,DPM,DPL��ɵĵ�ַ��д0
	ADIM 	DPL,		01H
	LDI 	TBR,		00H	;���ۼ���A ��0
	ADCM 	DPM,		00H
	BA3 	POWER_RESET_2
	JMP 	POWER_RESET_3

POWER_RESET_2:
	ADIM 	DPH,		01H
	
POWER_RESET_3:
	SBI 	DPH,		01H	;��$EF ���������ڵ�ַ001 111 000Bʱֹͣ
	BNZ 	POWER_RESET_1
	SBI 	DPM,		07H
	BNZ 	POWER_RESET_1

;----------------------------------------------
;��ʼ��ϵͳ�Ĵ���
;-----------------------------------------------
SYSTEM_INITIAL:
	;TIMER0 ��ʼ��
	;
	;  fosc=4M, fsys=4M/4=1M
	;
	;  fsys=1M                 31250Hz                   125Hz
	;           -------------            -------------
	;  -------->| Prescaler |----------->|  Counter  |----------->
	;           -------------            -------------
	;               (32)                     (250)
	
	LDI 	TM0,		03H 	;����TIMER0 Ԥ��ƵΪ/32
	LDI 	TL0,		06H
	LDI 	TH0,		00H 	;�����ж�ʱ��Ϊ8ms

	LDI	CNT0_200MS,	08H	;��ʱ200ms
	LDI	CNT1_200MS,	01H	;

	LDI 	CNT0,		0DH 	;��ʱ1s
	LDI 	CNT1,		07H 	;��ʱ1s
	
	LDI	SEC_CNT0,	0FH	;SEC_CNT0/1/2 ��ʼ��ΪE10H - 1����3600 -1
	LDI	SEC_CNT1,	00H
	LDI	SEC_CNT2,	0EH

	LDI	HOUR_CNT0,	07H	;HOUR_CNT0/1/2 ��ʼ��Ϊ2E8H - 1����744 - 1
	LDI	HOUR_CNT1,	0EH
	LDI	HOUR_CNT2,	02H

	LDI	MONTH_CNT,	0BH	;MONTH_CNT ��ʼ��Ϊ12 -1 ����
		

	;I/O �ڳ�ʼ��
	LDI 	PORTA,		00H
	LDI 	PACR,		00H 	;����PortA ��Ϊ�����
	
	LDI 	PORTB,		00H
	LDI 	PBCR,		00H 	;����PortB ��Ϊ�����

	LDI	PORTC,		00H
	LDI	PCCR,		0FH	;����PortC.0/PortC.1/PortC.2/PortC.3 ��Ϊ���
	
	LDI 	PDCR,		1110B 	;����PD.0Ϊ���룬PD.3Ϊ���
	LDI	TBR,		0001B	;��PD.0 �ڲ���������
	STA	PPDCR

	LDI 	PORTE,		00H
	LDI 	PECR,		0FH 	;����PortE ��Ϊ�����

	;ADC��ʼ��
	LDI 	PACR,		0000B 	;����PortA0/1 ��Ϊ�����
	LDI 	PBCR,		0000B 	;����PortB2/3 ��Ϊ�����
	LDI 	ADCCTL,		0001B 	;ѡ���ڲ��ο���ѹVDD��ʹ��ADC
	LDI 	ADCCFG,		0100B 	;A/D ʱ��tAD=8tOSC, A/D ת��ʱ��= 204tAD
	LDI	ADCPORT,	1100B	;ʹ��AN0 ~ AN7
	LDI	ADCCHN,		00H	;ѡ��AN0
	ORIM 	ADCCFG,		1000B 	;����A/D ת��

	;PWM��ʼ��
	LDI	PWMC0,		0001B	;PWM0 Clock = tosc = 4M
	LDI	PWMP00,		0DH	;����Ϊ125��PWM0 Clock
	LDI	PWMP01,		07H	
	LDI	PWMD00,		00H	;��΢��
	LDI	PWMD01,		0EH	;ռ�ձ�Ϊ50%
	LDI	PWMD02,		03H	

	LDI	PWMC1,		0000B	;PWM0 Clock = tosc = 4M
	LDI	PWMP10,		0DH	;����Ϊ125��PWM0 Clock
	LDI	PWMP11,		07H	
	LDI	PWMD10,		00H	;��΢��
	LDI	PWMD11,		0EH	;ռ�ձ�Ϊ50%
	LDI	PWMD12,		03H


	;�������
	LDI	CNT0_496MS,	0DH	;��ʼ��496ms ������,496 = 8 * 62
	LDI	CNT0_496MS,	03H	;��ʼ��496ms ������
	LDI	BTN_PRE_STA,	01H	;��ʼ����һ��û�а���

	;״̬���
	LDI	NORMAL_STA,	01H	;��ʼ��Ϊ"����"
	LDI	ABNORMAL_STA,	00H	;���κ��쳣״̬
	
;--------------------------------------
MAIN_PRE:
	LDI 	IRQ,		00H
	LDI 	IE,		1100B 	;��ADC,Timer0 �ж�

WAIT_AD_RESULT:
	

MAIN:


	;SBIM	PWMD01,		01H	;ռ�ձ�Ϊ50%
	;LDI	TBR,		00H
	;SBCM	PWMD02

	;BC	KEY_CHK

	;LDI	PWMD01,		0DH
	;LDI	PWMD02,		07H

KEY_CHK:
	CALL	KEY_CHECK_PROCESS	;����ɨ�裬���"ģ��ͣ��","�ֶ��¼�","�ֶ����","�ض�Ӧ�����"�ȱ�־λ

CHECK_PWR_CUT:
	ADI	SIMULATE_STA,	0001B	;���"ģ��ͣ��"��־λ
	BA0	CHECK_MONTH_CHK		
	CALL	SIM_PWR_CUT

CHECK_MONTH_CHK:
	ADI	SIMULATE_STA,	0010B	;���"�ֶ��¼�"��־λ
	BA0	CHECK_YEAR_CHK
	CALL	SIM_MONTH_CHK

CHECK_YEAR_CHK:
	ADI	SIMULATE_STA,	0100B	;���"�ֶ����"��־λ
	BA0	CHECK_DIS_PWR_OUT
	CALL	SIM_YEAR_CHK

CHECK_DIS_PWR_OUT
	ADI	SIMULATE_STA,	1000B	;���"�ض�Ӧ�����"��־λ
	;BA0	XXXXXXXXXXXX
	CALL	DIS_PWR_OUT
	

	;ADI 	F_TIME,		0001B
	;BA0 	HALTMODE 		;δ��1s,��ת
	
	ADI 	F_TIME,		0001B
	BA0	MAIN			;δ��1s,��ת
	
	ANDIM 	F_TIME,		1110B 	;�� "1s ��"��־
	EORIM	PORTC,		0001B	;��תPC.0	
	
	
HALTMODE:
	NOP
	HALT
	NOP
	NOP
	NOP
	JMP 	MAIN

	NOP
	NOP


;***********************************************************
; ģ��ͣ�紦����
;***********************************************************
SIM_PWR_CUT:
	NOP
	RTNI

;***********************************************************
; �ֶ��¼촦����
;***********************************************************
SIM_MONTH_CHK:

	RTNI

;***********************************************************
; �ֶ���촦����
;***********************************************************
SIM_YEAR_CHK:

	RTNI

;***********************************************************
; �ض�Ӧ�����
;***********************************************************
DIS_PWR_OUT:

	RTNI
	

;***********************************************************
; ����ɨ�輰������
;***********************************************************
KEY_CHECK_PROCESS:
	LDI 	PDCR,		1110B 	;����PD.0 Ϊ���룬PD.3 Ϊ���
	
KEY_CHECK:
	ADI	F_BUTTON,	0001B	;���496MS��־λ
	BA0	NOT_CHECK

	
	CALL 	DELAY_5MS 		;������������
	
	LDA 	PORTD,		00H 	;��ȡPD ��״̬
	STA 	TEMP,		00H 	;��PD ��״̬�浽TEMP �Ĵ�����
	CALL 	DELAY_5MS 		;������������
	
	LDA 	PORTD,		00H 	;��ȡPD ��״̬
	SUB 	TEMP,		00H 	;�Ƚ϶�ȡPD.0 ��״ֵ̬������������
	BA0 	KEY_ERROR
	CALL 	DELAY_5MS 		;������������
	
	LDA 	PORTD,		00H 	;��ȡPD ��״̬
	SUB 	TEMP,		00H 	;�Ƚ϶�ȡPD.0 ��״ֵ̬������������
	BA0 	KEY_ERROR
	
	LDA 	TEMP		 	;��TEMP �е����ݴ������ۼ���A ��
	BA0	NO_KEY_PRESSED		;û�м�⵽����
	
	JMP	KEY_PRESSED		;��⵽�а�������

NO_KEY_PRESSED:
	LDA	BTN_PRE_STA		;����һ�ΰ���״̬�����ۼ���A ��
	ADD	TEMP			;TEMP + A -> A
	BA0	KEY_RELEASED		;��һ�ΰ��£�����δ����
	
	JMP 	KEY_CHECK_PROCESS_OVER	;��һ��δ���£�����Ҳδ����

KEY_RELEASED:

	;���ݰ��������µ�ʱ��T�������������º���״̬:
	; T < 3s      -- "ģ��ͣ��"
	; 3s < T < 5s -- "�ֶ��¼�"
	; 5s < T < 7s -- "�ֶ����"
	; T > 7s      -- "�ض�Ӧ�����"
	SBI	BTN_PRESS_CNT,	06H	;
	BNC	LESS_3S			;��������ʱ��С��3S, 6.04 * 496ms = 3s
	SBI	BTN_PRESS_CNT,	0AH	;
	BNC	LESS_5S			;��������ʱ��С��5S, 10.08 * 496ms = 5s
	SBI	BTN_PRESS_CNT,	0EH	;
	BNC	LESS_7S			;��������ʱ��С��7S, 14.11 * 496ms = 7s

MORE_7S:
	ORIM	SIMULATE_STA,	0001B	;����"�ض�Ӧ�����"״̬
	JMP	RELEASED_OVER	
LESS_3S:
	ANDIM	SIMULATE_STA,	1110B	;�����˳�"ģ��ͣ��"״̬
	JMP	RELEASED_OVER
LESS_5S:
	ORIM	SIMULATE_STA,	0010B	;����"�ֶ��¼�"״̬
	JMP	RELEASED_OVER
LESS_7S:
	ORIM	SIMULATE_STA,	0010B	;����"�ֶ����"״̬
	JMP	RELEASED_OVER
	
RELEASED_OVER:
	LDI	BTN_PRESS_CNT,	00H	;��BTN_PRESS_CNT ��0
	JMP	KEY_CHECK_PROCESS_OVER


KEY_PRESSED:
	SBI	BTN_PRESS_CNT,	06H	
	BC	MORE_3S			;��������ʱ������3S, 6.04 * 496ms = 3s
	ORIM	SIMULATE_STA,	0001B	;��������ʱ��С��3S, ����"ģ��ͣ��"״̬
	JMP	CNT_ADD_1
	
MORE_3S:
	ANDIM	SIMULATE_STA,	1110B	;��������ʱ������3S, �˳�"ģ��ͣ��"״̬

CNT_ADD_1:	
	SBI	BTN_PRESS_CNT,  0FH	;�Ƚ�BTN_PRESS_CNT �� 0x0F �Ĵ�С
	BC	KEY_CHECK_PROCESS_OVER	;���BTN_PRESS_CNT�Ѿ��ۼ���0x0F�������ۼ�
	ADIM	BTN_PRESS_CNT,	01H	;496MS��ʱ������1
	JMP 	KEY_CHECK_PROCESS_OVER
	
KEY_ERROR: 				;�����ֵ����
	LDI	BTN_PRE_STA,	0001H
	LDI	BTN_PRESS_CNT,	00H

	JMP 	KEY_CHECK_PROCESS_OVER
	
KEY_CHECK_PROCESS_OVER: 		;����ɨ�輰�������������
	ANDIM	TEMP,		0001H	;
	STA	BTN_PRE_STA		;TEMP -> BTN_PRE_STA
	
	ANDIM	F_BUTTON,	1110B	;��496MS��־λ
	
NOT_CHECK:	
	RTNI
;************************************************************
; ��ʱ5 �����ӳ���
;************************************************************
DELAY_5MS:
	LDI 	DELAY_TIMER2,	03H 	;���ó�ʼֵ
	LDI 	DELAY_TIMER1,	03H
	LDI 	DELAY_TIMER0,	0CH

DELAY_5MS_LOOP:
	SBIM 	DELAY_TIMER0,	01H 	;ÿ�μ�1
	LDI 	CLEAR_AC,	00H
	SBCM 	DELAY_TIMER1,	00H
	LDI 	CLEAR_AC,	00H
	SBCM 	DELAY_TIMER2,	00H
	BC 	DELAY_5MS_LOOP
	
	RTNI

;*******************************************
; �ӳ���: CAL_CHN0_ADCDATA
; ����: ������ƽ���˲�����N=4��ȥһ�����ֵ��һ����Сֵ��ʣ��������ƽ��ֵ��
;*******************************************
CAL_CHN0_ADCDATA:

;----------------------------
;Ѱ����Сֵ
CAL_CHN0_AD_MIN01:	
	LDA 	CHN0_RET1_BAK0,		01H
	SUB 	CHN0_RET1_BAK1,		01H
	LDA 	CHN0_RET2_BAK0,		01H
	SBC 	CHN0_RET2_BAK1,		01H
	BC 	CAL_CHN0_AD_MIN02 		;D0<D1	

CAL_CHN0_AD_MIN12:
	LDA 	CHN0_RET1_BAK1,		01H
	SUB 	CHN0_RET1_BAK2,		01H
	LDA 	CHN0_RET2_BAK1,		01H
	SBC 	CHN0_RET2_BAK2,		01H
	BC 	CAL_CHN0_AD_MIN13 		;D1<D2

CAL_CHN0_AD_MIN23:
	LDA 	CHN0_RET1_BAK2,		01H
	SUB 	CHN0_RET1_BAK3,		01H
	LDA 	CHN0_RET2_BAK2,		01H
	SBC 	CHN0_RET2_BAK3,		01H
	BC 	CAL_CHN0_AD_MIN2 		;D2<D3
	;D3<D2
	JMP 	CAL_CHN0_AD_MIN3

CAL_CHN0_AD_MIN13:
	LDA 	CHN0_RET1_BAK1,		01H
	SUB 	CHN0_RET1_BAK3,		01H
	LDA 	CHN0_RET2_BAK1,		01H
	SBC 	CHN0_RET2_BAK3,		01H
	BC 	CAL_CHN0_AD_MIN1 		;D1<D3
	;D3<D1
	JMP 	CAL_CHN0_AD_MIN3

;D0<D1
CAL_CHN0_AD_MIN02:
	LDA 	CHN0_RET1_BAK0,		01H
	SUB 	CHN0_RET1_BAK2,		01H
	LDA 	CHN0_RET2_BAK0,		01H
	SBC 	CHN0_RET2_BAK2,		01H
	BC 	CAL_CHN0_AD_MIN03 		;D0<D2
	;D3<D1
	JMP 	CAL_CHN0_AD_MIN23

;D0<D2
CAL_CHN0_AD_MIN03:
	LDA 	CHN0_RET1_BAK0,		01H
	SUB 	CHN0_RET1_BAK3,		01H
	LDA 	CHN0_RET2_BAK0,		01H
	SBC 	CHN0_RET2_BAK3,		01H
	BC 	CAL_CHN0_AD_MIN0 		;D0<D3
	;D3<D0
	JMP 	CAL_CHN0_AD_MIN3

;-----------------------
;����Сֵ����
CAL_CHN0_AD_MIN0:
	LDI 	TBR,			00H
	STA 	CHN0_RET0_BAK0,		01H
	STA 	CHN0_RET1_BAK0,		01H
	STA 	CHN0_RET2_BAK0,		01H
	JMP 	CAL_CHN0_AD_MAX01

CAL_CHN0_AD_MIN1:
	LDI 	TBR,			00H
	STA 	CHN0_RET0_BAK1,		01H
	STA 	CHN0_RET1_BAK1,		01H
	STA 	CHN0_RET2_BAK1,		01H
	JMP 	CAL_CHN0_AD_MAX01

CAL_CHN0_AD_MIN2:
	LDI 	TBR,			00H
	STA 	CHN0_RET0_BAK2,		01H
	STA 	CHN0_RET1_BAK2,		01H
	STA 	CHN0_RET2_BAK2,		01H
	JMP 	CAL_CHN0_AD_MAX01

CAL_CHN0_AD_MIN3:
	LDI 	TBR,			00H
	STA 	CHN0_RET0_BAK3,		01H
	STA 	CHN0_RET1_BAK3,		01H
	STA 	CHN0_RET2_BAK3,		01H
	JMP 	CAL_CHN0_AD_MAX01

;----------------------------
;Ѱ�����ֵ
CAL_CHN0_AD_MAX01:
	LDA 	CHN0_RET1_BAK0,		01H
	SUB 	CHN0_RET1_BAK1,		01H
	LDA 	CHN0_RET2_BAK0,		01H
	SBC 	CHN0_RET2_BAK1,		01H
	BC 	CAL_CHN0_AD_MAX12 		;D1>D0

;D0>D1
CAL_CHN0_AD_MAX02:
	LDA 	CHN0_RET1_BAK0,		01H
	SUB 	CHN0_RET1_BAK2,		01H
	LDA 	CHN0_RET2_BAK0,		01H
	SBC 	CHN0_RET2_BAK2,		01H
	BC 	CAL_CHN0_AD_MAX23 		;D2>D0

;D0>D2
CAL_CHN0_AD_MAX03:
	LDA 	CHN0_RET1_BAK0,		01H
	SUB 	CHN0_RET1_BAK3,		01H
	LDA 	CHN0_RET2_BAK0,		01H
	SBC 	CHN0_RET2_BAK3,		01H
	BC 	CAL_CHN0_AD_MAX3 		;D3>D0
	;D0>D3
	JMP 	CAL_CHN0_AD_MAX0

;D2>D0
CAL_CHN0_AD_MAX23:
	LDA 	CHN0_RET1_BAK2,		01H
	SUB 	CHN0_RET1_BAK3,		01H
	LDA 	CHN0_RET2_BAK2,		01H
	SBC 	CHN0_RET2_BAK3,		01H
	BC 	CAL_CHN0_AD_MAX3 		;D3>D2
	;D2>D3
	JMP 	CAL_CHN0_AD_MAX2

;D1>D0
CAL_CHN0_AD_MAX12:
	LDA 	CHN0_RET1_BAK1,		01H
	SUB 	CHN0_RET1_BAK2,		01H
	LDA 	CHN0_RET2_BAK1,		01H
	SBC 	CHN0_RET2_BAK2,		01H
	BC 	CAL_CHN0_AD_MAX23 		;D2>D1

;D1>D2
CAL_CHN0_AD_MAX13:
	LDA 	CHN0_RET1_BAK1,		01H
	SUB 	CHN0_RET1_BAK3,		01H
	LDA 	CHN0_RET2_BAK1,		01H
	SBC 	CHN0_RET2_BAK3,		01H
	BC 	CAL_CHN0_AD_MAX3 		;D3>D1
	;D1>D3
	JMP 	CAL_CHN0_AD_MAX1

;-----------------------
;�����ֵ����
CAL_CHN0_AD_MAX0:
	LDI 	TBR,			00H
	STA 	CHN0_RET0_BAK0,		01H
	STA 	CHN0_RET1_BAK0,		01H
	STA 	CHN0_RET2_BAK0,		01H
	JMP 	CAL_CHN0_AD_ADD

CAL_CHN0_AD_MAX1:
	LDI 	TBR,			00H
	STA 	CHN0_RET0_BAK1,		01H
	STA 	CHN0_RET1_BAK1,		01H
	STA 	CHN0_RET2_BAK1,		01H
	JMP 	CAL_CHN0_AD_ADD

CAL_CHN0_AD_MAX2:
	LDI 	TBR,			00H
	STA 	CHN0_RET0_BAK2,		01H
	STA 	CHN0_RET1_BAK2,		01H
	STA 	CHN0_RET2_BAK2,		01H
	JMP 	CAL_CHN0_AD_ADD

CAL_CHN0_AD_MAX3:
	LDI 	TBR,			00H
	STA 	CHN0_RET0_BAK3,		01H
	STA 	CHN0_RET1_BAK3,		01H
	STA 	CHN0_RET2_BAK3,		01H
	JMP 	CAL_CHN0_AD_ADD

;----------------------------
;�����ܺͲ������CHN0_RET0_BAK3,CHN0_RET1_BAK3 ��CHN0_RET2_BAK3����������������ģ�
CAL_CHN0_AD_ADD:
	LDI 	TEMP_SUM_CY,		00H

	;D0 + D1
	;LDA 	CHN0_RET0_BAK0,		01H
	;ADDM 	CHN0_RET0_BAK1,		01H
	LDA 	CHN0_RET1_BAK0,		01H
	ADDM 	CHN0_RET1_BAK1,		01H
	LDA 	CHN0_RET2_BAK0,		01H
	ADCM 	CHN0_RET2_BAK1,		01H
	LDI 	TBR,			00H
	ADCM 	TEMP_SUM_CY

	;+ D2
	;LDA 	CHN0_RET0_BAK1,		01H
	;ADDM 	CHN0_RET0_BAK2,		01H
	LDA 	CHN0_RET1_BAK1,		01H
	ADDM 	CHN0_RET1_BAK2,		01H
	LDA 	CHN0_RET2_BAK1,		01H
	ADCM 	CHN0_RET2_BAK2,		01H
	LDI 	TBR,			00H
	ADCM 	TEMP_SUM_CY

	;+ D3
	;LDA 	CHN0_RET0_BAK2,		01H
	;ADDM 	CHN0_RET0_BAK3,		01H
	LDA 	CHN0_RET1_BAK2,		01H
	ADDM 	CHN0_RET1_BAK3,		01H
	LDA 	CHN0_RET2_BAK2,		01H
	ADCM 	CHN0_RET2_BAK3,		01H
	LDI 	TBR,			00H
	ADCM 	TEMP_SUM_CY

;----------------------------
;�ܺͳ���2���õ�ƽ��ֵ�������CHN0_FINAL_RET0(),CHN0_FINAL_RET1 ��CHN0_FINAL_RET2
CAL_CHN0_AD_DIV:
	;LDA 	CHN0_RET0_BAK3,		01H
	;SHR
	;STA 	CHN0_RET0_BAK3,		01H
	
	LDA 	CHN0_RET1_BAK3,		01H
	SHR
	STA 	CHN0_RET1_BAK3,		01H
	
	;BNC 	$+3
	;LDI 	TBR,			0010B
	;ORM 	CHN0_RET0_BAK3

	LDA 	CHN0_RET2_BAK3,		01H
	SHR
	STA 	CHN0_RET2_BAK3,		01H
	
	BNC 	$+3
	LDI 	TBR,			1000B
	ORM 	CHN0_RET1_BAK3,		01H

	LDA 	TEMP_SUM_CY
	SHR
	BNC 	$+3
	LDI 	TBR,			1000B
	ORM 	CHN0_RET2_BAK3,		01H


	;LDA	CHN0_RET0_BAK3,		01H
	;STA	CHN0_FINAL_RET0,		01H
	LDA	CHN0_RET1_BAK3,		01H
	STA	CHN0_FINAL_RET1,	01H
	LDA	CHN0_RET2_BAK3,		01H
	STA	CHN0_FINAL_RET2,	01H

;----------------------------
;����ΪCHN0_FINAL_RET0��ŵ�4λ��CHN0_FINAL_RET1�����4λ��CHN0_FINAL_RET2��Ÿ�2λ
	;LDA 	CHN0_FINAL_RET1,		01H
	;SHR
	;STA 	CHN0_FINAL_RET1,		01H

	;BNC 	$+3
	;LDI 	TBR,			0100B
	;ORM 	CHN0_FINAL_RET0,		01H

	;LDA 	CHN0_FINAL_RET1,		01H
	;SHR
	;STA 	CHN0_FINAL_RET1,		01H	

	;BNC 	$+3
	;LDI 	TBR,			1000B
	;ORM 	CHN0_FINAL_RET0,		01H


	;LDA 	CHN0_FINAL_RET2,		01H
	;SHR
	;STA 	CHN0_FINAL_RET2,		01H	

	;BNC 	$+3
	;LDI 	TBR,			0100B
	;ORM 	CHN0_FINAL_RET1,		01H

	;LDA 	CHN0_FINAL_RET2,		01H
	;SHR
	;STA 	CHN0_FINAL_RET2,		01H	

	;BNC 	$+3
	;LDI 	TBR,			1000B
	;ORM 	CHN0_FINAL_RET1,		01H
	
;----------------------------
CAL_CHN0_ADCDATA_END:	

	RTNI

;*******************************************
; �ӳ���: CAL_CHN1_ADCDATA
; ����: ������ƽ���˲�����N=4��ȥһ�����ֵ��һ����Сֵ��ʣ��������ƽ��ֵ��
;*******************************************
CAL_CHN1_ADCDATA:

;----------------------------
;Ѱ����Сֵ
CAL_CHN1_AD_MIN01:	
	LDA 	CHN1_RET1_BAK0,		01H
	SUB 	CHN1_RET1_BAK1,		01H
	LDA 	CHN1_RET2_BAK0,		01H
	SBC 	CHN1_RET2_BAK1,		01H
	BC 	CAL_CHN1_AD_MIN02 		;D0<D1	

CAL_CHN1_AD_MIN12:
	LDA 	CHN1_RET1_BAK1,		01H
	SUB 	CHN1_RET1_BAK2,		01H
	LDA 	CHN1_RET2_BAK1,		01H
	SBC 	CHN1_RET2_BAK2,		01H
	BC 	CAL_CHN1_AD_MIN13 		;D1<D2

CAL_CHN1_AD_MIN23:
	LDA 	CHN1_RET1_BAK2,		01H
	SUB 	CHN1_RET1_BAK3,		01H
	LDA 	CHN1_RET2_BAK2,		01H
	SBC 	CHN1_RET2_BAK3,		01H
	BC 	CAL_CHN1_AD_MIN2 		;D2<D3
	;D3<D2
	JMP 	CAL_CHN1_AD_MIN3

CAL_CHN1_AD_MIN13:
	LDA 	CHN1_RET1_BAK1,		01H
	SUB 	CHN1_RET1_BAK3,		01H
	LDA 	CHN1_RET2_BAK1,		01H
	SBC 	CHN1_RET2_BAK3,		01H
	BC 	CAL_CHN1_AD_MIN1 		;D1<D3
	;D3<D1
	JMP 	CAL_CHN1_AD_MIN3

;D0<D1
CAL_CHN1_AD_MIN02:
	LDA 	CHN1_RET1_BAK0,		01H
	SUB 	CHN1_RET1_BAK2,		01H
	LDA 	CHN1_RET2_BAK0,		01H
	SBC 	CHN1_RET2_BAK2,		01H
	BC 	CAL_CHN1_AD_MIN03 		;D0<D2
	;D3<D1
	JMP 	CAL_CHN1_AD_MIN23

;D0<D2
CAL_CHN1_AD_MIN03:
	LDA 	CHN1_RET1_BAK0,		01H
	SUB 	CHN1_RET1_BAK3,		01H
	LDA 	CHN1_RET2_BAK0,		01H
	SBC 	CHN1_RET2_BAK3,		01H
	BC 	CAL_CHN1_AD_MIN0 		;D0<D3
	;D3<D0
	JMP 	CAL_CHN1_AD_MIN3

;-----------------------
;����Сֵ����
CAL_CHN1_AD_MIN0:
	LDI 	TBR,			00H
	STA 	CHN1_RET0_BAK0,		01H
	STA 	CHN1_RET1_BAK0,		01H
	STA 	CHN1_RET2_BAK0,		01H
	JMP 	CAL_CHN1_AD_MAX01

CAL_CHN1_AD_MIN1:
	LDI 	TBR,			00H
	STA 	CHN1_RET0_BAK1,		01H
	STA 	CHN1_RET1_BAK1,		01H
	STA 	CHN1_RET2_BAK1,		01H
	JMP 	CAL_CHN1_AD_MAX01

CAL_CHN1_AD_MIN2:
	LDI 	TBR,			00H
	STA 	CHN1_RET0_BAK2,		01H
	STA 	CHN1_RET1_BAK2,		01H
	STA 	CHN1_RET2_BAK2,		01H
	JMP 	CAL_CHN1_AD_MAX01

CAL_CHN1_AD_MIN3:
	LDI 	TBR,			00H
	STA 	CHN1_RET0_BAK3,		01H
	STA 	CHN1_RET1_BAK3,		01H
	STA 	CHN1_RET2_BAK3,		01H
	JMP 	CAL_CHN1_AD_MAX01

;----------------------------
;Ѱ�����ֵ
CAL_CHN1_AD_MAX01:
	LDA 	CHN1_RET1_BAK0,		01H
	SUB 	CHN1_RET1_BAK1,		01H
	LDA 	CHN1_RET2_BAK0,		01H
	SBC 	CHN1_RET2_BAK1,		01H
	BC 	CAL_CHN1_AD_MAX12 		;D1>D0

;D0>D1
CAL_CHN1_AD_MAX02:
	LDA 	CHN1_RET1_BAK0,		01H
	SUB 	CHN1_RET1_BAK2,		01H
	LDA 	CHN1_RET2_BAK0,		01H
	SBC 	CHN1_RET2_BAK2,		01H
	BC 	CAL_CHN1_AD_MAX23 		;D2>D0

;D0>D2
CAL_CHN1_AD_MAX03:
	LDA 	CHN1_RET1_BAK0,		01H
	SUB 	CHN1_RET1_BAK3,		01H
	LDA 	CHN1_RET2_BAK0,		01H
	SBC 	CHN1_RET2_BAK3,		01H
	BC 	CAL_CHN1_AD_MAX3 		;D3>D0
	;D0>D3
	JMP 	CAL_CHN1_AD_MAX0

;D2>D0
CAL_CHN1_AD_MAX23:
	LDA 	CHN1_RET1_BAK2,		01H
	SUB 	CHN1_RET1_BAK3,		01H
	LDA 	CHN1_RET2_BAK2,		01H
	SBC 	CHN1_RET2_BAK3,		01H
	BC 	CAL_CHN1_AD_MAX3 		;D3>D2
	;D2>D3
	JMP 	CAL_CHN1_AD_MAX2

;D1>D0
CAL_CHN1_AD_MAX12:
	LDA 	CHN1_RET1_BAK1,		01H
	SUB 	CHN1_RET1_BAK2,		01H
	LDA 	CHN1_RET2_BAK1,		01H
	SBC 	CHN1_RET2_BAK2,		01H
	BC 	CAL_CHN1_AD_MAX23 		;D2>D1

;D1>D2
CAL_CHN1_AD_MAX13:
	LDA 	CHN1_RET1_BAK1,		01H
	SUB 	CHN1_RET1_BAK3,		01H
	LDA 	CHN1_RET2_BAK1,		01H
	SBC 	CHN1_RET2_BAK3,		01H
	BC 	CAL_CHN1_AD_MAX3 		;D3>D1
	;D1>D3
	JMP 	CAL_CHN1_AD_MAX1

;-----------------------
;�����ֵ����
CAL_CHN1_AD_MAX0:
	LDI 	TBR,			00H
	STA 	CHN1_RET0_BAK0,		01H
	STA 	CHN1_RET1_BAK0,		01H
	STA 	CHN1_RET2_BAK0,		01H
	JMP 	CAL_CHN1_AD_ADD

CAL_CHN1_AD_MAX1:
	LDI 	TBR,			00H
	STA 	CHN1_RET0_BAK1,		01H
	STA 	CHN1_RET1_BAK1,		01H
	STA 	CHN1_RET2_BAK1,		01H
	JMP 	CAL_CHN1_AD_ADD

CAL_CHN1_AD_MAX2:
	LDI 	TBR,			00H
	STA 	CHN1_RET0_BAK2,		01H
	STA 	CHN1_RET1_BAK2,		01H
	STA 	CHN1_RET2_BAK2,		01H
	JMP 	CAL_CHN1_AD_ADD

CAL_CHN1_AD_MAX3:
	LDI 	TBR,			00H
	STA 	CHN1_RET0_BAK3,		01H
	STA 	CHN1_RET1_BAK3,		01H
	STA 	CHN1_RET2_BAK3,		01H
	JMP 	CAL_CHN1_AD_ADD

;----------------------------
;�����ܺͲ������CHN1_RET0_BAK3,CHN1_RET1_BAK3 ��CHN1_RET2_BAK3����������������ģ�
CAL_CHN1_AD_ADD:
	LDI 	TEMP_SUM_CY,		00H

	;D0 + D1
	;LDA 	CHN1_RET0_BAK0,		01H
	;ADDM 	CHN1_RET0_BAK1,		01H
	LDA 	CHN1_RET1_BAK0,		01H
	ADDM 	CHN1_RET1_BAK1,		01H
	LDA 	CHN1_RET2_BAK0,		01H
	ADCM 	CHN1_RET2_BAK1,		01H
	LDI 	TBR,			00H
	ADCM 	TEMP_SUM_CY

	;+ D2
	;LDA 	CHN1_RET0_BAK1,		01H
	;ADDM 	CHN1_RET0_BAK2,		01H
	LDA 	CHN1_RET1_BAK1,		01H
	ADDM 	CHN1_RET1_BAK2,		01H
	LDA 	CHN1_RET2_BAK1,		01H
	ADCM 	CHN1_RET2_BAK2,		01H
	LDI 	TBR,			00H
	ADCM 	TEMP_SUM_CY

	;+ D3
	;LDA 	CHN1_RET0_BAK2,		01H
	;ADDM 	CHN1_RET0_BAK3,		01H
	LDA 	CHN1_RET1_BAK2,		01H
	ADDM 	CHN1_RET1_BAK3,		01H
	LDA 	CHN1_RET2_BAK2,		01H
	ADCM 	CHN1_RET2_BAK3,		01H
	LDI 	TBR,			00H
	ADCM 	TEMP_SUM_CY

;----------------------------
;�ܺͳ���2���õ�ƽ��ֵ�������CHN1_FINAL_RET0(),CHN1_FINAL_RET1 ��CHN1_FINAL_RET2
CAL_CHN1_AD_DIV:
	;LDA 	CHN1_RET0_BAK3,		01H
	;SHR
	;STA 	CHN1_RET0_BAK3,		01H
	
	LDA 	CHN1_RET1_BAK3,		01H
	SHR
	STA 	CHN1_RET1_BAK3,		01H
	
	;BNC 	$+3
	;LDI 	TBR,			0010B
	;ORM 	CHN1_RET0_BAK3

	LDA 	CHN1_RET2_BAK3,		01H
	SHR
	STA 	CHN1_RET2_BAK3,		01H
	
	BNC 	$+3
	LDI 	TBR,			1000B
	ORM 	CHN1_RET1_BAK3,		01H

	LDA 	TEMP_SUM_CY
	SHR
	BNC 	$+3
	LDI 	TBR,			1000B
	ORM 	CHN1_RET2_BAK3,		01H


	;LDA	CHN1_RET0_BAK3,		01H
	;STA	CHN1_FINAL_RET0,		01H
	LDA	CHN1_RET1_BAK3,		01H
	STA	CHN1_FINAL_RET1,	01H
	LDA	CHN1_RET2_BAK3,		01H
	STA	CHN1_FINAL_RET2,	01H

;----------------------------
;����ΪCHN1_FINAL_RET0��ŵ�4λ��CHN1_FINAL_RET1�����4λ��CHN1_FINAL_RET2��Ÿ�2λ
	;LDA 	CHN1_FINAL_RET1,		01H
	;SHR
	;STA 	CHN1_FINAL_RET1,		01H

	;BNC 	$+3
	;LDI 	TBR,			0100B
	;ORM 	CHN1_FINAL_RET0,		01H

	;LDA 	CHN1_FINAL_RET1,		01H
	;SHR
	;STA 	CHN1_FINAL_RET1,		01H	

	;BNC 	$+3
	;LDI 	TBR,			1000B
	;ORM 	CHN1_FINAL_RET0,		01H


	;LDA 	CHN1_FINAL_RET2,		01H
	;SHR
	;STA 	CHN1_FINAL_RET2,		01H	

	;BNC 	$+3
	;LDI 	TBR,			0100B
	;ORM 	CHN1_FINAL_RET1,		01H

	;LDA 	CHN1_FINAL_RET2,		01H
	;SHR
	;STA 	CHN1_FINAL_RET2,		01H	

	;BNC 	$+3
	;LDI 	TBR,			1000B
	;ORM 	CHN1_FINAL_RET1,		01H
	
;----------------------------
CAL_CHN1_ADCDATA_END:	

	RTNI


;*******************************************
; �ӳ���: CAL_CHN6_ADCDATA
; ����: ������ƽ���˲�����N=4��ȥһ�����ֵ��һ����Сֵ��ʣ��������ƽ��ֵ��
;*******************************************
CAL_CHN6_ADCDATA:

;----------------------------
;Ѱ����Сֵ
CAL_CHN6_AD_MIN01:	
	LDA 	CHN6_RET1_BAK0,		01H
	SUB 	CHN6_RET1_BAK1,		01H
	LDA 	CHN6_RET2_BAK0,		01H
	SBC 	CHN6_RET2_BAK1,		01H
	BC 	CAL_CHN6_AD_MIN02 		;D0<D1	

CAL_CHN6_AD_MIN12:
	LDA 	CHN6_RET1_BAK1,		01H
	SUB 	CHN6_RET1_BAK2,		01H
	LDA 	CHN6_RET2_BAK1,		01H
	SBC 	CHN6_RET2_BAK2,		01H
	BC 	CAL_CHN6_AD_MIN13 		;D1<D2

CAL_CHN6_AD_MIN23:
	LDA 	CHN6_RET1_BAK2,		01H
	SUB 	CHN6_RET1_BAK3,		01H
	LDA 	CHN6_RET2_BAK2,		01H
	SBC 	CHN6_RET2_BAK3,		01H
	BC 	CAL_CHN6_AD_MIN2 		;D2<D3
	;D3<D2
	JMP 	CAL_CHN6_AD_MIN3

CAL_CHN6_AD_MIN13:
	LDA 	CHN6_RET1_BAK1,		01H
	SUB 	CHN6_RET1_BAK3,		01H
	LDA 	CHN6_RET2_BAK1,		01H
	SBC 	CHN6_RET2_BAK3,		01H
	BC 	CAL_CHN6_AD_MIN1 		;D1<D3
	;D3<D1
	JMP 	CAL_CHN6_AD_MIN3

;D0<D1
CAL_CHN6_AD_MIN02:
	LDA 	CHN6_RET1_BAK0,		01H
	SUB 	CHN6_RET1_BAK2,		01H
	LDA 	CHN6_RET2_BAK0,		01H
	SBC 	CHN6_RET2_BAK2,		01H
	BC 	CAL_CHN6_AD_MIN03 		;D0<D2
	;D3<D1
	JMP 	CAL_CHN6_AD_MIN23

;D0<D2
CAL_CHN6_AD_MIN03:
	LDA 	CHN6_RET1_BAK0,		01H
	SUB 	CHN6_RET1_BAK3,		01H
	LDA 	CHN6_RET2_BAK0,		01H
	SBC 	CHN6_RET2_BAK3,		01H
	BC 	CAL_CHN6_AD_MIN0 		;D0<D3
	;D3<D0
	JMP 	CAL_CHN6_AD_MIN3

;-----------------------
;����Сֵ����
CAL_CHN6_AD_MIN0:
	LDI 	TBR,			00H
	STA 	CHN6_RET0_BAK0,		01H
	STA 	CHN6_RET1_BAK0,		01H
	STA 	CHN6_RET2_BAK0,		01H
	JMP 	CAL_CHN6_AD_MAX01

CAL_CHN6_AD_MIN1:
	LDI 	TBR,			00H
	STA 	CHN6_RET0_BAK1,		01H
	STA 	CHN6_RET1_BAK1,		01H
	STA 	CHN6_RET2_BAK1,		01H
	JMP 	CAL_CHN6_AD_MAX01

CAL_CHN6_AD_MIN2:
	LDI 	TBR,			00H
	STA 	CHN6_RET0_BAK2,		01H
	STA 	CHN6_RET1_BAK2,		01H
	STA 	CHN6_RET2_BAK2,		01H
	JMP 	CAL_CHN6_AD_MAX01

CAL_CHN6_AD_MIN3:
	LDI 	TBR,			00H
	STA 	CHN6_RET0_BAK3,		01H
	STA 	CHN6_RET1_BAK3,		01H
	STA 	CHN6_RET2_BAK3,		01H
	JMP 	CAL_CHN6_AD_MAX01

;----------------------------
;Ѱ�����ֵ
CAL_CHN6_AD_MAX01:
	LDA 	CHN6_RET1_BAK0,		01H
	SUB 	CHN6_RET1_BAK1,		01H
	LDA 	CHN6_RET2_BAK0,		01H
	SBC 	CHN6_RET2_BAK1,		01H
	BC 	CAL_CHN6_AD_MAX12 		;D1>D0

;D0>D1
CAL_CHN6_AD_MAX02:
	LDA 	CHN6_RET1_BAK0,		01H
	SUB 	CHN6_RET1_BAK2,		01H
	LDA 	CHN6_RET2_BAK0,		01H
	SBC 	CHN6_RET2_BAK2,		01H
	BC 	CAL_CHN6_AD_MAX23 		;D2>D0

;D0>D2
CAL_CHN6_AD_MAX03:
	LDA 	CHN6_RET1_BAK0,		01H
	SUB 	CHN6_RET1_BAK3,		01H
	LDA 	CHN6_RET2_BAK0,		01H
	SBC 	CHN6_RET2_BAK3,		01H
	BC 	CAL_CHN6_AD_MAX3 		;D3>D0
	;D0>D3
	JMP 	CAL_CHN6_AD_MAX0

;D2>D0
CAL_CHN6_AD_MAX23:
	LDA 	CHN6_RET1_BAK2,		01H
	SUB 	CHN6_RET1_BAK3,		01H
	LDA 	CHN6_RET2_BAK2,		01H
	SBC 	CHN6_RET2_BAK3,		01H
	BC 	CAL_CHN6_AD_MAX3 		;D3>D2
	;D2>D3
	JMP 	CAL_CHN6_AD_MAX2

;D1>D0
CAL_CHN6_AD_MAX12:
	LDA 	CHN6_RET1_BAK1,		01H
	SUB 	CHN6_RET1_BAK2,		01H
	LDA 	CHN6_RET2_BAK1,		01H
	SBC 	CHN6_RET2_BAK2,		01H
	BC 	CAL_CHN6_AD_MAX23 		;D2>D1

;D1>D2
CAL_CHN6_AD_MAX13:
	LDA 	CHN6_RET1_BAK1,		01H
	SUB 	CHN6_RET1_BAK3,		01H
	LDA 	CHN6_RET2_BAK1,		01H
	SBC 	CHN6_RET2_BAK3,		01H
	BC 	CAL_CHN6_AD_MAX3 		;D3>D1
	;D1>D3
	JMP 	CAL_CHN6_AD_MAX1

;-----------------------
;�����ֵ����
CAL_CHN6_AD_MAX0:
	LDI 	TBR,			00H
	STA 	CHN6_RET0_BAK0,		01H
	STA 	CHN6_RET1_BAK0,		01H
	STA 	CHN6_RET2_BAK0,		01H
	JMP 	CAL_CHN6_AD_ADD

CAL_CHN6_AD_MAX1:
	LDI 	TBR,			00H
	STA 	CHN6_RET0_BAK1,		01H
	STA 	CHN6_RET1_BAK1,		01H
	STA 	CHN6_RET2_BAK1,		01H
	JMP 	CAL_CHN6_AD_ADD

CAL_CHN6_AD_MAX2:
	LDI 	TBR,			00H
	STA 	CHN6_RET0_BAK2,		01H
	STA 	CHN6_RET1_BAK2,		01H
	STA 	CHN6_RET2_BAK2,		01H
	JMP 	CAL_CHN6_AD_ADD

CAL_CHN6_AD_MAX3:
	LDI 	TBR,			00H
	STA 	CHN6_RET0_BAK3,		01H
	STA 	CHN6_RET1_BAK3,		01H
	STA 	CHN6_RET2_BAK3,		01H
	JMP 	CAL_CHN6_AD_ADD

;----------------------------
;�����ܺͲ������CHN6_RET0_BAK3,CHN6_RET1_BAK3 ��CHN6_RET2_BAK3����������������ģ�
CAL_CHN6_AD_ADD:
	LDI 	TEMP_SUM_CY,		00H

	;D0 + D1
	;LDA 	CHN6_RET0_BAK0,		01H
	;ADDM 	CHN6_RET0_BAK1,		01H
	LDA 	CHN6_RET1_BAK0,		01H
	ADDM 	CHN6_RET1_BAK1,		01H
	LDA 	CHN6_RET2_BAK0,		01H
	ADCM 	CHN6_RET2_BAK1,		01H
	LDI 	TBR,			00H
	ADCM 	TEMP_SUM_CY

	;+ D2
	;LDA 	CHN6_RET0_BAK1,		01H
	;ADDM 	CHN6_RET0_BAK2,		01H
	LDA 	CHN6_RET1_BAK1,		01H
	ADDM 	CHN6_RET1_BAK2,		01H
	LDA 	CHN6_RET2_BAK1,		01H
	ADCM 	CHN6_RET2_BAK2,		01H
	LDI 	TBR,			00H
	ADCM 	TEMP_SUM_CY

	;+ D3
	;LDA 	CHN6_RET0_BAK2,		01H
	;ADDM 	CHN6_RET0_BAK3,		01H
	LDA 	CHN6_RET1_BAK2,		01H
	ADDM 	CHN6_RET1_BAK3,		01H
	LDA 	CHN6_RET2_BAK2,		01H
	ADCM 	CHN6_RET2_BAK3,		01H
	LDI 	TBR,			00H
	ADCM 	TEMP_SUM_CY

;----------------------------
;�ܺͳ���2���õ�ƽ��ֵ�������CHN6_FINAL_RET0(),CHN6_FINAL_RET1 ��CHN6_FINAL_RET2
CAL_CHN6_AD_DIV:
	;LDA 	CHN6_RET0_BAK3,		01H
	;SHR
	;STA 	CHN6_RET0_BAK3,		01H
	
	LDA 	CHN6_RET1_BAK3,		01H
	SHR
	STA 	CHN6_RET1_BAK3,		01H
	
	;BNC 	$+3
	;LDI 	TBR,			0010B
	;ORM 	CHN6_RET0_BAK3

	LDA 	CHN6_RET2_BAK3,		01H
	SHR
	STA 	CHN6_RET2_BAK3,		01H
	
	BNC 	$+3
	LDI 	TBR,			1000B
	ORM 	CHN6_RET1_BAK3,		01H

	LDA 	TEMP_SUM_CY
	SHR
	BNC 	$+3
	LDI 	TBR,			1000B
	ORM 	CHN6_RET2_BAK3,		01H


	;LDA	CHN6_RET0_BAK3,		01H
	;STA	CHN6_FINAL_RET0,		01H
	LDA	CHN6_RET1_BAK3,		01H
	STA	CHN6_FINAL_RET1,	01H
	LDA	CHN6_RET2_BAK3,		01H
	STA	CHN6_FINAL_RET2,	01H

;----------------------------
;����ΪCHN6_FINAL_RET0��ŵ�4λ��CHN6_FINAL_RET1�����4λ��CHN6_FINAL_RET2��Ÿ�2λ
	;LDA 	CHN6_FINAL_RET1,		01H
	;SHR
	;STA 	CHN6_FINAL_RET1,		01H

	;BNC 	$+3
	;LDI 	TBR,			0100B
	;ORM 	CHN6_FINAL_RET0,		01H

	;LDA 	CHN6_FINAL_RET1,		01H
	;SHR
	;STA 	CHN6_FINAL_RET1,		01H	

	;BNC 	$+3
	;LDI 	TBR,			1000B
	;ORM 	CHN6_FINAL_RET0,		01H


	;LDA 	CHN6_FINAL_RET2,		01H
	;SHR
	;STA 	CHN6_FINAL_RET2,		01H	

	;BNC 	$+3
	;LDI 	TBR,			0100B
	;ORM 	CHN6_FINAL_RET1,		01H

	;LDA 	CHN6_FINAL_RET2,		01H
	;SHR
	;STA 	CHN6_FINAL_RET2,		01H	

	;BNC 	$+3
	;LDI 	TBR,			1000B
	;ORM 	CHN6_FINAL_RET1,		01H
	
;----------------------------
CAL_CHN6_ADCDATA_END:	

	RTNI


;*******************************************
; �ӳ���: CAL_CHN7_ADCDATA
; ����: ������ƽ���˲�����N=4��ȥһ�����ֵ��һ����Сֵ��ʣ��������ƽ��ֵ��
;*******************************************
CAL_CHN7_ADCDATA:

;----------------------------
;Ѱ����Сֵ
CAL_CHN7_AD_MIN01:	
	LDA 	CHN7_RET1_BAK0,		01H
	SUB 	CHN7_RET1_BAK1,		01H
	LDA 	CHN7_RET2_BAK0,		01H
	SBC 	CHN7_RET2_BAK1,		01H
	BC 	CAL_CHN7_AD_MIN02 		;D0<D1	

CAL_CHN7_AD_MIN12:
	LDA 	CHN7_RET1_BAK1,		01H
	SUB 	CHN7_RET1_BAK2,		01H
	LDA 	CHN7_RET2_BAK1,		01H
	SBC 	CHN7_RET2_BAK2,		01H
	BC 	CAL_CHN7_AD_MIN13 		;D1<D2

CAL_CHN7_AD_MIN23:
	LDA 	CHN7_RET1_BAK2,		01H
	SUB 	CHN7_RET1_BAK3,		01H
	LDA 	CHN7_RET2_BAK2,		01H
	SBC 	CHN7_RET2_BAK3,		01H
	BC 	CAL_CHN7_AD_MIN2 		;D2<D3
	;D3<D2
	JMP 	CAL_CHN7_AD_MIN3

CAL_CHN7_AD_MIN13:
	LDA 	CHN7_RET1_BAK1,		01H
	SUB 	CHN7_RET1_BAK3,		01H
	LDA 	CHN7_RET2_BAK1,		01H
	SBC 	CHN7_RET2_BAK3,		01H
	BC 	CAL_CHN7_AD_MIN1 		;D1<D3
	;D3<D1
	JMP 	CAL_CHN7_AD_MIN3

;D0<D1
CAL_CHN7_AD_MIN02:
	LDA 	CHN7_RET1_BAK0,		01H
	SUB 	CHN7_RET1_BAK2,		01H
	LDA 	CHN7_RET2_BAK0,		01H
	SBC 	CHN7_RET2_BAK2,		01H
	BC 	CAL_CHN7_AD_MIN03 		;D0<D2
	;D3<D1
	JMP 	CAL_CHN7_AD_MIN23

;D0<D2
CAL_CHN7_AD_MIN03:
	LDA 	CHN7_RET1_BAK0,		01H
	SUB 	CHN7_RET1_BAK3,		01H
	LDA 	CHN7_RET2_BAK0,		01H
	SBC 	CHN7_RET2_BAK3,		01H
	BC 	CAL_CHN7_AD_MIN0 		;D0<D3
	;D3<D0
	JMP 	CAL_CHN7_AD_MIN3

;-----------------------
;����Сֵ����
CAL_CHN7_AD_MIN0:
	LDI 	TBR,			00H
	STA 	CHN7_RET0_BAK0,		01H
	STA 	CHN7_RET1_BAK0,		01H
	STA 	CHN7_RET2_BAK0,		01H
	JMP 	CAL_CHN7_AD_MAX01

CAL_CHN7_AD_MIN1:
	LDI 	TBR,			00H
	STA 	CHN7_RET0_BAK1,		01H
	STA 	CHN7_RET1_BAK1,		01H
	STA 	CHN7_RET2_BAK1,		01H
	JMP 	CAL_CHN7_AD_MAX01

CAL_CHN7_AD_MIN2:
	LDI 	TBR,			00H
	STA 	CHN7_RET0_BAK2,		01H
	STA 	CHN7_RET1_BAK2,		01H
	STA 	CHN7_RET2_BAK2,		01H
	JMP 	CAL_CHN7_AD_MAX01

CAL_CHN7_AD_MIN3:
	LDI 	TBR,			00H
	STA 	CHN7_RET0_BAK3,		01H
	STA 	CHN7_RET1_BAK3,		01H
	STA 	CHN7_RET2_BAK3,		01H
	JMP 	CAL_CHN7_AD_MAX01

;----------------------------
;Ѱ�����ֵ
CAL_CHN7_AD_MAX01:
	LDA 	CHN7_RET1_BAK0,		01H
	SUB 	CHN7_RET1_BAK1,		01H
	LDA 	CHN7_RET2_BAK0,		01H
	SBC 	CHN7_RET2_BAK1,		01H
	BC 	CAL_CHN7_AD_MAX12 		;D1>D0

;D0>D1
CAL_CHN7_AD_MAX02:
	LDA 	CHN7_RET1_BAK0,		01H
	SUB 	CHN7_RET1_BAK2,		01H
	LDA 	CHN7_RET2_BAK0,		01H
	SBC 	CHN7_RET2_BAK2,		01H
	BC 	CAL_CHN7_AD_MAX23 		;D2>D0

;D0>D2
CAL_CHN7_AD_MAX03:
	LDA 	CHN7_RET1_BAK0,		01H
	SUB 	CHN7_RET1_BAK3,		01H
	LDA 	CHN7_RET2_BAK0,		01H
	SBC 	CHN7_RET2_BAK3,		01H
	BC 	CAL_CHN7_AD_MAX3 		;D3>D0
	;D0>D3
	JMP 	CAL_CHN7_AD_MAX0

;D2>D0
CAL_CHN7_AD_MAX23:
	LDA 	CHN7_RET1_BAK2,		01H
	SUB 	CHN7_RET1_BAK3,		01H
	LDA 	CHN7_RET2_BAK2,		01H
	SBC 	CHN7_RET2_BAK3,		01H
	BC 	CAL_CHN7_AD_MAX3 		;D3>D2
	;D2>D3
	JMP 	CAL_CHN7_AD_MAX2

;D1>D0
CAL_CHN7_AD_MAX12:
	LDA 	CHN7_RET1_BAK1,		01H
	SUB 	CHN7_RET1_BAK2,		01H
	LDA 	CHN7_RET2_BAK1,		01H
	SBC 	CHN7_RET2_BAK2,		01H
	BC 	CAL_CHN7_AD_MAX23 		;D2>D1

;D1>D2
CAL_CHN7_AD_MAX13:
	LDA 	CHN7_RET1_BAK1,		01H
	SUB 	CHN7_RET1_BAK3,		01H
	LDA 	CHN7_RET2_BAK1,		01H
	SBC 	CHN7_RET2_BAK3,		01H
	BC 	CAL_CHN7_AD_MAX3 		;D3>D1
	;D1>D3
	JMP 	CAL_CHN7_AD_MAX1

;-----------------------
;�����ֵ����
CAL_CHN7_AD_MAX0:
	LDI 	TBR,			00H
	STA 	CHN7_RET0_BAK0,		01H
	STA 	CHN7_RET1_BAK0,		01H
	STA 	CHN7_RET2_BAK0,		01H
	JMP 	CAL_CHN7_AD_ADD

CAL_CHN7_AD_MAX1:
	LDI 	TBR,			00H
	STA 	CHN7_RET0_BAK1,		01H
	STA 	CHN7_RET1_BAK1,		01H
	STA 	CHN7_RET2_BAK1,		01H
	JMP 	CAL_CHN7_AD_ADD

CAL_CHN7_AD_MAX2:
	LDI 	TBR,			00H
	STA 	CHN7_RET0_BAK2,		01H
	STA 	CHN7_RET1_BAK2,		01H
	STA 	CHN7_RET2_BAK2,		01H
	JMP 	CAL_CHN7_AD_ADD

CAL_CHN7_AD_MAX3:
	LDI 	TBR,			00H
	STA 	CHN7_RET0_BAK3,		01H
	STA 	CHN7_RET1_BAK3,		01H
	STA 	CHN7_RET2_BAK3,		01H
	JMP 	CAL_CHN7_AD_ADD

;----------------------------
;�����ܺͲ������CHN7_RET0_BAK3,CHN7_RET1_BAK3 ��CHN7_RET2_BAK3����������������ģ�
CAL_CHN7_AD_ADD:
	LDI 	TEMP_SUM_CY,		00H

	;D0 + D1
	;LDA 	CHN7_RET0_BAK0,		01H
	;ADDM 	CHN7_RET0_BAK1,		01H
	LDA 	CHN7_RET1_BAK0,		01H
	ADDM 	CHN7_RET1_BAK1,		01H
	LDA 	CHN7_RET2_BAK0,		01H
	ADCM 	CHN7_RET2_BAK1,		01H
	LDI 	TBR,			00H
	ADCM 	TEMP_SUM_CY

	;+ D2
	;LDA 	CHN7_RET0_BAK1,		01H
	;ADDM 	CHN7_RET0_BAK2,		01H
	LDA 	CHN7_RET1_BAK1,		01H
	ADDM 	CHN7_RET1_BAK2,		01H
	LDA 	CHN7_RET2_BAK1,		01H
	ADCM 	CHN7_RET2_BAK2,		01H
	LDI 	TBR,			00H
	ADCM 	TEMP_SUM_CY

	;+ D3
	;LDA 	CHN7_RET0_BAK2,		01H
	;ADDM 	CHN7_RET0_BAK3,		01H
	LDA 	CHN7_RET1_BAK2,		01H
	ADDM 	CHN7_RET1_BAK3,		01H
	LDA 	CHN7_RET2_BAK2,		01H
	ADCM 	CHN7_RET2_BAK3,		01H
	LDI 	TBR,			00H
	ADCM 	TEMP_SUM_CY

;----------------------------
;�ܺͳ���2���õ�ƽ��ֵ�������CHN7_FINAL_RET0(),CHN7_FINAL_RET1 ��CHN7_FINAL_RET2
CAL_CHN7_AD_DIV:
	;LDA 	CHN7_RET0_BAK3,		01H
	;SHR
	;STA 	CHN7_RET0_BAK3,		01H
	
	LDA 	CHN7_RET1_BAK3,		01H
	SHR
	STA 	CHN7_RET1_BAK3,		01H
	
	;BNC 	$+3
	;LDI 	TBR,			0010B
	;ORM 	CHN7_RET0_BAK3

	LDA 	CHN7_RET2_BAK3,		01H
	SHR
	STA 	CHN7_RET2_BAK3,		01H
	
	BNC 	$+3
	LDI 	TBR,			1000B
	ORM 	CHN7_RET1_BAK3,		01H

	LDA 	TEMP_SUM_CY
	SHR
	BNC 	$+3
	LDI 	TBR,			1000B
	ORM 	CHN7_RET2_BAK3,		01H


	;LDA	CHN7_RET0_BAK3,		01H
	;STA	CHN7_FINAL_RET0,		01H
	LDA	CHN7_RET1_BAK3,		01H
	STA	CHN7_FINAL_RET1,	01H
	LDA	CHN7_RET2_BAK3,		01H
	STA	CHN7_FINAL_RET2,	01H

;----------------------------
;����ΪCHN7_FINAL_RET0��ŵ�4λ��CHN7_FINAL_RET1�����4λ��CHN7_FINAL_RET2��Ÿ�2λ
	;LDA 	CHN7_FINAL_RET1,		01H
	;SHR
	;STA 	CHN7_FINAL_RET1,		01H

	;BNC 	$+3
	;LDI 	TBR,			0100B
	;ORM 	CHN7_FINAL_RET0,		01H

	;LDA 	CHN7_FINAL_RET1,		01H
	;SHR
	;STA 	CHN7_FINAL_RET1,		01H	

	;BNC 	$+3
	;LDI 	TBR,			1000B
	;ORM 	CHN7_FINAL_RET0,		01H


	;LDA 	CHN7_FINAL_RET2,		01H
	;SHR
	;STA 	CHN7_FINAL_RET2,		01H	

	;BNC 	$+3
	;LDI 	TBR,			0100B
	;ORM 	CHN7_FINAL_RET1,		01H

	;LDA 	CHN7_FINAL_RET2,		01H
	;SHR
	;STA 	CHN7_FINAL_RET2,		01H	

	;BNC 	$+3
	;LDI 	TBR,			1000B
	;ORM 	CHN7_FINAL_RET1,		01H
	
;----------------------------
CAL_CHN7_ADCDATA_END:	

	RTNI

	END



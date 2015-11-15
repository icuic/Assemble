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

AD_RET0	EQU	2DH			;ADC ת�������2λ
AD_RET1	EQU	2EH			;ADC ת�������4λ
AD_RET2	EQU	2FH			;ADC ת�������4λ



PPBCR 	EQU 	389H 			;PORTB ������������ƼĴ��� 

;*****************************************************
;�û��Զ���Ĵ��� ($030 ~ $0EF)
;*****************************************************
AC_BAK 	EQU 	30H 			;AC ֵ���ݼĴ���


;--------------------------------------
; ����TIMER ��ʱ
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

DET0_CT		EQU	40H		;ADC ͨ��0 ת���������
DET1_CT		EQU	41H		;ADC ͨ��1 ת���������
DET6_CT		EQU	42H		;ADC ͨ��6 ת���������

;------------------------------------------------------------------
CHN0_RET0_BAK0	EQU	43H		;ADC CHN0 ת�������2λ����
CHN0_RET1_BAK0	EQU	44H		;ADC CHN0 ת�������4λ����
CHN0_RET2_BAK0	EQU	45H		;ADC CHN0 ת�������4λ����

CHN0_RET0_BAK1	EQU	46H		;ADC CHN0 ת�������2λ����
CHN0_RET1_BAK1	EQU	47H		;ADC CHN0 ת�������4λ����
CHN0_RET2_BAK1	EQU	48H		;ADC CHN0 ת�������4λ����

CHN0_RET0_BAK2	EQU	43H		;ADC CHN0 ת�������2λ����
CHN0_RET1_BAK2	EQU	44H		;ADC CHN0 ת�������4λ����
CHN0_RET2_BAK2	EQU	45H		;ADC CHN0 ת�������4λ����

CHN0_RET0_BAK3	EQU	46H		;ADC CHN0 ת�������2λ����
CHN0_RET1_BAK3	EQU	47H		;ADC CHN0 ת�������4λ����
CHN0_RET2_BAK3	EQU	48H		;ADC CHN0 ת�������4λ����

;------------------------------------------------------------------
CHN1_RET0_BAK0	EQU	49H		;ADC CHN1 ת�������2λ����
CHN1_RET1_BAK0	EQU	4AH		;ADC CHN1 ת�������4λ����
CHN1_RET2_BAK0	EQU	4BH		;ADC CHN1 ת�������4λ����

CHN1_RET0_BAK1	EQU	4CH		;ADC CHN1 ת�������2λ����
CHN1_RET1_BAK1	EQU	4DH		;ADC CHN1 ת�������4λ����
CHN1_RET2_BAK1	EQU	4EH		;ADC CHN1 ת�������4λ����

CHN1_RET0_BAK2	EQU	4FH		;ADC CHN1 ת�������2λ����
CHN1_RET1_BAK2	EQU	50H		;ADC CHN1 ת�������4λ����
CHN1_RET2_BAK2	EQU	51H		;ADC CHN1 ת�������4λ����

CHN1_RET0_BAK3	EQU	52H		;ADC CHN1 ת�������2λ����
CHN1_RET1_BAK3	EQU	53H		;ADC CHN1 ת�������4λ����
CHN1_RET2_BAK3	EQU	54H		;ADC CHN1 ת�������4λ����

;------------------------------------------------------------------
CHN6_RET0_BAK0	EQU	55H		;ADC CHN6 ת�������2λ����
CHN6_RET1_BAK0	EQU	56H		;ADC CHN6 ת�������4λ����
CHN6_RET2_BAK0	EQU	57H		;ADC CHN6 ת�������4λ����

CHN6_RET0_BAK1	EQU	58H		;ADC CHN6 ת�������2λ����
CHN6_RET1_BAK1	EQU	59H		;ADC CHN6 ת�������4λ����
CHN6_RET2_BAK1	EQU	5AH		;ADC CHN6 ת�������4λ����

CHN6_RET0_BAK2	EQU	5BH		;ADC CHN6 ת�������2λ����
CHN6_RET1_BAK2	EQU	5CH		;ADC CHN6 ת�������4λ����
CHN6_RET2_BAK2	EQU	5DH		;ADC CHN6 ת�������4λ����

CHN6_RET0_BAK3	EQU	5EH		;ADC CHN6 ת�������2λ����
CHN6_RET1_BAK3	EQU	5FH		;ADC CHN6 ת�������4λ����
CHN6_RET2_BAK3	EQU	60H		;ADC CHN6 ת�������4λ����

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
	JMP	ADC_ISP_END		;��������²�Ӧִ�д����
	
;ת��ͨ��0 ת�����
;----------------------------------------------------------------
CHN0_VOL_1:
	ADIM 	DET0_CT,	01H 	;������һ
	
	SBI 	DET0_CT,	04H
	BAZ 	CHN0_VOL_14		;��4��ת�����
	SBI 	DET0_CT,	03H
	BAZ 	CHN0_VOL_13		;��3��ת�����
	SBI 	DET0_CT,	02H
	BAZ 	CHN0_VOL_12		;��2��ת�����

CHN0_VOL_11:
	LDA 	AD_RET0,	00H 	;�����һ��A/D ת�����
	STA 	CHN0_RET0_BAK0
	LDA 	AD_RET1,	00H
	STA 	CHN0_RET1_BAK0
	LDA 	AD_RET2,	00H
	STA 	CHN0_RET2_BAK0
	JMP 	NEXT_CHN	

CHN0_VOL_12:
	LDA 	AD_RET0,	00H 	;����ڶ���A/D ת�����
	STA 	CHN0_RET0_BAK1
	LDA 	AD_RET1,	00H
	STA 	CHN0_RET1_BAK1
	LDA 	AD_RET2,	00H
	STA 	CHN0_RET2_BAK1
	JMP 	NEXT_CHN
	
CHN0_VOL_13:
	LDA 	AD_RET0,	00H 	;���������A/D ת�����
	STA 	CHN0_RET0_BAK2
	LDA 	AD_RET1,	00H
	STA 	CHN0_RET1_BAK2
	LDA 	AD_RET2,	00H
	STA 	CHN0_RET2_BAK2
	JMP 	NEXT_CHN	
	
CHN0_VOL_14:
	LDA 	AD_RET0,	00H 	;������Ĵ�A/D ת�����
	STA 	CHN0_RET0_BAK3
	LDA 	AD_RET1,	00H
	STA 	CHN0_RET1_BAK3
	LDA 	AD_RET2,	00H
	STA 	CHN0_RET2_BAK3
	JMP 	NEXT_CHN	
;----------------------------------------------------------------

;ת��ͨ��1 ת�����
;----------------------------------------------------------------
CHN1_VOL_1:
	ADIM 	DET1_CT,	01H 	;������һ
	
	SBI 	DET1_CT,	04H
	BAZ 	CHN1_VOL_14		;��4��ת�����
	SBI 	DET1_CT,	03H
	BAZ 	CHN1_VOL_13		;��3��ת�����
	SBI 	DET1_CT,	02H
	BAZ 	CHN1_VOL_12		;��2��ת�����

CHN1_VOL_11:
	LDA 	AD_RET0,	00H 	;�����һ��A/D ת�����
	STA 	CHN1_RET0_BAK0
	LDA 	AD_RET1,	00H
	STA 	CHN1_RET1_BAK0
	LDA 	AD_RET2,	00H
	STA 	CHN1_RET2_BAK0
	JMP 	NEXT_CHN	

CHN1_VOL_12:
	LDA 	AD_RET0,	00H 	;����ڶ���A/D ת�����
	STA 	CHN1_RET0_BAK1
	LDA 	AD_RET1,	00H
	STA 	CHN1_RET1_BAK1
	LDA 	AD_RET2,	00H
	STA 	CHN1_RET2_BAK1
	JMP 	NEXT_CHN
	
CHN1_VOL_13:
	LDA 	AD_RET0,	00H 	;���������A/D ת�����
	STA 	CHN1_RET0_BAK2
	LDA 	AD_RET1,	00H
	STA 	CHN1_RET1_BAK2
	LDA 	AD_RET2,	00H
	STA 	CHN1_RET2_BAK2
	JMP 	NEXT_CHN	
	
CHN1_VOL_14:
	LDA 	AD_RET0,	00H 	;������Ĵ�A/D ת�����
	STA 	CHN1_RET0_BAK3
	LDA 	AD_RET1,	00H
	STA 	CHN1_RET1_BAK3
	LDA 	AD_RET2,	00H
	STA 	CHN1_RET2_BAK3
	JMP 	NEXT_CHN	
;----------------------------------------------------------------
	
;ת��ͨ��6 ת�����
;----------------------------------------------------------------
CHN6_VOL_1:
	ADIM 	DET6_CT,	01H 	;������һ
	
	SBI 	DET6_CT,	04H
	BAZ 	CHN6_VOL_14		;��4��ת�����
	SBI 	DET6_CT,	03H
	BAZ 	CHN6_VOL_13		;��3��ת�����
	SBI 	DET6_CT,	02H
	BAZ 	CHN6_VOL_12		;��2��ת�����

CHN6_VOL_11:
	LDA 	AD_RET0,	00H 	;�����һ��A/D ת�����
	STA 	CHN6_RET0_BAK0
	LDA 	AD_RET1,	00H
	STA 	CHN6_RET1_BAK0
	LDA 	AD_RET2,	00H
	STA 	CHN6_RET2_BAK0
	JMP 	NEXT_CHN	

CHN6_VOL_12:
	LDA 	AD_RET0,	00H 	;����ڶ���A/D ת�����
	STA 	CHN6_RET0_BAK1
	LDA 	AD_RET1,	00H
	STA 	CHN6_RET1_BAK1
	LDA 	AD_RET2,	00H
	STA 	CHN6_RET2_BAK1
	JMP 	NEXT_CHN
	
CHN6_VOL_13:
	LDA 	AD_RET0,	00H 	;���������A/D ת�����
	STA 	CHN6_RET0_BAK2
	LDA 	AD_RET1,	00H
	STA 	CHN6_RET1_BAK2
	LDA 	AD_RET2,	00H
	STA 	CHN6_RET2_BAK2
	JMP 	NEXT_CHN	
	
CHN6_VOL_14:
	LDA 	AD_RET0,	00H 	;������Ĵ�A/D ת�����
	STA 	CHN1_RET0_BAK3
	LDA 	AD_RET1,	00H
	STA 	CHN1_RET1_BAK3
	LDA 	AD_RET2,	00H
	STA 	CHN1_RET2_BAK3
	JMP 	NEXT_CHN	
;----------------------------------------------------------------	
	
;----------------------------------------------------------------	
NEXT_CHN:
	SBI 	ADCCHN,		01H
	BAZ 	NEXT_CHN6 		;��2 ��ͨ��AN1�����趨��һ��ͨ��ΪAN6
	ADIM 	ADCCHN,		01H 	;ѡ����һ��ͨ��
	BA2	NEXT_CHN0		;����һͨ���趨ΪAN0
	JMP 	ADC_ISP_END

NEXT_CHN0:
	LDI	ADCCHN,		00H	;�趨Ϊ��0 ��ͨ��AN0
	JMP 	ADC_ISP_END
	
NEXT_CHN6:
	LDI 	ADCCHN,		06H 	;�趨Ϊ��7 ��ͨ��AN6	
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
	LDI 	TBR,		00H
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
	LDI 	PORTB,		00H
	LDI 	PBCR,		0FH 	;����PortB ��Ϊ�����
	LDI 	PORTE,		0FH
	LDI 	PECR,		0FH 	;����PortE ��Ϊ�����
	LDI	PCCR,		0001H	;����PortC.0 ��Ϊ�����

	;ADC��ʼ��
	LDI 	PACR,		0000B 	;����PortA0/1 ��Ϊ�����
	LDI 	PBCR,		0000B 	;����PortB2   ��Ϊ�����
	LDI 	ADCCTL,		0001B 	;ѡ���ڲ��ο���ѹVDD��ʹ��ADC
	LDI 	ADCCFG,		0100B 	;A/D ʱ��tAD=8tOSC, A/D ת��ʱ��= 204tAD
	LDI	ADCPORT,	0111B	;ʹ��AN0 ~ AN6
	LDI	ADCCHN,		00H	;ѡ��AN0
	ORIM 	ADCCFG,		1000B 	;����A/D ת��
	
;--------------------------------------
MAIN_PRE:
	LDI 	IRQ,		00H
	LDI 	IE,		1100B 	;��ADC,Timer0 �ж�

MAIN:
	ADI 	F_TIME,		0001B
	BA0 	HALTMODE 		;δ��1s,��ת
	
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



	END

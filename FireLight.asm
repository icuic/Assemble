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
AC_BAK 		EQU 	30H 		;AC ֵ���ݼĴ���

SIMULATE_STA	EQU	31H		;bit0 = 1, �ѽ���"ģ��ͣ��"״̬, bit0 = 0, ����"ģ��ͣ��"״̬�˳�
					;bit1 = 1, ����"�ֶ��¼�"״̬
					;bit2 = 1, ����"�ֶ����"״̬
					;bit3 = 1, ����"�ض�Ӧ�����"״̬

NORMAL_STA	EQU	32H		;bit0 = 1, ��ǰ����"����"״̬
ABNORMAL_STA	EQU	33H		;bit0 = 1, ��ǰ����"ͣ��"��"ģ��ͣ��"״̬
					;bit1 = 1, ��ǰ����"�¼�"��"�ֶ��¼�"״̬
					;bit2 = 1, ��ǰ����"���"��"�ֶ����"״̬

;--------------------------------------
; ����TIMER ��ʱ
F_496MS_1S	EQU	35H		;bit0 = 1, 496ms �������������ʹ�á�
					;bit1 = 1, 1s �������ڼ�ʱӦ��ʱ����

F_TIME 		EQU 	36H 		;bit0=1, 1s ��; bit1=1, 1�µ�; bit2=1, 1�굽��

CNT0_8MS 	EQU 	37H	 	;CNT1_8MS, CNT0_8MS��ɵ�8BIT���ݴﵽ125ʱ����Timer0����125���жϺ󣬱�ʾ1S��ʱ�ѵ�
CNT1_8MS 	EQU 	38H 		;���ԣ���ʼ��CNT1_8MS=07H, CNT0_8MS=0DH

SEC_CNT0	EQU	39H		;SEC_CNT0/1/2 ����Ϊ��λ��ʱ
SEC_CNT1	EQU	3AH		;����ֵ�ﵽ1Сʱ����3600(E10H)��ʱ����HOUR_CNT0/1��λ���������㡣
SEC_CNT2	EQU	3BH

HOUR_CNT0	EQU	3CH		;HOUR_CNT0/1 ��СʱΪ��λ��ʱ
HOUR_CNT1	EQU	3DH		;����ֵ�ﵽ1��ʱ����744(2EBH)Сʱʱ����MONTH_CNT0/1��λ��ͬʱ��F_TIME.1���������㡣
HOUR_CNT2	EQU	3EH		

MONTH_CNT	EQU	3FH		;MONTH_CNT0/1 ����Ϊ��λ��ʱ
					;����ֵ�ﵽ1��ʱ����12(0CH)��ʱ����ͬʱ��F_TIME.2���������㡣

TEMP_SUM_CY	EQU	40H		;AD�ӳ��������ʱ����
FLAG_OCCUPIED	EQU	41H		;bit0/1/2/3 = 1ʱ�ֱ��ʾCHN0��1��6��7��ת�����(CHN0_FINAL_RET1��)����ǰ̨ʹ��,
					;��ʱADC�жϲ����޸���Щ���ݡ�	

FLAG_TYPE	EQU	42H		;bit0 = 1��ʾ�Ѿ���ɵƾ�����ѡ��(PORTB.3/AN7),��λΪ1������Ҫ��AN7����AD����


CMP_MIN_PWR0	EQU	43H		;�ϵ��Լ�ʱ���ƾߵ�Դ��С��ѹֵ.(1.396V -> 0x23B ->(�������2λ) 0x8E)
CMP_MIN_PWR1	EQU	44H		;

CMP_TYPE00	EQU	45H		;�ƾ���������0
CMP_TYPE01	EQU	46H		;

CMP_TYPE10	EQU	47H		;�ƾ���������1
CMP_TYPE11	EQU	48H		;

CMP_TYPE20	EQU	49H		;�ƾ���������2
CMP_TYPE21	EQU	4AH		;

LIGHT_TYPE	EQU	4BH		;�ƾ�����
					;=0, ﮵�أ�������
					;=1, ﮵�أ�������
					;=2, ���ӵ�أ�������
					;=3, ���ӵ�أ�������

CMP_SUPPLY0	EQU	4CH		;��⵽��Դ��ѹС�ڴ���ֵʱ����ʼӦ���ŵ�.(1.115V -> 0x5B)
CMP_SUPPLY1	EQU	4DH

;XXXXXX		EQU	4EH
					
CNT0_EMERGENCY	EQU	4FH		;��Ӧ��ʱ����ʱ����λs
CNT1_EMERGENCY	EQU	50H
CNT2_EMERGENCY	EQU	51H

CMP_EXIT_EMER0	EQU	52H		;��⵽��ص�ѹС�ڴ���ֵʱ��Ӧ�ùر�Ӧ���ŵ繦��
CMP_EXIT_EMER1	EQU	53H

CMP_BAT_OPEN0	EQU	54H		;��⵽��ص�ѹ���ڴ���ֵʱ����Ϊ��س���·��·
CMP_BAT_OPEN1	EQU	55H		;��⵽��ص�ѹ���ڴ���ֵʱ����Ϊ��س���·��·

CMP_BAT_FULL0	EQU	56H		;��⵽��ص�ѹ���ڴ���ֵʱ����Ϊ����ѳ���
CMP_BAT_FULL1	EQU	57H		;��⵽��ص�ѹ���ڴ���ֵʱ����Ϊ����ѳ���

CMP_BAT_CHARGE0	EQU	58H		;��⵽��ص�ѹС�ڴ���ֵʱ����Ϊ����ѳ���
CMP_BAT_CHARGE1	EQU	59H		;��⵽��ص�ѹС�ڴ���ֵʱ����Ϊ����ѳ���



BAT_STATE	EQU	58H		;bit0 = 0, ��ʾ����·δ��·��bit0 = 1, ��ʾ����·��·
					;bit1 = 0, ��ʾ���δ������bit1 = 1, ��ʾ����ѳ���
					;bit2 = 0, ��ʾ��ػ�����Ҫ��磻bit2 = 0, ��ʾ�����Ҫ���
					;bit3 = 1, ��ʾ��ص�ѹ���ͣ������ټ���Ӧ���ŵ���


CMP_LIGHT0	EQU	59H		;����Դ���ʹ��
CMP_LIGHT1	EQU	5AH

LIGHT_STATE	EQU	5BH		;bit0 = 1, ��ʾ��Դ����


ALARM_STATE	EQU	5CH		;bit0 = 1, ��ʾ��ع���(��·���·)
					;bit1 = 1, ��ʾ��Դ����(��·���·)
					;bit2 = 1, ��ʾ�Լ�ŵ�ʱ�䲻��


CNT_LED_YELLOW	EQU	5FH		;������������ת�Ƶ����ʹ�ã���ʱ��λΪ328MS


FLAG_SIMU_EMER	EQU	60H		;bit0 = 1, ��ʾ��"ģ��ͣ��"״̬���Ѿ���Ӧ������
					;bit1 = 1��ʾ1s�ѵ�

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

CNT0_328MS	EQU	7AH		;���ڶ�ʱ328MS,����תLED��
CNT1_328MS	EQU	7BH
F_328MS		EQU	7CH		;ÿ328ms��bit0 = 1

CMP_RESUME0	EQU	4DH		;��⵽��Դ��ѹ���ڴ���ֵʱ����ʾ�е繩���ѻָ���Ӧ�ر�Ӧ��.(1.296V -> 0x84)
CMP_RESUME1	EQU	4EH

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

J_328MS:
	SBIM	CNT0_328MS,	01H
	LDI	TBR,		00H
	SBCM	CNT1_328MS
	BC	J_496MS

	LDI	CNT0_328MS,	08H	;8ms * 41 = 328ms
	LDI	CNT1_328MS,	02H

	ORIM	F_328MS,	0001B
	
J_496MS:
	;--------------------------------------------------------------------------
	SBIM 	CNT0_496MS,	01H	;ÿ��Timer0�жϲ����󣬽�CNT0_496MS��1
	LDI	TBR,		00H	;���ۼ���A ��0
	SBCM	CNT1_496MS		;ÿ��CNT0-1������λʱ����CNT1_496MS��1
	BC	J1MS			;���δ������λ�����ʾ200MS��δ����

	LDI 	CNT0_496MS,	0DH 	;����496ms ������,496 = 8 * 62
	LDI 	CNT1_496MS,	03H 	;����496ms ������
	
	ORIM 	F_496MS,	0001B 	;���� "496ms ��"��־

J1MS:	
	;--------------------------------------------------------------------------
	SBIM 	CNT0_8MS,	01H	;ÿ��Timer0�жϲ����󣬽�CNT0_8MS��1
	BC 	TIMER0_ISP_END 		;CNT0_8MS�Դ���0, �����ISP
	SBIM	CNT1_8MS,	01H	;ÿ��CNT0_8MS-1������λʱ����CNT1_8MS��1
	BC	TIMER0_ISP_END
	
	LDI 	CNT0_8MS,	0CH 	;����1s ������
	LDI 	CNT1_8MS,	07H 	;����1s ������
	
	ORIM 	F_TIME,		0001B 	;���� "1s ��"��־
	ORIM	F_496MS_1S,	0010B	;ΪӦ�������ṩ "1s ��"��־
	ORIM	FLAG_SIMU_EMER,	0010B	;Ϊ�ֶ��Լ��ṩ "1s ��"��־
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
	LDA	FLAG_TYPE
	BA0	NEXT_CHN0		;��FLAG_TYPE��bit0=1�����ʾ����ɵƾ�����ѡ�񣬴�ʱ������Ҫ��AN7���в�����
	
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

	
	LDI 	IE,		0000B	;�ر������ж�
	
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

	LDI	CNT0_328MS,	08H	;��ʱ328ms
	LDI	CNT1_328MS,	02H	;

	LDI 	CNT0_8MS,	0DH 	;��ʱ1s
	LDI 	CNT1_8MS,	07H 	;��ʱ1s
	
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
	;tosc = 1/4M = 0.25us, tAD = 8tosc = 2us, һ��A/D ת��ʱ�� = 204tAD = 408 us.
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

	;����ֵ
	LDI	CMP_MIN_PWR0,	0EH	;��С�ϵ��ѹ(1.396V)
	LDI	CMP_MIN_PWR1,	08H

	LDI	CMP_SUPPLY0,	0BH	;С�ڴ˵�ѹ������Ӧ������(1.115V -> 0x5B)
	LDI	CMP_SUPPLY1,	05H

	LDI	CMP_RESUME0,	04H	;���ڴ˵�ѹ������Ӧ��ת������(1.296V -> 0x84)
	LDI	CMP_RESUME1,	08H
	
	LDI	CMP_TYPE00,	00H	;�ƾ���������0
	LDI	CMP_TYPE01,	00H

	LDI	CMP_TYPE10,	00H	;�ƾ���������1
	LDI	CMP_TYPE11,	00H

	LDI	CMP_TYPE20,	00H	;�ƾ���������2
	LDI	CMP_TYPE21,	00H


	
;--------------------------------------
MAIN_PRE:
	LDI 	IRQ,		00H
	LDI 	IE,		1100B 	;��ADC,Timer0 �ж�


;--------------------------------------
;��鹩���Ƿ�����
;--------------------------------------
WAIT_AD_RESULT:
	;һ��ͨ������4�����ݣ�ȥ����С�����ֵ�������µ�2������ƽ����õ����ս����
	;�������̺�ʱԼ408us * 4 = 2ms
	;���������ƶϣ��ĸ�ͨ�����ó�һ�����ս�����ʱ 2ms * 4 = 8ms

	;����������˴���ʱ20ms
	CALL	DELAY_5MS
	CALL	DELAY_5MS
	CALL	DELAY_5MS
	CALL	DELAY_5MS

WAIT_PWR_NML:	
	ORIM	FLAG_OCCUPIED,	0100B	;����ͨ��6���ս��

	LDI	CHN6_FINAL_RET1,01H
	SUB	CMP_MIN_PWR0
	LDI	CHN6_FINAL_RET2,01H
	SBC	CMP_MIN_PWR1

	ANDIM	FLAG_OCCUPIED,	1011B	;�ͷŶ�ͨ��6���ս��������
	
	BNC	WAIT_AD_RESULT		;���δ�ﵽ��С�ϵ��ѹ����һֱ�ȴ���ѹ������С�ϵ��ѹ֮�ϡ�


;--------------------------------------
;�ж��ƾ�����
;--------------------------------------
	CALL	CHK_TYPE


MAIN:


	;SBIM	PWMD01,		01H	;ռ�ձ�Ϊ50%
	;LDI	TBR,		00H
	;SBCM	PWMD02

	;BC	KEY_CHK

	;LDI	PWMD01,		0DH
	;LDI	PWMD02,		07H

;--------------------------------------------------------------------------------------
;��鹩�����������ͣ�磬���Ӧ�����ܡ�
;ͬʱ����ص�ѹ�������غľ�����ֹͣӦ��
;����е繩��ָ����򷵻����磬�ر�Ӧ��
;--------------------------------------------------------------------------------------
CHK_PWR_SUPPLY:				;��鹩���Ƿ�����
	ORIM	FLAG_OCCUPIED,	0100B	;����ͨ��6���ս��

	LDI	CHN6_FINAL_RET1,01H
	SUB	CMP_SUPPLY0
	LDI	CHN6_FINAL_RET2,01H
	SBC	CMP_SUPPLY1

	ANDIM	FLAG_OCCUPIED,	1011B	;�ͷŶ�ͨ��6���ս��������
	
	BNC	CHK_BATTERY		;�����������,�����ص�ѹ

	;����Ӧ������
	LDA	ABNORMAL_STA
	BA0	EMERGENCY_CNT		;�Ѵ�Ӧ���ŵ繦��
	ORIM	ABNORMAL_STA,	0001B	;�ñ�־λ�������Ѵ�Ӧ���ŵ繦��
	CALL	EMERGENCY_ENABLE

EMERGENCY_CNT:
	ADI	F_496MS_1S,	0010B	;ÿ����һ��
	BA1	EMERGENCY_WAIT

	ANDIM	F_496MS_1S,	1101B	;���1s��־λ
	SBI	CNT2_EMERGENCY,	08H	;���CNT�ﵽ0x800�����ʾ��Ӧ���ŵ�0x800s = 2048s > 30min
	BC	EMERGENCY_BATTERY	;��ʱ�����ٶ�Ӧ���ŵ�ʱ����ʱ

	ADIM	CNT0_EMERGENCY,	01H
	LDI	TBR,		00H
	ADCM	CNT1_EMERGENCY
	LDI	TBR,		00H
	ADCM	CNT2_EMERGENCY

EMERGENCY_BATTERY:			;������Ƿ��Ѿ��ľ�
	ORIM	FLAG_OCCUPIED,	0010B	;����ͨ��1���ս��

	LDI	CHN1_FINAL_RET1,01H
	SUB	CMP_EXIT_EMER0
	LDI	CHN1_FINAL_RET2,01H
	SBC	CMP_EXIT_EMER1

	ANDIM	FLAG_OCCUPIED,	1101B	;�ͷŶ�ͨ��1���ս��������

	BC	EMERGENCY_WAIT
	CALL	EMERGENCY_DISABLE	;��ص�ѹ���ͣ�ֹͣӦ��


EMERGENCY_WAIT:
	JMP	CHK_PWR_SUPPLY
	

;--------------------------------------------------------------------------------------
;��ʱ��������������ص�ѹ��
;--------------------------------------------------------------------------------------
CHK_BATTERY:

	ORIM	FLAG_OCCUPIED,	0010B	;����ͨ��1���ս��

	LDI	CHN1_FINAL_RET1,01H	
	SUB	CMP_BAT_OPEN0		;�жϵ���Ƿ�·
	LDI	CHN1_FINAL_RET2,01H
	SBC	CMP_BAT_OPEN1
	BNC	BAT_OPEN		;ADת���������1.56V����ؿ�·
	ANDIM	BAT_STATE,	1110B	;�������·��·��־λ

	LDI	CHN1_FINAL_RET1,01H	
	SUB	CMP_BAT_FULL0		;�жϵ���Ƿ����
	LDI	CHN1_FINAL_RET2,01H
	SBC	CMP_BAT_FULL1
	BNC	BAT_FULL		;ADת���������1.44V����ؿ�·
	ANDIM	BAT_STATE,	1101B	;�������ѳ�����־λ

	LDI	CHN1_FINAL_RET1,01H	
	SUB	CMP_BAT_CHARGE0		;�жϵ���Ƿ���ͣ���Ҫ�����
	LDI	CHN1_FINAL_RET2,01H
	SBC	CMP_BAT_CHARGE1
	BNC	BAT_NEED_CHARGE		;ADת�����С��1.35V�������Ҫ���³��
	ANDIM	BAT_STATE,	0100B	;��������Ҫ���³���־λ


BAT_OPEN:
	ORIM	BAT_STATE,	0001B	;�ó���·��·��־λ
	JMP	CHK_BATTERY_END

BAT_FULL:
	ORIM	BAT_STATE,	0010B	;�õ���ѳ�����־λ
	JMP	CHK_BATTERY_END

BAT_NEED_CHARGE:
	ORIM	BAT_STATE,	0100B	;�õ����Ҫ���³���־λ
	JMP	CHK_BATTERY_END

CHK_BATTERY_END:
	ANDIM	FLAG_OCCUPIED,	1101B	;�ͷŶ�ͨ��1���ս��������

;--------------------------------------------------------------------------------------
;��Դ���
;--------------------------------------------------------------------------------------
CHK_LIGHT:
	LDI	TBR,		0101B	;��������0101B�����ۼ���A��
	AND	LIGHT_TYPE		;BIT0\2Ϊ1������ƾ�Ϊ������

	BNZ	TYPE_ON			;Ϊ�����͵ƾ�
	JMP	TYPE_OFF		;Ϊ�����͵ƾ�

	
TYPE_ON:
	CALL	PROCESS_LIGHT		;����Դ����������Ӧ��־λ
	JMP     CHK_LIGHT_END


TYPE_OFF:
	LDA	NORMAL_STA		;����NORMAL_STA���ۼ���A
	BNZ	CHK_LIGHT_END		;��������Դ��������״̬������Թ�Դ���м��
	CALL	PROCESS_LIGHT		;����Դ����������Ӧ��־λ

CHK_LIGHT_END:


;--------------------------------------------------------------------------------------
;������ʾ
;--------------------------------------------------------------------------------------
CHK_ALARM:
	CALL	PROCESS_ALARM		;���ݹ��ϱ�־λ�����ƻƵ�����
	

;--------------------------------------------------------------------------------------
;����ɨ��
;--------------------------------------------------------------------------------------
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
	LDA	FLAG_SIMU_EMER
	BA0	SIM_PWR_CUT_END		;��"ģ��ͣ��"״̬�£��Ѵ�Ӧ���ŵ繦��
	
	ORIM	FLAG_SIMU_EMER,	0001B	;�ñ�־λ��������"ģ��ͣ��"״̬��,�Ѵ�Ӧ���ŵ繦��
	CALL	EMERGENCY_ENABLE

SIM_PWR_CUT_END:	
	RTNI

;***********************************************************
; �ֶ��¼촦����
;***********************************************************
SIM_MONTH_CHK:
	LDA	FLAG_SIMU_EMER
	BA1	SIM_MONTH_CHK_END	;��"�ֶ��¼�"״̬�£��Ѵ�Ӧ���ŵ繦��
	
	ORIM	FLAG_SIMU_EMER,	0010B	;�ñ�־λ��������"�ֶ��¼�"״̬��,�Ѵ�Ӧ���ŵ繦��
	CALL	EMERGENCY_ENABLE


SIM_MONTH_CNT:
	ADI	FLAG_SIMU_EMER,	0010B	;ÿ����һ��
	BA1	SIM_MONTH_CHK_END

	SBI	CNT2_EMERGENCY,	08H	;���CNT�ﵽ0x800�����ʾ��Ӧ���ŵ�0x800s = 2048s > 30min
	BC	SIM_MONTH_BATTERY	;��ʱ�����ٶ�Ӧ���ŵ�ʱ����ʱ

	ADIM	CNT0_EMERGENCY,	01H
	LDI	TBR,		00H
	ADCM	CNT1_EMERGENCY
	LDI	TBR,		00H
	ADCM	CNT2_EMERGENCY

SIM_MONTH_BATTERY:			;������Ƿ��Ѿ��ľ�
	ORIM	FLAG_OCCUPIED,	0010B	;����ͨ��1���ս��

	LDI	CHN1_FINAL_RET1,01H
	SUB	CMP_EXIT_EMER0
	LDI	CHN1_FINAL_RET2,01H
	SBC	CMP_EXIT_EMER1

	ANDIM	FLAG_OCCUPIED,	1101B	;�ͷŶ�ͨ��1���ս��������

	BC	SIM_MONTH_CHK_END
	CALL	EMERGENCY_DISABLE	;��ص�ѹ���ͣ�ֹͣӦ��

SIM_MONTH_CHK_END:
	RTNI

;***********************************************************
; �ֶ���촦����
;***********************************************************
SIM_YEAR_CHK:
	LDA	FLAG_SIMU_EMER
	BA1	SIM_MONTH_CHK_END	;��"�ֶ����"״̬�£��Ѵ�Ӧ���ŵ繦��
	
	ORIM	FLAG_SIMU_EMER,	0010B	;�ñ�־λ��������"�ֶ����"״̬��,�Ѵ�Ӧ���ŵ繦��
	CALL	EMERGENCY_ENABLE


SIM_YEAR_CNT:
	ADI	FLAG_SIMU_EMER,	0010B	;ÿ����һ��
	BA1	SIM_YEAR_CHK_END

	SBI	CNT2_EMERGENCY,	08H	;���CNT�ﵽ0x800�����ʾ��Ӧ���ŵ�0x800s = 2048s > 30min
	BC	SIM_YEAR_BATTERY	;��ʱ�����ٶ�Ӧ���ŵ�ʱ����ʱ

	ADIM	CNT0_EMERGENCY,	01H
	LDI	TBR,		00H
	ADCM	CNT1_EMERGENCY
	LDI	TBR,		00H
	ADCM	CNT2_EMERGENCY

SIM_YEAR_BATTERY:			;������Ƿ��Ѿ��ľ�
	ORIM	FLAG_OCCUPIED,	0010B	;����ͨ��1���ս��

	LDI	CHN1_FINAL_RET1,01H
	SUB	CMP_EXIT_EMER0
	LDI	CHN1_FINAL_RET2,01H
	SBC	CMP_EXIT_EMER1

	ANDIM	FLAG_OCCUPIED,	1101B	;�ͷŶ�ͨ��1���ս��������

	BC	SIM_YEAR_CHK_END
	CALL	EMERGENCY_DISABLE	;��ص�ѹ���ͣ�ֹͣӦ��

SIM_YEAR_CHK_END:

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
	ADI	F_496MS,	0001B	;���496MS��־λ
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
	
	ANDIM	F_496MS,	1110B	;��496MS��־λ
	
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
	ADI	FLAG_OCCUPIED,		0001B
	BA0	CAL_CHN0_AD_MIN01
	JMP	CAL_CHN0_ADCDATA_END		;����ʹ��ת�����

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
	ADI	FLAG_OCCUPIED,		0010B
	BA1	CAL_CHN1_AD_MIN01
	JMP	CAL_CHN1_ADCDATA_END		;����ʹ��ת�����

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
	ADI	FLAG_OCCUPIED,		0100B
	BA2	CAL_CHN6_AD_MIN01
	JMP	CAL_CHN6_ADCDATA_END		;����ʹ��ת�����
	
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
	ADI	FLAG_OCCUPIED,		1000B
	BA3	CAL_CHN7_AD_MIN01
	JMP	CAL_CHN7_ADCDATA_END		;����ʹ��ת�����

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

;***********************************************************
; ���ƾ�����
; ����: CHN7_FINAL_RET1, CHN7_FINAL_RET2
; ���: LIGHT_TYPE
;***********************************************************
CHK_TYPE:
	ORIM	FLAG_OCCUPIED,	1000B	;����ͨ��7���ս��

	LDI	CHN7_FINAL_RET1,01H	;������0�Ƚ�
	SUB	CMP_TYPE00
	LDI	CHN7_FINAL_RET2,01H
	SBC	CMP_TYPE01
	BNC	LI_ON			;

	LDI	CHN7_FINAL_RET1,01H	;������1�Ƚ�
	SUB	CMP_TYPE10
	LDI	CHN7_FINAL_RET2,01H
	SBC	CMP_TYPE11
	BNC	LI_OFF			;

	LDI	CHN7_FINAL_RET1,01H	;������2�Ƚ�
	SUB	CMP_TYPE20
	LDI	CHN7_FINAL_RET2,01H
	SBC	CMP_TYPE21
	BNC	NI_ON			;

NI_OFF:
	LDI	LIGHT_TYPE,	03H
	JMP	CHK_TYPE_END
	
LI_ON:
	LDI	LIGHT_TYPE,	00H
	JMP	CHK_TYPE_END
	
LI_OFF:
	LDI	LIGHT_TYPE,	01H
	JMP	CHK_TYPE_END
	
NI_ON:
	LDI	LIGHT_TYPE,	02H
	
CHK_TYPE_END:
	ANDIM	FLAG_OCCUPIED,	0111B	;�ͷŶ�ͨ��7���ս��������
	ORIM	FLAG_TYPE,	0001B	;���ٶ�ͨ��7���в���
	
	RTNI


;***********************************************************
; ͨ��PWM0���Ƶ��Ϊ32KHZ��ռ�ձ�Ϊ50%�ķ������Դ�����Ӧ����·
;***********************************************************
EMERGENCY_ENABLE:
	LDI	PWMC0,		0000B	;PWM0 Clock = tosc = 4M
	LDI	PWMP00,		0DH	;����Ϊ125��PWM0 Clock
	LDI	PWMP01,		07H	
	LDI	PWMD00,		00H	;��΢��
	LDI	PWMD01,		0EH	;ռ�ձ�Ϊ50%
	LDI	PWMD02,		03H
	ORIM	PWMC0,		0001B	;ʹ��PWM0���

	RTNI

;-----------------------------------------------------------
;����PWM0���ر�Ӧ������
;-----------------------------------------------------------
EMERGENCY_DISABLE:
	LDI	PWMC0,		0000B	;����PWM0

	RTNI


;-----------------------------------------------------------
;����ͨ��0ת�����������Դ״̬�������ù�Դ���ϱ�־λ
;-----------------------------------------------------------
PROCESS_LIGHT:

	ORIM	FLAG_OCCUPIED,	0001B	;����ͨ��0���ս��

	LDI	CHN1_FINAL_RET1,01H
	SUB	CMP_LIGHT0
	LDI	CHN1_FINAL_RET2,01H
	SBC	CMP_LIGHT1

	ANDIM	FLAG_OCCUPIED,	1110B	;�ͷŶ�ͨ��0���ս��������

	BC	ERROR_LIGHT		;��Դ����

	ANDIM	LIGHT_STATE,	1110B	;�����Դ���ϱ�־λ
	JMP     PROCESS_LIGHT_END


ERROR_LIGHT:

	ORIM	LIGHT_STATE,	0001B	;�ù�Դ���ϱ�־λ


PROCESS_LIGHT_END:

	RTNI

;--------------------------------------------------------------------------------------
;���ݵ�ص�ѹ���������Դ�����������Ӧ����
;����·��·/��·: ����𣬻Ƶ�1HZ��˸
;��Դ��·/��·:             �Ƶ�3HZ��˸
;�ŵ�ʱ�䲻��:              �ƵƳ���
;--------------------------------------------------------------------------------------
PROCESS_ALARM:

ALARM_BAT:	
	LDI	TBR,		0001B	;��0001B�����ۼ���A��
	AND	ALARM_STATE 		;�жϵ���Ƿ��ڹ���״̬
	BAZ	ALARM_LIGHT		;���û�й��ϣ�����ת

	ANDIM	PORTC,		1110B	;��س���·���ϣ��رպ��

	ADI	F_328MS,	01H	;�ж��Ƿ���һ����328MS
	BA0	ALARM_LIGHT		;��δ���µ�328MS,��ת

	ADIM	CNT_LED_YELLOW,	01H	;328MS�ѵ�����������1

	SBI	CNT_LED_YELLOW,	03H
	BNC	ALARM_LIGHT		;δ��1s

	LDI	CNT_LED_YELLOW,	00H	;���������
	EORIM	PORTE,		0001B	;��1HZƵ�ʷ�ת�Ƶ�

ALARM_LIGHT:
	LDI	TBR,		0010B	;��0010B�����ۼ���A��
	AND	ALARM_STATE		;�жϹ�Դ�Ƿ��ڹ���״̬
	BAZ	ALARM_TIME_NOT_ENOUGH	;��Դû�й��ϣ�����ת

	ADI	CNT0_328MS,	01H	;�ж��Ƿ���һ����328MS
	BA0	ALARM_TIME_NOT_ENOUGH	;��δ���µ�328MS,��ת

	EORIM	PORTE,		0001B	;��3HZƵ�ʷ�ת�Ƶ�

	ANDIM	F_328MS,	1110B	;���328MS��־

ALARM_TIME_NOT_ENOUGH:
	LDI	TBR,		0100B	;��0100B�����ۼ���A��
	AND	ALARM_STATE		;�ж��Ƿ���ַŵ�ʱ�䲻��֮����
	BAZ	OFF_LED_YELLOW		;û�г��ַŵ�ʱ�䲻��֮���ϣ�����ת
	
	ORIM	PORTE,		0001B	;�ƵƳ���

OFF_LED_YELLOW:
	LDA	ALARM_STATE		;���û���κι��ϣ���رջƵ�
	BNZ	PROCESS_ALARM_END
	ANDIM	PORTE,		1110B

PROCESS_ALARM_END:
	RTNI



	
	END



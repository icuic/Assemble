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
;系统寄存器 ($000 ~ $02F, $380 ~ $38C)
;*****************************************************
IE	EQU	00H			;中断使能/禁能控制
IRQ	EQU	01H			;中断请求标志

TM0	EQU	02H			;Timer0 模式寄存器
TM1	EQU	03H			;Timer1 模式寄存器

TL0	EQU	04H			;Timer0 重载值低4位
TH0	EQU	05H			;Timer0 重载值高4位

TL1	EQU	06H			;Timer1 重载值低4位
TH1	EQU	07H			;Timer1 重载值高4位

PORTA	EQU	08H			;PortA 数据寄存器
PORTB	EQU	09H			;PortB 数据寄存器
PORTC	EQU	0AH			;PortC 数据寄存器
PORTD	EQU	0BH			;PortD 数据寄存器
PORTE	EQU	0CH			;PortE 数据寄存器

					;0DH Reserved
				
TBR	EQU	0EH			;查表寄存器
INX	EQU	0FH			;间接寻址伪索引寄存器
DPL	EQU	10H			;INX数据指针低4位
DPM	EQU	11H			;INX数据指针中4位
DPH	EQU	12H			;INX数据指针高4位

TCTL1	EQU	13H			;Timer1 控制寄存器

ADCCTL	EQU	14H			;ADC 使能与参考电压
ADCCFG	EQU	15H			;ADC configuration
ADCPORT	EQU	16H			;ADC PORT CONFIGURATION
ADCCHN	EQU	17H			;ADC channel selection

PACR	EQU	18H			;PortA 控制寄存器
PBCR	EQU	19H			;PortB 控制寄存器
PCCR	EQU	1AH			;PortC 控制寄存器
PDCR	EQU	1BH			;PortD 控制寄存器
PECR	EQU	1CH			;PortE 控制寄存器

PWMC0	EQU	20H			;PWM0 控制寄存器
PWMC1	EQU	21H			;PWM1 控制寄存器

PWMP00	EQU	22H			;PWM0 周期控制寄存器低4位
PWMP01	EQU	23H			;PWM0 周期控制寄存器高4位

PWMD00	EQU	24H			;PWM0 占空比控制寄存器低2位
PWMD01	EQU	25H			;PWM0 占空比控制寄存器中4位
PWMD02	EQU	26H			;PWM0 占空比控制寄存器高4位

PWMP10	EQU	27H			;PWM1 周期控制寄存器低4位
PWMP11	EQU	28H			;PWM1 周期控制寄存器高4位

PWMD10	EQU	29H			;PWM1 占空比控制寄存器低2位
PWMD11	EQU	2AH			;PWM1 占空比控制寄存器中4位
PWMD12	EQU	2BH			;PWM1 占空比控制寄存器高4位


AD_RET0	EQU	2DH			;ADC 转换结果低2位
AD_RET1	EQU	2EH			;ADC 转换结果中4位
AD_RET2	EQU	2FH			;ADC 转换结果高4位


PPACR 	EQU 	388H 			;PORTA 口上拉电阻控制寄存器 
PPBCR 	EQU 	389H 			;PORTB 口上拉电阻控制寄存器 
PPCCR 	EQU 	38AH 			;PORTC 口上拉电阻控制寄存器 
PPDCR 	EQU 	38BH 			;PORTD 口上拉电阻控制寄存器 
PPECR 	EQU 	38CH 			;PORTE 口上拉电阻控制寄存器 

;*****************************************************
;用户自定义寄存器 ($030 ~ $0EF)
;*****************************************************
AC_BAK 	EQU 	30H 			;AC 值备份寄存器

SIMULATE_STA	EQU	31H		;bit0 = 1, 进入"模拟停电"状态
					;bit1 = 1, 进入"手动月检"状态
					;bit2 = 1, 进入"手动年检"状态
					;bit3 = 1, 进入"关断应急输出"状态

NORMAL_STA	EQU	32H		;bit0 = 1, 当前处于"主电"状态
ABNORMAL_STA	EQU	33H		;bit0 = 1, 当前处于"停电"或"模拟停电"状态
					;bit1 = 1, 当前处于"月检"或"手动月检"状态
					;bit2 = 1, 当前处于"年检"或"手动年检"状态
					
;--------------------------------------
; 用于TIMER 定时
F_BUTTON	EQU	35H		;供按键检测使用。bit0=1, 496ms 到;
F_TIME 		EQU 	36H 		;bit0=1, 1s 到; bit1=1, 1月到; bit2=1, 1年到。

CNT0 		EQU 	37H 		;CNT1,CNT0组成的8BIT数据达到125时，即Timer0产生125次中断后，表示1S计时已到
CNT1 		EQU 	38H 		;所以，CNT1=07H, CNT0=0DH

SEC_CNT0	EQU	39H		;SEC_CNT0/1/2 以秒为单位计时
SEC_CNT1	EQU	3AH		;当数值达到1小时，即3600(E10H)秒时，向HOUR_CNT0/1进位，自身清零。
SEC_CNT2	EQU	3BH

HOUR_CNT0	EQU	3CH		;HOUR_CNT0/1 以小时为单位计时
HOUR_CNT1	EQU	3DH		;当数值达到1月时，即744(2EBH)小时时，向MONTH_CNT0/1进位，同时置F_TIME.1，自身清零。
HOUR_CNT2	EQU	3EH		

MONTH_CNT	EQU	3FH		;MONTH_CNT0/1 以月为单位计时
					;当数值达到1年时，即12(0CH)月时，，同时置F_TIME.2，自身清零。

DET0_CT		EQU	40H		;ADC 通道0 转换结果个数
DET1_CT		EQU	41H		;ADC 通道1 转换结果个数
DET6_CT		EQU	42H		;ADC 通道6 转换结果个数

;------------------------------------------------------------------
CHN0_RET0_BAK0	EQU	43H		;ADC CHN0 转换结果低2位备份
CHN0_RET1_BAK0	EQU	44H		;ADC CHN0 转换结果中4位备份
CHN0_RET2_BAK0	EQU	45H		;ADC CHN0 转换结果高4位备份

CHN0_RET0_BAK1	EQU	46H		;ADC CHN0 转换结果低2位备份
CHN0_RET1_BAK1	EQU	47H		;ADC CHN0 转换结果中4位备份
CHN0_RET2_BAK1	EQU	48H		;ADC CHN0 转换结果高4位备份

CHN0_RET0_BAK2	EQU	43H		;ADC CHN0 转换结果低2位备份
CHN0_RET1_BAK2	EQU	44H		;ADC CHN0 转换结果中4位备份
CHN0_RET2_BAK2	EQU	45H		;ADC CHN0 转换结果高4位备份

CHN0_RET0_BAK3	EQU	46H		;ADC CHN0 转换结果低2位备份
CHN0_RET1_BAK3	EQU	47H		;ADC CHN0 转换结果中4位备份
CHN0_RET2_BAK3	EQU	48H		;ADC CHN0 转换结果高4位备份

;------------------------------------------------------------------
CHN1_RET0_BAK0	EQU	49H		;ADC CHN1 转换结果低2位备份
CHN1_RET1_BAK0	EQU	4AH		;ADC CHN1 转换结果中4位备份
CHN1_RET2_BAK0	EQU	4BH		;ADC CHN1 转换结果高4位备份

CHN1_RET0_BAK1	EQU	4CH		;ADC CHN1 转换结果低2位备份
CHN1_RET1_BAK1	EQU	4DH		;ADC CHN1 转换结果中4位备份
CHN1_RET2_BAK1	EQU	4EH		;ADC CHN1 转换结果高4位备份

CHN1_RET0_BAK2	EQU	4FH		;ADC CHN1 转换结果低2位备份
CHN1_RET1_BAK2	EQU	50H		;ADC CHN1 转换结果中4位备份
CHN1_RET2_BAK2	EQU	51H		;ADC CHN1 转换结果高4位备份

CHN1_RET0_BAK3	EQU	52H		;ADC CHN1 转换结果低2位备份
CHN1_RET1_BAK3	EQU	53H		;ADC CHN1 转换结果中4位备份
CHN1_RET2_BAK3	EQU	54H		;ADC CHN1 转换结果高4位备份

;------------------------------------------------------------------
CHN6_RET0_BAK0	EQU	55H		;ADC CHN6 转换结果低2位备份
CHN6_RET1_BAK0	EQU	56H		;ADC CHN6 转换结果中4位备份
CHN6_RET2_BAK0	EQU	57H		;ADC CHN6 转换结果高4位备份

CHN6_RET0_BAK1	EQU	58H		;ADC CHN6 转换结果低2位备份
CHN6_RET1_BAK1	EQU	59H		;ADC CHN6 转换结果中4位备份
CHN6_RET2_BAK1	EQU	5AH		;ADC CHN6 转换结果高4位备份

CHN6_RET0_BAK2	EQU	5BH		;ADC CHN6 转换结果低2位备份
CHN6_RET1_BAK2	EQU	5CH		;ADC CHN6 转换结果中4位备份
CHN6_RET2_BAK2	EQU	5DH		;ADC CHN6 转换结果高4位备份

CHN6_RET0_BAK3	EQU	5EH		;ADC CHN6 转换结果低2位备份
CHN6_RET1_BAK3	EQU	5FH		;ADC CHN6 转换结果中4位备份
CHN6_RET2_BAK3	EQU	60H		;ADC CHN6 转换结果高4位备份

;按键相关寄存器
DELAY_TIMER2	EQU	61H		;延时子程序使用
DELAY_TIMER1	EQU	62H		;延时子程序使用
DELAY_TIMER0	EQU	63H		;延时子程序使用
CLEAR_AC 	EQU 	64H 		;清除累加器A 值用寄存器
TEMP 		EQU 	65H 		;临时寄存器

CNT0_496MS	EQU	66H		;用于定时496MS
CNT1_496MS	EQU	67H

BTN_PRE_STA	EQU	68H		;bit0储存上一次按键状态,0:按下,1:未按下
BTN_PRESS_CNT	EQU	69H		;按键按下时长，单位为496ms

;*****************************************************
;程序
;*****************************************************
	ORG	0000H

	;中断向量表
	JMP	RESET			;RESET ISP
	JMP	ADC_ISP			;ADC INTERRUPT ISP
	JMP	TIMER0_ISP		;TIMER0 ISP
	RTNI				;TIMER1 ISP
	RTNI				;PORTB/D ISP

;*****************************************************
;Timer0 中断服务程序
;*****************************************************
TIMER0_ISP:
	STA 	AC_BAK,		00H 	;备份AC 值
	ANDIM 	IRQ,		1011B 	;清TIMER0 中断请求标志
	
J_496MS:
	;--------------------------------------------------------------------------
	SBIM 	CNT0_496MS,	01H	;每次Timer0中断产生后，将CNT0_496MS减1
	LDI	TBR,		00H	;将累加器A 清0
	SBCM	CNT1_496MS		;每次CNT0-1产生借位时，将CNT1_496MS减1
	BC	J1MS			;如果未产生借位，则表示200MS还未计满

	LDI 	CNT0_496MS,	0DH 	;重置496ms 计数器,496 = 8 * 62
	LDI 	CNT1_496MS,	03H 	;重置496ms 计数器
	
	ORIM 	F_BUTTON,	0001B 	;设置 "496ms 到"标志

J1MS:	
	;--------------------------------------------------------------------------
	SBIM 	CNT0,		01H	;每次Timer0中断产生后，将CNT0减1
	BC 	TIMER0_ISP_END 		;CNT0仍大于0, 则结束ISP
	SBIM	CNT1,		01H	;每次CNT0-1产生借位时，将CNT1减1
	BC	TIMER0_ISP_END
	
	LDI 	CNT0,		0CH 	;重置1s 计数器
	LDI 	CNT1,		07H 	;重置1s 计数器
	
	ORIM 	F_TIME,		0001B 	;设置 "1s 到"标志
	;--------------------------------------------------------------------------
	

	;--------------------------------------------------------------------------
	SBIM	SEC_CNT0,	01H	;SEC_CNT0 每秒减1
	BC	TIMER0_ISP_END		;SEC_CNT0仍大于0，则结束ISP
	SBIM	SEC_CNT1,	01H	;每次SEC_CNT0-1产生借位时，将SEC_CNT1减1
	BC	TIMER0_ISP_END		;SEC_CNT1仍大于0，则结束ISP
	SBIM	SEC_CNT2,	01H	;每次SEC_CNT1-1产生借位时，将SEC_CNT2减1
	BC	TIMER0_ISP_END		;SEC_CNT2减1产生借位时，则表示1小时计时已到
	
	LDI 	SEC_CNT0,	0FH 	;重置SEC_CNT0/1/2 为E10H-1(3600-1)
	LDI 	SEC_CNT1,	00H
	LDI 	SEC_CNT2,	0EH
	;--------------------------------------------------------------------------
	
	
	;--------------------------------------------------------------------------
	SBIM 	HOUR_CNT0,	01H	;HOUR_CNT0 每小时减1
	BC 	TIMER0_ISP_END 		;HOUR_CNT0 仍大于0, 则结束ISP
	SBIM	HOUR_CNT1,	01H	;每次 HOUR_CNT0 产生借位时，将 HOUR_CNT1 减1
	BC	TIMER0_ISP_END		;HOUR_CNT1 减1产生借位时，则表示1月计时已到
	
	LDI 	HOUR_CNT0,	07H 	;重置HOUR_CNT0/1/2 为2E8H-1(744-1)
	LDI 	HOUR_CNT1,	0EH
	LDI	HOUR_CNT2,	02H
	
	ORIM 	F_TIME,		0010B 	;设置 "1月到" 标志
	;--------------------------------------------------------------------------
	
	
	;--------------------------------------------------------------------------
	SBIM 	MONTH_CNT,	01H	;MONTH_CNT 每月减1
	BC 	TIMER0_ISP_END		;MONTH_CNT 减1产生借位时，则表示1年计时已到
	
	LDI 	MONTH_CNT,	0BH 	;重置MONTH_CNT 为0CH-1(12-1)
	
	ORIM 	F_TIME,		0100B 	;设置 "1年到" 标志
	;--------------------------------------------------------------------------

TIMER0_ISP_END:
	LDI 	IE,		1100B 	;打开ADC,Timer0 中断
	LDA 	AC_BAK,		00H 	;取出AC 值
	RTNI	
	
;*****************************************************
;ADC 中断服务程序
;*****************************************************	
ADC_ISP:
	STA 	AC_BAK,		00H 	;备份AC 值
	ANDIM 	IRQ,		0111B 	;清ADC 中断请求标志
	
	LDA	ADCCHN			
	BAZ	CHN0_VOL_1		;此次为通道0 转换结果
	SBI	ADCCHN,		01H
	BAZ	CHN1_VOL_1		;此次为通道1 转换结果	
	SBI	ADCCHN,		06H
	BAZ	CHN6_VOL_1		;此次为通道6 转换结果
	JMP	ADC_ISP_END		;正常情况下不应执行此语句
	
;转存通道0 转换结果
;----------------------------------------------------------------
CHN0_VOL_1:
	ADIM 	DET0_CT,	01H 	;次数加一
	
	SBI 	DET0_CT,	04H
	BAZ 	CHN0_VOL_14		;第4个转换结果
	SBI 	DET0_CT,	03H
	BAZ 	CHN0_VOL_13		;第3个转换结果
	SBI 	DET0_CT,	02H
	BAZ 	CHN0_VOL_12		;第2个转换结果

CHN0_VOL_11:
	LDA 	AD_RET0,	00H 	;保存第一次A/D 转换结果
	STA 	CHN0_RET0_BAK0
	LDA 	AD_RET1,	00H
	STA 	CHN0_RET1_BAK0
	LDA 	AD_RET2,	00H
	STA 	CHN0_RET2_BAK0
	JMP 	NEXT_CHN	

CHN0_VOL_12:
	LDA 	AD_RET0,	00H 	;保存第二次A/D 转换结果
	STA 	CHN0_RET0_BAK1
	LDA 	AD_RET1,	00H
	STA 	CHN0_RET1_BAK1
	LDA 	AD_RET2,	00H
	STA 	CHN0_RET2_BAK1
	JMP 	NEXT_CHN
	
CHN0_VOL_13:
	LDA 	AD_RET0,	00H 	;保存第三次A/D 转换结果
	STA 	CHN0_RET0_BAK2
	LDA 	AD_RET1,	00H
	STA 	CHN0_RET1_BAK2
	LDA 	AD_RET2,	00H
	STA 	CHN0_RET2_BAK2
	JMP 	NEXT_CHN	
	
CHN0_VOL_14:
	LDA 	AD_RET0,	00H 	;保存第四次A/D 转换结果
	STA 	CHN0_RET0_BAK3
	LDA 	AD_RET1,	00H
	STA 	CHN0_RET1_BAK3
	LDA 	AD_RET2,	00H
	STA 	CHN0_RET2_BAK3
	JMP 	NEXT_CHN	
;----------------------------------------------------------------

;转存通道1 转换结果
;----------------------------------------------------------------
CHN1_VOL_1:
	ADIM 	DET1_CT,	01H 	;次数加一
	
	SBI 	DET1_CT,	04H
	BAZ 	CHN1_VOL_14		;第4个转换结果
	SBI 	DET1_CT,	03H
	BAZ 	CHN1_VOL_13		;第3个转换结果
	SBI 	DET1_CT,	02H
	BAZ 	CHN1_VOL_12		;第2个转换结果

CHN1_VOL_11:
	LDA 	AD_RET0,	00H 	;保存第一次A/D 转换结果
	STA 	CHN1_RET0_BAK0
	LDA 	AD_RET1,	00H
	STA 	CHN1_RET1_BAK0
	LDA 	AD_RET2,	00H
	STA 	CHN1_RET2_BAK0
	JMP 	NEXT_CHN	

CHN1_VOL_12:
	LDA 	AD_RET0,	00H 	;保存第二次A/D 转换结果
	STA 	CHN1_RET0_BAK1
	LDA 	AD_RET1,	00H
	STA 	CHN1_RET1_BAK1
	LDA 	AD_RET2,	00H
	STA 	CHN1_RET2_BAK1
	JMP 	NEXT_CHN
	
CHN1_VOL_13:
	LDA 	AD_RET0,	00H 	;保存第三次A/D 转换结果
	STA 	CHN1_RET0_BAK2
	LDA 	AD_RET1,	00H
	STA 	CHN1_RET1_BAK2
	LDA 	AD_RET2,	00H
	STA 	CHN1_RET2_BAK2
	JMP 	NEXT_CHN	
	
CHN1_VOL_14:
	LDA 	AD_RET0,	00H 	;保存第四次A/D 转换结果
	STA 	CHN1_RET0_BAK3
	LDA 	AD_RET1,	00H
	STA 	CHN1_RET1_BAK3
	LDA 	AD_RET2,	00H
	STA 	CHN1_RET2_BAK3
	JMP 	NEXT_CHN	
;----------------------------------------------------------------
	
;转存通道6 转换结果
;----------------------------------------------------------------
CHN6_VOL_1:
	ADIM 	DET6_CT,	01H 	;次数加一
	
	SBI 	DET6_CT,	04H
	BAZ 	CHN6_VOL_14		;第4个转换结果
	SBI 	DET6_CT,	03H
	BAZ 	CHN6_VOL_13		;第3个转换结果
	SBI 	DET6_CT,	02H
	BAZ 	CHN6_VOL_12		;第2个转换结果

CHN6_VOL_11:
	LDA 	AD_RET0,	00H 	;保存第一次A/D 转换结果
	STA 	CHN6_RET0_BAK0
	LDA 	AD_RET1,	00H
	STA 	CHN6_RET1_BAK0
	LDA 	AD_RET2,	00H
	STA 	CHN6_RET2_BAK0
	JMP 	NEXT_CHN	

CHN6_VOL_12:
	LDA 	AD_RET0,	00H 	;保存第二次A/D 转换结果
	STA 	CHN6_RET0_BAK1
	LDA 	AD_RET1,	00H
	STA 	CHN6_RET1_BAK1
	LDA 	AD_RET2,	00H
	STA 	CHN6_RET2_BAK1
	JMP 	NEXT_CHN
	
CHN6_VOL_13:
	LDA 	AD_RET0,	00H 	;保存第三次A/D 转换结果
	STA 	CHN6_RET0_BAK2
	LDA 	AD_RET1,	00H
	STA 	CHN6_RET1_BAK2
	LDA 	AD_RET2,	00H
	STA 	CHN6_RET2_BAK2
	JMP 	NEXT_CHN	
	
CHN6_VOL_14:
	LDA 	AD_RET0,	00H 	;保存第四次A/D 转换结果
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
	BAZ 	NEXT_CHN6 		;第2 个通道AN1，将设定下一个通道为AN6
	ADIM 	ADCCHN,		01H 	;选择下一个通道
	BA2	NEXT_CHN0		;将下一通道设定为AN0
	JMP 	ADC_ISP_END

NEXT_CHN0:
	LDI	ADCCHN,		00H	;设定为第0 个通道AN0
	JMP 	ADC_ISP_END
	
NEXT_CHN6:
	LDI 	ADCCHN,		06H 	;设定为第7 个通道AN6	
;----------------------------------------------------------------	

	
ADC_ISP_END:
	ORIM 	ADCCFG,		1000B 	;启动A/D 转换

	LDI 	IE,		1100B 	;打开ADC,Timer0 中断
	LDA 	AC_BAK,		00H 	;取出AC 值
	RTNI	
	
	
;*****************************************************
; 主程序
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
;清用户寄存器($030 ~ $0EF)
;-------------------------------------------------
POWER_RESET:
	LDI 	DPL,		00H
	LDI 	DPM,		03H
	LDI 	DPH,		00H	;从$30 开始
	
POWER_RESET_1:
	LDI 	INX,		00H	;向DPH,DPM,DPL组成的地址处写0
	ADIM 	DPL,		01H
	LDI 	TBR,		00H	;将累加器A 清0
	ADCM 	DPM,		00H
	BA3 	POWER_RESET_2
	JMP 	POWER_RESET_3

POWER_RESET_2:
	ADIM 	DPH,		01H
	
POWER_RESET_3:
	SBI 	DPH,		01H	;到$EF 结束，即在地址001 111 000B时停止
	BNZ 	POWER_RESET_1
	SBI 	DPM,		07H
	BNZ 	POWER_RESET_1

;----------------------------------------------
;初始化系统寄存器
;-----------------------------------------------
SYSTEM_INITIAL:
	;TIMER0 初始化
	;
	;  fosc=4M, fsys=4M/4=1M
	;
	;  fsys=1M                 31250Hz                   125Hz
	;           -------------            -------------
	;  -------->| Prescaler |----------->|  Counter  |----------->
	;           -------------            -------------
	;               (32)                     (250)
	
	LDI 	TM0,		03H 	;设置TIMER0 预分频为/32
	LDI 	TL0,		06H
	LDI 	TH0,		00H 	;设置中断时间为8ms
	LDI 	CNT0,		0DH 	;定时1s
	LDI 	CNT1,		07H 	;定时1s
	
	LDI	SEC_CNT0,	0FH	;SEC_CNT0/1/2 初始化为E10H - 1，即3600 -1
	LDI	SEC_CNT1,	00H
	LDI	SEC_CNT2,	0EH

	LDI	HOUR_CNT0,	07H	;HOUR_CNT0/1/2 初始化为2E8H - 1，即744 - 1
	LDI	HOUR_CNT1,	0EH
	LDI	HOUR_CNT2,	02H

	LDI	MONTH_CNT,	0BH	;MONTH_CNT 初始化为12 -1 个月
		

	;I/O 口初始化
	LDI 	PORTA,		00H
	LDI 	PACR,		00H 	;设置PortA 作为输入口
	
	LDI 	PORTB,		00H
	LDI 	PBCR,		00H 	;设置PortB 作为输入口

	LDI	PORTC,		00H
	LDI	PCCR,		0FH	;设置PortC.0/PortC.1/PortC.2/PortC.3 作为输出
	
	LDI 	PDCR,		1110B 	;设置PD.0为输入，PD.3为输出
	LDI	TBR,		0001B	;打开PD.0 内部上拉电阻
	STA	PPDCR

	LDI 	PORTE,		00H
	LDI 	PECR,		0FH 	;设置PortE 作为输出口

	;ADC初始化
	LDI 	PACR,		0000B 	;设置PortA0/1 作为输入口
	LDI 	PBCR,		0000B 	;设置PortB2/3 作为输入口
	LDI 	ADCCTL,		0001B 	;选择内部参考电压VDD，使能ADC
	LDI 	ADCCFG,		0100B 	;A/D 时钟tAD=8tOSC, A/D 转换时间= 204tAD
	LDI	ADCPORT,	0111B	;使用AN0 ~ AN6
	LDI	ADCCHN,		00H	;选择AN0
	ORIM 	ADCCFG,		1000B 	;启动A/D 转换

	;PWM初始化
	LDI	PWMC0,		0001B	;PWM0 Clock = tosc = 4M
	LDI	PWMP00,		0DH	;周期为125个PWM0 Clock
	LDI	PWMP01,		07H	
	LDI	PWMD00,		00H	;无微调
	LDI	PWMD01,		0EH	;占空比为50%
	LDI	PWMD02,		03H	

	LDI	PWMC1,		0000B	;PWM0 Clock = tosc = 4M
	LDI	PWMP10,		0DH	;周期为125个PWM0 Clock
	LDI	PWMP11,		07H	
	LDI	PWMD10,		00H	;无微调
	LDI	PWMD11,		0EH	;占空比为50%
	LDI	PWMD12,		03H


	;按键相关
	LDI	CNT0_496MS,	0DH	;初始化496ms 计数器,496 = 8 * 62
	LDI	CNT0_496MS,	03H	;初始化496ms 计数器
	LDI	BTN_PRE_STA,	01H	;初始化上一次没有按键

	;状态相关
	LDI	NORMAL_STA,	01H	;初始化为"主电"
	LDI	ABNORMAL_STA,	00H	;无任何异常状态
	
;--------------------------------------
MAIN_PRE:
	LDI 	IRQ,		00H
	LDI 	IE,		1100B 	;打开ADC,Timer0 中断

MAIN:
	CALL	KEY_CHECK_PROCESS	;按键扫描，输出"模拟停电","手动月检","手动年检","关断应急输出"等标志位

CHECK_PWR_CUT:
	ADI	SIMULATE_STA,	0001B	;检查"模拟停电"标志位
	BA0	CHECK_MONTH_CHK		
	CALL	SIM_PWR_CUT

CHECK_MONTH_CHK:
	ADI	SIMULATE_STA,	0010B	;检查"手动月检"标志位
	BA0	CHECK_YEAR_CHK
	CALL	SIM_MONTH_CHK

CHECK_YEAR_CHK:
	ADI	SIMULATE_STA,	0100B	;检查"手动年检"标志位
	BA0	CHECK_DIS_PWR_OUT
	CALL	SIM_YEAR_CHK

CHECK_DIS_PWR_OUT
	ADI	SIMULATE_STA,	1000B	;检查"关断应急输出"标志位
	;BA0	XXXXXXXXXXXX
	CALL	DIS_PWR_OUT
	

	;ADI 	F_TIME,		0001B
	;BA0 	HALTMODE 		;未到1s,跳转
	
	ADI 	F_TIME,		0001B
	BA0	MAIN			;未到1s,跳转
	
	ANDIM 	F_TIME,		1110B 	;清 "1s 到"标志
	EORIM	PORTC,		0001B	;翻转PC.0	
	
	
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
; 模拟停电处理部分
;***********************************************************
SIM_PWR_CUT:
	NOP
	RTNI

;***********************************************************
; 手动月检处理部分
;***********************************************************
SIM_MONTH_CHK:

	RTNI

;***********************************************************
; 手动年检处理部分
;***********************************************************
SIM_YEAR_CHK:

	RTNI

;***********************************************************
; 关断应急输出
;***********************************************************
DIS_PWR_OUT:

	RTNI
	

;***********************************************************
; 按键扫描及处理部分
;***********************************************************
KEY_CHECK_PROCESS:
	LDI 	PDCR,		1110B 	;设置PD.0 为输入，PD.3 为输出
	
KEY_CHECK:
	ADI	F_BUTTON,	0001B	;检查496MS标志位
	BA0	NOT_CHECK

	
	CALL 	DELAY_5MS 		;消除按键抖动
	
	LDA 	PORTD,		00H 	;读取PD 口状态
	STA 	TEMP,		00H 	;把PD 口状态存到TEMP 寄存器中
	CALL 	DELAY_5MS 		;消除按键抖动
	
	LDA 	PORTD,		00H 	;读取PD 口状态
	SUB 	TEMP,		00H 	;比较读取PD.0 口状态值，不相等则错误
	BA0 	KEY_ERROR
	CALL 	DELAY_5MS 		;消除按键抖动
	
	LDA 	PORTD,		00H 	;读取PD 口状态
	SUB 	TEMP,		00H 	;比较读取PD.0 口状态值，不相等则错误
	BA0 	KEY_ERROR
	
	LDA 	TEMP		 	;将TEMP 中的数据储存至累加器A 中
	BA0	NO_KEY_PRESSED		;没有检测到按键
	
	JMP	KEY_PRESSED		;检测到有按键按下

NO_KEY_PRESSED:
	LDA	BTN_PRE_STA		;将上一次按键状态载入累加器A 中
	ADD	TEMP			;TEMP + A -> A
	BA0	KEY_RELEASED		;上一次按下，本次未按下
	
	JMP 	KEY_CHECK_PROCESS_OVER	;上一次未按下，本次也未按下

KEY_RELEASED:

	;根据按键被按下的时长T，决定进入以下何种状态:
	; T < 3s      -- "模拟停电"
	; 3s < T < 5s -- "手动月检"
	; 5s < T < 7s -- "手动年检"
	; T > 7s      -- "关断应急输出"
	SBI	BTN_PRESS_CNT,	06H	;
	BNC	LESS_3S			;按键持续时长小于3S, 6.04 * 496ms = 3s
	SBI	BTN_PRESS_CNT,	0AH	;
	BNC	LESS_5S			;按键持续时长小于5S, 10.08 * 496ms = 5s
	SBI	BTN_PRESS_CNT,	0EH	;
	BNC	LESS_7S			;按键持续时长小于7S, 14.11 * 496ms = 7s

MORE_7S:
	ORIM	SIMULATE_STA,	0001B	;进入"关断应急输出"状态
	JMP	RELEASED_OVER	
LESS_3S:
	ANDIM	SIMULATE_STA,	1110B	;进入退出"模拟停电"状态
	JMP	RELEASED_OVER
LESS_5S:
	ORIM	SIMULATE_STA,	0010B	;进入"手动月检"状态
	JMP	RELEASED_OVER
LESS_7S:
	ORIM	SIMULATE_STA,	0010B	;进入"手动年检"状态
	JMP	RELEASED_OVER
	
RELEASED_OVER:
	LDI	BTN_PRESS_CNT,	00H	;将BTN_PRESS_CNT 清0
	JMP	KEY_CHECK_PROCESS_OVER


KEY_PRESSED:
	SBI	BTN_PRESS_CNT,	06H	
	BC	MORE_3S			;按键持续时长大于3S, 6.04 * 496ms = 3s
	ORIM	SIMULATE_STA,	0001B	;按键持续时长小于3S, 进入"模拟停电"状态
	JMP	CNT_ADD_1
	
MORE_3S:
	ANDIM	SIMULATE_STA,	1110B	;按键持续时长大于3S, 退出"模拟停电"状态

CNT_ADD_1:	
	SBI	BTN_PRESS_CNT,  0FH	;比较BTN_PRESS_CNT 与 0x0F 的大小
	BC	KEY_CHECK_PROCESS_OVER	;如果BTN_PRESS_CNT已经累加至0x0F，则不再累加
	ADIM	BTN_PRESS_CNT,	01H	;496MS计时次数加1
	JMP 	KEY_CHECK_PROCESS_OVER
	
KEY_ERROR: 				;错误键值处理
	LDI	BTN_PRE_STA,	0001H
	LDI	BTN_PRESS_CNT,	00H

	JMP 	KEY_CHECK_PROCESS_OVER
	
KEY_CHECK_PROCESS_OVER: 		;按键扫描及处理结束，返回
	ANDIM	TEMP,		0001H	;
	STA	BTN_PRE_STA		;TEMP -> BTN_PRE_STA
	
	ANDIM	F_BUTTON,	1110B	;清496MS标志位
	
NOT_CHECK:	
	RTNI
;************************************************************
; 延时5 毫秒子程序
;************************************************************
DELAY_5MS:
	LDI 	DELAY_TIMER2,	03H 	;设置初始值
	LDI 	DELAY_TIMER1,	03H
	LDI 	DELAY_TIMER0,	0CH

DELAY_5MS_LOOP:
	SBIM 	DELAY_TIMER0,	01H 	;每次减1
	LDI 	CLEAR_AC,	00H
	SBCM 	DELAY_TIMER1,	00H
	LDI 	CLEAR_AC,	00H
	SBCM 	DELAY_TIMER2,	00H
	BC 	DELAY_5MS_LOOP
	
	RTNI


	END



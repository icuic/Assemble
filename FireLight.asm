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
;Bank0
;------------------------------------------------------------------
AC_BAK 		EQU 	30H 		;AC 值备份寄存器

SIMULATE_STA	EQU	31H		;bit0 = 1, 已进入"模拟停电"状态, bit0 = 0, 已由"模拟停电"状态退出
					;bit1 = 1, 进入"手动月检"状态
					;bit2 = 1, 进入"手动年检"状态
					;bit3 = 1, 进入"关断应急输出"状态

NORMAL_STA	EQU	32H		;bit0 = 1, 当前处于"主电"状态
ABNORMAL_STA	EQU	33H		;bit0 = 1, 当前处于"停电"或"模拟停电"状态
					;bit1 = 1, 当前处于"月检"或"手动月检"状态
					;bit2 = 1, 当前处于"年检"或"手动年检"状态

;--------------------------------------
; 用于TIMER 定时
F_496MS_1S	EQU	35H		;bit0 = 1, 496ms 到，供按键检测使用。
					;bit1 = 1, 1s 到，用于计时应急时长。

F_TIME 		EQU 	36H 		;bit0=1, 1s 到; bit1=1, 1月到; bit2=1, 1年到。

CNT0_8MS 	EQU 	37H	 	;CNT1_8MS, CNT0_8MS组成的8BIT数据达到125时，即Timer0产生125次中断后，表示1S计时已到
CNT1_8MS 	EQU 	38H 		;所以，初始化CNT1_8MS=07H, CNT0_8MS=0DH

SEC_CNT0	EQU	39H		;SEC_CNT0/1/2 以秒为单位计时
SEC_CNT1	EQU	3AH		;当数值达到1小时，即3600(E10H)秒时，向HOUR_CNT0/1进位，自身清零。
SEC_CNT2	EQU	3BH

HOUR_CNT0	EQU	3CH		;HOUR_CNT0/1 以小时为单位计时
HOUR_CNT1	EQU	3DH		;当数值达到1月时，即744(2EBH)小时时，向MONTH_CNT0/1进位，同时置F_TIME.1，自身清零。
HOUR_CNT2	EQU	3EH		

MONTH_CNT	EQU	3FH		;MONTH_CNT0/1 以月为单位计时
					;当数值达到1年时，即12(0CH)月时，，同时置F_TIME.2，自身清零。

TEMP_SUM_CY	EQU	40H		;AD子程序参数临时变量
FLAG_OCCUPIED	EQU	41H		;bit0/1/2/3 = 1时分别表示CHN0、1、6、7的转换结果(CHN0_FINAL_RET1等)正被前台使用,
					;此时ADC中断不能修改这些数据。	

FLAG_TYPE	EQU	42H		;bit0 = 1表示已经完成灯具类型选择(PORTB.3/AN7),此位为1后不再需要对AN7进行AD采样


CMP_MIN_PWR0	EQU	43H		;上电自检时，灯具电源最小电压值.(1.396V -> 0x23B ->(丢弃最低2位) 0x8E)
CMP_MIN_PWR1	EQU	44H		;

CMP_TYPE00	EQU	45H		;灯具类型门限0
CMP_TYPE01	EQU	46H		;

CMP_TYPE10	EQU	47H		;灯具类型门限1
CMP_TYPE11	EQU	48H		;

CMP_TYPE20	EQU	49H		;灯具类型门限2
CMP_TYPE21	EQU	4AH		;

LIGHT_TYPE	EQU	4BH		;灯具类型
					;=0, 锂电池，常亮型
					;=1, 锂电池，常灭型
					;=2, 镍镉电池，常亮型
					;=3, 镍镉电池，常灭型

CMP_SUPPLY0	EQU	4CH		;检测到电源电压小于此数值时，开始应急放电.(1.115V -> 0x5B)
CMP_SUPPLY1	EQU	4DH

;XXXXXX		EQU	4EH
					
CNT0_EMERGENCY	EQU	4FH		;对应急时长计时，单位s
CNT1_EMERGENCY	EQU	50H
CNT2_EMERGENCY	EQU	51H

CMP_EXIT_EMER0	EQU	52H		;检测到电池电压小于此数值时，应该关闭应急放电功能
CMP_EXIT_EMER1	EQU	53H

CMP_BAT_OPEN0	EQU	54H		;检测到电池电压大于此数值时，视为电池充电回路开路
CMP_BAT_OPEN1	EQU	55H		;检测到电池电压大于此数值时，视为电池充电回路开路

CMP_BAT_FULL0	EQU	56H		;检测到电池电压大于此数值时，视为电池已充满
CMP_BAT_FULL1	EQU	57H		;检测到电池电压大于此数值时，视为电池已充满

CMP_BAT_CHARGE0	EQU	58H		;检测到电池电压小于此数值时，视为电池已充满
CMP_BAT_CHARGE1	EQU	59H		;检测到电池电压小于此数值时，视为电池已充满



BAT_STATE	EQU	58H		;bit0 = 0, 表示充电回路未开路；bit0 = 1, 表示充电回路开路
					;bit1 = 0, 表示电池未充满；bit1 = 1, 表示电池已充满
					;bit2 = 0, 表示电池还不需要充电；bit2 = 0, 表示电池需要充电
					;bit3 = 1, 表示电池电压过低，不能再继续应急放电了


CMP_LIGHT0	EQU	59H		;供光源检测使用
CMP_LIGHT1	EQU	5AH

LIGHT_STATE	EQU	5BH		;bit0 = 1, 表示光源故障


ALARM_STATE	EQU	5CH		;bit0 = 1, 表示电池故障(开路或短路)
					;bit1 = 1, 表示光源故障(开路或短路)
					;bit2 = 1, 表示自检放电时间不足


CNT_LED_YELLOW	EQU	5FH		;计数器，供翻转黄灯输出使用，计时单位为328MS


FLAG_SIMU_EMER	EQU	60H		;bit0 = 1, 表示在"模拟停电"状态下已经打开应急功能
					;bit1 = 1表示1s已到

;按键相关寄存器
DELAY_TIMER2	EQU	71H		;延时子程序使用
DELAY_TIMER1	EQU	72H		;延时子程序使用
DELAY_TIMER0	EQU	73H		;延时子程序使用
CLEAR_AC 	EQU 	74H 		;清除累加器A 值用寄存器
TEMP 		EQU 	75H 		;临时寄存器

CNT0_496MS	EQU	76H		;用于定时496MS
CNT1_496MS	EQU	77H

BTN_PRE_STA	EQU	78H		;bit0储存上一次按键状态,0:按下,1:未按下
BTN_PRESS_CNT	EQU	79H		;按键按下时长，单位为496ms

CNT0_328MS	EQU	7AH		;用于定时328MS,供翻转LED用
CNT1_328MS	EQU	7BH
F_328MS		EQU	7CH		;每328ms将bit0 = 1

CMP_RESUME0	EQU	4DH		;检测到电源电压大于此数值时，表示市电供电已恢复，应关闭应急.(1.296V -> 0x84)
CMP_RESUME1	EQU	4EH

;Bank1(以下寄存器真实地址应加上80H)
;------------------------------------------------------------------
CHN0_RET0_BAK0	EQU	00H		;ADC CHN0 转换结果低2位备份
CHN0_RET1_BAK0	EQU	01H		;ADC CHN0 转换结果中4位备份
CHN0_RET2_BAK0	EQU	02H		;ADC CHN0 转换结果高4位备份

CHN0_RET0_BAK1	EQU	03H		;ADC CHN0 转换结果低2位备份
CHN0_RET1_BAK1	EQU	04H		;ADC CHN0 转换结果中4位备份
CHN0_RET2_BAK1	EQU	05H		;ADC CHN0 转换结果高4位备份

CHN0_RET0_BAK2	EQU	06H		;ADC CHN0 转换结果低2位备份
CHN0_RET1_BAK2	EQU	07H		;ADC CHN0 转换结果中4位备份
CHN0_RET2_BAK2	EQU	08H		;ADC CHN0 转换结果高4位备份

CHN0_RET0_BAK3	EQU	09H		;ADC CHN0 转换结果低2位备份
CHN0_RET1_BAK3	EQU	0AH		;ADC CHN0 转换结果中4位备份
CHN0_RET2_BAK3	EQU	0BH		;ADC CHN0 转换结果高4位备份

CHN0_FINAL_RET0	EQU	0CH		;通道0平均后的结果
CHN0_FINAL_RET1	EQU	0DH		;
CHN0_FINAL_RET2	EQU	0EH

DET0_CT		EQU	0FH		;ADC 通道0 转换结果个数

;------------------------------------------------------------------
CHN1_RET0_BAK0	EQU	10H		;ADC CHN1 转换结果低2位备份
CHN1_RET1_BAK0	EQU	11H		;ADC CHN1 转换结果中4位备份
CHN1_RET2_BAK0	EQU	12H		;ADC CHN1 转换结果高4位备份

CHN1_RET0_BAK1	EQU	13H		;ADC CHN1 转换结果低2位备份
CHN1_RET1_BAK1	EQU	14H		;ADC CHN1 转换结果中4位备份
CHN1_RET2_BAK1	EQU	15H		;ADC CHN1 转换结果高4位备份

CHN1_RET0_BAK2	EQU	16H		;ADC CHN1 转换结果低2位备份
CHN1_RET1_BAK2	EQU	17H		;ADC CHN1 转换结果中4位备份
CHN1_RET2_BAK2	EQU	18H		;ADC CHN1 转换结果高4位备份

CHN1_RET0_BAK3	EQU	19H		;ADC CHN1 转换结果低2位备份
CHN1_RET1_BAK3	EQU	1AH		;ADC CHN1 转换结果中4位备份
CHN1_RET2_BAK3	EQU	1BH		;ADC CHN1 转换结果高4位备份

CHN1_FINAL_RET0	EQU	1CH		;通道1平均后的结果
CHN1_FINAL_RET1	EQU	1DH		;
CHN1_FINAL_RET2	EQU	1EH		;

DET1_CT		EQU	1FH		;ADC 通道1 转换结果个数

;------------------------------------------------------------------
CHN6_RET0_BAK0	EQU	20H		;ADC CHN6 转换结果低2位备份
CHN6_RET1_BAK0	EQU	21H		;ADC CHN6 转换结果中4位备份
CHN6_RET2_BAK0	EQU	22H		;ADC CHN6 转换结果高4位备份

CHN6_RET0_BAK1	EQU	23H		;ADC CHN6 转换结果低2位备份
CHN6_RET1_BAK1	EQU	24H		;ADC CHN6 转换结果中4位备份
CHN6_RET2_BAK1	EQU	25H		;ADC CHN6 转换结果高4位备份

CHN6_RET0_BAK2	EQU	26H		;ADC CHN6 转换结果低2位备份
CHN6_RET1_BAK2	EQU	27H		;ADC CHN6 转换结果中4位备份
CHN6_RET2_BAK2	EQU	28H		;ADC CHN6 转换结果高4位备份

CHN6_RET0_BAK3	EQU	29H		;ADC CHN6 转换结果低2位备份
CHN6_RET1_BAK3	EQU	2AH		;ADC CHN6 转换结果中4位备份
CHN6_RET2_BAK3	EQU	2BH		;ADC CHN6 转换结果高4位备份

CHN6_FINAL_RET0	EQU	2CH		;通道6平均后的结果
CHN6_FINAL_RET1	EQU	2DH		;
CHN6_FINAL_RET2	EQU	2EH

DET6_CT		EQU	2FH		;ADC 通道6 转换结果个数

;------------------------------------------------------------------
CHN7_RET0_BAK0	EQU	30H		;ADC CHN7 转换结果低2位备份
CHN7_RET1_BAK0	EQU	31H		;ADC CHN7 转换结果中4位备份
CHN7_RET2_BAK0	EQU	32H		;ADC CHN7 转换结果高4位备份

CHN7_RET0_BAK1	EQU	33H		;ADC CHN7 转换结果低2位备份
CHN7_RET1_BAK1	EQU	34H		;ADC CHN7 转换结果中4位备份
CHN7_RET2_BAK1	EQU	35H		;ADC CHN7 转换结果高4位备份

CHN7_RET0_BAK2	EQU	36H		;ADC CHN7 转换结果低2位备份
CHN7_RET1_BAK2	EQU	37H		;ADC CHN7 转换结果中4位备份
CHN7_RET2_BAK2	EQU	38H		;ADC CHN7 转换结果高4位备份

CHN7_RET0_BAK3	EQU	39H		;ADC CHN7 转换结果低2位备份
CHN7_RET1_BAK3	EQU	3AH		;ADC CHN7 转换结果中4位备份
CHN7_RET2_BAK3	EQU	3BH		;ADC CHN7 转换结果高4位备份

CHN7_FINAL_RET0	EQU	3CH		;通道7平均后的结果
CHN7_FINAL_RET1	EQU	3DH		;
CHN7_FINAL_RET2	EQU	3EH		;

DET7_CT		EQU	3FH		;ADC 通道7 转换结果个数
;------------------------------------------------------------------


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
	SBIM 	CNT0_496MS,	01H	;每次Timer0中断产生后，将CNT0_496MS减1
	LDI	TBR,		00H	;将累加器A 清0
	SBCM	CNT1_496MS		;每次CNT0-1产生借位时，将CNT1_496MS减1
	BC	J1MS			;如果未产生借位，则表示200MS还未计满

	LDI 	CNT0_496MS,	0DH 	;重置496ms 计数器,496 = 8 * 62
	LDI 	CNT1_496MS,	03H 	;重置496ms 计数器
	
	ORIM 	F_496MS,	0001B 	;设置 "496ms 到"标志

J1MS:	
	;--------------------------------------------------------------------------
	SBIM 	CNT0_8MS,	01H	;每次Timer0中断产生后，将CNT0_8MS减1
	BC 	TIMER0_ISP_END 		;CNT0_8MS仍大于0, 则结束ISP
	SBIM	CNT1_8MS,	01H	;每次CNT0_8MS-1产生借位时，将CNT1_8MS减1
	BC	TIMER0_ISP_END
	
	LDI 	CNT0_8MS,	0CH 	;重置1s 计数器
	LDI 	CNT1_8MS,	07H 	;重置1s 计数器
	
	ORIM 	F_TIME,		0001B 	;设置 "1s 到"标志
	ORIM	F_496MS_1S,	0010B	;为应急功能提供 "1s 到"标志
	ORIM	FLAG_SIMU_EMER,	0010B	;为手动自检提供 "1s 到"标志
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
	SBI	ADCCHN,		07H
	BAZ	CHN7_VOL_1		;此次为通道7 转换结果
	JMP	ADC_ISP_END		;正常情况下不应执行此语句
	
;----------------------------------------------------------------	

;转存通道0 转换结果
;----------------------------------------------------------------
CHN0_VOL_1:
	LDI	TBR,		01H	;次数加一
	ADDM	DET0_CT,	01H	

	LDI	TBR,		04H	;DET0_CT - 4 -> A
	SUB	DET0_CT,	01H
	BAZ 	CHN0_VOL_14		;第4个转换结果

	LDI	TBR,		03H	;DET0_CT - 3 -> A
	SUB	DET0_CT,	01H
	BAZ 	CHN0_VOL_13		;第3个转换结果

	LDI	TBR,		02H	;DET0_CT - 2 -> A
	SUB	DET0_CT,	01H
	BAZ 	CHN0_VOL_12		;第2个转换结果

CHN0_VOL_11:
	LDA 	AD_RET0,	00H 	;保存第一次A/D 转换结果
	STA 	CHN0_RET0_BAK0,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN0_RET1_BAK0,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN0_RET2_BAK0,	01H
	JMP 	NEXT_CHN	

CHN0_VOL_12:
	LDA 	AD_RET0,	00H 	;保存第二次A/D 转换结果
	STA 	CHN0_RET0_BAK1,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN0_RET1_BAK1,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN0_RET2_BAK1,	01H
	JMP 	NEXT_CHN
	
CHN0_VOL_13:
	LDA 	AD_RET0,	00H 	;保存第三次A/D 转换结果
	STA 	CHN0_RET0_BAK2,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN0_RET1_BAK2,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN0_RET2_BAK2,	01H
	JMP 	NEXT_CHN	
	
CHN0_VOL_14:
	LDA 	AD_RET0,	00H 	;保存第四次A/D 转换结果
	STA 	CHN0_RET0_BAK3,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN0_RET1_BAK3,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN0_RET2_BAK3,	01H

	LDI	TBR,		00H	;DET0_CT 清0
	STA	DET0_CT,	01H
	
	CALL	CAL_CHN0_ADCDATA
	
	JMP 	NEXT_CHN	
;----------------------------------------------------------------	

;转存通道1 转换结果
;----------------------------------------------------------------
CHN1_VOL_1:
	LDI	TBR,		01H	;次数加一
	ADDM	DET1_CT,	01H	

	LDI	TBR,		04H	;DET1_CT - 4 -> A
	SUB	DET1_CT,	01H
	BAZ 	CHN1_VOL_14		;第4个转换结果

	LDI	TBR,		03H	;DET1_CT - 3 -> A
	SUB	DET1_CT,	01H
	BAZ 	CHN1_VOL_13		;第3个转换结果

	LDI	TBR,		02H	;DET1_CT - 2 -> A
	SUB	DET1_CT,	01H
	BAZ 	CHN1_VOL_12		;第2个转换结果

CHN1_VOL_11:
	LDA 	AD_RET0,	00H 	;保存第一次A/D 转换结果
	STA 	CHN1_RET0_BAK0,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN1_RET1_BAK0,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN1_RET2_BAK0,	01H
	JMP 	NEXT_CHN	

CHN1_VOL_12:
	LDA 	AD_RET0,	00H 	;保存第二次A/D 转换结果
	STA 	CHN1_RET0_BAK1,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN1_RET1_BAK1,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN1_RET2_BAK1,	01H
	JMP 	NEXT_CHN
	
CHN1_VOL_13:
	LDA 	AD_RET0,	00H 	;保存第三次A/D 转换结果
	STA 	CHN1_RET0_BAK2,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN1_RET1_BAK2,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN1_RET2_BAK2,	01H
	JMP 	NEXT_CHN	
	
CHN1_VOL_14:
	LDA 	AD_RET0,	00H 	;保存第四次A/D 转换结果
	STA 	CHN1_RET0_BAK3,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN1_RET1_BAK3,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN1_RET2_BAK3,	01H

	LDI	TBR,		00H	;DET1_CT 清0
	STA	DET1_CT,	01H
	
	CALL	CAL_CHN1_ADCDATA
	
	JMP 	NEXT_CHN	
;----------------------------------------------------------------	

;转存通道6 转换结果
;----------------------------------------------------------------
CHN6_VOL_1:
	LDI	TBR,		01H	;次数加一
	ADDM	DET6_CT,	01H	

	LDI	TBR,		04H	;DET6_CT - 4 -> A
	SUB	DET6_CT,	01H
	BAZ 	CHN6_VOL_14		;第4个转换结果

	LDI	TBR,		03H	;DET6_CT - 3 -> A
	SUB	DET6_CT,	01H
	BAZ 	CHN6_VOL_13		;第3个转换结果

	LDI	TBR,		02H	;DET6_CT - 2 -> A
	SUB	DET6_CT,	01H
	BAZ 	CHN6_VOL_12		;第2个转换结果

CHN6_VOL_11:
	LDA 	AD_RET0,	00H 	;保存第一次A/D 转换结果
	STA 	CHN6_RET0_BAK0,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN6_RET1_BAK0,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN6_RET2_BAK0,	01H
	JMP 	NEXT_CHN	

CHN6_VOL_12:
	LDA 	AD_RET0,	00H 	;保存第二次A/D 转换结果
	STA 	CHN6_RET0_BAK1,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN6_RET1_BAK1,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN6_RET2_BAK1,	01H
	JMP 	NEXT_CHN
	
CHN6_VOL_13:
	LDA 	AD_RET0,	00H 	;保存第三次A/D 转换结果
	STA 	CHN6_RET0_BAK2,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN6_RET1_BAK2,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN6_RET2_BAK2,	01H
	JMP 	NEXT_CHN	
	
CHN6_VOL_14:
	LDA 	AD_RET0,	00H 	;保存第四次A/D 转换结果
	STA 	CHN6_RET0_BAK3,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN6_RET1_BAK3,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN6_RET2_BAK3,	01H

	LDI	TBR,		00H	;DET6_CT 清0
	STA	DET6_CT,	01H
	
	CALL	CAL_CHN6_ADCDATA
	
	JMP 	NEXT_CHN	
;----------------------------------------------------------------	

;转存通道7 转换结果
;----------------------------------------------------------------
CHN7_VOL_1:
	LDI	TBR,		01H	;次数加一
	ADDM	DET7_CT,	01H	

	LDI	TBR,		04H	;DET7_CT - 4 -> A
	SUB	DET7_CT,	01H
	BAZ 	CHN7_VOL_14		;第4个转换结果

	LDI	TBR,		03H	;DET7_CT - 3 -> A
	SUB	DET7_CT,	01H
	BAZ 	CHN7_VOL_13		;第3个转换结果

	LDI	TBR,		02H	;DET7_CT - 2 -> A
	SUB	DET7_CT,	01H
	BAZ 	CHN7_VOL_12		;第2个转换结果

CHN7_VOL_11:
	LDA 	AD_RET0,	00H 	;保存第一次A/D 转换结果
	STA 	CHN7_RET0_BAK0,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN7_RET1_BAK0,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN7_RET2_BAK0,	01H
	JMP 	NEXT_CHN	

CHN7_VOL_12:
	LDA 	AD_RET0,	00H 	;保存第二次A/D 转换结果
	STA 	CHN7_RET0_BAK1,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN7_RET1_BAK1,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN7_RET2_BAK1,	01H
	JMP 	NEXT_CHN
	
CHN7_VOL_13:
	LDA 	AD_RET0,	00H 	;保存第三次A/D 转换结果
	STA 	CHN7_RET0_BAK2,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN7_RET1_BAK2,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN7_RET2_BAK2,	01H
	JMP 	NEXT_CHN	
	
CHN7_VOL_14:
	LDA 	AD_RET0,	00H 	;保存第四次A/D 转换结果
	STA 	CHN7_RET0_BAK3,	01H
	LDA 	AD_RET1,	00H
	STA 	CHN7_RET1_BAK3,	01H
	LDA 	AD_RET2,	00H
	STA 	CHN7_RET2_BAK3,	01H

	LDI	TBR,		00H	;DET7_CT 清0
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
	
	JMP 	ADC_ISP_END		;不可能执行这一句

NEXT_CHN0:
	LDI	ADCCHN,		00H	;设定为CHN0
	JMP 	ADC_ISP_END

NEXT_CHN1:
	LDI	ADCCHN,		01H	;设定为CHN1
	JMP 	ADC_ISP_END
	
NEXT_CHN6:
	LDI 	ADCCHN,		06H 	;设定为CHN6
	JMP	ADC_ISP_END

NEXT_CHN7:
	LDA	FLAG_TYPE
	BA0	NEXT_CHN0		;若FLAG_TYPE的bit0=1，则表示已完成灯具类型选择，此时不再需要对AN7进行采样。
	
	LDI	ADCCHN,		07H	;设定为CHN7
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

	
	LDI 	IE,		0000B	;关闭所有中断
	
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

	LDI	CNT0_328MS,	08H	;定时328ms
	LDI	CNT1_328MS,	02H	;

	LDI 	CNT0_8MS,	0DH 	;定时1s
	LDI 	CNT1_8MS,	07H 	;定时1s
	
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
	;tosc = 1/4M = 0.25us, tAD = 8tosc = 2us, 一次A/D 转换时间 = 204tAD = 408 us.
	LDI 	PACR,		0000B 	;设置PortA0/1 作为输入口
	LDI 	PBCR,		0000B 	;设置PortB2/3 作为输入口
	LDI 	ADCCTL,		0001B 	;选择内部参考电压VDD，使能ADC
	LDI 	ADCCFG,		0100B 	;A/D 时钟tAD=8tOSC, A/D 转换时间= 204tAD
	LDI	ADCPORT,	1100B	;使用AN0 ~ AN7
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

	;门限值
	LDI	CMP_MIN_PWR0,	0EH	;最小上电电压(1.396V)
	LDI	CMP_MIN_PWR1,	08H

	LDI	CMP_SUPPLY0,	0BH	;小于此电压，则开启应急功能(1.115V -> 0x5B)
	LDI	CMP_SUPPLY1,	05H

	LDI	CMP_RESUME0,	04H	;大于此电压，则由应急转入主电(1.296V -> 0x84)
	LDI	CMP_RESUME1,	08H
	
	LDI	CMP_TYPE00,	00H	;灯具类型门限0
	LDI	CMP_TYPE01,	00H

	LDI	CMP_TYPE10,	00H	;灯具类型门限1
	LDI	CMP_TYPE11,	00H

	LDI	CMP_TYPE20,	00H	;灯具类型门限2
	LDI	CMP_TYPE21,	00H


	
;--------------------------------------
MAIN_PRE:
	LDI 	IRQ,		00H
	LDI 	IE,		1100B 	;打开ADC,Timer0 中断


;--------------------------------------
;检查供电是否正常
;--------------------------------------
WAIT_AD_RESULT:
	;一个通道采样4个数据，去掉最小与最大值，将余下的2个数据平均后得到最终结果。
	;上述过程耗时约408us * 4 = 2ms
	;根据以上推断，四个通道各得出一个最终结果需耗时 2ms * 4 = 8ms

	;保险起见，此处延时20ms
	CALL	DELAY_5MS
	CALL	DELAY_5MS
	CALL	DELAY_5MS
	CALL	DELAY_5MS

WAIT_PWR_NML:	
	ORIM	FLAG_OCCUPIED,	0100B	;锁定通道6最终结果

	LDI	CHN6_FINAL_RET1,01H
	SUB	CMP_MIN_PWR0
	LDI	CHN6_FINAL_RET2,01H
	SBC	CMP_MIN_PWR1

	ANDIM	FLAG_OCCUPIED,	1011B	;释放对通道6最终结果的锁定
	
	BNC	WAIT_AD_RESULT		;如果未达到最小上电电压，则一直等待电压升至最小上电电压之上。


;--------------------------------------
;判定灯具类型
;--------------------------------------
	CALL	CHK_TYPE


MAIN:


	;SBIM	PWMD01,		01H	;占空比为50%
	;LDI	TBR,		00H
	;SBCM	PWMD02

	;BC	KEY_CHK

	;LDI	PWMD01,		0DH
	;LDI	PWMD02,		07H

;--------------------------------------------------------------------------------------
;检查供电情况，如若停电，则打开应急功能。
;同时检查电池电压，如果电池耗尽，则停止应急
;如果市电供电恢复，则返回主电，关闭应急
;--------------------------------------------------------------------------------------
CHK_PWR_SUPPLY:				;检查供电是否正常
	ORIM	FLAG_OCCUPIED,	0100B	;锁定通道6最终结果

	LDI	CHN6_FINAL_RET1,01H
	SUB	CMP_SUPPLY0
	LDI	CHN6_FINAL_RET2,01H
	SBC	CMP_SUPPLY1

	ANDIM	FLAG_OCCUPIED,	1011B	;释放对通道6最终结果的锁定
	
	BNC	CHK_BATTERY		;如果供电正常,则检测电池电压

	;驱动应急引脚
	LDA	ABNORMAL_STA
	BA0	EMERGENCY_CNT		;已打开应急放电功能
	ORIM	ABNORMAL_STA,	0001B	;置标志位，表明已打开应急放电功能
	CALL	EMERGENCY_ENABLE

EMERGENCY_CNT:
	ADI	F_496MS_1S,	0010B	;每秒检查一次
	BA1	EMERGENCY_WAIT

	ANDIM	F_496MS_1S,	1101B	;清除1s标志位
	SBI	CNT2_EMERGENCY,	08H	;如果CNT达到0x800，则表示已应急放电0x800s = 2048s > 30min
	BC	EMERGENCY_BATTERY	;此时无需再对应急放电时长计时

	ADIM	CNT0_EMERGENCY,	01H
	LDI	TBR,		00H
	ADCM	CNT1_EMERGENCY
	LDI	TBR,		00H
	ADCM	CNT2_EMERGENCY

EMERGENCY_BATTERY:			;检查电池是否已经耗尽
	ORIM	FLAG_OCCUPIED,	0010B	;锁定通道1最终结果

	LDI	CHN1_FINAL_RET1,01H
	SUB	CMP_EXIT_EMER0
	LDI	CHN1_FINAL_RET2,01H
	SBC	CMP_EXIT_EMER1

	ANDIM	FLAG_OCCUPIED,	1101B	;释放对通道1最终结果的锁定

	BC	EMERGENCY_WAIT
	CALL	EMERGENCY_DISABLE	;电池电压过低，停止应急


EMERGENCY_WAIT:
	JMP	CHK_PWR_SUPPLY
	

;--------------------------------------------------------------------------------------
;此时供电正常，检查电池电压。
;--------------------------------------------------------------------------------------
CHK_BATTERY:

	ORIM	FLAG_OCCUPIED,	0010B	;锁定通道1最终结果

	LDI	CHN1_FINAL_RET1,01H	
	SUB	CMP_BAT_OPEN0		;判断电池是否开路
	LDI	CHN1_FINAL_RET2,01H
	SBC	CMP_BAT_OPEN1
	BNC	BAT_OPEN		;AD转换结果大于1.56V，电池开路
	ANDIM	BAT_STATE,	1110B	;清除充电回路开路标志位

	LDI	CHN1_FINAL_RET1,01H	
	SUB	CMP_BAT_FULL0		;判断电池是否充满
	LDI	CHN1_FINAL_RET2,01H
	SBC	CMP_BAT_FULL1
	BNC	BAT_FULL		;AD转换结果大于1.44V，电池开路
	ANDIM	BAT_STATE,	1101B	;清除电池已充满标志位

	LDI	CHN1_FINAL_RET1,01H	
	SUB	CMP_BAT_CHARGE0		;判断电池是否过低，需要充电了
	LDI	CHN1_FINAL_RET2,01H
	SBC	CMP_BAT_CHARGE1
	BNC	BAT_NEED_CHARGE		;AD转换结果小于1.35V，电池需要重新充电
	ANDIM	BAT_STATE,	0100B	;清除电池需要重新充电标志位


BAT_OPEN:
	ORIM	BAT_STATE,	0001B	;置充电回路开路标志位
	JMP	CHK_BATTERY_END

BAT_FULL:
	ORIM	BAT_STATE,	0010B	;置电池已充满标志位
	JMP	CHK_BATTERY_END

BAT_NEED_CHARGE:
	ORIM	BAT_STATE,	0100B	;置电池需要重新充电标志位
	JMP	CHK_BATTERY_END

CHK_BATTERY_END:
	ANDIM	FLAG_OCCUPIED,	1101B	;释放对通道1最终结果的锁定

;--------------------------------------------------------------------------------------
;光源检测
;--------------------------------------------------------------------------------------
CHK_LIGHT:
	LDI	TBR,		0101B	;将立即数0101B载入累加器A中
	AND	LIGHT_TYPE		;BIT0\2为1，代表灯具为常亮型

	BNZ	TYPE_ON			;为常亮型灯具
	JMP	TYPE_OFF		;为常灭型灯具

	
TYPE_ON:
	CALL	PROCESS_LIGHT		;检测光源，并设置相应标志位
	JMP     CHK_LIGHT_END


TYPE_OFF:
	LDA	NORMAL_STA		;载入NORMAL_STA至累加器A
	BNZ	CHK_LIGHT_END		;处于主电源正常供电状态，无需对光源进行检测
	CALL	PROCESS_LIGHT		;检测光源，并设置相应标志位

CHK_LIGHT_END:


;--------------------------------------------------------------------------------------
;故障提示
;--------------------------------------------------------------------------------------
CHK_ALARM:
	CALL	PROCESS_ALARM		;根据故障标志位，控制黄灯与红灯
	

;--------------------------------------------------------------------------------------
;按键扫描
;--------------------------------------------------------------------------------------
KEY_CHK:
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
	LDA	FLAG_SIMU_EMER
	BA0	SIM_PWR_CUT_END		;在"模拟停电"状态下，已打开应急放电功能
	
	ORIM	FLAG_SIMU_EMER,	0001B	;置标志位，表明在"模拟停电"状态下,已打开应急放电功能
	CALL	EMERGENCY_ENABLE

SIM_PWR_CUT_END:	
	RTNI

;***********************************************************
; 手动月检处理部分
;***********************************************************
SIM_MONTH_CHK:
	LDA	FLAG_SIMU_EMER
	BA1	SIM_MONTH_CHK_END	;在"手动月检"状态下，已打开应急放电功能
	
	ORIM	FLAG_SIMU_EMER,	0010B	;置标志位，表明在"手动月检"状态下,已打开应急放电功能
	CALL	EMERGENCY_ENABLE


SIM_MONTH_CNT:
	ADI	FLAG_SIMU_EMER,	0010B	;每秒检查一次
	BA1	SIM_MONTH_CHK_END

	SBI	CNT2_EMERGENCY,	08H	;如果CNT达到0x800，则表示已应急放电0x800s = 2048s > 30min
	BC	SIM_MONTH_BATTERY	;此时无需再对应急放电时长计时

	ADIM	CNT0_EMERGENCY,	01H
	LDI	TBR,		00H
	ADCM	CNT1_EMERGENCY
	LDI	TBR,		00H
	ADCM	CNT2_EMERGENCY

SIM_MONTH_BATTERY:			;检查电池是否已经耗尽
	ORIM	FLAG_OCCUPIED,	0010B	;锁定通道1最终结果

	LDI	CHN1_FINAL_RET1,01H
	SUB	CMP_EXIT_EMER0
	LDI	CHN1_FINAL_RET2,01H
	SBC	CMP_EXIT_EMER1

	ANDIM	FLAG_OCCUPIED,	1101B	;释放对通道1最终结果的锁定

	BC	SIM_MONTH_CHK_END
	CALL	EMERGENCY_DISABLE	;电池电压过低，停止应急

SIM_MONTH_CHK_END:
	RTNI

;***********************************************************
; 手动年检处理部分
;***********************************************************
SIM_YEAR_CHK:
	LDA	FLAG_SIMU_EMER
	BA1	SIM_MONTH_CHK_END	;在"手动年检"状态下，已打开应急放电功能
	
	ORIM	FLAG_SIMU_EMER,	0010B	;置标志位，表明在"手动年检"状态下,已打开应急放电功能
	CALL	EMERGENCY_ENABLE


SIM_YEAR_CNT:
	ADI	FLAG_SIMU_EMER,	0010B	;每秒检查一次
	BA1	SIM_YEAR_CHK_END

	SBI	CNT2_EMERGENCY,	08H	;如果CNT达到0x800，则表示已应急放电0x800s = 2048s > 30min
	BC	SIM_YEAR_BATTERY	;此时无需再对应急放电时长计时

	ADIM	CNT0_EMERGENCY,	01H
	LDI	TBR,		00H
	ADCM	CNT1_EMERGENCY
	LDI	TBR,		00H
	ADCM	CNT2_EMERGENCY

SIM_YEAR_BATTERY:			;检查电池是否已经耗尽
	ORIM	FLAG_OCCUPIED,	0010B	;锁定通道1最终结果

	LDI	CHN1_FINAL_RET1,01H
	SUB	CMP_EXIT_EMER0
	LDI	CHN1_FINAL_RET2,01H
	SBC	CMP_EXIT_EMER1

	ANDIM	FLAG_OCCUPIED,	1101B	;释放对通道1最终结果的锁定

	BC	SIM_YEAR_CHK_END
	CALL	EMERGENCY_DISABLE	;电池电压过低，停止应急

SIM_YEAR_CHK_END:

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
	ADI	F_496MS,	0001B	;检查496MS标志位
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
	
	ANDIM	F_496MS,	1110B	;清496MS标志位
	
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

;*******************************************
; 子程序: CAL_CHN0_ADCDATA
; 描述: 防脉冲平均滤波法（N=4，去一个最大值和一个最小值，剩下两个求平均值）
;*******************************************
CAL_CHN0_ADCDATA:
	ADI	FLAG_OCCUPIED,		0001B
	BA0	CAL_CHN0_AD_MIN01
	JMP	CAL_CHN0_ADCDATA_END		;正在使用转换结果

;----------------------------
;寻找最小值
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
;将最小值清零
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
;寻找最大值
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
;将最大值清零
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
;计算总和并存放在CHN0_RET0_BAK3,CHN0_RET1_BAK3 和CHN0_RET2_BAK3（包括两个被清零的）
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
;总和除以2，得到平均值，存放在CHN0_FINAL_RET0(),CHN0_FINAL_RET1 和CHN0_FINAL_RET2
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
;调整为CHN0_FINAL_RET0存放低4位，CHN0_FINAL_RET1存放中4位，CHN0_FINAL_RET2存放高2位
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
; 子程序: CAL_CHN1_ADCDATA
; 描述: 防脉冲平均滤波法（N=4，去一个最大值和一个最小值，剩下两个求平均值）
;*******************************************
CAL_CHN1_ADCDATA:
	ADI	FLAG_OCCUPIED,		0010B
	BA1	CAL_CHN1_AD_MIN01
	JMP	CAL_CHN1_ADCDATA_END		;正在使用转换结果

;----------------------------
;寻找最小值
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
;将最小值清零
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
;寻找最大值
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
;将最大值清零
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
;计算总和并存放在CHN1_RET0_BAK3,CHN1_RET1_BAK3 和CHN1_RET2_BAK3（包括两个被清零的）
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
;总和除以2，得到平均值，存放在CHN1_FINAL_RET0(),CHN1_FINAL_RET1 和CHN1_FINAL_RET2
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
;调整为CHN1_FINAL_RET0存放低4位，CHN1_FINAL_RET1存放中4位，CHN1_FINAL_RET2存放高2位
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
; 子程序: CAL_CHN6_ADCDATA
; 描述: 防脉冲平均滤波法（N=4，去一个最大值和一个最小值，剩下两个求平均值）
;*******************************************
CAL_CHN6_ADCDATA:
	ADI	FLAG_OCCUPIED,		0100B
	BA2	CAL_CHN6_AD_MIN01
	JMP	CAL_CHN6_ADCDATA_END		;正在使用转换结果
	
;----------------------------
;寻找最小值
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
;将最小值清零
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
;寻找最大值
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
;将最大值清零
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
;计算总和并存放在CHN6_RET0_BAK3,CHN6_RET1_BAK3 和CHN6_RET2_BAK3（包括两个被清零的）
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
;总和除以2，得到平均值，存放在CHN6_FINAL_RET0(),CHN6_FINAL_RET1 和CHN6_FINAL_RET2
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
;调整为CHN6_FINAL_RET0存放低4位，CHN6_FINAL_RET1存放中4位，CHN6_FINAL_RET2存放高2位
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
; 子程序: CAL_CHN7_ADCDATA
; 描述: 防脉冲平均滤波法（N=4，去一个最大值和一个最小值，剩下两个求平均值）
;*******************************************
CAL_CHN7_ADCDATA:
	ADI	FLAG_OCCUPIED,		1000B
	BA3	CAL_CHN7_AD_MIN01
	JMP	CAL_CHN7_ADCDATA_END		;正在使用转换结果

;----------------------------
;寻找最小值
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
;将最小值清零
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
;寻找最大值
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
;将最大值清零
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
;计算总和并存放在CHN7_RET0_BAK3,CHN7_RET1_BAK3 和CHN7_RET2_BAK3（包括两个被清零的）
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
;总和除以2，得到平均值，存放在CHN7_FINAL_RET0(),CHN7_FINAL_RET1 和CHN7_FINAL_RET2
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
;调整为CHN7_FINAL_RET0存放低4位，CHN7_FINAL_RET1存放中4位，CHN7_FINAL_RET2存放高2位
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
; 检查灯具类型
; 输入: CHN7_FINAL_RET1, CHN7_FINAL_RET2
; 输出: LIGHT_TYPE
;***********************************************************
CHK_TYPE:
	ORIM	FLAG_OCCUPIED,	1000B	;锁定通道7最终结果

	LDI	CHN7_FINAL_RET1,01H	;和门限0比较
	SUB	CMP_TYPE00
	LDI	CHN7_FINAL_RET2,01H
	SBC	CMP_TYPE01
	BNC	LI_ON			;

	LDI	CHN7_FINAL_RET1,01H	;和门限1比较
	SUB	CMP_TYPE10
	LDI	CHN7_FINAL_RET2,01H
	SBC	CMP_TYPE11
	BNC	LI_OFF			;

	LDI	CHN7_FINAL_RET1,01H	;和门限2比较
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
	ANDIM	FLAG_OCCUPIED,	0111B	;释放对通道7最终结果的锁定
	ORIM	FLAG_TYPE,	0001B	;不再对通道7进行采样
	
	RTNI


;***********************************************************
; 通过PWM0输出频率为32KHZ，占空比为50%的方波，以此驱动应急电路
;***********************************************************
EMERGENCY_ENABLE:
	LDI	PWMC0,		0000B	;PWM0 Clock = tosc = 4M
	LDI	PWMP00,		0DH	;周期为125个PWM0 Clock
	LDI	PWMP01,		07H	
	LDI	PWMD00,		00H	;无微调
	LDI	PWMD01,		0EH	;占空比为50%
	LDI	PWMD02,		03H
	ORIM	PWMC0,		0001B	;使能PWM0输出

	RTNI

;-----------------------------------------------------------
;禁能PWM0，关闭应急功能
;-----------------------------------------------------------
EMERGENCY_DISABLE:
	LDI	PWMC0,		0000B	;禁能PWM0

	RTNI


;-----------------------------------------------------------
;根据通道0转换结果，检测光源状态，并设置光源故障标志位
;-----------------------------------------------------------
PROCESS_LIGHT:

	ORIM	FLAG_OCCUPIED,	0001B	;锁定通道0最终结果

	LDI	CHN1_FINAL_RET1,01H
	SUB	CMP_LIGHT0
	LDI	CHN1_FINAL_RET2,01H
	SBC	CMP_LIGHT1

	ANDIM	FLAG_OCCUPIED,	1110B	;释放对通道0最终结果的锁定

	BC	ERROR_LIGHT		;光源故障

	ANDIM	LIGHT_STATE,	1110B	;清除光源故障标志位
	JMP     PROCESS_LIGHT_END


ERROR_LIGHT:

	ORIM	LIGHT_STATE,	0001B	;置光源故障标志位


PROCESS_LIGHT_END:

	RTNI

;--------------------------------------------------------------------------------------
;根据电池电压检测结果、光源检测结果，做相应处理
;充电回路开路/短路: 红灯灭，黄灯1HZ闪烁
;光源开路/短路:             黄灯3HZ闪烁
;放电时间不足:              黄灯常亮
;--------------------------------------------------------------------------------------
PROCESS_ALARM:

ALARM_BAT:	
	LDI	TBR,		0001B	;将0001B载入累加器A中
	AND	ALARM_STATE 		;判断电池是否处于故障状态
	BAZ	ALARM_LIGHT		;电池没有故障，则跳转

	ANDIM	PORTC,		1110B	;电池充电回路故障，关闭红灯

	ADI	F_328MS,	01H	;判断是否到了一个新328MS
	BA0	ALARM_LIGHT		;还未到新的328MS,跳转

	ADIM	CNT_LED_YELLOW,	01H	;328MS已到，计数器加1

	SBI	CNT_LED_YELLOW,	03H
	BNC	ALARM_LIGHT		;未满1s

	LDI	CNT_LED_YELLOW,	00H	;清零计数器
	EORIM	PORTE,		0001B	;以1HZ频率翻转黄灯

ALARM_LIGHT:
	LDI	TBR,		0010B	;将0010B载入累加器A中
	AND	ALARM_STATE		;判断光源是否处于故障状态
	BAZ	ALARM_TIME_NOT_ENOUGH	;光源没有故障，则跳转

	ADI	CNT0_328MS,	01H	;判断是否到了一个新328MS
	BA0	ALARM_TIME_NOT_ENOUGH	;还未到新的328MS,跳转

	EORIM	PORTE,		0001B	;以3HZ频率翻转黄灯

	ANDIM	F_328MS,	1110B	;清除328MS标志

ALARM_TIME_NOT_ENOUGH:
	LDI	TBR,		0100B	;将0100B载入累加器A中
	AND	ALARM_STATE		;判断是否出现放电时间不足之故障
	BAZ	OFF_LED_YELLOW		;没有出现放电时间不足之故障，则跳转
	
	ORIM	PORTE,		0001B	;黄灯长亮

OFF_LED_YELLOW:
	LDA	ALARM_STATE		;如果没有任何故障，则关闭黄灯
	BNZ	PROCESS_ALARM_END
	ANDIM	PORTE,		1110B

PROCESS_ALARM_END:
	RTNI



	
	END



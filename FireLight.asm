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
ADCCHL	EQU	17H			;ADC channel selection

PACR	EQU	18H			;PortA 控制寄存器
PBCR	EQU	19H			;PortB 控制寄存器
PCCR	EQU	1AH			;PortC 控制寄存器
PDCR	EQU	1BH			;PortD 控制寄存器
PECR	EQU	1CH			;PortE 控制寄存器


PPBCR 	EQU 	389H 			;PORTB 口上拉电阻控制寄存器 

;*****************************************************
;用户自定义寄存器 ($030 ~ $0EF)
;*****************************************************
AC_BAK 	EQU 	30H 			;AC 值备份寄存器

;--------------------------------------
; 用于TIMER 定时
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






;*****************************************************
;程序
;*****************************************************
	ORG	0000H

	;中断向量表
	JMP	RESET			;RESET ISP
	RTNI				;ADC INTERRUPT ISP
	JMP	TIMER0_ISP		;TIMER0 ISP
	RTNI				;TIMER1 ISP
	RTNI				;PORTB/D ISP

;*****************************************************
;Timer0 中断服务程序
;*****************************************************
TIMER0_ISP:
	STA 	AC_BAK,		00H 	;备份AC 值
	ANDIM 	IRQ,		1011B 	;清TIMER0 中断请求标志
	
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
	LDI 	IE,		0100B 	;打开TIMER0 中断
	LDA 	AC_BAK,		00H 	;取出AC 值
	RTNI	
	
;*****************************************************
; 主程序
;*****************************************************
RESET:
	NOP	
	

	
	
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
	LDI 	TBR,		00H
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
	LDI 	PORTB,		00H
	LDI 	PBCR,		0FH 	;设置PortB 作为输出口
	LDI 	PORTE,		0FH
	LDI 	PECR,		0FH 	;设置PortE 作为输出口

;--------------------------------------
MAIN_PRE:
	LDI 	IRQ,		00H
	LDI 	IE,		0100B 	;打开Timer0 中断

MAIN:
	ADI 	F_TIME,		0001B
	BA0 	HALTMODE 		;未到1s,跳转
	ANDIM 	F_TIME,		1110B 	;清 "1s 到"标志
	EORIM	PORTB,		0001B	;翻转PB.0	
	
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

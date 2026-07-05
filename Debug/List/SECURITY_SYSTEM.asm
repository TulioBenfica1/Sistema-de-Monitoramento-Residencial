
;CodeVisionAVR C Compiler V4.06a Evaluation
;(C) Copyright 1998-2025 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 14,745600 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': No
;'char' is unsigned     : No
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC

	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPMCSR=0x37
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.EQU __FLASH_PAGE_SIZE=0x40

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETW1P
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETD1P_INC
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	.ENDM

	.MACRO __GETD1P_DEC
	LD   R23,-X
	LD   R22,-X
	LD   R31,-X
	LD   R30,-X
	.ENDM

	.MACRO __PUTDP1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTDP1_DEC
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __CPD10
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	.ENDM

	.MACRO __CPD20
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	.ENDM

	.MACRO __ADDD12
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	.ENDM

	.MACRO __ADDD21
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	.ENDM

	.MACRO __SUBD12
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	.ENDM

	.MACRO __SUBD21
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	.ENDM

	.MACRO __ANDD12
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	.ENDM

	.MACRO __ORD12
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	.ENDM

	.MACRO __XORD12
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	.ENDM

	.MACRO __XORD21
	EOR  R26,R30
	EOR  R27,R31
	EOR  R24,R22
	EOR  R25,R23
	.ENDM

	.MACRO __COMD1
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	.ENDM

	.MACRO __MULD2_2
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	.ENDM

	.MACRO __LSRD1
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	.ENDM

	.MACRO __LSLD1
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	.ENDM

	.MACRO __ASRB4
	ASR  R30
	ASR  R30
	ASR  R30
	ASR  R30
	.ENDM

	.MACRO __ASRW8
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	.ENDM

	.MACRO __LSRD16
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	.ENDM

	.MACRO __LSLD16
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	.ENDM

	.MACRO __CWD1
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	.ENDM

	.MACRO __CWD2
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	.ENDM

	.MACRO __SETMSD1
	SER  R31
	SER  R22
	SER  R23
	.ENDM

	.MACRO __ADDW1R15
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	.ENDM

	.MACRO __ADDW2R15
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	.ENDM

	.MACRO __EQB12
	CP   R30,R26
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __NEB12
	CP   R30,R26
	LDI  R30,1
	BRNE PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12
	CP   R30,R26
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12
	CP   R26,R30
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12
	CP   R26,R30
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12
	CP   R30,R26
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12U
	CP   R30,R26
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12U
	CP   R26,R30
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12U
	CP   R26,R30
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12U
	CP   R30,R26
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __CPW01
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	.ENDM

	.MACRO __CPW02
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	.ENDM

	.MACRO __CPD12
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	.ENDM

	.MACRO __CPD21
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	.ENDM

	.MACRO __BSTB1
	CLT
	TST  R30
	BREQ PC+2
	SET
	.ENDM

	.MACRO __LNEGB1
	TST  R30
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __LNEGW1
	OR   R30,R31
	LDI  R30,1
	BREQ PC+2
	LDI  R30,0
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _keys=R4
	.DEF _keys_msb=R5
	.DEF __lcd_x=R7
	.DEF __lcd_y=R6
	.DEF __lcd_maxx=R9

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_compa_isr
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_keymap_G005:
	.DB  0x31,0x34,0x37,0x3C,0x32,0x35,0x38,0x30
	.DB  0x33,0x36,0x39,0x23
_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0001

_0x40000:
	.DB  0x53,0x65,0x6E,0x68,0x61,0x20,0x49,0x6E
	.DB  0x63,0x6F,0x72,0x72,0x65,0x74,0x61,0x0
	.DB  0x53,0x65,0x6E,0x68,0x61,0x20,0x43,0x6F
	.DB  0x72,0x72,0x65,0x74,0x61,0x0,0x4C,0x69
	.DB  0x67,0x61,0x6E,0x64,0x6F,0x2E,0x2E,0x2E
	.DB  0x0,0x53,0x69,0x73,0x74,0x65,0x6D,0x61
	.DB  0x20,0x41,0x72,0x6D,0x61,0x64,0x6F,0x0
	.DB  0x41,0x72,0x6D,0x61,0x6E,0x64,0x6F,0x20
	.DB  0x53,0x69,0x73,0x74,0x65,0x6D,0x61,0x0
	.DB  0x53,0x69,0x73,0x74,0x65,0x6D,0x61,0x20
	.DB  0x44,0x65,0x73,0x61,0x72,0x6D,0x61,0x64
	.DB  0x6F,0x0,0x41,0x6C,0x65,0x72,0x74,0x61
	.DB  0x3A,0x20,0x49,0x6E,0x74,0x72,0x75,0x73
	.DB  0x61,0x6F,0x0,0x53,0x65,0x6E,0x68,0x61
	.DB  0x3A,0x20,0x5F,0x20,0x5F,0x20,0x5F,0x20
	.DB  0x5F,0x0,0x41,0x6C,0x65,0x72,0x74,0x61
	.DB  0x3A,0x20,0x50,0x72,0x65,0x73,0x65,0x6E
	.DB  0x63,0x61,0x0,0x41,0x6C,0x65,0x72,0x74
	.DB  0x61,0x3A,0x20,0x46,0x75,0x6D,0x61,0xC3
	.DB  0xA7,0x61,0x0,0x53,0x75,0x70,0x65,0x72
	.DB  0x61,0x71,0x75,0x65,0x63,0x69,0x6D,0x65
	.DB  0x6E,0x74,0x6F,0x0,0x45,0x72,0x72,0x6F
	.DB  0x20,0x6E,0x6F,0x20,0x53,0x69,0x73,0x74
	.DB  0x65,0x6D,0x61,0x0,0x45,0x73,0x74,0x61
	.DB  0x64,0x6F,0x20,0x44,0x65,0x73,0x63,0x6F
	.DB  0x6E,0x68,0x65,0x63,0x69,0x64,0x6F,0x0
_0x60003:
	.DB  0x32,0x32,0x33,0x34
_0xA0003:
	.DB  0xA
_0xA0004:
	.DB  0x40
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x10
	.DW  _0x40003
	.DW  _0x40000*2

	.DW  0x0E
	.DW  _0x40004
	.DW  _0x40000*2+16

	.DW  0x0B
	.DW  _0x40009
	.DW  _0x40000*2+30

	.DW  0x0F
	.DW  _0x40009+11
	.DW  _0x40000*2+41

	.DW  0x10
	.DW  _0x40009+26
	.DW  _0x40000*2+56

	.DW  0x04
	.DW  _0x40009+42
	.DW  _0x40000*2+37

	.DW  0x12
	.DW  _0x40009+46
	.DW  _0x40000*2+72

	.DW  0x11
	.DW  _0x40009+64
	.DW  _0x40000*2+90

	.DW  0x0F
	.DW  _0x40009+81
	.DW  _0x40000*2+107

	.DW  0x11
	.DW  _0x40009+96
	.DW  _0x40000*2+122

	.DW  0x0F
	.DW  _0x40009+113
	.DW  _0x40000*2+107

	.DW  0x10
	.DW  _0x40009+128
	.DW  _0x40000*2+139

	.DW  0x0F
	.DW  _0x40009+144
	.DW  _0x40000*2+107

	.DW  0x11
	.DW  _0x40009+159
	.DW  _0x40000*2+155

	.DW  0x0F
	.DW  _0x40009+176
	.DW  _0x40000*2+107

	.DW  0x10
	.DW  _0x40009+191
	.DW  _0x40000*2+172

	.DW  0x14
	.DW  _0x40009+207
	.DW  _0x40000*2+188

	.DW  0x04
	.DW  _password_G003
	.DW  _0x60003*2

	.DW  0x01
	.DW  _key_pressed_counter_S0050000000
	.DW  _0xA0003*2

	.DW  0x01
	.DW  _column_S0050000000
	.DW  _0xA0004*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI

	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x160

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;void main(void)
; 0000 0005 {

	.CSEG
_main:
; .FSTART _main
; 0000 0006 SystemInit();
	RCALL _SystemInit
; 0000 0007 
; 0000 0008 while (1)
_0x3:
; 0000 0009 {
; 0000 000A SystemUpdate();
	RCALL _SystemUpdate
; 0000 000B }
	RJMP _0x3
; 0000 000C }
_0x6:
	RJMP _0x6
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;void SystemInit(void)
; 0001 000D {

	.CSEG
_SystemInit:
; .FSTART _SystemInit
; 0001 000E // Configuração de registradores
; 0001 000F LCDInit();
	RCALL _LCDInit
; 0001 0010 KEYPAD_init();
	RCALL _KEYPAD_init
; 0001 0011 TIMER1Init();
	RCALL _TIMER1Init
; 0001 0012 #asm("sei");
	SEI
; 0001 0013 
; 0001 0014 }
	RET
; .FEND
;void SystemUpdate(void)
; 0001 0017 {
_SystemUpdate:
; .FSTART _SystemUpdate
; 0001 0018 if (lcd_update_pending)
	SBRS R2,0
	RJMP _0x20003
; 0001 0019 {
; 0001 001A LCDUpdate(current_state);
	LDS  R26,_current_state_G001
	RCALL _LCDUpdate
; 0001 001B lcd_update_pending = 0;
	CLT
	BLD  R2,0
; 0001 001C }
; 0001 001D if(keypad_entry)
_0x20003:
	SBRS R2,1
	RJMP _0x20004
; 0001 001E {
; 0001 001F KEYPADProcess(current_state);
	LDS  R26,_current_state_G001
	RCALL _KEYPADProcess
; 0001 0020 }
; 0001 0021 }
_0x20004:
	RET
; .FEND
;void SystemSetState(SystemState state)
; 0001 0024 {
_SystemSetState:
; .FSTART _SystemSetState
; 0001 0025 current_state = state;
	ST   -Y,R17
	MOV  R17,R26
;	state -> R17
	STS  _current_state_G001,R17
; 0001 0026 lcd_update_pending = 1;
	SET
	BLD  R2,0
; 0001 0027 if (state == ST_DISARMED || state == ST_SHOCK ||
; 0001 0028 state == ST_MOTION || state == ST_SMOKE ||
; 0001 0029 state == ST_OVERHEAT)
	CPI  R17,3
	BREQ _0x20006
	CPI  R17,4
	BREQ _0x20006
	CPI  R17,5
	BREQ _0x20006
	CPI  R17,6
	BREQ _0x20006
	CPI  R17,7
	BRNE _0x20005
_0x20006:
; 0001 002A {
; 0001 002B keypad_entry = 1;
	SET
	BLD  R2,1
; 0001 002C PasswordStart();
	RCALL _PasswordStart
; 0001 002D }
; 0001 002E else
	RJMP _0x20008
_0x20005:
; 0001 002F {
; 0001 0030 keypad_entry = 0;
	CLT
	BLD  R2,1
; 0001 0031 }
_0x20008:
; 0001 0032 }
	JMP  _0x2080001
; .FEND
;SystemState SystemGetState(void)
; 0001 0035 {
; 0001 0036 return current_state;
; 0001 0037 }
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;void LCDInit(void)
; 0002 0008 {

	.CSEG
_LCDInit:
; .FSTART _LCDInit
; 0002 0009 // Configura os registradores para utilizar o LCD - Barramento A
; 0002 000A DDRA |= 0x04;     // Configura o pino PA2 como saída para habilitar o LCD
	SBI  0x1A,2
; 0002 000B lcd_init(16);     // Inicializa o LCD com 16 caracteres
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0002 000C PORTA |= 0x08;    // Habilita o backlight do LCD
	SBI  0x1B,3
; 0002 000D lcd_gotoxy(0, 0); // Posicão padrão do cursor no LCD
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0002 000E }
	RET
; .FEND
;void UpdatePasswordDisplay(unsigned char input, unsigned char length)
; 0002 0011 {
_UpdatePasswordDisplay:
; .FSTART _UpdatePasswordDisplay
; 0002 0012 lcd_gotoxy(7 + 2 * (length - 1), 1);
	RCALL SUBOPT_0x0
;	input -> R16
;	length -> R17
	RCALL SUBOPT_0x1
; 0002 0013 lcd_putchar(input);
	MOV  R26,R16
	RCALL _lcd_putchar
; 0002 0014 delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0002 0015 lcd_gotoxy(7 + 2 * (length - 1), 1);
	MOV  R30,R17
	RCALL SUBOPT_0x1
; 0002 0016 lcd_putchar('*');
	LDI  R26,LOW(42)
	RCALL _lcd_putchar
; 0002 0017 }
	JMP  _0x2080003
; .FEND
;void WrongPasswordDisplay(void)
; 0002 001A {
_WrongPasswordDisplay:
; .FSTART _WrongPasswordDisplay
; 0002 001B lcd_gotoxy(0, 1);
	RCALL SUBOPT_0x2
; 0002 001C lcd_puts("Senha Incorreta");
	__POINTW2MN _0x40003,0
	RJMP _0x2080004
; 0002 001D }
; .FEND

	.DSEG
_0x40003:
	.BYTE 0x10
;void CorrectPasswordDisplay(void)
; 0002 0020 {

	.CSEG
_CorrectPasswordDisplay:
; .FSTART _CorrectPasswordDisplay
; 0002 0021 lcd_clear();
	RCALL _lcd_clear
; 0002 0022 lcd_puts("Senha Correta");
	__POINTW2MN _0x40004,0
_0x2080004:
	RCALL _lcd_puts
; 0002 0023 }
	RET
; .FEND

	.DSEG
_0x40004:
	.BYTE 0xE
;void LCDUpdate(SystemState state)
; 0002 0026 {

	.CSEG
_LCDUpdate:
; .FSTART _LCDUpdate
; 0002 0027 // Atualiza o display do LCD com base no estado atual do sistema
; 0002 0028 lcd_clear();
	ST   -Y,R17
	MOV  R17,R26
;	state -> R17
	RCALL _lcd_clear
; 0002 0029 
; 0002 002A switch (state)
	MOV  R30,R17
; 0002 002B {
; 0002 002C case ST_BOOT:
	CPI  R30,0
	BRNE _0x40008
; 0002 002D lcd_puts("Ligando...");
	__POINTW2MN _0x40009,0
	RJMP _0x40013
; 0002 002E break;
; 0002 002F 
; 0002 0030 case ST_ARMED:
_0x40008:
	CPI  R30,LOW(0x1)
	BRNE _0x4000A
; 0002 0031 lcd_puts("Sistema Armado");
	__POINTW2MN _0x40009,11
	RJMP _0x40013
; 0002 0032 break;
; 0002 0033 
; 0002 0034 case ST_ARMING_DELAY:
_0x4000A:
	CPI  R30,LOW(0x2)
	BRNE _0x4000B
; 0002 0035 lcd_puts("Armando Sistema");
	__POINTW2MN _0x40009,26
	RCALL _lcd_puts
; 0002 0036 lcd_gotoxy(0, 1);
	RCALL SUBOPT_0x2
; 0002 0037 lcd_puts("...");
	__POINTW2MN _0x40009,42
	RJMP _0x40013
; 0002 0038 break;
; 0002 0039 
; 0002 003A case ST_DISARMED:
_0x4000B:
	CPI  R30,LOW(0x3)
	BRNE _0x4000C
; 0002 003B lcd_puts("Sistema Desarmado");
	__POINTW2MN _0x40009,46
	RJMP _0x40013
; 0002 003C break;
; 0002 003D 
; 0002 003E case ST_SHOCK:
_0x4000C:
	CPI  R30,LOW(0x4)
	BRNE _0x4000D
; 0002 003F lcd_puts("Alerta: Intrusao");
	__POINTW2MN _0x40009,64
	RCALL _lcd_puts
; 0002 0040 lcd_gotoxy(0, 1);
	RCALL SUBOPT_0x2
; 0002 0041 lcd_puts("Senha: _ _ _ _");
	__POINTW2MN _0x40009,81
	RJMP _0x40013
; 0002 0042 break;
; 0002 0043 
; 0002 0044 case ST_MOTION:
_0x4000D:
	CPI  R30,LOW(0x5)
	BRNE _0x4000E
; 0002 0045 lcd_puts("Alerta: Presenca");
	__POINTW2MN _0x40009,96
	RCALL _lcd_puts
; 0002 0046 lcd_gotoxy(0, 1);
	RCALL SUBOPT_0x2
; 0002 0047 lcd_puts("Senha: _ _ _ _");
	__POINTW2MN _0x40009,113
	RJMP _0x40013
; 0002 0048 break;
; 0002 0049 
; 0002 004A case ST_SMOKE:
_0x4000E:
	CPI  R30,LOW(0x6)
	BRNE _0x4000F
; 0002 004B lcd_puts("Alerta: Fumaça");
	__POINTW2MN _0x40009,128
	RCALL _lcd_puts
; 0002 004C lcd_gotoxy(0, 1);
	RCALL SUBOPT_0x2
; 0002 004D lcd_puts("Senha: _ _ _ _");
	__POINTW2MN _0x40009,144
	RJMP _0x40013
; 0002 004E break;
; 0002 004F 
; 0002 0050 case ST_OVERHEAT:
_0x4000F:
	CPI  R30,LOW(0x7)
	BRNE _0x40010
; 0002 0051 lcd_puts("Superaquecimento");
	__POINTW2MN _0x40009,159
	RCALL _lcd_puts
; 0002 0052 lcd_gotoxy(0, 1);
	RCALL SUBOPT_0x2
; 0002 0053 lcd_puts("Senha: _ _ _ _");
	__POINTW2MN _0x40009,176
	RJMP _0x40013
; 0002 0054 break;
; 0002 0055 
; 0002 0056 case ST_ERROR:
_0x40010:
	CPI  R30,LOW(0x8)
	BRNE _0x40012
; 0002 0057 lcd_puts("Erro no Sistema");
	__POINTW2MN _0x40009,191
	RJMP _0x40013
; 0002 0058 break;
; 0002 0059 
; 0002 005A default:
_0x40012:
; 0002 005B lcd_puts("Estado Desconhecido");
	__POINTW2MN _0x40009,207
_0x40013:
	RCALL _lcd_puts
; 0002 005C break;
; 0002 005D }
; 0002 005E }
	JMP  _0x2080001
; .FEND

	.DSEG
_0x40009:
	.BYTE 0xE3

	.DSEG
;void PasswordStart(void)
; 0003 000D {

	.CSEG
_PasswordStart:
; .FSTART _PasswordStart
; 0003 000E password_length = 0;
	RCALL SUBOPT_0x3
; 0003 000F password_entry_active = 1;
	STS  _password_entry_active_G003,R30
; 0003 0010 }
	RET
; .FEND
;void PasswordInput(unsigned char input)
; 0003 0013 {
_PasswordInput:
; .FSTART _PasswordInput
; 0003 0014 if (password_length >= PASSWORD_LENGTH)
	ST   -Y,R17
	MOV  R17,R26
;	input -> R17
	LDS  R26,_password_length_G003
	CPI  R26,LOW(0x4)
	BRLO _0x60004
; 0003 0015 return;
	JMP  _0x2080001
; 0003 0016 
; 0003 0017 password_input[password_length] = input;
_0x60004:
	LDS  R30,_password_length_G003
	LDI  R31,0
	SUBI R30,LOW(-_password_input_G003)
	SBCI R31,HIGH(-_password_input_G003)
	ST   Z,R17
; 0003 0018 password_length++;
	LDS  R30,_password_length_G003
	SUBI R30,-LOW(1)
	STS  _password_length_G003,R30
; 0003 0019 
; 0003 001A UpdatePasswordDisplay(input, password_length);
	ST   -Y,R17
	LDS  R26,_password_length_G003
	RCALL _UpdatePasswordDisplay
; 0003 001B }
	JMP  _0x2080001
; .FEND
;void CleanLastDigit(void)
; 0003 001E {
_CleanLastDigit:
; .FSTART _CleanLastDigit
; 0003 001F if (password_length > 0)
	LDS  R26,_password_length_G003
	CPI  R26,LOW(0x1)
	BRLO _0x60005
; 0003 0020 {
; 0003 0021 password_length--;
	LDS  R30,_password_length_G003
	SUBI R30,LOW(1)
	STS  _password_length_G003,R30
; 0003 0022 lcd_gotoxy(7 + 2 * password_length, 1);
	LSL  R30
	SUBI R30,-LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0003 0023 lcd_putchar('_');
	LDI  R26,LOW(95)
	RCALL _lcd_putchar
; 0003 0024 }
; 0003 0025 }
_0x60005:
	RET
; .FEND
;PasswordResult PasswordConfirm(void)
; 0003 0028 {
_PasswordConfirm:
; .FSTART _PasswordConfirm
; 0003 0029 unsigned char i;
; 0003 002A 
; 0003 002B if (!password_entry_active || password_length < PASSWORD_LENGTH)
	ST   -Y,R17
;	i -> R17
	LDS  R30,_password_entry_active_G003
	CPI  R30,0
	BREQ _0x60007
	LDS  R26,_password_length_G003
	CPI  R26,LOW(0x4)
	BRSH _0x60006
_0x60007:
; 0003 002C return PASSWORD_PENDING;
	LDI  R30,LOW(0)
	JMP  _0x2080001
; 0003 002D 
; 0003 002E for (i = 0; i < PASSWORD_LENGTH; i++)
_0x60006:
	LDI  R17,LOW(0)
_0x6000A:
	CPI  R17,4
	BRSH _0x6000B
; 0003 002F {
; 0003 0030 if (password_input[i] != password[i])
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_password_input_G003)
	SBCI R31,HIGH(-_password_input_G003)
	LD   R26,Z
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_password_G003)
	SBCI R31,HIGH(-_password_G003)
	LD   R30,Z
	CP   R30,R26
	BREQ _0x6000C
; 0003 0031 {
; 0003 0032 WrongPasswordDisplay();
	RCALL _WrongPasswordDisplay
; 0003 0033 PasswordStart();
	RCALL _PasswordStart
; 0003 0034 return PASSWORD_INCORRECT;
	LDI  R30,LOW(2)
	JMP  _0x2080001
; 0003 0035 }
; 0003 0036 }
_0x6000C:
	SUBI R17,-1
	RJMP _0x6000A
_0x6000B:
; 0003 0037 
; 0003 0038 CorrectPasswordDisplay();
	RCALL _CorrectPasswordDisplay
; 0003 0039 password_entry_active = 0;
	LDI  R30,LOW(0)
	STS  _password_entry_active_G003,R30
; 0003 003A password_length = 0;
	RCALL SUBOPT_0x3
; 0003 003B return PASSWORD_CORRECT;
	JMP  _0x2080001
; 0003 003C }
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;interrupt [7] void timer1_compa_isr(void)
; 0004 0007 {

	.CSEG
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
	ST   -Y,R30
	ST   -Y,R31
; 0004 0008 TCNT1 = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0004 0009 flag_tim1 = 1;
	LDI  R30,LOW(1)
	STS  _flag_tim1_G004,R30
; 0004 000A }
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;void TIMER1Init(void)
; 0004 000D {
_TIMER1Init:
; .FSTART _TIMER1Init
; 0004 000E // Registradores para configurar o Timer1
; 0004 000F TCCR1B = 0x05; // Prescaler de 64
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0004 0010 TIMSK = 0x10; // Habilita interrupção do Timer1 via comparacao registrador A
	LDI  R30,LOW(16)
	OUT  0x39,R30
; 0004 0011 OCR1A = 0x00;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0004 0012 }
	RET
; .FEND
;void UpdateTIMER1CompareValue(unsigned int time)
; 0004 0015 {
; 0004 0016 // Recebe um periodo em ms e atualiza o valor do registrador de comparacao A do Timer1
; 0004 0017 OCR1A = (14400UL * time) / 1000UL - 1;
;	time -> R16,R17
; 0004 0018 }
;unsigned char GetTIMER1Flag(void)
; 0004 001B {
; 0004 001C return flag_tim1;
; 0004 001D }
;void SetTIMER1Flag(unsigned char value)
; 0004 0020 {
; 0004 0021 flag_tim1 = value;
;	value -> R17
; 0004 0022 }
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;interrupt [10] void timer0_ovf_isr(void)
; 0005 0019 {

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0005 001A // Interrupção do Timer0 para varredura do teclado a cada 2ms
; 0005 001B static byte key_pressed_counter = 10;

	.DSEG

	.CSEG
; 0005 001C static byte key_released_counter, column = FIRST_COLUMN;

	.DSEG

	.CSEG
; 0005 001D static unsigned row_data, crt_key;
; 0005 001E 
; 0005 001F // Reinicia o timer0
; 0005 0020 TCNT0 = 0x8D; // 2ms
	LDI  R30,LOW(141)
	OUT  0x32,R30
; 0005 0021 
; 0005 0022 row_data <<= 4;
	RCALL SUBOPT_0x4
	RCALL __LSLW4
	RCALL SUBOPT_0x5
; 0005 0023 row_data |= ~(KEYIN)&0xF; // le as linhas do teclado
	IN   R30,0x13
	COM  R30
	ANDI R30,LOW(0xF)
	RCALL SUBOPT_0x6
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	RCALL SUBOPT_0x5
; 0005 0024 column >>= 1; // muda para a proxima coluna
	LDS  R30,_column_S0050000000
	LSR  R30
	STS  _column_S0050000000,R30
; 0005 0025 
; 0005 0026 if(column == (LAST_COLUMN >> 1)) // se chegou na ultima coluna
	LDS  R26,_column_S0050000000
	CPI  R26,LOW(0x8)
	BRNE _0xA0005
; 0005 0027 {
; 0005 0028 column = FIRST_COLUMN; // volta para a primeira coluna
	LDI  R30,LOW(64)
	STS  _column_S0050000000,R30
; 0005 0029 
; 0005 002A // Verifica se alguma tecla foi pressionada, logica para debouncing
; 0005 002B if(row_data == 0)
	RCALL SUBOPT_0x4
	SBIW R30,0
	BREQ _0xA0007
; 0005 002C {
; 0005 002D goto new_key;
; 0005 002E }
; 0005 002F if(key_released_counter)
	LDS  R30,_key_released_counter_S0050000000
	CPI  R30,0
	BREQ _0xA0008
; 0005 0030 {
; 0005 0031 --key_released_counter;
	SUBI R30,LOW(1)
	RJMP _0xA001C
; 0005 0032 }
; 0005 0033 else
_0xA0008:
; 0005 0034 {
; 0005 0035 if(--key_pressed_counter == 9)
	LDS  R26,_key_pressed_counter_S0050000000
	SUBI R26,LOW(1)
	STS  _key_pressed_counter_S0050000000,R26
	CPI  R26,LOW(0x9)
	BRNE _0xA000A
; 0005 0036 {
; 0005 0037 crt_key = row_data;
	RCALL SUBOPT_0x4
	STS  _crt_key_S0050000000,R30
	STS  _crt_key_S0050000000+1,R31
; 0005 0038 }
; 0005 0039 else
	RJMP _0xA000B
_0xA000A:
; 0005 003A {
; 0005 003B if(row_data != crt_key)
	LDS  R30,_crt_key_S0050000000
	LDS  R31,_crt_key_S0050000000+1
	RCALL SUBOPT_0x6
	CP   R30,R26
	CPC  R31,R27
	BREQ _0xA000C
; 0005 003C {
; 0005 003D new_key:
_0xA0007:
; 0005 003E key_pressed_counter = 10;
	LDI  R30,LOW(10)
	STS  _key_pressed_counter_S0050000000,R30
; 0005 003F key_released_counter = 10;
	RJMP _0xA001C
; 0005 0040 goto end_key;
; 0005 0041 }
; 0005 0042 if(!key_pressed_counter)
_0xA000C:
	LDS  R30,_key_pressed_counter_S0050000000
	CPI  R30,0
	BRNE _0xA000E
; 0005 0043 {
; 0005 0044 keys = row_data;
	__GETWRMN 4,5,0,_row_data_S0050000000
; 0005 0045 key_released_counter = 20;
	LDI  R30,LOW(20)
_0xA001C:
	STS  _key_released_counter_S0050000000,R30
; 0005 0046 }
; 0005 0047 }
_0xA000E:
_0xA000B:
; 0005 0048 }
; 0005 0049 end_key:
; 0005 004A row_data = 0;
	LDI  R30,LOW(0)
	STS  _row_data_S0050000000,R30
	STS  _row_data_S0050000000+1,R30
; 0005 004B }
; 0005 004C KEYOUT = ~column; // seleciona a proxima coluna do teclado
_0xA0005:
	LDS  R30,_column_S0050000000
	COM  R30
	OUT  0x15,R30
; 0005 004D }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;unsigned InKey(void)
; 0005 0050 {
_InKey:
; .FSTART _InKey
; 0005 0051 // Retorna o valor da tecla pressionada, se houver
; 0005 0052 unsigned k;
; 0005 0053 if (k=keys)
	ST   -Y,R17
	ST   -Y,R16
;	k -> R16,R17
	MOVW R30,R4
	MOVW R16,R30
	SBIW R30,0
	BREQ _0xA000F
; 0005 0054 keys = 0;
	CLR  R4
	CLR  R5
; 0005 0055 return k;
_0xA000F:
	MOVW R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0005 0056 }
; .FEND
;void KEYPAD_init(void)
; 0005 0059 {
_KEYPAD_init:
; .FSTART _KEYPAD_init
; 0005 005A // Configuracoes dos registradores do teclado
; 0005 005B DDRC |= 0x70; // Bits 0..3: entrada, 4..6: saida - Ultima coluna inativa
	IN   R30,0x14
	ORI  R30,LOW(0x70)
	OUT  0x14,R30
; 0005 005C PORTC |= 0x7f; // saida alta em 4..6
	IN   R30,0x15
	ORI  R30,LOW(0x7F)
	OUT  0x15,R30
; 0005 005D 
; 0005 005E // Configuracoes do Timer0 para varredura do teclado a cada 2ms
; 0005 005F TCCR0 |= 0x04;
	IN   R30,0x33
	ORI  R30,4
	OUT  0x33,R30
; 0005 0060 TCNT0 |= 0x8D;
	IN   R30,0x32
	ORI  R30,LOW(0x8D)
	OUT  0x32,R30
; 0005 0061 
; 0005 0062 TIMSK |= 0x01; // habilita interrupcao do Timer0
	IN   R30,0x39
	ORI  R30,1
	OUT  0x39,R30
; 0005 0063 }
	RET
; .FEND
;unsigned char KeyToIndex (unsigned key)
; 0005 0066 {
_KeyToIndex:
; .FSTART _KeyToIndex
; 0005 0067 // Converte o valor da tecla pressionada para um índice de 0 a 11
; 0005 0068 unsigned char i;
; 0005 0069 
; 0005 006A for (i = 0; i < 12; i++)
	RCALL __SAVELOCR4
	MOVW R18,R26
;	key -> R18,R19
;	i -> R17
	LDI  R17,LOW(0)
_0xA0011:
	CPI  R17,12
	BRSH _0xA0012
; 0005 006B {
; 0005 006C if (key & (1U << i))
	MOV  R30,R17
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL __LSLW12
	AND  R30,R18
	AND  R31,R19
	SBIW R30,0
	BREQ _0xA0013
; 0005 006D 
; 0005 006E return i;
	MOV  R30,R17
	RJMP _0x2080002
; 0005 006F }
_0xA0013:
	SUBI R17,-1
	RJMP _0xA0011
_0xA0012:
; 0005 0070 }
	RJMP _0x2080002
; .FEND
;void KEYPADProcess(SystemState state)
; 0005 0073 {
_KEYPADProcess:
; .FSTART _KEYPADProcess
; 0005 0074 // Processa a tecla pressionada, se houver
; 0005 0075 unsigned k;
; 0005 0076 unsigned char index;
; 0005 0077 char key;
; 0005 0078 PasswordResult password_result;
; 0005 0079 
; 0005 007A if(k=InKey())
	RCALL __SAVELOCR6
	MOV  R20,R26
;	state -> R20
;	k -> R16,R17
;	index -> R19
;	key -> R18
;	password_result -> R21
	RCALL _InKey
	MOVW R16,R30
	SBIW R30,0
	BREQ _0xA0014
; 0005 007B {
; 0005 007C index = KeyToIndex(k);
	MOVW R26,R16
	RCALL _KeyToIndex
	MOV  R19,R30
; 0005 007D key = keymap[index];
	RCALL SUBOPT_0x7
	LPM  R18,Z
; 0005 007E if (key == '<') // Tecla *
	CPI  R18,60
	BRNE _0xA0015
; 0005 007F {
; 0005 0080 CleanLastDigit();
	RCALL _CleanLastDigit
; 0005 0081 }
; 0005 0082 else if (key == '#') // Tecla #
	RJMP _0xA0016
_0xA0015:
	CPI  R18,35
	BRNE _0xA0017
; 0005 0083 {
; 0005 0084 password_result = PasswordConfirm();
	RCALL _PasswordConfirm
	MOV  R21,R30
; 0005 0085 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0005 0086 if (password_result == PASSWORD_INCORRECT)
	CPI  R21,2
	BRNE _0xA0018
; 0005 0087 SystemSetState(state);
	MOV  R26,R20
	RJMP _0xA001D
; 0005 0088 else if (password_result == PASSWORD_CORRECT)
_0xA0018:
	CPI  R21,1
	BRNE _0xA001A
; 0005 0089 SystemSetState(ST_DISARMED);
	LDI  R26,LOW(3)
_0xA001D:
	RCALL _SystemSetState
; 0005 008A }
_0xA001A:
; 0005 008B else
	RJMP _0xA001B
_0xA0017:
; 0005 008C {
; 0005 008D PasswordInput(keymap[index]);
	RCALL SUBOPT_0x7
	LPM  R26,Z
	RCALL _PasswordInput
; 0005 008E }
_0xA001B:
_0xA0016:
; 0005 008F }
; 0005 0090 }
_0xA0014:
	RCALL __LOADLOCR6
	ADIW R28,6
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	MOV  R30,R17
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 25
	SBI  0x1B,2
	__DELAY_USB 25
	CBI  0x1B,2
	__DELAY_USB 25
	RJMP _0x2080001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 246
	ADIW R28,1
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	RCALL SUBOPT_0x0
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	ADD  R30,R16
	MOV  R26,R30
	RCALL __lcd_write_data
	MOV  R7,R16
	MOV  R6,R17
_0x2080003:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x8
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x8
	LDI  R30,LOW(0)
	MOV  R6,R30
	MOV  R7,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R17
	MOV  R17,R26
	CPI  R17,10
	BREQ _0x2000005
	CP   R7,R9
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R6
	MOV  R26,R6
	RCALL _lcd_gotoxy
	CPI  R17,10
	BREQ _0x2080001
_0x2000004:
	INC  R7
	SBI  0x1B,0
	MOV  R26,R17
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2080001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	RCALL __SAVELOCR4
	MOVW R18,R26
_0x2000008:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
_0x2080002:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	MOV  R9,R17
	MOV  R30,R17
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	MOV  R30,R17
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x9
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 369
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080001:
	LD   R17,Y+
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_current_state_G001:
	.BYTE 0x1
_password_G003:
	.BYTE 0x4
_password_length_G003:
	.BYTE 0x1
_password_input_G003:
	.BYTE 0x4
_password_entry_active_G003:
	.BYTE 0x1
_flag_tim1_G004:
	.BYTE 0x1
_key_pressed_counter_S0050000000:
	.BYTE 0x1
_key_released_counter_S0050000000:
	.BYTE 0x1
_column_S0050000000:
	.BYTE 0x1
_row_data_S0050000000:
	.BYTE 0x2
_crt_key_S0050000000:
	.BYTE 0x2
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	ST   -Y,R17
	ST   -Y,R16
	MOV  R17,R26
	LDD  R16,Y+2
	MOV  R30,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	SUBI R30,LOW(1)
	LSL  R30
	SUBI R30,-LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	STS  _password_length_G003,R30
	LDI  R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	LDS  R30,_row_data_S0050000000
	LDS  R31,_row_data_S0050000000+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	STS  _row_data_S0050000000,R30
	STS  _row_data_S0050000000+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDS  R26,_row_data_S0050000000
	LDS  R27,_row_data_S0050000000+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	MOV  R30,R19
	LDI  R31,0
	SUBI R30,LOW(-_keymap_G005*2)
	SBCI R31,HIGH(-_keymap_G005*2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 369
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	LDI  R30,8
	MOV  R1,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12S8:
	CP   R0,R1
	BRLO __LSLW12L
	MOV  R31,R30
	LDI  R30,0
	SUB  R0,R1
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xE66
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:

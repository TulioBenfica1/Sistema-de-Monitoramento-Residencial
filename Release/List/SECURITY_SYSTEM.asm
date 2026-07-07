
;CodeVisionAVR C Compiler V2.05.0 Advanced
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 14,745600 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
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
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
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
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
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

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0005

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
	.DB  0x41,0x74,0x69,0x76,0x65,0x20,0x6F,0x20
	.DB  0x73,0x69,0x73,0x74,0x65,0x6D,0x61,0x3A
	.DB  0x0,0x53,0x65,0x6E,0x68,0x61,0x3A,0x20
	.DB  0x5F,0x20,0x5F,0x20,0x5F,0x20,0x5F,0x20
	.DB  0x20,0x0,0x41,0x6C,0x65,0x72,0x74,0x61
	.DB  0x3A,0x20,0x49,0x6E,0x74,0x72,0x75,0x73
	.DB  0x61,0x6F,0x0,0x41,0x6C,0x65,0x72,0x74
	.DB  0x61,0x3A,0x20,0x50,0x72,0x65,0x73,0x65
	.DB  0x6E,0x63,0x61,0x0,0x41,0x6C,0x65,0x72
	.DB  0x74,0x61,0x3A,0x20,0x49,0x6E,0x63,0x65
	.DB  0x6E,0x64,0x69,0x6F,0x0,0x53,0x75,0x70
	.DB  0x65,0x72,0x61,0x71,0x75,0x65,0x63,0x69
	.DB  0x6D,0x65,0x6E,0x74,0x6F,0x0,0x45,0x72
	.DB  0x72,0x6F,0x20,0x6E,0x6F,0x20,0x53,0x69
	.DB  0x73,0x74,0x65,0x6D,0x61,0x0,0x45,0x73
	.DB  0x74,0x61,0x64,0x6F,0x20,0x44,0x65,0x73
	.DB  0x63,0x6F,0x6E,0x68,0x65,0x63,0x69,0x64
	.DB  0x6F,0x0
_0x60003:
	.DB  0x32,0x32,0x33,0x34
_0xA0003:
	.DB  0xA
_0xA0004:
	.DB  0x40
_0xA0000:
	.DB  0x20,0x20,0x20,0x20,0x53,0x69,0x73,0x74
	.DB  0x65,0x6D,0x61,0x0,0x20,0x20,0x44,0x65
	.DB  0x73,0x61,0x72,0x6D,0x61,0x64,0x6F,0x0
_0xE0008:
	.DB  0x8A,0x2,0x26,0x2
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

	.DW  0x11
	.DW  _0x40009+46
	.DW  _0x40000*2+72

	.DW  0x11
	.DW  _0x40009+63
	.DW  _0x40000*2+89

	.DW  0x11
	.DW  _0x40009+80
	.DW  _0x40000*2+106

	.DW  0x11
	.DW  _0x40009+97
	.DW  _0x40000*2+89

	.DW  0x11
	.DW  _0x40009+114
	.DW  _0x40000*2+123

	.DW  0x11
	.DW  _0x40009+131
	.DW  _0x40000*2+89

	.DW  0x11
	.DW  _0x40009+148
	.DW  _0x40000*2+140

	.DW  0x11
	.DW  _0x40009+165
	.DW  _0x40000*2+89

	.DW  0x11
	.DW  _0x40009+182
	.DW  _0x40000*2+157

	.DW  0x11
	.DW  _0x40009+199
	.DW  _0x40000*2+89

	.DW  0x10
	.DW  _0x40009+216
	.DW  _0x40000*2+174

	.DW  0x14
	.DW  _0x40009+232
	.DW  _0x40000*2+190

	.DW  0x04
	.DW  _password_G003
	.DW  _0x60003*2

	.DW  0x01
	.DW  _key_pressed_counter_S0050000000
	.DW  _0xA0003*2

	.DW  0x01
	.DW  _column_S0050000000
	.DW  _0xA0004*2

	.DW  0x0C
	.DW  _0xA001D
	.DW  _0xA0000*2

	.DW  0x0C
	.DW  _0xA001D+12
	.DW  _0xA0000*2+12

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

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

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

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
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega16.h>
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
;#include "config.h"
;
;void main(void)
; 0000 0005 {

	.CSEG
_main:
; 0000 0006     SystemInit();
	RCALL _SystemInit
; 0000 0007 
; 0000 0008     while (1)
_0x3:
; 0000 0009     {
; 0000 000A         SystemUpdate();
	RCALL _SystemUpdate
; 0000 000B         if(PIND.2 == 0)
	SBIC 0x10,2
	RJMP _0x6
; 0000 000C         {
; 0000 000D             SystemSetState(ST_MOTION);
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _SystemSetState
; 0000 000E         }
; 0000 000F         if(PIND.3 == 0)
_0x6:
	SBIC 0x10,3
	RJMP _0x7
; 0000 0010         {
; 0000 0011             SystemSetState(ST_FLAME);
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL _SystemSetState
; 0000 0012         }
; 0000 0013     }
_0x7:
	RJMP _0x3
; 0000 0014 }
_0x8:
	RJMP _0x8
;#include <mega16.h>
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
;#include <delay.h>
;#include "config.h"
;#include "lcd.h"
;#include "timer.h"
;#include "pwm.h"
;#include "keypad.h"
;#include "buzzer.h"
;#include "password.h"
;#include "sensors.h"
;
;static SystemState current_state;
;static bit lcd_update_pending = 1;
;static bit keypad_entry = 0;
;
;void SystemInit(void)
; 0001 0011 {

	.CSEG
_SystemInit:
; 0001 0012     // Configuração de registradores
; 0001 0013     LCDInit();
	RCALL _LCDInit
; 0001 0014     KEYPADInit();
	CALL _KEYPADInit
; 0001 0015     TIMER1Init();
	CALL _TIMER1Init
; 0001 0016     SENSORSInit();
	CALL _SENSORSInit
; 0001 0017     PWMInit();
	CALL _PWMInit
; 0001 0018     #asm("sei");
	sei
; 0001 0019 
; 0001 001A }
	RET
;
;void SystemUpdate(void)
; 0001 001D {
_SystemUpdate:
; 0001 001E     if (lcd_update_pending)
	SBRS R2,0
	RJMP _0x20003
; 0001 001F     {
; 0001 0020         LCDUpdate(current_state);
	LDS  R30,_current_state_G001
	ST   -Y,R30
	RCALL _LCDUpdate
; 0001 0021         if(current_state == ST_BOOT)
	LDS  R30,_current_state_G001
	CPI  R30,0
	BRNE _0x20004
; 0001 0022         {
; 0001 0023             delay_ms(5000);
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	CALL SUBOPT_0x0
; 0001 0024             LCDUpdate(ST_ARMING_DELAY);
	CALL SUBOPT_0x1
; 0001 0025             SystemSetState(ST_ARMING_DELAY);
; 0001 0026             return;
	RET
; 0001 0027         }
; 0001 0028         lcd_update_pending = 0;
_0x20004:
	CLT
	BLD  R2,0
; 0001 0029     }
; 0001 002A     if(keypad_entry)
_0x20003:
	SBRS R2,1
	RJMP _0x20005
; 0001 002B     {
; 0001 002C         KEYPADProcess(current_state);
	LDS  R30,_current_state_G001
	ST   -Y,R30
	CALL _KEYPADProcess
; 0001 002D     }
; 0001 002E     SensorsUpdate();
_0x20005:
	CALL _SensorsUpdate
; 0001 002F     //BuzzerUpdate(current_state);
; 0001 0030 }
	RET
;
;void SystemSetState(SystemState state)
; 0001 0033 {
_SystemSetState:
; 0001 0034     current_state = state;
;	state -> Y+0
	LD   R30,Y
	STS  _current_state_G001,R30
; 0001 0035     lcd_update_pending = 1;
	SET
	BLD  R2,0
; 0001 0036     if (state == ST_SHOCK || state == ST_MOTION ||
; 0001 0037         state == ST_FLAME || state == ST_OVERHEAT ||
; 0001 0038         state == ST_DISARMED)
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BREQ _0x20007
	CPI  R26,LOW(0x5)
	BREQ _0x20007
	CPI  R26,LOW(0x6)
	BREQ _0x20007
	CPI  R26,LOW(0x8)
	BREQ _0x20007
	CPI  R26,LOW(0x3)
	BRNE _0x20006
_0x20007:
; 0001 0039     {
; 0001 003A         keypad_entry = 1;
	SET
	BLD  R2,1
; 0001 003B         PasswordStart();
	RCALL _PasswordStart
; 0001 003C     }
; 0001 003D     else
	RJMP _0x20009
_0x20006:
; 0001 003E     {
; 0001 003F         keypad_entry = 0;
	CLT
	BLD  R2,1
; 0001 0040     }
_0x20009:
; 0001 0041 
; 0001 0042     if(state == ST_ARMING_DELAY)
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x2000A
; 0001 0043     {
; 0001 0044         //delay_ms(60000);         // tempo para ajuste de sensores
; 0001 0045         delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL SUBOPT_0x0
; 0001 0046         current_state = ST_ARMED;
	LDI  R30,LOW(1)
	STS  _current_state_G001,R30
; 0001 0047     }
; 0001 0048 }
_0x2000A:
	JMP  _0x2020001
;
;SystemState SystemGetState(void)
; 0001 004B {
; 0001 004C     return current_state;
; 0001 004D }
;#include <mega16.h>
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
;#include <alcd.h>
;#include <delay.h>
;
;#include "lcd.h"
;
;void LCDInit(void)
; 0002 0008 {

	.CSEG
_LCDInit:
; 0002 0009     // Configura os registradores para utilizar o LCD - Barramento A
; 0002 000A     DDRA |= 0x04;     // Configura o pino PA2 como saída para habilitar o LCD
	SBI  0x1A,2
; 0002 000B     lcd_init(16);     // Inicializa o LCD com 16 caracteres
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0002 000C     PORTA |= 0x08;    // Habilita o backlight do LCD
	SBI  0x1B,3
; 0002 000D     lcd_gotoxy(0, 0); // Posicão padrão do cursor no LCD
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0002 000E }
	RET
;
;void UpdatePasswordDisplay(unsigned char input, unsigned char length)
; 0002 0011 {
_UpdatePasswordDisplay:
; 0002 0012     lcd_gotoxy(7 + 2 * (length - 1), 1);
;	input -> Y+1
;	length -> Y+0
	CALL SUBOPT_0x2
; 0002 0013     lcd_putchar(input);
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _lcd_putchar
; 0002 0014     delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x0
; 0002 0015     lcd_gotoxy(7 + 2 * (length - 1), 1);
	CALL SUBOPT_0x2
; 0002 0016     lcd_putchar('*');
	LDI  R30,LOW(42)
	ST   -Y,R30
	CALL _lcd_putchar
; 0002 0017 }
	JMP  _0x2020003
;
;void WrongPasswordDisplay(void)
; 0002 001A {
_WrongPasswordDisplay:
; 0002 001B     lcd_gotoxy(0, 1);
	CALL SUBOPT_0x3
; 0002 001C     lcd_puts("Senha Incorreta");
	__POINTW1MN _0x40003,0
	RJMP _0x2020005
; 0002 001D }

	.DSEG
_0x40003:
	.BYTE 0x10
;
;void CorrectPasswordDisplay(void)
; 0002 0020 {

	.CSEG
_CorrectPasswordDisplay:
; 0002 0021     lcd_clear();
	CALL _lcd_clear
; 0002 0022     lcd_puts("Senha Correta");
	__POINTW1MN _0x40004,0
_0x2020005:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0002 0023 }
	RET

	.DSEG
_0x40004:
	.BYTE 0xE
;
;void LCDUpdate(SystemState state)
; 0002 0026 {

	.CSEG
_LCDUpdate:
; 0002 0027     // Atualiza o display do LCD com base no estado atual do sistema
; 0002 0028     lcd_clear();
;	state -> Y+0
	CALL _lcd_clear
; 0002 0029 
; 0002 002A     switch (state)
	LD   R30,Y
	LDI  R31,0
; 0002 002B     {
; 0002 002C         case ST_BOOT:
	SBIW R30,0
	BRNE _0x40008
; 0002 002D             lcd_puts("Ligando...");
	__POINTW1MN _0x40009,0
	RJMP _0x40014
; 0002 002E             break;
; 0002 002F 
; 0002 0030         case ST_ARMED:
_0x40008:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x4000A
; 0002 0031             lcd_puts("Sistema Armado");
	__POINTW1MN _0x40009,11
	RJMP _0x40014
; 0002 0032             break;
; 0002 0033 
; 0002 0034         case ST_ARMING_DELAY:
_0x4000A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x4000B
; 0002 0035             lcd_puts("Armando Sistema");
	__POINTW1MN _0x40009,26
	CALL SUBOPT_0x4
; 0002 0036             lcd_gotoxy(0, 1);
; 0002 0037             lcd_puts("...");
	__POINTW1MN _0x40009,42
	RJMP _0x40014
; 0002 0038             break;
; 0002 0039 
; 0002 003A         case ST_DISARMED:
_0x4000B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x4000C
; 0002 003B             lcd_puts("Ative o sistema:");
	__POINTW1MN _0x40009,46
	CALL SUBOPT_0x4
; 0002 003C             lcd_gotoxy(0, 1);
; 0002 003D             lcd_puts("Senha: _ _ _ _  ");
	__POINTW1MN _0x40009,63
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0002 003E 
; 0002 003F         case ST_SHOCK:
	RJMP _0x4000D
_0x4000C:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x4000E
_0x4000D:
; 0002 0040             lcd_puts("Alerta: Intrusao");
	__POINTW1MN _0x40009,80
	CALL SUBOPT_0x4
; 0002 0041             lcd_gotoxy(0, 1);
; 0002 0042             lcd_puts("Senha: _ _ _ _  ");
	__POINTW1MN _0x40009,97
	RJMP _0x40014
; 0002 0043             break;
; 0002 0044 
; 0002 0045         case ST_MOTION:
_0x4000E:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x4000F
; 0002 0046             lcd_puts("Alerta: Presenca");
	__POINTW1MN _0x40009,114
	CALL SUBOPT_0x4
; 0002 0047             lcd_gotoxy(0, 1);
; 0002 0048             lcd_puts("Senha: _ _ _ _  ");
	__POINTW1MN _0x40009,131
	RJMP _0x40014
; 0002 0049             break;
; 0002 004A 
; 0002 004B         case ST_FLAME:
_0x4000F:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x40010
; 0002 004C             lcd_puts("Alerta: Incendio");
	__POINTW1MN _0x40009,148
	CALL SUBOPT_0x4
; 0002 004D             lcd_gotoxy(0, 1);
; 0002 004E             lcd_puts("Senha: _ _ _ _  ");
	__POINTW1MN _0x40009,165
	RJMP _0x40014
; 0002 004F             break;
; 0002 0050 
; 0002 0051         case ST_OVERHEAT:
_0x40010:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x40011
; 0002 0052             lcd_puts("Superaquecimento");
	__POINTW1MN _0x40009,182
	CALL SUBOPT_0x4
; 0002 0053             lcd_gotoxy(0, 1);
; 0002 0054             lcd_puts("Senha: _ _ _ _  ");
	__POINTW1MN _0x40009,199
	RJMP _0x40014
; 0002 0055             break;
; 0002 0056 
; 0002 0057         case ST_ERROR:
_0x40011:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x40013
; 0002 0058             lcd_puts("Erro no Sistema");
	__POINTW1MN _0x40009,216
	RJMP _0x40014
; 0002 0059             break;
; 0002 005A 
; 0002 005B         default:
_0x40013:
; 0002 005C             lcd_puts("Estado Desconhecido");
	__POINTW1MN _0x40009,232
_0x40014:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0002 005D             break;
; 0002 005E     }
; 0002 005F }
	JMP  _0x2020001

	.DSEG
_0x40009:
	.BYTE 0xFC
;#include <alcd.h>
;#include "password.h"
;#include "lcd.h"
;
;#define PASSWORD_LENGTH 4
;
;static unsigned char password[PASSWORD_LENGTH] = {'2', '2', '3', '4'};

	.DSEG
;static unsigned char password_length;
;static unsigned char password_input[PASSWORD_LENGTH];
;static unsigned char password_entry_active;
;
;void PasswordStart(void)
; 0003 000D {

	.CSEG
_PasswordStart:
; 0003 000E     password_length = 0;
	LDI  R30,LOW(0)
	STS  _password_length_G003,R30
; 0003 000F     password_entry_active = 1;
	LDI  R30,LOW(1)
	STS  _password_entry_active_G003,R30
; 0003 0010 }
	RET
;
;void PasswordInput(unsigned char input)
; 0003 0013 {
_PasswordInput:
; 0003 0014     if (password_length >= PASSWORD_LENGTH)
;	input -> Y+0
	LDS  R26,_password_length_G003
	CPI  R26,LOW(0x4)
	BRLO _0x60004
; 0003 0015         return;
	JMP  _0x2020001
; 0003 0016 
; 0003 0017     password_input[password_length] = input;
_0x60004:
	LDS  R30,_password_length_G003
	LDI  R31,0
	SUBI R30,LOW(-_password_input_G003)
	SBCI R31,HIGH(-_password_input_G003)
	LD   R26,Y
	STD  Z+0,R26
; 0003 0018     password_length++;
	LDS  R30,_password_length_G003
	SUBI R30,-LOW(1)
	STS  _password_length_G003,R30
; 0003 0019 
; 0003 001A     UpdatePasswordDisplay(input, password_length);
	LD   R30,Y
	ST   -Y,R30
	LDS  R30,_password_length_G003
	ST   -Y,R30
	RCALL _UpdatePasswordDisplay
; 0003 001B }
	JMP  _0x2020001
;
;void CleanLastDigit(void)
; 0003 001E {
_CleanLastDigit:
; 0003 001F     if (password_length > 0)
	LDS  R26,_password_length_G003
	CPI  R26,LOW(0x1)
	BRLO _0x60005
; 0003 0020     {
; 0003 0021         password_length--;
	LDS  R30,_password_length_G003
	SUBI R30,LOW(1)
	STS  _password_length_G003,R30
; 0003 0022         lcd_gotoxy(7 + 2 * password_length, 1);
	LSL  R30
	SUBI R30,-LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0003 0023         lcd_putchar('_');
	LDI  R30,LOW(95)
	ST   -Y,R30
	CALL _lcd_putchar
; 0003 0024     }
; 0003 0025 }
_0x60005:
	RET
;
;PasswordResult PasswordConfirm(void)
; 0003 0028 {
_PasswordConfirm:
; 0003 0029     unsigned char i;
; 0003 002A 
; 0003 002B     if (!password_entry_active || password_length < PASSWORD_LENGTH)
	ST   -Y,R17
;	i -> R17
	LDS  R30,_password_entry_active_G003
	CPI  R30,0
	BREQ _0x60007
	LDS  R26,_password_length_G003
	CPI  R26,LOW(0x4)
	BRSH _0x60006
_0x60007:
; 0003 002C         return PASSWORD_PENDING;
	LDI  R30,LOW(0)
	RJMP _0x2020004
; 0003 002D 
; 0003 002E     for (i = 0; i < PASSWORD_LENGTH; i++)
_0x60006:
	LDI  R17,LOW(0)
_0x6000A:
	CPI  R17,4
	BRSH _0x6000B
; 0003 002F     {
; 0003 0030         if (password_input[i] != password[i])
	MOV  R30,R17
	LDI  R31,0
	MOVW R0,R30
	SUBI R30,LOW(-_password_input_G003)
	SBCI R31,HIGH(-_password_input_G003)
	LD   R26,Z
	MOVW R30,R0
	SUBI R30,LOW(-_password_G003)
	SBCI R31,HIGH(-_password_G003)
	LD   R30,Z
	CP   R30,R26
	BREQ _0x6000C
; 0003 0031         {
; 0003 0032             WrongPasswordDisplay();
	RCALL _WrongPasswordDisplay
; 0003 0033             PasswordStart();
	RCALL _PasswordStart
; 0003 0034             return PASSWORD_INCORRECT;
	LDI  R30,LOW(2)
	RJMP _0x2020004
; 0003 0035         }
; 0003 0036     }
_0x6000C:
	SUBI R17,-1
	RJMP _0x6000A
_0x6000B:
; 0003 0037 
; 0003 0038     CorrectPasswordDisplay();
	RCALL _CorrectPasswordDisplay
; 0003 0039     password_entry_active = 0;
	LDI  R30,LOW(0)
	STS  _password_entry_active_G003,R30
; 0003 003A     password_length = 0;
	STS  _password_length_G003,R30
; 0003 003B     return PASSWORD_CORRECT;
	LDI  R30,LOW(1)
_0x2020004:
	LD   R17,Y+
	RET
; 0003 003C }
;#include <mega16.h>
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
;#include "timer.h"
;
;static volatile unsigned char flag_tim1 = 0;
;
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0004 0007 {

	.CSEG
_timer1_compa_isr:
	ST   -Y,R30
	ST   -Y,R31
; 0004 0008     TCNT1 = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0004 0009     flag_tim1 = 1;
	LDI  R30,LOW(1)
	STS  _flag_tim1_G004,R30
; 0004 000A }
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;void TIMER1Init(void)
; 0004 000D {
_TIMER1Init:
; 0004 000E     // Registradores para configurar o Timer1
; 0004 000F     TCCR1B = 0x05; // Prescaler de 64
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0004 0010     TIMSK |= 0x10; // Habilita interrupção do Timer1 sem desabilitar o Timer0
	IN   R30,0x39
	ORI  R30,0x10
	OUT  0x39,R30
; 0004 0011     OCR1A = 0x00;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0004 0012 }
	RET
;
;void UpdateTIMER1CompareValue(unsigned int time)
; 0004 0015 {
_UpdateTIMER1CompareValue:
; 0004 0016     // Recebe um periodo em ms e atualiza o valor do registrador de comparacao A do Timer1
; 0004 0017     OCR1A = (int)((14400UL * time) / 1000UL) - 1;
;	time -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	CLR  R22
	CLR  R23
	__GETD2N 0x3840
	CALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3E8
	CALL __DIVD21U
	CLR  R22
	CLR  R23
	SBIW R30,1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0004 0018 }
	JMP  _0x2020003
;
;unsigned char GetTIMER1Flag(void)
; 0004 001B {
_GetTIMER1Flag:
; 0004 001C     return flag_tim1;
	LDS  R30,_flag_tim1_G004
	RET
; 0004 001D }
;
;void SetTIMER1Flag(unsigned char value)
; 0004 0020 {
_SetTIMER1Flag:
; 0004 0021     flag_tim1 = value;
;	value -> Y+0
	LD   R30,Y
	STS  _flag_tim1_G004,R30
; 0004 0022 }
	JMP  _0x2020001
;#include <mega16.h>
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
;#include <delay.h>
;#include <alcd.h>
;#include "config.h"
;#include "keypad.h"
;#include "password.h"
;#include "buzzer.h"
;#include "lcd.h"
;
;#define KEYIN PINC // PINC0..3 para entrada do teclado nas linhas
;#define KEYOUT PORTC // PORTC4..6 para saida do teclado nas colunas
;#define FIRST_COLUMN 0x40
;#define LAST_COLUMN 0x10
;
;#define ROW_LENGTH 4
;#define COLUMN_LENGTH 3
;
;typedef unsigned char byte;
;unsigned keys; // armazena cada estado da chave
;
;static const char keymap[ROW_LENGTH * COLUMN_LENGTH] = {
;   '1', '4', '7', '<',
;   '2', '5', '8', '0',
;   '3', '6', '9', '#'
;};
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0005 001C {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0005 001D    // Interrupção do Timer0 para varredura do teclado a cada 2ms
; 0005 001E    static byte key_pressed_counter = 10;

	.DSEG

	.CSEG
; 0005 001F    static byte key_released_counter, column = FIRST_COLUMN;

	.DSEG

	.CSEG
; 0005 0020    static unsigned row_data, crt_key;
; 0005 0021 
; 0005 0022    // Reinicia o timer0
; 0005 0023    TCNT0 = 0x8D; // 2ms
	LDI  R30,LOW(141)
	OUT  0x32,R30
; 0005 0024 
; 0005 0025    row_data <<= 4;
	CALL SUBOPT_0x5
	CALL __LSLW4
	STS  _row_data_S0050000000,R30
	STS  _row_data_S0050000000+1,R31
; 0005 0026    row_data |= ~(KEYIN)&0xF; // le as linhas do teclado
	IN   R30,0x13
	LDI  R31,0
	COM  R30
	COM  R31
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	LDS  R26,_row_data_S0050000000
	LDS  R27,_row_data_S0050000000+1
	OR   R30,R26
	OR   R31,R27
	STS  _row_data_S0050000000,R30
	STS  _row_data_S0050000000+1,R31
; 0005 0027    column >>= 1; // muda para a proxima coluna
	LDS  R30,_column_S0050000000
	LDI  R31,0
	ASR  R31
	ROR  R30
	STS  _column_S0050000000,R30
; 0005 0028 
; 0005 0029    if(column == (LAST_COLUMN >> 1)) // se chegou na ultima coluna
	LDS  R26,_column_S0050000000
	CPI  R26,LOW(0x8)
	BRNE _0xA0005
; 0005 002A    {
; 0005 002B       column = FIRST_COLUMN; // volta para a primeira coluna
	LDI  R30,LOW(64)
	STS  _column_S0050000000,R30
; 0005 002C 
; 0005 002D       // Verifica se alguma tecla foi pressionada, logica para debouncing
; 0005 002E       if(row_data == 0)
	CALL SUBOPT_0x5
	SBIW R30,0
	BREQ _0xA0007
; 0005 002F       {
; 0005 0030          goto new_key;
; 0005 0031       }
; 0005 0032       if(key_released_counter)
	LDS  R30,_key_released_counter_S0050000000
	CPI  R30,0
	BREQ _0xA0008
; 0005 0033       {
; 0005 0034          --key_released_counter;
	SUBI R30,LOW(1)
	RJMP _0xA001F
; 0005 0035       }
; 0005 0036       else
_0xA0008:
; 0005 0037       {
; 0005 0038          if(--key_pressed_counter == 9)
	LDS  R26,_key_pressed_counter_S0050000000
	SUBI R26,LOW(1)
	STS  _key_pressed_counter_S0050000000,R26
	CPI  R26,LOW(0x9)
	BRNE _0xA000A
; 0005 0039          {
; 0005 003A             crt_key = row_data;
	CALL SUBOPT_0x5
	STS  _crt_key_S0050000000,R30
	STS  _crt_key_S0050000000+1,R31
; 0005 003B          }
; 0005 003C          else
	RJMP _0xA000B
_0xA000A:
; 0005 003D          {
; 0005 003E             if(row_data != crt_key)
	LDS  R30,_crt_key_S0050000000
	LDS  R31,_crt_key_S0050000000+1
	LDS  R26,_row_data_S0050000000
	LDS  R27,_row_data_S0050000000+1
	CP   R30,R26
	CPC  R31,R27
	BREQ _0xA000C
; 0005 003F             {
; 0005 0040                new_key:
_0xA0007:
; 0005 0041                   key_pressed_counter = 10;
	LDI  R30,LOW(10)
	STS  _key_pressed_counter_S0050000000,R30
; 0005 0042                   key_released_counter = 10;
	RJMP _0xA001F
; 0005 0043                   goto end_key;
; 0005 0044             }
; 0005 0045             if(!key_pressed_counter)
_0xA000C:
	LDS  R30,_key_pressed_counter_S0050000000
	CPI  R30,0
	BRNE _0xA000E
; 0005 0046             {
; 0005 0047                keys = row_data;
	__GETWRMN 4,5,0,_row_data_S0050000000
; 0005 0048                key_released_counter = 20;
	LDI  R30,LOW(20)
_0xA001F:
	STS  _key_released_counter_S0050000000,R30
; 0005 0049             }
; 0005 004A          }
_0xA000E:
_0xA000B:
; 0005 004B       }
; 0005 004C    end_key:
; 0005 004D       row_data = 0;
	LDI  R30,LOW(0)
	STS  _row_data_S0050000000,R30
	STS  _row_data_S0050000000+1,R30
; 0005 004E    }
; 0005 004F    KEYOUT = ~column; // seleciona a proxima coluna do teclado
_0xA0005:
	LDS  R30,_column_S0050000000
	COM  R30
	OUT  0x15,R30
; 0005 0050 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;unsigned InKey(void)
; 0005 0053 {
_InKey:
; 0005 0054    // Retorna o valor da tecla pressionada, se houver
; 0005 0055    unsigned k;
; 0005 0056    if (k=keys)
	ST   -Y,R17
	ST   -Y,R16
;	k -> R16,R17
	MOVW R30,R4
	MOVW R16,R30
	SBIW R30,0
	BREQ _0xA000F
; 0005 0057       keys = 0;
	CLR  R4
	CLR  R5
; 0005 0058    return k;
_0xA000F:
	MOVW R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0005 0059 }
;
;void KEYPADInit(void)
; 0005 005C {
_KEYPADInit:
; 0005 005D    // Configuracoes dos registradores do teclado
; 0005 005E    DDRC |= 0x70; // Bits 0..3: entrada, 4..6: saida - Ultima coluna inativa
	IN   R30,0x14
	ORI  R30,LOW(0x70)
	OUT  0x14,R30
; 0005 005F    PORTC |= 0x7f; // saida alta em 4..6
	IN   R30,0x15
	ORI  R30,LOW(0x7F)
	OUT  0x15,R30
; 0005 0060 
; 0005 0061    // Configuracoes do Timer0 para varredura do teclado a cada 2ms
; 0005 0062    TCCR0 |= 0x04;
	IN   R30,0x33
	ORI  R30,4
	OUT  0x33,R30
; 0005 0063    TCNT0 |= 0x8D;
	IN   R30,0x32
	ORI  R30,LOW(0x8D)
	OUT  0x32,R30
; 0005 0064 
; 0005 0065    TIMSK |= 0x01; // habilita interrupcao do Timer0
	IN   R30,0x39
	ORI  R30,1
	OUT  0x39,R30
; 0005 0066 }
	RET
;
;unsigned char KeyToIndex (unsigned key)
; 0005 0069 {
_KeyToIndex:
; 0005 006A    // Converte o valor da tecla pressionada para um índice de 0 a 11
; 0005 006B    unsigned char i;
; 0005 006C 
; 0005 006D     for (i = 0; i < 12; i++)
	ST   -Y,R17
;	key -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0xA0011:
	CPI  R17,12
	BRSH _0xA0012
; 0005 006E     {
; 0005 006F         if (key & (1U << i))
	MOV  R30,R17
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0xA0013
; 0005 0070 
; 0005 0071          return i;
	MOV  R30,R17
	JMP  _0x2020002
; 0005 0072     }
_0xA0013:
	SUBI R17,-1
	RJMP _0xA0011
_0xA0012:
; 0005 0073 }
	JMP  _0x2020002
;
;void KEYPADProcess(SystemState state)
; 0005 0076 {
_KEYPADProcess:
; 0005 0077    // Processa a tecla pressionada, se houver
; 0005 0078    unsigned k;
; 0005 0079    unsigned char index;
; 0005 007A    char key;
; 0005 007B    static PasswordResult password_result;
; 0005 007C 
; 0005 007D    if(k=InKey())
	CALL __SAVELOCR4
;	state -> Y+4
;	k -> R16,R17
;	index -> R19
;	key -> R18
	RCALL _InKey
	MOVW R16,R30
	SBIW R30,0
	BRNE PC+3
	JMP _0xA0014
; 0005 007E    {
; 0005 007F       index = KeyToIndex(k);
	ST   -Y,R17
	ST   -Y,R16
	RCALL _KeyToIndex
	MOV  R19,R30
; 0005 0080       key = keymap[index];
	CALL SUBOPT_0x6
	LPM  R18,Z
; 0005 0081       if (key == '<') // Tecla <
	CPI  R18,60
	BRNE _0xA0015
; 0005 0082       {
; 0005 0083          CleanLastDigit();
	CALL _CleanLastDigit
; 0005 0084       }
; 0005 0085       else if (key == '#') // Tecla #
	RJMP _0xA0016
_0xA0015:
	CPI  R18,35
	BRNE _0xA0017
; 0005 0086       {
; 0005 0087          password_result = PasswordConfirm();
	CALL _PasswordConfirm
	STS  _password_result_S0050004000,R30
; 0005 0088          delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x0
; 0005 0089          if (password_result == PASSWORD_INCORRECT)
	LDS  R26,_password_result_S0050004000
	CPI  R26,LOW(0x2)
	BRNE _0xA0018
; 0005 008A          {
; 0005 008B             SystemSetState(state);
	LDD  R30,Y+4
	ST   -Y,R30
	CALL _SystemSetState
; 0005 008C             BeepSound();
	RCALL _BeepSound
; 0005 008D          }
; 0005 008E          else if (password_result == PASSWORD_CORRECT)
	RJMP _0xA0019
_0xA0018:
	LDS  R26,_password_result_S0050004000
	CPI  R26,LOW(0x1)
	BRNE _0xA001A
; 0005 008F          {
; 0005 0090             if(state == ST_DISARMED)
	LDD  R26,Y+4
	CPI  R26,LOW(0x3)
	BRNE _0xA001B
; 0005 0091             {
; 0005 0092                 LCDUpdate(ST_ARMING_DELAY);
	CALL SUBOPT_0x1
; 0005 0093                 SystemSetState(ST_ARMING_DELAY);
; 0005 0094             }
; 0005 0095             else
	RJMP _0xA001C
_0xA001B:
; 0005 0096             {
; 0005 0097                 SystemSetState(ST_DISARMED);
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _SystemSetState
; 0005 0098 
; 0005 0099                 lcd_clear();
	CALL _lcd_clear
; 0005 009A 
; 0005 009B                 lcd_puts("    Sistema");
	__POINTW1MN _0xA001D,0
	CALL SUBOPT_0x4
; 0005 009C                 lcd_gotoxy(0,1);
; 0005 009D                 lcd_puts("  Desarmado");
	__POINTW1MN _0xA001D,12
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0005 009E                 delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x0
; 0005 009F             }
_0xA001C:
; 0005 00A0          }
; 0005 00A1       }
_0xA001A:
_0xA0019:
; 0005 00A2       else
	RJMP _0xA001E
_0xA0017:
; 0005 00A3       {
; 0005 00A4          PasswordInput(keymap[index]);
	CALL SUBOPT_0x6
	LPM  R30,Z
	ST   -Y,R30
	CALL _PasswordInput
; 0005 00A5       }
_0xA001E:
_0xA0016:
; 0005 00A6    }
; 0005 00A7 }
_0xA0014:
	CALL __LOADLOCR4
	ADIW R28,5
	RET

	.DSEG
_0xA001D:
	.BYTE 0x18
;#include <mega16.h>
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
;#include "pwm.h"
;
;void PWMInit(void)
; 0006 0005 {

	.CSEG
_PWMInit:
; 0006 0006     // Configuracoes do PWM no modo geracao de onda quadrada no timer 2
; 0006 0007     // modo CTC (clear timer on compare match), prescaler = 1024, pino PD7 pro PWM2
; 0006 0008     TCCR2 = 0b00011100;
	LDI  R30,LOW(28)
	OUT  0x25,R30
; 0006 0009     DDRD = 0x80;
	LDI  R30,LOW(128)
	OUT  0x11,R30
; 0006 000A }
	RET
;
;void SetPWMFrequency(unsigned int frequency)
; 0006 000D {
_SetPWMFrequency:
; 0006 000E     // Altera o registrador OCR2 para alterar a frequencia do PWM
; 0006 000F     unsigned char reg;
; 0006 0010 
; 0006 0011     if(frequency == 0) {
	ST   -Y,R17
;	frequency -> Y+1
;	reg -> R17
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BRNE _0xC0003
; 0006 0012         DDRD &= ~0x80; // Desliga o pino PD7
	CBI  0x11,7
; 0006 0013         return;
	JMP  _0x2020002
; 0006 0014     }
; 0006 0015 
; 0006 0016     DDRD |= 0x80;
_0xC0003:
	SBI  0x11,7
; 0006 0017 
; 0006 0018     reg = (unsigned char)((14745600UL / (128UL * frequency)) - 1);
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	CLR  R22
	CLR  R23
	__GETD2N 0x80
	CALL __MULD12U
	__GETD2N 0xE10000
	CALL __DIVD21U
	__SUBD1N 1
	MOV  R17,R30
; 0006 0019     OCR2 = reg;
	OUT  0x23,R17
; 0006 001A }
	JMP  _0x2020002
;#include "pwm.h"
;#include "buzzer.h"
;#include "timer.h"
;
;void PoliceSiren(void)
; 0007 0006 {

	.CSEG
; 0007 0007     static unsigned int f;
; 0007 0008     static bit drive = 1;  // Variavel para controlar a direcao da frequencia: 1 - subindo, 0 - descendo
; 0007 0009 
; 0007 000A     UpdateTIMER1CompareValue(20);
; 0007 000B 
; 0007 000C     if(GetTIMER1Flag())
; 0007 000D     {
; 0007 000E         SetTIMER1Flag(0);
; 0007 000F 
; 0007 0010         if (drive == 1)
; 0007 0011         {
; 0007 0012             f += 10;
; 0007 0013             if (f >= 1400) {
; 0007 0014                 drive = 0;
; 0007 0015             }
; 0007 0016         }
; 0007 0017         else
; 0007 0018         {
; 0007 0019             f -= 10;
; 0007 001A             if (f <= 600) {
; 0007 001B                 drive = 1;
; 0007 001C             }
; 0007 001D         }
; 0007 001E 
; 0007 001F         SetPWMFrequency(f);
; 0007 0020     }
; 0007 0021 }
;
;void FireAlarm(void)
; 0007 0024 {
; 0007 0025     static unsigned int f[2] = {650, 550};

	.DSEG

	.CSEG
; 0007 0026     static bit drive = 0;
; 0007 0027 
; 0007 0028     UpdateTIMER1CompareValue(20);
; 0007 0029 
; 0007 002A     if(GetTIMER1Flag())
; 0007 002B     {
; 0007 002C         SetTIMER1Flag(0);
; 0007 002D 
; 0007 002E         if (drive == 0)
; 0007 002F         {
; 0007 0030             f[drive] += 1;
; 0007 0031             if (f[drive] >= 750) {
; 0007 0032                 drive = 1;
; 0007 0033                 f[0] = 650;
; 0007 0034             }
; 0007 0035         }
; 0007 0036         else
; 0007 0037         {
; 0007 0038             f[drive] -= 1;
; 0007 0039             if (f[drive] <= 450) {
; 0007 003A                 drive = 0;
; 0007 003B                 f[1] = 550;
; 0007 003C             }
; 0007 003D         }
; 0007 003E 
; 0007 003F         SetPWMFrequency(f[drive]);
; 0007 0040     }
; 0007 0041 }
;
;void StopSound(void)
; 0007 0044 {
; 0007 0045     SetPWMFrequency(0);
; 0007 0046     UpdateTIMER1CompareValue(0);
; 0007 0047 }
;
;void BeepSound(void)
; 0007 004A {
_BeepSound:
; 0007 004B     UpdateTIMER1CompareValue(20);
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   -Y,R31
	ST   -Y,R30
	CALL _UpdateTIMER1CompareValue
; 0007 004C     if(GetTIMER1Flag()) {
	CALL _GetTIMER1Flag
	CPI  R30,0
	BREQ _0xE000E
; 0007 004D         SetTIMER1Flag(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _SetTIMER1Flag
; 0007 004E         SetPWMFrequency(450);
	LDI  R30,LOW(450)
	LDI  R31,HIGH(450)
	RJMP _0xE001A
; 0007 004F     }
; 0007 0050     else {
_0xE000E:
; 0007 0051         SetPWMFrequency(0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0xE001A:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _SetPWMFrequency
; 0007 0052     }
; 0007 0053 }
	RET
;
;void BuzzerUpdate(SystemState state)
; 0007 0056 {
; 0007 0057     switch (state)
;	state -> Y+0
; 0007 0058     {
; 0007 0059         case ST_MOTION:
; 0007 005A         case ST_SHOCK:
; 0007 005B             PoliceSiren();
; 0007 005C             break;
; 0007 005D 
; 0007 005E         case ST_OVERHEAT:
; 0007 005F         case ST_FLAME:
; 0007 0060             FireAlarm();
; 0007 0061             break;
; 0007 0062 
; 0007 0063         default:
; 0007 0064             StopSound();
; 0007 0065             break;
; 0007 0066     }
; 0007 0067 }
;#include <mega16.h>
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
;#include <sensors.h>
;
;void SENSORSInit(void) {
; 0008 0004 void SENSORSInit(void) {

	.CSEG
_SENSORSInit:
; 0008 0005     DDRB = 0x00; // Configura PORTB como entrada
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0008 0006 }
	RET
;
;void SensorsUpdate(void) {
; 0008 0008 void SensorsUpdate(void) {
_SensorsUpdate:
; 0008 0009     unsigned char flame = PINB.0;
; 0008 000A     unsigned char presence = PINB.1;
; 0008 000B     unsigned char vibration = PINB.2;
; 0008 000C 
; 0008 000D     if (flame) {
	CALL __SAVELOCR4
;	flame -> R17
;	presence -> R16
;	vibration -> R19
	LDI  R30,0
	SBIC 0x16,0
	LDI  R30,1
	MOV  R17,R30
	LDI  R30,0
	SBIC 0x16,1
	LDI  R30,1
	MOV  R16,R30
	LDI  R30,0
	SBIC 0x16,2
	LDI  R30,1
	MOV  R19,R30
	CPI  R17,0
	BREQ _0x100003
; 0008 000E         SystemSetState(ST_FLAME);
	LDI  R30,LOW(6)
	RJMP _0x10000C
; 0008 000F     }
; 0008 0010     else if (presence && vibration) {
_0x100003:
	CPI  R16,0
	BREQ _0x100006
	CPI  R19,0
	BRNE _0x100007
_0x100006:
	RJMP _0x100005
_0x100007:
; 0008 0011         SystemSetState(ST_INVASION);
	LDI  R30,LOW(7)
	RJMP _0x10000C
; 0008 0012     }
; 0008 0013     else if (presence) {
_0x100005:
	CPI  R16,0
	BREQ _0x100009
; 0008 0014         SystemSetState(ST_MOTION);
	LDI  R30,LOW(5)
	RJMP _0x10000C
; 0008 0015     }
; 0008 0016     else if (vibration) {
_0x100009:
	CPI  R19,0
	BREQ _0x10000B
; 0008 0017         SystemSetState(ST_SHOCK);
	LDI  R30,LOW(4)
_0x10000C:
	ST   -Y,R30
	CALL _SystemSetState
; 0008 0018     }
; 0008 0019     return;
_0x10000B:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; 0008 001A }
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
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0x1B,4
	RJMP _0x2000005
_0x2000004:
	CBI  0x1B,4
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x1B,5
	RJMP _0x2000007
_0x2000006:
	CBI  0x1B,5
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x1B,6
	RJMP _0x2000009
_0x2000008:
	CBI  0x1B,6
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0x1B,7
	RJMP _0x200000B
_0x200000A:
	CBI  0x1B,7
_0x200000B:
	__DELAY_USB 10
	SBI  0x1B,2
	__DELAY_USB 25
	CBI  0x1B,2
	__DELAY_USB 25
	RJMP _0x2020001
__lcd_write_data:
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 246
	RJMP _0x2020001
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	RCALL __lcd_write_data
	LDD  R7,Y+1
	LDD  R6,Y+0
_0x2020003:
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x7
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x7
	LDI  R30,LOW(0)
	MOV  R6,R30
	MOV  R7,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	CP   R7,R9
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R6
	ST   -Y,R6
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000013
	RJMP _0x2020001
_0x2000013:
_0x2000010:
	INC  R7
	SBI  0x1B,0
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2020001
_lcd_puts:
	ST   -Y,R17
_0x2000014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000016
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2000014
_0x2000016:
_0x2020002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	SBI  0x1A,4
	SBI  0x1A,5
	SBI  0x1A,6
	SBI  0x1A,7
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LDD  R9,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x8
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 369
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(133)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2020001:
	ADIW R28,1
	RET

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
_password_result_S0050004000:
	.BYTE 0x1
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _LCDUpdate
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _SystemSetState

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	LD   R30,Y
	LDI  R31,0
	SBIW R30,1
	LSL  R30
	SUBI R30,-LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _lcd_puts
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDS  R30,_row_data_S0050000000
	LDS  R31,_row_data_S0050000000+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	MOV  R30,R19
	LDI  R31,0
	SUBI R30,LOW(-_keymap_G005*2)
	SBCI R31,HIGH(-_keymap_G005*2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 369
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xE66
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
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

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:

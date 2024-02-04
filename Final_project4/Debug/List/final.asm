
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
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
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
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
	.DEF _cmp=R4
	.DEF _cmp_msb=R5
	.DEF _count=R6
	.DEF _count_msb=R7
	.DEF _number=R8
	.DEF _number_msb=R9
	.DEF _flag=R10
	.DEF _flag_msb=R11
	.DEF _answer=R12
	.DEF _answer_msb=R13

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
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_comp_isr
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

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x64,0x0,0xFF,0xFF
	.DB  0x0,0x0,0x0,0x0

_0x3:
	.DB  0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xD8
	.DB  0x80,0x90
_0x0:
	.DB  0x6F,0x6B,0x20,0x6C,0x65,0x74,0x27,0x73
	.DB  0x20,0x73,0x74,0x61,0x72,0x74,0x0,0x62
	.DB  0x61,0x73,0x65,0x3A,0x0,0x65,0x6E,0x55
	.DB  0x50,0x0,0x65,0x6E,0x44,0x4F,0x57,0x4E
	.DB  0x0,0x63,0x6F,0x75,0x6E,0x74,0x65,0x72
	.DB  0x20,0x3A,0x0,0x48,0x65,0x6C,0x6C,0x6F
	.DB  0x20,0x21,0x0,0x69,0x74,0x27,0x73,0x20
	.DB  0x63,0x6F,0x75,0x6E,0x74,0x65,0x72,0x21
	.DB  0x0,0x75,0x73,0x65,0x20,0x2A,0x20,0x61
	.DB  0x73,0x20,0x23,0x20,0x74,0x6F,0x20,0x61
	.DB  0x6E,0x73,0x77,0x65,0x72,0x0,0x2A,0x20
	.DB  0x69,0x73,0x20,0x79,0x65,0x73,0x20,0x23
	.DB  0x20,0x69,0x73,0x20,0x6E,0x6F,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x47,0x65,0x74,0x20,0x73,0x74,0x61,0x72
	.DB  0x74,0x3F,0x0,0x45,0x6E,0x74,0x65,0x72
	.DB  0x20,0x74,0x68,0x65,0x20,0x62,0x61,0x73
	.DB  0x65,0x3A,0x0,0x79,0x6F,0x75,0x72,0x20
	.DB  0x62,0x61,0x73,0x65,0x20,0x69,0x73,0x3A
	.DB  0x0,0x79,0x6F,0x75,0x20,0x63,0x6F,0x6E
	.DB  0x66,0x69,0x72,0x6D,0x3F,0x0,0x79,0x6F
	.DB  0x75,0x20,0x63,0x61,0x6E,0x20,0x73,0x65
	.DB  0x65,0x20,0x62,0x61,0x73,0x65,0x0,0x6F
	.DB  0x6E,0x20,0x37,0x53,0x45,0x47,0x4D,0x45
	.DB  0x4E,0x54,0x2D,0x2D,0x2D,0x3E,0x0,0x43
	.DB  0x6F,0x75,0x6E,0x74,0x20,0x75,0x70,0x20
	.DB  0x6F,0x72,0x20,0x64,0x6F,0x77,0x6E,0x20
	.DB  0x3F,0x0,0x23,0x20,0x64,0x6F,0x77,0x6E
	.DB  0x20,0x20,0x20,0x20,0x2A,0x20,0x75,0x70
	.DB  0x20,0x0,0x73,0x65,0x74,0x20,0x63,0x6F
	.DB  0x75,0x6E,0x74,0x20,0x64,0x6F,0x77,0x6E
	.DB  0x0,0x73,0x65,0x74,0x20,0x63,0x6F,0x75
	.DB  0x6E,0x74,0x20,0x75,0x70,0x0,0x48,0x6F
	.DB  0x77,0x20,0x6C,0x6F,0x6E,0x67,0x20,0x69
	.DB  0x73,0x0,0x64,0x65,0x6C,0x61,0x79,0x3F
	.DB  0x20,0x20,0x58,0x20,0x20,0x2A,0x20,0x31
	.DB  0x6D,0x73,0x0,0x53,0x68,0x6F,0x75,0x6C
	.DB  0x64,0x20,0x49,0x20,0x73,0x74,0x6F,0x70
	.DB  0x0,0x61,0x66,0x74,0x65,0x72,0x20,0x6F
	.DB  0x77,0x65,0x72,0x66,0x6C,0x6F,0x77,0x3F
	.DB  0x0,0x73,0x74,0x6F,0x70,0x20,0x2A,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x63,0x6F,0x6E,0x74,0x69,0x6E,0x75,0x65
	.DB  0x20,0x23,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x63,0x6F,0x6E,0x74,0x69
	.DB  0x6E,0x75,0x65,0x20,0x3F,0x0,0x67,0x6F
	.DB  0x6F,0x64,0x62,0x79,0x65,0x20,0x0
_0x2020003:
	.DB  0x80,0xC0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0A
	.DW  _segd
	.DW  _0x3*2

	.DW  0x0F
	.DW  _0x7
	.DW  _0x0*2

	.DW  0x06
	.DW  _0x7+15
	.DW  _0x0*2+15

	.DW  0x05
	.DW  _0x7+21
	.DW  _0x0*2+21

	.DW  0x0A
	.DW  _0x7+26
	.DW  _0x0*2+33

	.DW  0x0E
	.DW  _0x10
	.DW  _0x0*2+51

	.DW  0x15
	.DW  _0x10+14
	.DW  _0x0*2+65

	.DW  0x11
	.DW  _0x10+35
	.DW  _0x0*2+86

	.DW  0x11
	.DW  _0x10+52
	.DW  _0x0*2+103

	.DW  0x0B
	.DW  _0x10+69
	.DW  _0x0*2+120

	.DW  0x10
	.DW  _0x10+80
	.DW  _0x0*2+131

	.DW  0x0E
	.DW  _0x10+96
	.DW  _0x0*2+147

	.DW  0x0D
	.DW  _0x10+110
	.DW  _0x0*2+161

	.DW  0x11
	.DW  _0x10+123
	.DW  _0x0*2+174

	.DW  0x10
	.DW  _0x10+140
	.DW  _0x0*2+191

	.DW  0x13
	.DW  _0x10+156
	.DW  _0x0*2+207

	.DW  0x10
	.DW  _0x10+175
	.DW  _0x0*2+226

	.DW  0x0F
	.DW  _0x10+191
	.DW  _0x0*2+242

	.DW  0x0D
	.DW  _0x10+206
	.DW  _0x0*2+257

	.DW  0x0C
	.DW  _0x10+219
	.DW  _0x0*2+270

	.DW  0x11
	.DW  _0x10+231
	.DW  _0x0*2+282

	.DW  0x02
	.DW  _0x10+248
	.DW  _0x0*2+118

	.DW  0x0E
	.DW  _0x10+250
	.DW  _0x0*2+299

	.DW  0x10
	.DW  _0x10+264
	.DW  _0x0*2+313

	.DW  0x0F
	.DW  _0x10+280
	.DW  _0x0*2+329

	.DW  0x0F
	.DW  _0x10+295
	.DW  _0x0*2+344

	.DW  0x14
	.DW  _0x46
	.DW  _0x0*2+359

	.DW  0x11
	.DW  _0x47
	.DW  _0x0*2+103

	.DW  0x04
	.DW  _0x5B
	.DW  _0x0*2+116

	.DW  0x0B
	.DW  _0x5C
	.DW  _0x0*2+379

	.DW  0x09
	.DW  _0x5C+11
	.DW  _0x0*2+390

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

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
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 2/2/2024
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <string.h>
;#include <alcd.h>
;#include <io.h>
;#include <stdlib.h>
;#include <stdbool.h>
;
;//function's
;void delay(int time);
;int slowWrite(char mesg[16], int x , int y);
;void baseInput ();
;int getInput();
;int getAns();
;void clear();
;void segShow(int num);
;int counter(int num , bool upCount , bool owerCount , int delayNum);
;void end();
;
;//global variable
;int cmp = 100 ;
;int count =-1  ;
;int number;
;int flag = 0;
;int answer;
;bool upCounter , owerCounter;
;unsigned char segd[10] = {0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xd8,0x80,0x90};

	.DSEG
;int delayNum = 0;
;
;void main(void)
; 0000 0035 {

	.CSEG
_main:
; .FSTART _main
; 0000 0036 char mesg[16];
; 0000 0037 DDRB = 0b11111000;
	SBIW R28,16
;	mesg -> Y+0
	LDI  R30,LOW(248)
	OUT  0x17,R30
; 0000 0038 DDRC = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0039 DDRD = 0x7F;
	LDI  R30,LOW(127)
	OUT  0x11,R30
; 0000 003A 
; 0000 003B //LCD PORT
; 0000 003C DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 003D PORTA=0x00;
	OUT  0x1B,R30
; 0000 003E 
; 0000 003F lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 0040 
; 0000 0041 // Timer/Counter0
; 0000 0042 TCCR0 = (1 << WGM01) | (1 << CS01) | (1 << CS00); // CTC mode, prescaler = 64
	LDI  R30,LOW(11)
	OUT  0x33,R30
; 0000 0043 OCR0 = 125;
	LDI  R30,LOW(125)
	OUT  0x3C,R30
; 0000 0044 
; 0000 0045 // Enable Timer/Counter0 Compare Match A interrupt
; 0000 0046 
; 0000 0047 TIMSK = (1 << OCIE0);
	LDI  R30,LOW(2)
	OUT  0x39,R30
; 0000 0048     #asm("sei");
	sei
; 0000 0049     while (1) {
; 0000 004A             baseInput();
	RCALL _baseInput
; 0000 004B 
; 0000 004C             strcpy(mesg,"ok let's start");;
	CALL SUBOPT_0x0
	__POINTW2MN _0x7,0
	CALL SUBOPT_0x1
; 0000 004D             slowWrite(mesg ,0,0);
	CALL SUBOPT_0x2
; 0000 004E             delay(100);
	CALL SUBOPT_0x3
; 0000 004F             strcpy(mesg,"base:");;
	CALL SUBOPT_0x0
	__POINTW2MN _0x7,15
	CALL SUBOPT_0x1
; 0000 0050             slowWrite(mesg ,0,0);
	CALL SUBOPT_0x2
; 0000 0051             itoa(number , mesg);
	ST   -Y,R9
	ST   -Y,R8
	MOVW R26,R28
	ADIW R26,2
	CALL _itoa
; 0000 0052             slowWrite(mesg ,7,0);
	CALL SUBOPT_0x0
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x4
; 0000 0053             strcpy(mesg,(upCounter)?"enUP":"enDOWN");;
	__POINTW2MN _0x7,21
	CALL SUBOPT_0x1
; 0000 0054             slowWrite(mesg ,10,0);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x4
; 0000 0055             strcpy(mesg,"counter :");
	__POINTW2MN _0x7,26
	CALL SUBOPT_0x1
; 0000 0056             slowWrite(mesg ,0,1);
	CALL SUBOPT_0x5
; 0000 0057 
; 0000 0058             counter(number , upCounter , owerCounter , delayNum);
	ST   -Y,R9
	ST   -Y,R8
	LDS  R30,_upCounter
	ST   -Y,R30
	LDS  R30,_owerCounter
	ST   -Y,R30
	LDS  R26,_delayNum
	LDS  R27,_delayNum+1
	RCALL _counter
; 0000 0059             end();
	RCALL _end
; 0000 005A             break;
; 0000 005B 
; 0000 005C     }
; 0000 005D }
	ADIW R28,16
_0xB:
	RJMP _0xB
; .FEND

	.DSEG
_0x7:
	.BYTE 0x24
;
;interrupt [TIM0_COMP] void timer0_comp_isr(void) {
; 0000 005F interrupt [11] void timer0_comp_isr(void) {

	.CSEG
_timer0_comp_isr:
; .FSTART _timer0_comp_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0060     count ++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0061     if (count == cmp) {
	__CPWRR 4,5,6,7
	BRNE _0xC
; 0000 0062         count = 0;
	CLR  R6
	CLR  R7
; 0000 0063         flag = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 0064     }
; 0000 0065 }
_0xC:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;void delay(int time){
; 0000 0067 void delay(int time){
_delay:
; .FSTART _delay
; 0000 0068     cmp = time;
	ST   -Y,R27
	ST   -Y,R26
;	time -> Y+0
	__GETWRS 4,5,0
; 0000 0069     count = 0 ;
	CLR  R6
	CLR  R7
; 0000 006A     while(flag == 0);
_0xD:
	MOV  R0,R10
	OR   R0,R11
	BREQ _0xD
; 0000 006B     flag=0;
	CLR  R10
	CLR  R11
; 0000 006C }
	JMP  _0x20A0003
; .FEND
;
;void baseInput () {
; 0000 006E void baseInput () {
_baseInput:
; .FSTART _baseInput
; 0000 006F     char mesg[16];
; 0000 0070     int ans;
; 0000 0071     int i ;
; 0000 0072 
; 0000 0073 
; 0000 0074     lcd_gotoxy(0,0);
	SBIW R28,16
	CALL __SAVELOCR4
;	mesg -> Y+4
;	ans -> R16,R17
;	i -> R18,R19
	CALL SUBOPT_0x6
; 0000 0075     lcd_putsf("Hello !");
	__POINTW2FN _0x0,43
	CALL _lcd_putsf
; 0000 0076     //lcd_gotoxy(0,1);
; 0000 0077     strcpy(mesg,"it's counter!");
	CALL SUBOPT_0x7
	__POINTW2MN _0x10,0
	CALL SUBOPT_0x8
; 0000 0078     slowWrite(mesg ,0,1);
	CALL SUBOPT_0x5
; 0000 0079     delay(100);
	CALL SUBOPT_0x3
; 0000 007A     clear();
	CALL SUBOPT_0x9
; 0000 007B     strcpy(mesg,"use * as # to answer");
	__POINTW2MN _0x10,14
	CALL SUBOPT_0x8
; 0000 007C     slowWrite(mesg ,0,0);
	CALL SUBOPT_0x2
; 0000 007D     //clear();
; 0000 007E 
; 0000 007F     //lcd_gotoxy(0,0);
; 0000 0080     strcpy(mesg,"* is yes # is no");
	CALL SUBOPT_0x7
	__POINTW2MN _0x10,35
	CALL SUBOPT_0x8
; 0000 0081     slowWrite(mesg ,0,1);
	CALL SUBOPT_0x5
; 0000 0082     delay(150);
	LDI  R26,LOW(150)
	LDI  R27,0
	RCALL _delay
; 0000 0083     //lcd_puts(mesg);
; 0000 0084     clear();
	CALL SUBOPT_0x9
; 0000 0085     strcpy(mesg,"                ");
	__POINTW2MN _0x10,52
	CALL SUBOPT_0x8
; 0000 0086     strcpy(mesg,"Get start?");
	__POINTW2MN _0x10,69
	CALL SUBOPT_0x8
; 0000 0087     slowWrite(mesg ,0,1);
	CALL SUBOPT_0x5
; 0000 0088 
; 0000 0089     answer = 0;
	CLR  R12
	CLR  R13
; 0000 008A     while (answer != 1 ){answer = getAns();}
_0x11:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R12
	CPC  R31,R13
	BREQ _0x13
	RCALL _getAns
	MOVW R12,R30
	RJMP _0x11
_0x13:
; 0000 008B     answer = 0;
	CLR  R12
	CLR  R13
; 0000 008C 
; 0000 008D     //Get the initial value--------------------------------------------------
; 0000 008E     do {
_0x15:
; 0000 008F         clear();
	CALL SUBOPT_0x9
; 0000 0090         strcpy(mesg,"Enter the base:");
	__POINTW2MN _0x10,80
	CALL SUBOPT_0x8
; 0000 0091         slowWrite(mesg ,0,0);
	CALL SUBOPT_0x2
; 0000 0092         PORTC=~segd[0];
	LDS  R30,_segd
	COM  R30
	OUT  0x15,R30
; 0000 0093         PORTD=~segd[0];
	LDS  R30,_segd
	COM  R30
	OUT  0x12,R30
; 0000 0094         ans = getInput();
	RCALL _getInput
	MOVW R16,R30
; 0000 0095         while (ans<0){ans = getInput();delay(50);}
_0x17:
	TST  R17
	BRPL _0x19
	RCALL _getInput
	MOVW R16,R30
	CALL SUBOPT_0xA
	RJMP _0x17
_0x19:
; 0000 0096         delay(50);
	CALL SUBOPT_0xA
; 0000 0097         PORTC=~segd[ans];
	LDI  R26,LOW(_segd)
	LDI  R27,HIGH(_segd)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	COM  R30
	OUT  0x15,R30
; 0000 0098         itoa(ans,mesg);
	CALL SUBOPT_0xB
; 0000 0099         lcd_gotoxy(7 , 1);
; 0000 009A         lcd_puts(mesg);
; 0000 009B         ans = ans*10;
	MOVW R30,R16
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	MOVW R16,R30
; 0000 009C         i = getInput();
	RCALL _getInput
	MOVW R18,R30
; 0000 009D         delay(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay
; 0000 009E         ans = (i<0)?ans/10:ans+i;
	TST  R19
	BRPL _0x1A
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	RJMP _0x1B
_0x1A:
	MOVW R30,R18
	ADD  R30,R16
	ADC  R31,R17
_0x1B:
	MOVW R16,R30
; 0000 009F         PORTD=~segd[(ans%10)];
	MOVW R26,R16
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	OUT  0x12,R30
; 0000 00A0         itoa(ans,mesg);
	CALL SUBOPT_0xB
; 0000 00A1         lcd_gotoxy(7 , 1);
; 0000 00A2         lcd_puts(mesg);
; 0000 00A3         delay(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay
; 0000 00A4 
; 0000 00A5         clear();
	CALL SUBOPT_0x9
; 0000 00A6         strcpy(mesg,"your base is:");
	__POINTW2MN _0x10,96
	CALL SUBOPT_0x8
; 0000 00A7         slowWrite(mesg ,0,0);
	CALL SUBOPT_0x2
; 0000 00A8         itoa(ans,mesg);
	CALL SUBOPT_0xE
; 0000 00A9         lcd_gotoxy(13 , 0);
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL SUBOPT_0xF
; 0000 00AA         lcd_puts(mesg);
; 0000 00AB         strcpy(mesg,"you confirm?");
	CALL SUBOPT_0x7
	__POINTW2MN _0x10,110
	CALL SUBOPT_0x8
; 0000 00AC         slowWrite(mesg ,0,1);
	CALL SUBOPT_0x5
; 0000 00AD 
; 0000 00AE         answer = getAns();
	RCALL _getAns
	MOVW R12,R30
; 0000 00AF     }while(answer == 0);
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x16
	RJMP _0x15
_0x16:
; 0000 00B0 
; 0000 00B1     number = ans;
	MOVW R8,R16
; 0000 00B2     clear();
	CALL SUBOPT_0x9
; 0000 00B3 
; 0000 00B4     strcpy(mesg,"you can see base");
	__POINTW2MN _0x10,123
	CALL SUBOPT_0x8
; 0000 00B5     slowWrite(mesg ,0,0);
	CALL SUBOPT_0x2
; 0000 00B6     strcpy(mesg,"on 7SEGMENT--->");
	CALL SUBOPT_0x7
	__POINTW2MN _0x10,140
	CALL SUBOPT_0x8
; 0000 00B7     slowWrite(mesg ,0,1);
	CALL SUBOPT_0x5
; 0000 00B8     segShow(number);
	MOVW R26,R8
	RCALL _segShow
; 0000 00B9     delay(100);
	CALL SUBOPT_0x3
; 0000 00BA     //strcpy(mesg,"on 7seg --> ");
; 0000 00BB     //lcd_gotoxy(0,0);
; 0000 00BC     //lcd_puts(mesg);
; 0000 00BD     //strcpy(mesg,"Count up or down ?");
; 0000 00BE     //slowWrite(mesg ,0,1);
; 0000 00BF 
; 0000 00C0     //Get the counter status --------------------------------------------------
; 0000 00C1     strcpy(mesg,"Count up or down ?");
	CALL SUBOPT_0x7
	__POINTW2MN _0x10,156
	CALL SUBOPT_0x10
; 0000 00C2     lcd_gotoxy(0,0);
; 0000 00C3     lcd_puts(mesg);
	CALL SUBOPT_0x11
; 0000 00C4     strcpy(mesg,"# down    * up ");
	__POINTW2MN _0x10,175
	CALL SUBOPT_0x8
; 0000 00C5     slowWrite(mesg ,0,1);
	CALL SUBOPT_0x5
; 0000 00C6     ans = getAns();
	RCALL _getAns
	MOVW R16,R30
; 0000 00C7     upCounter = (ans)? true:false;
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x1D
	LDI  R30,LOW(1)
	RJMP _0x1E
_0x1D:
	LDI  R30,LOW(0)
_0x1E:
	STS  _upCounter,R30
; 0000 00C8 
; 0000 00C9     (!upCounter)?strcpy(mesg,"set count down"):strcpy(mesg,"set count up");
	CPI  R30,0
	BRNE _0x20
	CALL SUBOPT_0x7
	__POINTW2MN _0x10,191
	RJMP _0x5E
_0x20:
	CALL SUBOPT_0x7
	__POINTW2MN _0x10,206
_0x5E:
	CALL _strcpy
; 0000 00CA     clear();
	CALL SUBOPT_0x9
; 0000 00CB    // strcpy(mesg,(upCounter)?"set count up":"set count down");
; 0000 00CC     slowWrite(mesg ,0,0);
	CALL SUBOPT_0x2
; 0000 00CD     delay(100);
	CALL SUBOPT_0x3
; 0000 00CE 
; 0000 00CF     //Get the delay value--------------------------------------------------
; 0000 00D0     strcpy(mesg,"How long is");
	CALL SUBOPT_0x7
	__POINTW2MN _0x10,219
	CALL SUBOPT_0x8
; 0000 00D1     slowWrite(mesg ,0,0);
	CALL SUBOPT_0x2
; 0000 00D2     strcpy(mesg,"delay?  X  * 1ms");
	CALL SUBOPT_0x7
	__POINTW2MN _0x10,231
	CALL SUBOPT_0x8
; 0000 00D3     slowWrite(mesg ,0,1);
	CALL SUBOPT_0x5
; 0000 00D4     i = 0 ;
	__GETWRN 18,19,0
; 0000 00D5     ans = 0 ;
	__GETWRN 16,17,0
; 0000 00D6     do {
_0x24:
; 0000 00D7 
; 0000 00D8         ans = getInput();
	RCALL _getInput
	MOVW R16,R30
; 0000 00D9         delay(40);
	LDI  R26,LOW(40)
	LDI  R27,0
	RCALL _delay
; 0000 00DA 
; 0000 00DB         if (ans >= 0){
	TST  R17
	BRMI _0x26
; 0000 00DC             delayNum *=10 ;
	LDS  R30,_delayNum
	LDS  R31,_delayNum+1
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	STS  _delayNum,R30
	STS  _delayNum+1,R31
; 0000 00DD             delayNum += ans;
	MOVW R30,R16
	LDS  R26,_delayNum
	LDS  R27,_delayNum+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _delayNum,R30
	STS  _delayNum+1,R31
; 0000 00DE             i++;
	__ADDWRN 18,19,1
; 0000 00DF             itoa(ans,mesg);
	CALL SUBOPT_0xE
; 0000 00E0             lcd_gotoxy(6+i,1);
	MOV  R30,R18
	SUBI R30,-LOW(6)
	CALL SUBOPT_0x12
; 0000 00E1             lcd_puts(mesg);
; 0000 00E2         }
; 0000 00E3 
; 0000 00E4         if (i == 1){
_0x26:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x27
; 0000 00E5             strcpy(mesg," ");
	CALL SUBOPT_0x7
	__POINTW2MN _0x10,248
	CALL _strcpy
; 0000 00E6             lcd_gotoxy(8,1);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x12
; 0000 00E7             lcd_puts(mesg);
; 0000 00E8         }
; 0000 00E9 
; 0000 00EA 
; 0000 00EB     }while(0<=ans && i<6 );
_0x27:
	TST  R17
	BRMI _0x28
	__CPWRN 18,19,6
	BRLT _0x29
_0x28:
	RJMP _0x25
_0x29:
	RJMP _0x24
_0x25:
; 0000 00EC 
; 0000 00ED 
; 0000 00EE     //initialise state of the overflow--------------------------------------------------
; 0000 00EF     clear();
	CALL SUBOPT_0x9
; 0000 00F0     strcpy(mesg,"Should I stop");
	__POINTW2MN _0x10,250
	CALL SUBOPT_0x8
; 0000 00F1     slowWrite(mesg ,0,0);
	CALL SUBOPT_0x2
; 0000 00F2     strcpy(mesg,"after owerflow?");
	CALL SUBOPT_0x7
	__POINTW2MN _0x10,264
	CALL SUBOPT_0x8
; 0000 00F3     slowWrite(mesg ,0,1);
	CALL SUBOPT_0x5
; 0000 00F4     delay(150);
	LDI  R26,LOW(150)
	LDI  R27,0
	RCALL _delay
; 0000 00F5     strcpy(mesg,"stop *        ");;
	CALL SUBOPT_0x7
	__POINTW2MN _0x10,280
	CALL SUBOPT_0x10
; 0000 00F6     lcd_gotoxy(0,0);
; 0000 00F7     lcd_puts(mesg);
	CALL SUBOPT_0x11
; 0000 00F8     strcpy(mesg,"continue #    ");
	__POINTW2MN _0x10,295
	CALL _strcpy
; 0000 00F9     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x12
; 0000 00FA     lcd_puts(mesg);
; 0000 00FB     ans = getAns();
	CALL SUBOPT_0x13
; 0000 00FC     owerCounter = (ans == 1) ? false:true;
	BRNE _0x2A
	LDI  R30,LOW(0)
	RJMP _0x2B
_0x2A:
	LDI  R30,LOW(1)
_0x2B:
	STS  _owerCounter,R30
; 0000 00FD     clear();
	RCALL _clear
; 0000 00FE 
; 0000 00FF }
	CALL __LOADLOCR4
	ADIW R28,20
	RET
; .FEND

	.DSEG
_0x10:
	.BYTE 0x136
;
;int getInput(){
; 0000 0101 int getInput(){

	.CSEG
_getInput:
; .FSTART _getInput
; 0000 0102     while(1){
_0x2D:
; 0000 0103         PORTB=0x08;
	LDI  R30,LOW(8)
	OUT  0x18,R30
; 0000 0104             if (PINB.0==1){delay(50);PORTB=0x00;return 3;}
	SBIS 0x16,0
	RJMP _0x30
	CALL SUBOPT_0xA
	LDI  R30,LOW(0)
	OUT  0x18,R30
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RET
; 0000 0105             if (PINB.1==1){delay(50);PORTB=0x00;return 2;}
_0x30:
	SBIS 0x16,1
	RJMP _0x31
	CALL SUBOPT_0xA
	LDI  R30,LOW(0)
	OUT  0x18,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RET
; 0000 0106             if (PINB.2==1){delay(50);PORTB=0x00;return 1;}
_0x31:
	SBIS 0x16,2
	RJMP _0x32
	CALL SUBOPT_0xA
	LDI  R30,LOW(0)
	OUT  0x18,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET
; 0000 0107         PORTB=0x10;
_0x32:
	LDI  R30,LOW(16)
	OUT  0x18,R30
; 0000 0108             if (PINB.0==1){delay(50);PORTB=0x00;return 6;}
	SBIS 0x16,0
	RJMP _0x33
	CALL SUBOPT_0xA
	LDI  R30,LOW(0)
	OUT  0x18,R30
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RET
; 0000 0109             if (PINB.1==1){delay(50);PORTB=0x00;return 5;}
_0x33:
	SBIS 0x16,1
	RJMP _0x34
	CALL SUBOPT_0xA
	LDI  R30,LOW(0)
	OUT  0x18,R30
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET
; 0000 010A             if (PINB.2==1){delay(50);PORTB=0x00;return 4;}
_0x34:
	SBIS 0x16,2
	RJMP _0x35
	CALL SUBOPT_0xA
	LDI  R30,LOW(0)
	OUT  0x18,R30
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RET
; 0000 010B         PORTB=0x20;
_0x35:
	LDI  R30,LOW(32)
	OUT  0x18,R30
; 0000 010C             if (PINB.0==1){delay(50);PORTB=0x00;return 9;}
	SBIS 0x16,0
	RJMP _0x36
	CALL SUBOPT_0xA
	LDI  R30,LOW(0)
	OUT  0x18,R30
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RET
; 0000 010D             if (PINB.1==1){delay(50);PORTB=0x00;return 8;}
_0x36:
	SBIS 0x16,1
	RJMP _0x37
	CALL SUBOPT_0xA
	LDI  R30,LOW(0)
	OUT  0x18,R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RET
; 0000 010E             if (PINB.2==1){delay(50);PORTB=0x00;return 7;}
_0x37:
	SBIS 0x16,2
	RJMP _0x38
	CALL SUBOPT_0xA
	LDI  R30,LOW(0)
	OUT  0x18,R30
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RET
; 0000 010F         PORTB=0x40;
_0x38:
	LDI  R30,LOW(64)
	OUT  0x18,R30
; 0000 0110             if (PINB.0==1){delay(50);PORTB=0x00;return -2;}// # = -2 => 0
	SBIS 0x16,0
	RJMP _0x39
	CALL SUBOPT_0xA
	LDI  R30,LOW(0)
	OUT  0x18,R30
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	RET
; 0000 0111             if (PINB.1==1){delay(50);PORTB=0x00;return 0;}
_0x39:
	SBIS 0x16,1
	RJMP _0x3A
	CALL SUBOPT_0xA
	LDI  R30,LOW(0)
	OUT  0x18,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET
; 0000 0112             if (PINB.2==1){delay(50);PORTB=0x00;return -1;}// * = -1 => 1
_0x3A:
	SBIS 0x16,2
	RJMP _0x3B
	CALL SUBOPT_0xA
	LDI  R30,LOW(0)
	OUT  0x18,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RET
; 0000 0113      }
_0x3B:
	RJMP _0x2D
; 0000 0114 }
; .FEND
;int getAns(){
; 0000 0115 int getAns(){
_getAns:
; .FSTART _getAns
; 0000 0116     int tmp =0;
; 0000 0117     while (1){
	ST   -Y,R17
	ST   -Y,R16
;	tmp -> R16,R17
	__GETWRN 16,17,0
_0x3C:
; 0000 0118         tmp = getInput();
	RCALL _getInput
	MOVW R16,R30
; 0000 0119         if (tmp < 0)
	TST  R17
	BRPL _0x3C
; 0000 011A             break;
; 0000 011B     }
; 0000 011C     return (tmp == -1) ? 1:0 ;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x40
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x41
_0x40:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x41:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 011D }
; .FEND
;int slowWrite(char mesg[16], int x , int y){
; 0000 011E int slowWrite(char mesg[16], int x , int y){
_slowWrite:
; .FSTART _slowWrite
; 0000 011F     int i;
; 0000 0120     char chr='';
; 0000 0121     lcd_gotoxy(x,y);
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
;	mesg -> Y+8
;	x -> Y+6
;	y -> Y+4
;	i -> R16,R17
;	chr -> R19
	LDI  R19,0
	LDD  R30,Y+6
	ST   -Y,R30
	LDD  R26,Y+5
	CALL _lcd_gotoxy
; 0000 0122     for (i=0;i<=15;i++){
	__GETWRN 16,17,0
_0x44:
	__CPWRN 16,17,16
	BRGE _0x45
; 0000 0123         delay(4);
	LDI  R26,LOW(4)
	LDI  R27,0
	RCALL _delay
; 0000 0124         lcd_gotoxy((x+i),y);
	MOV  R30,R16
	LDD  R26,Y+6
	ADD  R30,R26
	ST   -Y,R30
	LDD  R26,Y+5
	CALL _lcd_gotoxy
; 0000 0125 
; 0000 0126         chr = mesg[i];
	MOVW R30,R16
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R19,X
; 0000 0127         lcd_putchar(chr);
	MOV  R26,R19
	CALL _lcd_putchar
; 0000 0128     }
	__ADDWRN 16,17,1
	RJMP _0x44
_0x45:
; 0000 0129     strcpy(mesg,"                   ");
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x46,0
	CALL _strcpy
; 0000 012A     return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __LOADLOCR4
	ADIW R28,10
	RET
; 0000 012B }
; .FEND

	.DSEG
_0x46:
	.BYTE 0x14
;void clear (){
; 0000 012C void clear (){

	.CSEG
_clear:
; .FSTART _clear
; 0000 012D     char mesg[16];
; 0000 012E     strcpy(mesg,"                ");
	SBIW R28,16
;	mesg -> Y+0
	CALL SUBOPT_0x0
	__POINTW2MN _0x47,0
	CALL SUBOPT_0x10
; 0000 012F     lcd_gotoxy(0,0);
; 0000 0130     lcd_puts(mesg);
	CALL SUBOPT_0x14
; 0000 0131     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x15
; 0000 0132     lcd_puts(mesg);
; 0000 0133 }
	ADIW R28,16
	RET
; .FEND

	.DSEG
_0x47:
	.BYTE 0x11
;void segShow(int num){
; 0000 0134 void segShow(int num){

	.CSEG
_segShow:
; .FSTART _segShow
; 0000 0135     PORTC =~segd[(num-(num%10))/10];
	ST   -Y,R27
	ST   -Y,R26
;	num -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0xC
	LD   R26,Y
	LDD  R27,Y+1
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	CALL SUBOPT_0xD
	OUT  0x15,R30
; 0000 0136     PORTD =~segd[num%10];
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	OUT  0x12,R30
; 0000 0137 }
	JMP  _0x20A0003
; .FEND
;
;int counter(int num , bool upCount , bool owerCount, int delayNum){
; 0000 0139 int counter(int num , _Bool upCount , _Bool owerCount, int delayNum){
_counter:
; .FSTART _counter
; 0000 013A     char mesg[16];
; 0000 013B 
; 0000 013C     while(1){
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,16
;	num -> Y+20
;	upCount -> Y+19
;	owerCount -> Y+18
;	delayNum -> Y+16
;	mesg -> Y+0
_0x48:
; 0000 013D        while (PIND.7==0);
_0x4B:
	SBIS 0x10,7
	RJMP _0x4B
; 0000 013E        if (PINB.7==1 && PORTD.7==0)
	SBIS 0x16,7
	RJMP _0x4F
	SBIS 0x12,7
	RJMP _0x50
_0x4F:
	RJMP _0x4E
_0x50:
; 0000 013F             return 0 ;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x20A0004
; 0000 0140        num += (upCount)? 1:-1;
_0x4E:
	LDD  R30,Y+19
	LDI  R31,0
	SBIW R30,0
	BREQ _0x51
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x52
_0x51:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x52:
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+20,R30
	STD  Y+20+1,R31
; 0000 0141 
; 0000 0142        if ( num==100 || num == -1 ){
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BREQ _0x55
	CPI  R26,LOW(0xFFFF)
	LDI  R30,HIGH(0xFFFF)
	CPC  R27,R30
	BRNE _0x54
_0x55:
; 0000 0143             if (!owerCount)
	LDD  R30,Y+18
	CPI  R30,0
	BRNE _0x57
; 0000 0144                 return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x20A0004
; 0000 0145             num = (upCount)? 0:99;
_0x57:
	LDD  R30,Y+19
	LDI  R31,0
	SBIW R30,0
	BREQ _0x58
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x59
_0x58:
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
_0x59:
	STD  Y+20,R30
	STD  Y+20+1,R31
; 0000 0146             strcpy(mesg,"   ");
	CALL SUBOPT_0x0
	__POINTW2MN _0x5B,0
	CALL _strcpy
; 0000 0147             lcd_gotoxy(10,1);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x15
; 0000 0148             lcd_puts(mesg);
; 0000 0149 
; 0000 014A        }
; 0000 014B        segShow(num);
_0x54:
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL _segShow
; 0000 014C        itoa(num,mesg);
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,2
	CALL _itoa
; 0000 014D        lcd_gotoxy(10,1);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x15
; 0000 014E        lcd_puts(mesg);
; 0000 014F        delay(delayNum);
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RCALL _delay
; 0000 0150     }
	RJMP _0x48
; 0000 0151 }
_0x20A0004:
	ADIW R28,22
	RET
; .FEND

	.DSEG
_0x5B:
	.BYTE 0x4
;void end(){
; 0000 0152 void end(){

	.CSEG
_end:
; .FSTART _end
; 0000 0153     char mesg[16];
; 0000 0154     int ans;
; 0000 0155     clear();
	SBIW R28,16
	ST   -Y,R17
	ST   -Y,R16
;	mesg -> Y+2
;	ans -> R16,R17
	CALL SUBOPT_0x16
; 0000 0156     strcpy(mesg,"continue ?");
	__POINTW2MN _0x5C,0
	CALL SUBOPT_0x17
; 0000 0157     slowWrite(mesg ,0,1);
; 0000 0158 
; 0000 0159     ans = getAns();
	CALL SUBOPT_0x13
; 0000 015A     if (ans==1)
	BRNE _0x5D
; 0000 015B         main();
	RCALL _main
; 0000 015C 
; 0000 015D     clear();
_0x5D:
	CALL SUBOPT_0x16
; 0000 015E     strcpy(mesg,"goodbye ");
	__POINTW2MN _0x5C,11
	CALL SUBOPT_0x17
; 0000 015F     slowWrite(mesg ,0,1);
; 0000 0160 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,18
	RET
; .FEND

	.DSEG
_0x5C:
	.BYTE 0x14

	.CSEG
_strcpy:
; .FSTART _strcpy
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpy0:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcpy0
    movw r30,r24
    ret
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
; .FSTART __lcd_write_nibble_G101
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2020004
	SBI  0x1B,3
	RJMP _0x2020005
_0x2020004:
	CBI  0x1B,3
_0x2020005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2020006
	SBI  0x1B,2
	RJMP _0x2020007
_0x2020006:
	CBI  0x1B,2
_0x2020007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2020008
	SBI  0x1B,1
	RJMP _0x2020009
_0x2020008:
	CBI  0x1B,1
_0x2020009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x202000A
	SBI  0x1B,0
	RJMP _0x202000B
_0x202000A:
	CBI  0x1B,0
_0x202000B:
	__DELAY_USB 13
	SBI  0x1B,4
	__DELAY_USB 13
	CBI  0x1B,4
	__DELAY_USB 13
	RJMP _0x20A0001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 133
	RJMP _0x20A0001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x20A0003:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x18
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x18
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2020010
_0x2020011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020013
	RJMP _0x20A0001
_0x2020013:
_0x2020010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x1B,6
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,6
	RJMP _0x20A0001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020014
_0x2020016:
	RJMP _0x20A0002
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020017:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020019
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020017
_0x2020019:
_0x20A0002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	SBI  0x1A,3
	SBI  0x1A,2
	SBI  0x1A,1
	SBI  0x1A,0
	SBI  0x1A,4
	SBI  0x1A,6
	SBI  0x1A,5
	CBI  0x1B,4
	CBI  0x1B,6
	CBI  0x1B,5
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x19
	CALL SUBOPT_0x19
	CALL SUBOPT_0x19
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20A0001:
	ADIW R28,1
	RET
; .FEND

	.CSEG
_itoa:
; .FSTART _itoa
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret
; .FEND

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_upCounter:
	.BYTE 0x1
_owerCounter:
	.BYTE 0x1
_segd:
	.BYTE 0xA
_delayNum:
	.BYTE 0x2
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x0:
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	CALL _strcpy
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	JMP  _slowWrite

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	CALL _slowWrite
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _slowWrite

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 36 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0x7:
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x8:
	CALL _strcpy
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9:
	CALL _clear
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(50)
	LDI  R27,0
	JMP  _delay

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xB:
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,6
	CALL _itoa
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
	MOVW R26,R28
	ADIW R26,4
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	SUBI R30,LOW(-_segd)
	SBCI R31,HIGH(-_segd)
	LD   R30,Z
	COM  R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,6
	JMP  _itoa

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF:
	CALL _lcd_gotoxy
	MOVW R26,R28
	ADIW R26,4
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	CALL _strcpy
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	MOVW R26,R28
	ADIW R26,4
	CALL _lcd_puts
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	CALL _getAns
	MOVW R16,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	MOVW R26,R28
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	CALL _clear
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	CALL _strcpy
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x19:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G101
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
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

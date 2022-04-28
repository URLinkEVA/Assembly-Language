# 1
已知在累加器A中存放一个BCD数（0~9），设计程序，实现一个查平方表的子程序。
```
ORG  0000H
SQR：1NC  A
MOVC  A，@A+PC
RET
TAB：DB  0，1，4，9，16
DB  25，36，49，64，81
```
```
ORG  0000H
MOV DPTR,#TAB2
MOV A,#04H
MOVC A,@A+DPTR
MOV 21H,A
MOV A,21H
SJMP  $
TAB2:DB 00H,01H,04H,09H,16H,25H
END
```

# 2
在内部RAM 的21H单元开始存有一组单字节不带符号数，数据长度为30H，要求找出最大数存入BIG单元。

```
ORG  0000H
MOV R0, #21H ;起始地址
MOV BIG,#00H ;先用0当做最大值
MOV R2, #30H ;数据长度
LOOP:
MOV A, @R0   ;取来一个数据
CLR C
SUBB A, BIG  ;减"最大值"
JNC rel1     ;不够减就算了
MOV A, @R0   ;够减，就把这个数据
MOV BIG,A    ;当做最大值
rel1:
INC R0       ;转向下一个
DJNZ R2, LOOP ;循环
SJMP $          ;结束
END
```
```
	ORG 0000H
	BIG EQU 00H		
	MOV R0,30H
	MOV R1,21H
	MOV R2,00H
	
DL1:NOP
	MOV A,R2
	CLR C
	SUBB A,@R1
	JC REL
	MOV A,@R1
	MOV R2,A
REL:
	INC R1
	DJNZ R0,DL1
	
	MOV BIG,R2
	SJMP $
	END
```
# 3
编写一段程序，完成将片内RAM 40H和41H中的两压缩BCD码相加，并将结果的BCD码存入片内RAM 42H,43H单元中。
```
ORG 0000H
CLR C
MOV A,40H
ADD A,41H
DA A
MOV 43H,A
ADDC A,0
MOV 42H,A
SJMP $
END
```


# 4
将单片机片内RAM区60H-69H单元中的数传送到单片机片外RAM区90H-99H中。(说明：要求用DJNZ指令循环实现。)
```
	ORG 0000H
	MOV R0,#60H
	MOV DPTR,#90H
	MOV R1,#0AH
REL:
	MOV A,@R0
	MOVX @DPTR,A
	INC R0
	INC DPTR
	DJNZ R1,REL
SJMP $
END	
```

# 5
在外部RAM首地址为500H的数据表中，有15个字节的数据。
编程先将每个字节的最低3位取反（其余位不变），然后将结果存入片内RAM首地址为50H的连续存储单元中。 (说明：要求用DJNZ指令实现)

```
	ORG 0000H
	MOV R0,#15
	MOV R1,#50H
	MOV DPTR,#500H
REL:
	MOVX A,@DPTR
	XRL A,#07H
	MOV @R1,A
	INC R1
	INC DPTR
	DJNZ R0,REL
SJMP $
END
```

# 6
在外RAM 1000H 单元开始建立0～99（BCD 码）的一百个数，试编制此程序。
```
	ORG 0000H
	MOV DPTR,#1000H
	MOV R1,#100
	MOV A,#0
REL:
	INC A
	DA A
	MOVX @DPTR,A
	INC DPTR
	DJNZ R1,REL
SJMP $
END
```


# 7
请使用位操作指令，编制程序实现下列逻辑操作：
P1.0=ACC.1∧P2.1∨ACC.2∧P2.2

```
ORG 0000H
CLR C
ORL C,ACC.1

ANL C,P2.1
ORL C,ACC.2
ANL C,P2.2
CLR P1.0
MOV P1.0,C
SJMP $
END
```

# 8
利用51单片机的位逻辑功能，设计程序，以实现下图中的逻辑运算电路（用软件替代硬件）。
其中P1.1和P3.4是端口线上的信息，TF1是定时器定时溢出标志，22H是位地址，运算结果由端口线P1.2输出。

```
START:
	MOV C,P1.1
	ANL C,TF1
	MOV F0,C
	MOV C,23H
	ANL C,/P3.4
	ANL C,F0
	MOV P1.2,C
SJMP $
END
```

# 9
在内部RAM首地址为30H的数据表中有16个字节数据，请编程将每个字节的最高位无条件地置1。

```
    ORG 0000H
	MOV R0,30H
	MOV R1,#16
REL:
	MOV A,@R0
	ORL A,#128
	MOV @R0,A
	INC R0
	DJNZ R1,REL
SJMP $
END
```

# 10
在片内RAM中，起始地址为40H的16个单元中存放有16个无符号数。采用冒泡排序法，试对这些无符号数进行降序排序。

```
	ORG 0000H
	MOV R2,#15
	MOV R3,#15
REL:	
	MOV R0,#40H
	MOV R1,#41H
	CLR C
	MOV A,@R0
	SUBB A,@R1
	JNC notChange
	MOV A,@R0
	MOV R4,A
	MOV A,@R1
	MOV @R0,A
	MOV A,R4
	MOV @R1,A
notChange:
	INC R0
	INC R1
	DJNZ R2,REL
	MOV A,R3
	MOV R2,A
	DJNZ R3,REL
SJMP $
END
```

## 采用冒泡法编写51单片机排序程序
试设计一个子程序，其功能为将（R0）指出的内部RAM中6个单字节正整数按从小到大的次序重新排列。
```
下列程序使用冒泡法排序，经过KEIL仿真测试通过。
    ORG 0000H
;------------------------下面先准备6个数字
    MOV 40H, #8AH
    MOV 41H, #3BH
    MOV 42H, #0B9H
    MOV 43H, #47H
    MOV 44H, #29H
    MOV 45H, #0AFH

    CALL SORT6           ;调用排序子程序

    SJMP $               ;停止，此时可以观察排序结果
;-------------------------------------
SORT6:                   ;排序子程序
    MOV R6, #5          ;6个数字，比较5次
S1:
    MOV R0, #40H        ;起始地址
    MOV B, R6
    MOV R7, B
    CLR PSW.5           ;交换标志清零
S2:
    MOV B, @R0         ;取出前一个数
    INC R0
    MOV A, @R0         ;取出后一个数
    CJNE A, B, S3        ;后－前
S3:
    JNC N_JH            ;够减就不用交换
    MOV @R0, B          ;交换存放
    DEC R0
    MOV @R0, A
    INC R0
    SETB PSW.5           ;设立交换标志位
N_JH:
    DJNZ R7, S2
    JNB PSW.5, S_END    ;没有交换过，就结束
    DJNZ R6, S1
S_END:
    RET
;-------------------------------------
```


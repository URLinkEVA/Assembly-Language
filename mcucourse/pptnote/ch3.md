# 顺序程序设计
## 例 3-1   
编程将外部数据存储器的000EH和000FH单元的内容相换

分析: 外部数据存储器的数据操作只能用MOVX指令，且只能和A之间传送，因此必须用一个中间环节作暂存，设用20H单元。
用R0、R1指示两单元的低八位地址，高八位地址由P2指示。

```
ORG   0000H
MOV  P2,  #00H       ;送地址高八位至P2口
MOV  R0,  #0EH      ;R0= 0EH 
MOV  R1,  #0FH      ;R1= 0FH
MOVX  A,  @R0      ;A=(000EH)
MOV  20H,  A         ;(20H)=(000EH)
MOVX  A,  @R1     ;A=(000FH)
XCH   A, 20H         ; A=(000EH),(20H)=(000FH) 
MOVX   @R1,  A                      
MOV  A,  20H
MOVX   @R0,  A   ;交换后的数送各单元
SJMP   $
END
```

## 例3-2
将R4R5双字节符号数求补码程序
```
    ORG 0000H
    MOV A，R4
    JB ACC.7, CPLL ;判符号位，如为负数转CPLL
    SJMP $         ;正数的补码＝原码
CPLL: MOV A，R5    ;取低字节
    CPL A
    ADD A，#1      ;低字节变补
    MOV R5，A
    MOV A，R4      ;取高字节
    CPL A
    ADDC A，#00H   ;高字节变补
    ORL A,   #80H  ; 恢复负号
    MOV R4，A
    SJMP   $
```
## 例3-3   
求 Y=X^2 (0≤X≤5)

变量X放在片内RAM的20H单元,其值为00H~05H之间, Y在片内RAM的21H单元，在程序存储器安排一张平方表，通过查表求 Y=X^2 ,比完成 X*X 编程简便

表首地址为TAB，以DPTR指向表首址，利用查表指令MOVC A，@A+DPTR，即可求得。

```
    ORG  0000H
    MOV  DPTR,#TAB 
    MOV A, 20H        ；取X
    MOVC A,@A+DPTR    ; 查表
    MOV 21H,A         ; 存于Y
    SJMP $
TAB: DB 00H,01H,04H,09H,16H,25H 
    END
```
## 例3-4 
分解压缩式BCD码,使其成为非压缩式BCD码。如把 65H→06H和05H

```
ORG 0000H
MOV	  R0，#40H	；设指针
MOV	  A，@R0	；取一个字节
MOV	  R2，A	；暂存
ANL	  A，#0FH	；清0高半字节,逻辑与运算
INC	  R0
MOV	  @R0，A  	；保存数据个位
MOV	  A，R2
SWAP    A	  	；十位换到低半字节
ANL	  A，#0FH
INC	  R0
MOV	  @R0，A	；保存数据十位
SJMP   $
```

# 分支程序设计
## 例3-5
在内部RAM的40H和41H地址单元中，有 2个无符号数，试编程比较这两数的大小，将大数存于内部RAM的GR单元，小数存于LE单元，如两数相等，则分别送入GR和LE地址单元。

```
GR EQU 30H
LE EQU 31H
ORG OOOOH
MOV A,40H
CJNE A,41H,NEQ
MOV GR,A
MOV LE,A
SJMP $
NEQ:JC LESS
MOV GR,A
MOV LE,41H
SJMP $
LESS:MOV LE,A
MOV GR,41H
SJMP $
END
``` 
### 利用转移地址表实现转移
根据R3的内容转向对应的程序，R3的内容为0～n,处理程序的入口符号地址分别为PR0～PRn (n<128)

将PR0—PRn入口地址列在表格中，每一项占两个单元，PRn在表中的偏移量为2n，因此将R3的内容乘2即得PRn在表中的偏移地址，从偏移地址2n和2n+1两个单元分别取出PRn的高八位地址和低八位地址送DPTR寄存器，用JMP @A+DPTR指令（A先清零）即转移到PRn入口执行。设PR0—PRn入口地址分别为0110H，0220H，0330H，......程序如下：
```
ORG　0000H
PR0  EQU 0110 H
PR1  EQU 0220 H 
PR2  EQU 0330 H 
MOV A,R3             ;R3→A
ADD A,ACC            ;A*2
MOV DPTR,#TAB
PUSH ACC
MOVC A,@A+DPTR ;取地址表中高字节
MOV B,A              ;暂存于B
INC DPL              ;表地址加1
POP ACC
MOVC A,@A+DPTR ;取地址表中低字节
MOV DPL,A
MOV DPH,B        ;DPTR为表中地址
CLR A              ;A=0
JMP @A+DPTR         ;转移
TAB：DW PR0,PR1,PR2,…..,PRn ;转移地址表
END
```

### 利用转移指令表实现转移
设有五个按键 0、1、2、3、4其编码分别为3AH、47H、65H、70H、8BH，要求根据按下的键转向不同的处理程序，分别为PR0 、PR1 、PR2、PR3、PR4，设按键的编码已在B寄存器中，编出程序。

将键码排成表，将键码表中的值和B中的键编码比对，记下在键码表中和B中的键编码相等的序号，另安排一个转移表,安排AJMP指令(机器码)，因每条AJMP指令占二字节，将刚才记下的序号乘2即为转移表的偏移地址，利用JMP @A+DPTR执行表内的AJMP指令，从而实现多分支转移.

```
       PR0 EQU 0110H
       PR1 EQU 0220H
       PR2 EQU 0330H
       PR3 EQU 0440H
       PR4 EQU 0550H
       ORG 0000H
       MOV DPTR,#TAB             ;置键码表首址
       MOV A,#0                          ;表的起始位的偏移量为0
NEXT:  PUSH ACC
       MOVC A,@A+DPTR        ;取键码表的编码存于A
       CJNE A,B,AGAN             ;将B中值和A中的键码比较，不等转移
       POP ACC    ；A=B,查到了B的键码恢复键码表的偏移量（序号）
       RL A                                ; 序号乘2得分支表内偏移量
       MOV DPTR,#JPT            ;置分支表首址
       JMP @A+DPTR              ；如B=65H，该指令即为JMP  001CH
AGAN: POP ACC                        ;不相等比较下一个
       INC A                                  ;序号加1
       CJNE A,#5,NEXT
       SJMP $                           ;键码查完还没有B中按键编码程序结束
JPT:  AJMP PR0                     ;分支转移表
       AJMP PR1
       AJMP PR2
       AJMP PR3
       AJMP PR4
TAB: DB 3AH,47H,65H,70H,8BH      ;键码表
```
# 循环程序设计
## 例3-9 
设计一个延时10ms的延时子程序，已知单片机使用的晶振为6MHz。

延时时间与两个因素有关:晶振频率和循环次数。由于晶振采用6MHz，一个机器周期是2μs，用单循环可以实现1ms延时，外循环10次即可达10ms延时。

```
ORG OO20H
MOV  R0，#0AH  ；外循环10次
DL2：  MOV  R1，#MT   ；内循环MT次
DL1：  NOP 
NOP   ；空操作指令
DJNZ  R1，DL1 
DJNZ  R0，DL2 
RET
```
```
内循环DL1到指令DJNZ R1，DL1的计算：
（1+1+2）×2μS×MT=1000μS
MT=125=7DH
将7DH代入上面程序的MT，计算总的延时时间：
{1+[1+（1+1+2）×125+2] × 10}×2μS=10062μS=10.062mS
```

## 例3-10 
编写多字节数×10程序

内部RAM以20H为首址的一片单元中存放着一个多字节符号数，字节数存放在R7中，存放方式为低位字节在低地址，高位字节在高地址，要求乘10后的积仍存放在这一片单元中。

用R1作该多字节的地址指针，部分积的低位仍存放于本单元，部分积的高位存放于R2，以便和下一位的部分积的低位相加。以R7作字节数计数。

```
        ORG  0000H
        CLR  C            ；清进位位C
        MOV  R1，#20H     ；R1指示地址
        MOV  R2，#00H     ；存积的高八位寄存器R2清0
S10：MOV  A, ＠R1         ；取一字节送A
        MOV  B，#0AH      ；10送B
        PUSH  PSW
        MUL  AB           ；字节乘10
        POP  PSW        
        ADDC A，R2        ；上次积高八位加本次积低八位 
        MOV @R1，A        ；送原存储单元
        MOV R2，B         ；积的高八位送R2
        INC R1            ；指向下一字节
        DJNZ R7，S10      ；未乘完去SH10，否则向下执行
        MOV @R1，B         ；存最高字节积的高位
        SJMP $
```

## 例3-11
将片内RAM  30H-39H中的10个无符号的无序数按从小到大的顺序排列到这一片单元中
```
	ORG   0000H
START:  CLR    00H                 ；00H位作交换标志位
	CLR    C
	MOV   R7, #09H       ；比较次数
	MOV   R0, #30H        ；地址
	MOV   A, @R0          ；取数到A
LOOP:   INC   R0                  ；指向新的下一单元
	MOV   R2, A             ；R2 暂存大数 
	SUBB  A, @R0         ；比较，A中为差，谁大反映在C.
	MOV   A, R2              ；还原成单元中的数
	JC    NEXT            ；A中数小不交换
	SETB   00H               ； A中数大交换，置交换标志
	XCH    A, @R0         ；交换， A中大数置于高地址单元
	DEC    R0
	XCH    A, @R0         ；小数置于低地址单元
	INC     R0                  ；指向已比较过的高地址单元
NEXT:   MOV   A, @R0         ；取数
	DJNZ  R7, LOOP
	JB   00H, START      ；交换标志位为1，重新进行下一轮比较
        SJMP   $
```
# 子程序
## 例3-16 
用程序实现 c = a2 + b2，设a,b均小于10。a存放在31H单元，b存放在32H单元，把 c 存入34H和33H单元。（和要求为BCD码）

因该算式两次用到平方值，所以在程序中采用把求平方编为子程序的方法。求平方采用查表法 , 主程序和子程序编写如下
```
ORG  0000H                      
MOV  SP，#3FH 
MOV   A，31H       ；取a
LCALL   SQR         ;求a方
MOV   R1，A
MOV   A，32H       ；取b
LCALL   SQR         ; 求b方
ADD   A，R1          ; 求和
DA   A                      ；调整
MOV    33H，A   
MOV   A，#0
ADDC   A，＃0  
MOV   34H，A             
SJMP   $ 
子程序：   
ORG   0030H
SQR：INC A         
     MOVC A，@A+PC  
     RET
TAB：DB 00H,01H,04H
     DB  09H 16H,25H,
     DB  36H,49H64H,81H
     END
```
## 例3-17
求两个无符号数数据块中的最大值的乘积。 数据块的首地址分别为60H和70H，每个数据块的第一个字节都存放数据块长度，结果存入5FH和5EH单元中。

可采用分别求出两个数据块的最大值然后求积的方法，求最大值的过程可采用子程序。子程序的入口参数是数据块首地址，存放在R1中；出口参数为最大值，存放在A中
```
主程序:
ORG 000H
MOV R1, #60H		;置第一个数据块入口参数
ACALL QMAX		;调求最大值子程序
MOV B,A			;第一个数据块的最大值暂存于B中
MOV R1,#70H		;置第二个数据块入口参数
ACALL QMAX		;调求最大值子程序
MUL AB			;求积
MOV 5EH,A			;存积低位
MOV 5FH,B			;存积高位
SJMP $
子程序:
ORG 0030H
QMAX: MOV  A,@R1	;取数据块长度
MOV  R2, A	;设置计数值
CLR   A		;设0为最大值
LP1: INC R1		;修改地址指针
CLR   C		;0->CY
SUBB   A,@R1	;两数相减，比较大小
JNC     LP3		;原数仍为最大值转LP3
MOV   A,@R1	;否，用此数代替最大值
SJMP  LP4		;无条件转移
LP3:  ADD  A,@R1    ;恢复原最大值（因用SUBB做比较指令)
LP4:  DJNZ  R2,LP1	;若没比较完，继续比较
RET			;比较完,返回
END
```

# 思考练习
## 1
设在8031内部RAM中存一无符号数的数组，其长度为100，起始地址是30H，要求将它们从大到小排序，排序后仍存放在原区域中，试编程
```
ORG  1000H
BUBBLE：MOV  R0，#30H
        MOV  R7，#63H
        CLR  10H
LOOP：MOV  A，@R0            ；内循环的入口
      MOV  20H，A            ；暂存，为交换作准备
      INC  R0
      MOV  21H，@R0
      CJNE  A，21H，BUEU     ；若（20H）≠（21H）转移

BUEU： JNC  BUNEXT        ；（20H）≥（21H）转移
         MOV  A，@R0        ；若（20H）< （21H）则交换
         MOV  @R0，20H
         DEC  R0            ；使R0退格指向小地址
         MOV  @R0，A
         INC  R0            ；恢复R0指向大地址
         SETB  10H          ；置交换标志
BUNEXT： DJNZ  R7，LOOP      ；内循环是否结束的判断
         JB  10H，BUBBLE    ；判断标志位为1否？外循环结束的判断
         END
```


## 2
设晶振6MHz，试分别设计延迟1ms、200ms、5s的延时程序
```
;1ms
ORG    2000H
       MOV    R7，#250
LOOP1：DJNZ   R7，LOOP1
       RET
```
```
;200ms
       MOV    R6，#200
LOOP2：DJNZ   R6，LOOP2
```

```
;5s
MOV    R5，#25
LOOP3：DJNZ   R5，LOOP3
```

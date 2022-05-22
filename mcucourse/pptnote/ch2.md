# 单片机指令系统
## 助记符举例
```
MOV  __  move                 传送
XCH  __  exchange             交换
ANL  __  and logic            与逻辑运算
XRL  __  exclusive or logic   异或运算
MUL  __  multiply             乘法
RR   __  rotate right         右循环
SJMP __  short jump           短跳转
RET  __  return               子程序返回
```
## 指令中操作数的描述符号
```
Rn       ——工作寄存器(R0 - R7)
Ri       ——间接寻址寄存器(R0、R1)
Direct   ——直接地址(30H、0D0H等）
#data    ——8位常数(#30H、#0F0H等）
#data16  ——16位常数(#1234H等）
addr16   ——16位目的地址(2030H等）
addr11   ——11位目的地址(123H等）
rel      ——8位带符号的偏移地址(08H、0E5H等）
DPTR     ——16位外部数据指针寄存器(1234H等）
bit      ——可直接位寻址的位（01H等）
```
```
A     ——  累加器
B     ——  寄存器B
C     ——  进、借位标志位，或位累加器
@    ——  间接寄存器或基址寄存器的前缀
/     ——  指定位求反
(x)   ——  x中的内容
((x)) ——  x中的地址中的内容
＄    ——  当前指令存放的地址 
←    ——  箭头右边的内容传送到箭头左边
```

## 寻址方式
### 立即寻址
- 立即数前用“#”作为前缀，以区别直接地址。
- 常数以A~F开头时，应在其前加0，以区别其它符号（如0EFH）。
- 立即数只能作源操作数，不能作目的操作数。


### 直接寻址
指令中操作数直接以单元地址的形式给出

### 寄存器寻址
操作数在寄存器中的寻址方式

### 寄存器间接寻址
寄存器中存放的是操作数的地址

> MOVX  A，@DPTR

- 可用于间址的寄存器有R0、R1、DPTR和SP。寄存器间址符号为@。
- 片内RAM 256B单元
    - 间址寄存器：R0或R1
    - 通用形式为：MOV指令及@Ri（i=0或1）
- 片外RAM 64KB
    - 间址寄存器：DPTR
    - 通用形式为：MOVX指令及@DPTR
- 片外RAM低256B单元
    - 间址寄存器：R0或R1
    - 通用形式为：MOVX指令及@Ri（i=0或1）
- 堆栈操作指令（PUSH和POP）也应算作是寄存器间接寻址，即以堆栈指针SP作间址寄存器的间接寻址方式。

### 基址+变址寻址
基址+变址寻址是以DPTR或PC作基址寄存器，以累加器A作为变址寄存器，并以两者中的内容相加形成16位地址作为操作数地址，已达到访问程序存储器中数据表格的目的。

> MOVC  A，@A+DPTR；A←(A+DPTR)

> MOVC  A，@A+PC；A←(A+PC)

### 相对寻址
以当前程序计数器PC的内容为基础，加上指令给出的一字节偏移量形成新的PC值的寻址方式称为相对寻址。

- 相对寻址用于修改PC值，主要用于实现程序的分支转移。
- 目的地址=转移指令地址+转移指令字节数+rel
    - rel（-128 ~  +127）

### 位寻址
操作数的地址是位地址的寻址方式称为位寻址，即操作数是片内RAM中的某一位的信息。

#### 位地址的表示形式
```
直接使用位地址。    SETB  0D5H
使用位名称。    SETB  F0
单元地址加位数。    SETB  0D0H.5
专用寄存器符号加位数。    SETB  PSW.5
```


# 练习题1
## 思考练习1
指出下列指令的寻址方式
```
MOV   A，R1
ADD   A，#05H
MOV   A，@R1
MOV   30H，4AH
MOVC  A，@A+DPTR
SJMP  LP
MOV   65H, C
```

## 思考练习2
设(70H)＝60H，(60H)＝20H，(P1)＝B7H。写出下列程序顺序执行后的结果。 
```
MOV  R0，#70H    
MOV  A，@R0     	       		
MOV  R1，A              		
MOV  B，@R1     	       		
MOV  @R0，P1    	       	
MOV  60H，#60H  	
```

## 思考练习3
已知内部RAM中(30H)=40H，(40H)=10H，(10H)=00H，(P1)=0CAH，分析以下程序执行后，各单元及寄存器、P2口的内容。
```
MOV 	R0，#30H   			
MOV  	A，@R0   			
MOV  	R1，A    	
MOV  	B，@R1   			
MOV  	@R1，P1  			
MOV  	P2，P1    			
MOV  	10H，#20H 	
```

## 思考练习4
设SP＝32H，内部RAM的30H～32H单元内容分别为20H，23H，01H。
```
执行指令：
	POP  DPH
	POP  DPL
	POP  B
结果 (DPTR)=  0123H   、(B)= 20H  。 	
```
DPTR 16位，高8位DPH，低8位DPL

## 思考练习5
设SP＝60H，A=30H，B=70H。
```
执行指令：
    PUSH  ACC
    PUSH  B
结果 (61H)=    、(62H)=     、SP=    。 	
```

## 思考练习6
试用不同方法实现将片内RAM 30H单元与40H单元中的内容互换。写出实现互换的指令。 

### 方法1
```
（字节交换传送法）
   MOV  A，30H
   XCH  A，40H
   MOV  30H，A
```
### 方法2
```
（直接地址传送法）
   MOV  31H，30H
   MOV  30H，40H
   MOV  40H，31H
```

## 思考练习7
试用不同方法实现将片内RAM 30H单元与40H单元中的内容互换。写出实现互换的指令。
### 方法3
```
（堆栈传送法）
   PUSH   30H
   PUSH   40H
   POP    30H
   POP    40H
```
### 方法4
```
（间接地址传送法）
   MOV   R0，#30H
   MOV   R1，#40H
   MOV   A，@R0
   MOV   B，@R1
   MOV   @R1，A
   MOV   @R0，B
```

## 思考练习8
1.在基址+变址寻址方式中，以       或       作为基址寄存器，以       作为变址寄存器。

2.指令格式是由      和      组成，也可仅由      组成。

3.在寄存器间接寻址方式中，其“间接”体现在指令中寄存器的内容不是操作数，而是操作数的        。

4.访问SFR，可使用哪些寻址方式？

5.MCS-51系列单片机指令系统有几种寻址方式？


## 思考练习9
1.假定累加器A中的内容为30H，执行下列指令：

         1000H： MOVC  A,@A+PC

  则指令功能是把程序存储器        单元的内容送入累加器A中。

2.写出能完成下列数据传送的指令。
```
(1)R1中内容传送到R0；
(2)内部RAM 20H单元中内容送到内部RAM 30H单元；
(3)外部RAM 20H单元中内容送到内部RAM 30H单元；
(4)外部RAM 2000H单元中内容送到内部RAM 30H单元；
(5)外部ROM 2000H单元中内容送到内部RAM 30H单元；
(6)外部ROM 2000H单元中内容送到外部RAM 30H单元；
(7)外部ROM 2000H单元中内容送到外部RAM 3000H单。	
```

3. 以近程查表方法求累加器A中数(0~5)的立方值，并保存到累加器A中。
```
        ORG    2000H
  MAIN：MOV    A，#TAB    ；取偏移量
        INC    A          ；修正偏移地址，单字节
        MOVC   A，@A＋PC ；查表，单字节
        RET               ；子程序返回，单字节
   TAB：DB	 0，1，8，27，64，125；数据表，从2005H;单元开始存放
```

# 练习题2
## 思考练习1
已知（A）＝F0H、（R1）＝40H	 （40H）＝0FH、（30H）＝18H
```
ANL	 A，R1;A＝40H
ANL	 A，40H;A＝00H
ORL	 A，@R1;A＝FFH
ORL	 A，#30H;A＝F0H
XRL	 30H，A;(30H)＝E8H
XRL	40H，#0FH;(40H)=00H
```
## 思考练习2
已知(A)=89H，(Cy)=0
```
CLR	A    ;A =00H
CPL	A    ;A =76H
RL	A    ;A =13H
RLC	A    ;A =12H,CY = 1
RR	A    ;A =C4H
RRC	A    ;A =44H,CY = 1
```

## 思考练习3
设：(A)=0FFH,(R3)=0FH,(30H)=0F0H,(R0)=40H,(40H)=00H

写出执行下列指令后的结果
```
INC  A (A)=00H
INC  R3 (R3)=10H
XRL  30H，A (30H)=0FH
DEC  ＠R0 (40)=0FFH
```

## 思考练习4
将累加器A的低4位传送到P1口的低4位，但P1口的高4位和累加器A的内容需保持不变。写出相应的程序段。
```
MOV  	 R0，A　　　　　		
ANL   A，＃0FH　　　		
ANL   P1，#0F0H   		
ORL   P1，A    　　　		
MOV   A，R0 
```

## 思考练习5
将内部RAM 50H中数据的低4位传送到P1口的高4位，P1口的低4位翻转，而且要求程序执行后50H中的数据保持不变。写出相应的程序段。
```
MOV	 A，50H				
ANL	 A，#0FH			
SWAP	 A					
ANL	 P1，#0FH			
XRL	 P1，#0FH			
ORL	 P1，A
```

## 思考练习6
将外部数据存储器RAM从1000H开始的连续单元的数据，传送到内部RAM从40H开始的连续单元，所传送的数据为零时，传送停止。
```
        MOV	DPTR，#1000H	
       	MOV   	R0，  #40H  	
LOOP：	MOVX  	A，@DPTR 		
       	JZ     	NEXT      		
       	MOV  	         @R0，A     	
       	INC    	DPTR        	
       	INC   	R0           	
       	SJMP  	LOOP        	
NEXT：	END  
```

## 思考练习7
比较内部RAM中30H和40H中两个无符号数的大小，大数存于50H，小数存于51H单元中。若两数相等，则置位片内RAM的127

```
        MOV	A，30H
	CJNE	A，40H，Q1	；两数不等则转Q1
	SETB  127		；相等则置位127
	SJMP  NEXT		；转出口
Q1：	JC    Q2         	；大数在40H单元，转Q2
    	MOV  	50H，A    	；大数在30H单元，存于50H单元  
    	MOV 	51H，40H  	；小数存于51H单元
    	SJMP  NEXT        ；转出口
Q2：	MOV  	50H，40H  	；大数在40H单元，存于50H单元
    	MOV 	51H，A     	；小数存于51H单元
NEXT：RET              	；统一出口
```

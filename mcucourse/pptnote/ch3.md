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





# 思考练习
## 1
设在8031内部RAM中存一无符号数的数组，其长度为100，起始地址是30H，要求将它们从大到小排序，排序后仍存放在原区域中，试编程



## 2
设晶振6MHz，试分别设计延迟1ms、200ms、5s的延时程序

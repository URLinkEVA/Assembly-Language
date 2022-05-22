# 一份选择

1．当CPU响应外部中断0 INT0的中断请求后，程序计数器PC的内容是A。

A．0003H   B．000BH   C．00013H    D．001BH

2．当CPU响应外部中断1 INT1的中断请求后，程序计数器PC的内容是C。

A．0003HB．000BHC．00013HD．001BH

3．MCS-51单片机在同一级别里除串行口外，级别最低的中断源是C。

A．外部中断1B．定时器T0C．定时器T1D．串行口

4．MCS-51单片机在同一级别里除INT0外，级别最高的中断源是B。

A．外部中断1B．定时器T0C．定时器T1D．外部中断0

5．

6．当定时器T0发出中断请求后，中断响应的条件是C。

A．SETB ET0B．SETB EX0C．MOV IE，#82HD．MOV IE，#61H

7．MCS-51单片机CPU开中断的指令是A。

A．SETB  EAB．SETB  ESC．CLR  EAD．SETB  EX0

8．MCS-51单片机外部中断0开中断的指令是B。

A．SETB  ETOB．SETB  EXOC．CLR  ETOD．SETB  ET1

9．8051响应中断后，中断的一般处理过程是A。
```
A．关中断，保护现场，开中断，中断服务，关中断，恢复现场，开中断，中断返回
B．关中断，保护现场，保护断点，开中断，中断服务，恢复现场，中断返回
C．关中断，保护现场，保护中断，中断服务，恢复断点，开中断，中断返回
D．关中断，保护断点，保护现场，中断服务，关中断，恢复现场，开中断，中断返回
```

10．8051单片机共有5 个中断源，在同一级别里，5个中断源同时发出中断请求时，程序计数器PC的内容变为B。

A．000BH           B．0003H          C．0013H          D．001BH

11．MCS-51单片机响应中断的过程是D。
```
A．断点PC自动压栈，对应中断矢量地址装入PC  
B．关中断，程序转到中断服务程序
C．断点压栈，PC指向中断服务程序地址
D．断点PC自动压栈，对应中断矢量地址装入PC，程序转到该矢量地址
```

12．执行中断处理程序最后一句指令RETI后，D。
```
A．程序返回到ACALL的下一句
B．程序返回到LCALL的下一句
C．程序返回到主程序开始处
D．程序返回到响应中断时一句的下一句
```
13．MCS-51单片机响应中断矢量地址是C。
```
A．中断服务程序的首句地址
B．中断服务程序的出口地址
C．中断服务程序的入口地址
D．主程序等待中断指令的地址
```
14．当TCON 的IT0 为1，且CPU 响应外部中断0，INT0的中断请求后， C 。
```
A．需用软件将IE0 清0
B．需用软件将IE0 置1
C．硬件自动将IE0清0 
D．INT0（P3.2管脚）为高电平时自动将IE0 清0
```

15．外部中断源（外部中断1）的矢量地址为C。1INT

A．0003H             B．000BH      C．0013H      D．002BH

16．8051单片机共有B中断源。

A．4                 B．5           C．6         D．7

17．MCS-51单片机在同一级别里除串行口外，级别最低的中断源是      。C

A．外部中断1       B．定时器T0       C．定时器T1        D．串行口

18．MCS-51单片机在同一级别里除INT0外，级别最高的中断源是      。B

A．外部中断1       B．定时器T0       C．定时器T1    D．外部中断0

19．关于下列四种说法有几个是正确的（A）
```
①、同一级别的两个中断请求按时间的先后顺序响应。    ②、同级中断不能嵌套。
③、低优先级中断请求不能中断高优先级中断请求。
④、高优先级中断请求能中断低优先级中断请求。
```
 A、全正确   B、3个正确   C、2个正确  D、1个正确 

20．中断查询的是： (  B  ) 
```
   A. 中断请求信号                B. 中断标志位
   C. 外中断方式控制位            D. 中断允许控制位
```
MCS-51单片机定时器外部中断1和外部中断0的触发方式选择位是      。C

   A．TR1和TR0      B．IE1和IE0         C．IT1和IT0      D．TF1和TF0
   
在8051中，外部中断由IT0(1)位来控制其两种触发方式，分别是电平触发方式和边沿触发方式。
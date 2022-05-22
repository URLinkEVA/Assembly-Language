# 思考练习
## 1
80C51的外部中断有  电平触发 和  脉冲触发 两种触发方式。


## 2
中断具备 中断源 、中断响应和 中断返回三个要素。 


## 3
某单片机系统使用了全部5个中断源，其中INTO和串行口中断为高级中断，其它三个为低级中断。INTO为低电平有效，INT1为下降沿有效。试写出相关程序并设置有关的专用寄存器。 
```
ORG    0000H        ；复位地址
LJMP   MAIN
ORG    0003H        ；外部中断0入口地址
LJMP   INT0_PRO
ORG    000BH        ；定时中断0入口地址
LJMP   T0_PRO
ORG    0013H        ；外部中断1入口地址
LJMP   INT1_PRO
ORG    001BH        ；定时中断1入口地址
LJMP   T1_PRO
ORG    0023H        ；串行中断入口地址
LJMP   TR_PRO
```
```
ORG    0030H
    MAIN：MOV    SP，#0EH ；开辟堆栈
          MOV    IP，#11H ；设置优先级
          SETB   IT1      ；脉冲触发方式
          CLR    ITO      ；电平触发方式
          MOV    IE，#9FH ；设置中断允许位
          ┇
          ORG    0100H
INT0_PRO	：┇            ；INTO中断服务程序
          RETI
```
```
          ORG    0180H        
  T0_PRO：┇            ；TO中断服务程序
          RETI
          ORG    0200H        
INT1_PRO：┇            ；INT1中断服务程序
          RETI
          ORG    0350H        
  T1_PRO：┇            ；T1中断服务程序
          RETI
          ORG    1000H        
  TR_PRO：┇            ；串口中断服务程序
          RETI
```

## 4
为上题中的串口中断编制一段串口中断服务子程序
```
        ORG    1000H        
TR_PRO：PUSH   PSW       ；保护现场
        PUSH   A
        CLR    RS1       ；设置工作寄存器
        SETB   RS0
        JB     RI，RI_PRO；是接收中断则转移
        CLR    TI        ；是发送中断，软件清零
        ……
TR_RET：POP    A
        POP    PSW
        RETI
RI_PRO：CLR    RI        ；软件清零
        ……
        AJMP   TR_RET
```

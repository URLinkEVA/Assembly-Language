# 前言
控制指令是将程序跳转到某个指定的地址，在顺序执行

控制指令是通过修改PC的内容来实现跳转的功能

PC的内容是将要执行的下一跳指令的地址

# 无条件转移指令
LJMP英文全称：Long Jump

AJMP英文全称：Absolute Jump

SJMP英文全称：Short Jump

JMP英文全称：Jump
## LJMP addr16
指令名称：长转移指令

目的：程序无条件转向 **64KB** 程序存储器地址空间的任何单元

源操作数：16位跳转目标地址

- 地址范围为0000H—FFFFH；
- addr16常采用标号地址（如：LOOP、LOOP1、MAIN、START、DONE、NEXT1……）表示；

## AJMP addr11
指令名称：绝对转移指令

目的：程序无条件转向 **2KB** 程序存储器地址空间的任何单元

源操作数：11位跳转目标地址


## SJMP rel
指令名称：相对短转移指令

目的：程序无条件转向 **256B** 程序存储器地址空间的任何单元

源操作数：8位跳转相对地址


## JMP @A + DPTR
指令名称：间接移指令/散转指令

目的：程序无条件转向DPTR和A之和的目标地址空间单元

源操作数：16位的DPTR和8位的累加器A

## 关于SJMP、AJMP、LJMP的选择
SJMP 如果跳转到的标号地址距离当前PC所指的地址小于256字节，用SJMP

AJMP 如果跳转到的标号地址距离当前PC所指的地址小于2K字节，用AJMP

LJMP 如果跳转到的标号地址距离当前PC所指的地址小于64K字节，用LJMP

# 条件转移指令
JZ英文全称：Jump if Zero

JNZ英文全称：Jump if Not Zero

CJNE英文全称：Compare Jump if Not Equal

DJNE英文全称：Compare Jump if Not Equal

## JZ rel
指令名称：判零转移指令

目的：对累加器A中的内容进行零的判定

源操作数：8位跳转相对地址

## JNZ rel
指令名称：判零转移指令

目的：对累加器A中的内容进行零的判定，同JZ

源操作数：8位跳转相对地址

## CJNE XXX, XXX, rel
指令名称：比较转移指令

目的：对指定的目的字节和源字节进行比较， **不等转移，相等继续执行** 

源操作数：8位跳转相对地址，累加器A，直接地址direct，立即数#data，间接寄存器@Ri，寄存器Rn

## DJNZ XXX, rel
指令名称：循环转移指令

目的：以直接地址或寄存器Rn的单元内容作为循环控制寄存器使用，利用其进行循环

源操作数：8位跳转相对地址，寄存器Rn，直接地址direct

- 执行一次该语句，第一操作数减一，判断字节变量是否为0，不为0则继续循环；为0，则退出循环；
- DJNZ可以理解高级语言中的for (int i = n; i > 0; i–-)循环语句；


# 调用和返回指令
ACALL英文全称：Absolute subroutine Call

LCALL英文全称：Long subroutine Call

RET英文全称：Return from Subroutine

RETI英文全称：Return from Interruption

调用和返回之间的过程：
```
CPU在主程序中遇到调用子程序ADD1的指令；
CPU下一条指令第一字节的地址(PC值，断点处)压入堆栈中；
栈指针(SP) + 2，并将ADD1的起始地址送入PC，开始执行子程序了。
子程序执行完，通过RET指令回调到主函数；
将SP中的地址弹回PC中，回到主函数中。
```
## ACALL addr11
指令名称：短调用指令

目的：调用 **2KB** 范围内的所指定的子程序

源操作数：11位目的地址
## LCALL addr16
指令名称：长调用指令

目的：调用 **64KB** 范围内的所指定的子程序

源操作数：16位目的地址
```
1.断点压入栈的过程
将栈指针SP向下移动一个单元空间(对其加一操作)；
将PC的低8位送入SP的内容指向的单元空间；
再将栈指针SP向下移动一个单元空间；
将PC的高8位送入SP的内容指向的单元空间；

2.跳转到子程序过程
将addr15 ~ 0送入PC15 ~ 0，形成16位转移目的地址；
PC就指向子程序的首地址；

3.所调用的子程序首地址可以设置在64KB范围内的ROM中。
```
## RET
指令名称：子程序返回指令

目的：从子程序返回
## RETI
指令名称：中断返回指令

目的：从中断返回

# 位条件转移类指令
JC英文全称：Jump if the Carry flag is set

JNC英文全称：Jump if Not Carry

JB英文全称：Jump if the Bit is set

JNB英文全称：Jump if the Bit is Not set

JBC英文全称：Jump if the Bit is set and Clear the bit


## JC rel
指令名称：判布尔累加器C转移指令

操作数：8位目的地址

## JNC rel
指令名称：判布尔累加器C转移指令

操作数：8位目的地址

- 累加器C是一个布尔累加器，位累加器；
- 根据累加器C中的值进行判断转移。

## JB bit, rel
指令名称：判位变量转移指令

操作数：位变量，8位目的地址
## JNB bit, rel
指令名称：判位变量转移指令

操作数：位变量，8位目的地址

- 根据位变量bit的值进行判断转移；
- JB、JNB相对于JC、JNC，其是对位变量bit进行判断转移，其他性质都一样。
## JBC bit, rel
指令名称：判位变量并清零转移指令

操作数：位变量，8位目的地址

- 相比于JB，JBC仅仅是增加CY清零的步骤；
- 在位变量bit为1时，不仅仅要跳转，还要CY清零。

# 空操作指令
NOP英文全称：No Operation

## NOP
指令名称：空操作指令

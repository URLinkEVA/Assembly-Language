## Debug 调试程序

了解并掌握汇编语言源程序上机练习的过程（四个步骤）：
编辑、汇编、连接和调试。
热身：Debug 调试程序

> 1. masm test.asm 生成obj文件
> 2. link test 连接成exe可执行文件
>3. debug test.exe 调试test.exe程序

|具体指令|作用  |
|---|--|
| -t  |单步执行程序  |
| -g [memory]   | 程序具体执行到memory处  |
|-d |查看内存空间 |
| -d [memory]|查看具体内存空间的值 |


## 题目一
X = 30，Y = 15，求 X + Y，X - Y，X * Y 分别保存至 z1，z2，z3 变量中。

```
STACK SEGMENT
       DW 200 DUP(?)
STACK ENDS
DATA SEGMENT
       X DW 30
       Y DW 15
       Z1 DW ?
       Z2 DW ?
       Z3 DW ?
DATA ENDS
CODE SEGMENT
       ASSUME SS:STACK,DS:DATA,CS:CODE
       START:
       MOV AX,DATA
       MOV DS,AX

       ;Z1=X+Y
       MOV AX,X
       ADD AX,Y
       MOV Z1,AX
       ;Z2=X-Y
       MOV AX,X
       SUB AX,Y
       MOV Z2,AX
       ;Z3=X*Y
       MOV AL,BYTE PTR X
       MUL BYTE PTR Y
       MOV Z3,AX

       MOV AX,4C00H
       INT 21H
CODE ENDS
END START
```

同学的代码

```
.model small
.data
; 定义数据段的内容
x db 30
y db 15
z1 db ?
z2 db ?
z3 dw ?
.code
start
; 下面两条语句是将data段与数据段绑定
mov ax, @data
mov ds, ax

mov al, x
add al, y
mov z1, al

mov al, x
sub al, y
mov z2, al

mov ah, 0
mov al, x
mul y
mov z3, ax

mov ax, 4c00h
int 21h
end start
```
运行结果
![案例](https://github.com/URLinkEVA/Assembly-Language/raw/main/imgs/2d.png)


```
2D：45（30+15） 0F：15（30-15） 01C2：450（15*30）
```

可能使用到的指令

> SUB DST，SRC DST = DST + SRC ADD DST，
> SRC DST = DST + SRC MUL SRC 无符号乘法

其中如果SRC是字节变量，则 AX = AL * SRC
其中如果SRC是字变量，则DX:AX = AX * SRC
### 汇编程序模板

```
.model small
.data
; 定义数据段的内容
.code
start:
; 下面两条语句是将data段与数据段绑定
mov ax,@data
mov ds,ax
mov ax,4c00h
int 21h
end start
```

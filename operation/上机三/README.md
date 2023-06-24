## 循环程序设计
### 题目一
找出一个字节数组中最大数和最小数，分别存入 MAX 和 MIN 单元中(假设字节数组为 45,98,63,78,88,101,89,65,100)
#### 流程图
![流程图](https://img-blog.csdnimg.cn/20210601083119486.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NjE4NTIx,size_16,color_FFFFFF,t_70#pic_center)
#### 效果图
![效果图](https://img-blog.csdnimg.cn/20210601083227112.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NjE4NTIx,size_16,color_FFFFFF,t_70#pic_center)
**最大值是64H（十进制的100），最小值为2EH（十进制的45）**
#### 实现代码

```bash
DATA SEGMENT
    ARRAY DB  45,98,63,78,88,101,89,65,100
    LEN  EQU $-ARRAY
    MIN  DB  ?
    MAX  DB  ?
DATA ENDS

STACK SEGMENT
STACK ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACK
START:
    MOV AX,DATA
    MOV DS,AX

    ;初始化最大值最小值
    MOV AL,ARRAY
    MOV MAX,AL
    MOV MIN,AL

    MOV BX,1
    MOV CX,LEN-1
LOOP1:
    INC BX
    MOV AL,DS:[BX];
    call CMPMAX
    call CMPMIN
    LOOP LOOP1
    JMP EXIT    ;程序结束
CMPMAX:
    CMP MAX,AL
    JAE NEXT1
    MOV MAX,AL
NEXT1: 
    ret
CMPMIN:
    CMP MIN,AL
    JBE NEXT2
    MOV MIN,AL
NEXT2:    
    ret
EXIT:    
    MOV AX,4c00H
    INT 21H
CODE ENDS
END START
```
实现效果
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210602230006207.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NjE4NTIx,size_16,color_FFFFFF,t_70#pic_center)

#### 同学代码

```bash
.model small
.data ; 定义数据段的内容
a db 45, 98, 63, 78, 88, 101, 89, 65, 100
MAX db ?
MIN db ?
.code
start: ; 下面两条语句是将data段与数据段绑定
mov ax, @data
mov ds, ax

mov al, a
mov MAX, al
mov MIN, al
mov cx, 8
mov si, 1
s:
mov al, a[si]
cmp al, MAX
jbe next1
mov MAX, al
jmp short next2
next1:
cmp al, MIN
jae next2
mov MIN, al
next2:
inc si
loop s

mov ax, 4c00h
int 21h

end start
```

### 题目二
统计字变量 X 中的各位有多少个 1，并将结果存入到 NUM 单元中(假设
X=97B4H)
#### 流程图
![在这里插入图片描述](https://img-blog.csdnimg.cn/2021060108350013.png#pic_center)

> 在每个循环体内，使用SHL指令左移X，并根据左移结果影响标志位的状态来判断当前位是不是1，如果是1，则BL+1；如果不是1，则continue

#### 效果图
![](https://img-blog.csdnimg.cn/20210601083630520.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NjE4NTIx,size_16,color_FFFFFF,t_70#pic_center)
**97B4H = 1001 0111 1011 0010，一共有9个1**
#### 实现代码

```bash
DATA SEGMENT
    X DW 9780H
    NUM DB 0
DATA ENDS
CODE SEGMENT
    ASSUME DS:DATA,CS:CODE
START:
    MOV AX,DATA
    MOV DS,AX
    MOV AX,X
    MOV CX,16
LOOP1:
    SHL AX,1
    JNC NEXT1
    INC NUM
NEXT1:
    LOOP LOOP1

    MOV AX,4c00H
    INT 21H
CODE ENDS
END START 
    
```
#### 实现效果
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210602232222658.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NjE4NTIx,size_16,color_FFFFFF,t_70#pic_center)
#### 同学代码

```bash
.model small
.data ; 定义数据段的内容
X dw 97B4h
NUM db 0
.code
start: ; 下面两条语句是将data段与数据段绑定
mov ax, @data
mov ds, ax

mov ax, X
mov cx, 16
s:
shl ax, 1
adc NUM, 0
loop s

mov ax, 4c00h
int 21h

end start
```

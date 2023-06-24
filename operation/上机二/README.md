# 分支程序设计
## 题目一

> 统计学生成绩
> 设有 10 个学生的成绩分别为 46、68、88、87、76、89、99、65、100 和 80 分。试编制程序统计低于 60分、60～69 分、70～79 分、80～89 分、90～99 分及 100 分的人数，并存放到 S5、S6、S7、S8、S9 及 S10 单元中。

![流程图](https://img-blog.csdnimg.cn/20210527230744417.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NjE4NTIx,size_16,color_FFFFFF,t_70#pic_center)
### 思路
1. 在处理成绩的时候，首先取得成绩。可以采取寄存器相对寻址方式，disp保存的是数组的首地址的偏移量，可以用SI保存数组的下标，使用 MOV AX，disp [SI] 进行取值。在判断成绩的时候，可以先取的成绩的十位具体是多少，如果小于6，则直接S5 + 1，否则减去6，放入到BX中，也可以使用取成绩的那种寻
址方式进行操作。
2. 打印变量值，使用21H中断的0200H号子功能，打印某个字符（将打印的字符提前放到DL中），由于我们统计的个数是数字，需要加上30H（十进制的48）将数字转化为相应的ASCII，然后才能进行正常打印。

> MOV DL,48 ; 十进制的48对应的ASCII值为0
MOV AH，0200H
int 21H ;会将字母0打印到屏幕上
3. 打印字符串；0DH，ASCII对应的是回车键，$ 代表的是字符串的结束，就类似于C语言字符串的最后一个
字符串是'\0'
> BUT DB 0DH,'THE RESULT $'
; 将字符串的偏移地址移至DX 然后使用21H中断的0900H子功能进行显示,显示之后再显示具体
的个数
### 难点分析
#### 取数据（寄存器间接寻址方式）
取数据（寄存器间接寻址方式）

```
.model small
.data
table db 0, 1,4,9,16,25,36,49,64,81
x db 0 ;偏移值
cnt dw 10
.code
start:
mov ax,@data
mov ds,ax
mov cx,cnt
mov ax,0
loop1:
mov bx,offset table
mov dl,x
mov dh,0
add bx,dx
mov al,[bx]
add x,1
loop loop1 ; p148
mov ax,4c00h
int 21h
end start
```
**LOOP TOKEN ： CX = CX - 1 当CX != 0 时，跳转到TOKEN继续执行**
#### 处理数据
DIV SRC
字节除法： AX / SRC ，其中商送到AL，余数送到AH
字除法：DX：AX / SRC，其中商送AX，余数送到DX

```
.model small
.data
s1 db ?
s2 db ?
s3 db ?
x db 32
CONST db 10
.code
start:
mov ax,@data
mov ds,ax
mov ah,0
mov al,x
div CONST ;字除法 AL存商
mov bx,offset s1
mov ah,0
sub al,1
add bx,ax
add byte ptr [bx],1
mov ax,4c00h
int 21h
end start
```
#### 显示数据

```
.model small
.data
BUT DB 0DH,0AH,'THE RESULT $'
.code
start:
mov ax,@data
mov ds,ax
mov cx,2
lp1:
mov dx,offset but
mov ax,0900h
int 21h
mov dl,cl
add dl,30h
mov ax,0200h
int 21h
loop lp1
mov ax,4c00h
int 21h
end start
```

### 实现代码
```
.model small
.data
a db 46, 68, 88, 87, 76, 89, 99, 65, 100, 80
s5 db 0
s6 db 0
s7 db 0
s8 db 0
s9 db 0
s10 db 0
string db 'THE RESULT $'
.code
start:
mov ax, @data
mov ds, ax

mov cx, 10
s:
mov bx, cx
mov bl, a[bx-1]
cmp bl, 60
jb  x5
cmp bl, 70
jb  x6
cmp bl, 80
jb  x7
cmp bl, 90
jb x8
cmp bl, 100
jne x9
jmp short x10
x5:
inc s5
jmp short next
x6:
inc s6
jmp short next
x7:
inc s7
jmp short next
x8:
inc s8
jmp short next
x9:
inc s9
jmp short next
x10:
inc s10
next:
loop s

mov bl, s5
call print
mov bl, s6
call print
mov bl, s7
call print
mov bl, s8
call print
mov bl, s9
call print
mov bl, s10
call print

mov ax, 4c00h
int 21h

print:
push dx
push ax

mov dx, offset string
mov ah, 09h
int 21h

mov dl, 48
add dl, bl
mov ah, 02h
int 21h

mov dl, 10
mov ah, 02h
int 21h

pop ax
pop dx

ret
end start
```
### 效果图
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210530230604223.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NjE4NTIx,size_16,color_FFFFFF,t_70#pic_center)
### 同学代码

```
DATA SEGMENT
    DB 46,68,88,87,76,89,99,65,100,80
    S5 DB ?
    S6 DB ?
    S7 DB ?
    S8 DB ?
    S9 DB ?
    S10 DB ?
    OUTPUT DB "THE RESULT ?",0DH,0AH,"$"
DATA ENDS
CODE SEGMENT
    ASSUME DS:DATA, CS:CODE
    START:
        MOV AX,DATA
        MOV DS,AX
        MOV CX,10
    FLAG:
        MOV SI,CX
        MOV AL,[SI-1]
        CMP AL,60
        JNS GRADE60
        ADD S5,1
    NEXT:
        LOOP FLAG

    LEA SI,OUTPUT
    ADD SI,11

    LEA BX,S5;输出60分以下的
    call S

    LEA BX,S6;60-69
    call S

    LEA BX,S7;70-79
    call s

    LEA BX,S8;80-89
    call S

    LEA BX,S9;90-99
    call S

    LEA BX,S10;100
    call S

    MOV AX,4c00H
    INT 21H

S:MOV AX,DS:[BX]
    ADD AX,30H
    MOV DS:[SI],AX
    LEA DX,OUTPUT
    MOV AH,09H
    INT 21H
    ret

    GRADE60:
        CMP AL,70
        JNS GRADE70
        ADD S6,1
        JMP NEXT

    GRADE70:
        CMP AL,80
        JNS GRADE80
        ADD S7,1
        JMP NEXT
    GRADE80:
        CMP AL,90
        JNS GRADE90
        ADD S8,1
        JMP NEXT
    GRADE90:
        CMP AL,100
        JNS GRADE100
        ADD S9,1
        JMP NEXT
    GRADE100:
        ADD S10,1
        JMP NEXT
CODE ENDS
END START

```

### 网上的参考借鉴
```
 ;用汇编语言编写学生成绩统计程序：键盘输入学生成绩到SCORE中（
 ;0<=分数<=100，设有10个学生成绩分别是56，69，84，82，73，88，99，63，100，80）
。
 ;编程将它们由大到小排序，存回到原来的SCORE变量中；
 ;并统计低于60分、60～69、70～79、80～89、90～99及100分的人数，
 ;分别存放在S5、S6、S7、S8、S9、S10单元中。


 CRLF         MACRO            ;回车换行
        MOV         AH, 02H
        MOV         DL, 0DH
        INT          21H
        MOV         AH, 02H
        MOV         DL, 0AH
        INT          21H
 ENDM  
DISPL  MACRO X,Y               ;输出各段人数
        LEA DX,Y
        MOV AH,09H
        INT 21H
        MOV DL,X
        ADD DL,30H
        MOV AH,02H
        INT 21H 

ENDM
    
DATA SEGMENT
 STRING1 DB  'Please Input Score:','$' ;提示输入
 STRING2 DB  'The Order From MAX To MIN:','$'
  ;输出排序从大到小     
    SCORE   DW  60 DUP(0)     ;分配存放空间
    S5  DB 0        ;定义变量
    S6  DB  0
    S7  DB  0
    S8  DB  0
    S9  DB  0
    S10 DB  0 
   SS5 DB 'SCORE BELOW 60:$'
   SS6 DB 'SCORE 60-69:$'
   SS7 DB 'SCORE 70-79:$'
   SS8 DB 'SCORE 80-89:$'
   SS9 DB 'SCORE 90-99:$'
   SS10 DB 'SCORE 100:$'

DATA ENDS
     
STACK SEGMENT                         ;堆栈段
     DW  64 DUP(0)
STACK ENDS

CODE SEGMENT                          ;代码段
     ASSUME CS:CODE,DS:DATA,SS:STACK
START:
    MOV AX,DATA
    MOV DS,AX
    MOV AX,STACK
    MOV SS,AX
    MOV DX,OFFSET STRING1          ;显示提示输入
    MOV AH,09H
 INT 21H
 
 XOR BX,BX                      ;寄存器清零
 XOR CX,CX
 XOR SI,SI
 XOR DI,DI
 
INPUT:  MOV AH,1      ;输入一个字符
        INT 21H
        CMP AL,0DH    ;是否为回车键
        JZ  OVER      ;是就跳到OVER
        CMP AL,20H    ;是否为空格
        JZ  SAVE      ;是就跳到SAVE
        SUB AL,30H    ;变为真数
        MOV CL,4      
        SHL BX,CL     ;左移四位，变为BCD码
        ADD BL,AL
        JMP INPUT

 
SAVE:MOV SCORE[SI],BX   ;保存到SCORE中
    ADD SI,2
    INC DI
    XOR BX,BX
    JMP INPUT

OVER:     MOV SCORE[SI],BX  ;保存最后一个数据，并存放到SCORE中
    INC DI
    MOV DL,0AH
    MOV AH,02H
    INT 21H
    MOV CX,DI  ;记录输入的个数

        MOV S5,0
        MOV S6,0
        MOV S7,0
        MOV S8,0
        MOV S9,0
        MOV S10,0 
 
        LEA SI,SCORE 
        
COMP:   MOV AX,[SI]
        CMP AX,60H ;为什么是60H？调试时发现，AX中存的全是16进制数，
        JL SFIVE   ;数值上与10进制，但经加权后就不等了
        CMP AX,70H ;如：在输入了65时，这时AX中显示的为0065，是16进制的
        JL SSIX     ;如果是从键盘输入100时，AX这时为0100，也是16进制的
        CMP AX,80H  ;这里只简单比较下，没有将内存的16进制全换成10进制
        JL SSEVEN
        CMP AX,90H
        JL SEIGHT
        CMP AX,100H
        JL SNINE  
        INC S10 
        JMP CHANGE

SFIVE:INC S5
        JMP CHANGE
SSIX:INC S6
        JMP CHANGE
SSEVEN:INC S7
        JMP CHANGE
SEIGHT:INC S8
        JMP CHANGE
SNINE:INC S9
        JMP CHANGE  
                   
CHANGE: ADD SI,2
        DEC CX
        JNZ COMP                  
;显示各段人数                   
DISPL1: DISPL S5,SS5
        CRLF
        DISPL S6,SS6
        CRLF            
        DISPL S7,SS7
        CRLF
        DISPL S8,SS8
        CRLF
        DISPL S9,SS9 
        CRLF
        DISPL S10,SS10
        CRLF
        MOV CX,DI
        DEC CX
        XOR BX,BX 
    
             
COMP1:   MOV SI,2      ;指向下一个数
         MOV DX,CX
         
COMP2:   MOV AX,SCORE[BX]     
         CMP AX,SCORE[BX+SI]     ;比较前后两个数
         JNC COMP3            ;小于就跳到COMP3
         XCHG AX,SCORE[BX+SI]    ;交换位置
         MOV SCORE[BX],AX
                 
COMP3:   ADD SI,2    ;指向下一个数
         DEC DX
         JNZ COMP2
         ADD BX,2    ;指向下一个数
         LOOP COMP1
                  
         MOV DX,OFFSET STRING2
         MOV AH,09H
         INT 21H
         SUB SI,SI   ;把SI清零
           
OUT_PUT1: 
         MOV BX,SCORE[SI]    ;输出百位数           
         MOV DL,BH
         AND DL,0FH
         ADD DL,30H
         MOV AH,02H
         INT 21H
         
         MOV DL,BL      ;输出十位数
         MOV CL,4
         SHR DL,CL
         ADD DL,30H
         MOV AH,02H
         INT 21H
         
         MOV DL,BL      ;输出个位数
         AND DL,0FH
         ADD DL,30H
         MOV AH,02H
         INT 21H
         
         MOV DL,20H     ;输出空格
         MOV AH,02H
         INT 21H
         ADD SI,2
         DEC DI
         JNZ OUT_PUT1    
         



    MOV AH,4CH    ;返回DOS
    INT 21H

CODE ENDS
    END START 
    
```

## 题目二

> 对键盘键入的小写字母用大写字母显示出来；若键入的为非字母键，则程序结束。
![流程图](https://img-blog.csdnimg.cn/2021052723141670.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NjE4NTIx,size_16,color_FFFFFF,t_70#pic_center)
### 思路
1. 输入字符的问题，可以使用21H中断的0100H号子功能，通过键盘输入一个ASCII值放入到AL中
> MOV AH,0100H
int 21H; 执行这两行指令，系统会产生中断，直至从键盘录入一个字符
2. 比较字符问题，可以使用CMP指令（p132页）
```
DATA SEGMENT
    X DB ?,"$"
DATA ENDS    
CODE SEGMENT
    ASSUME CS:CODE
START: 
    MOV AX,DATA
    MOV DS,AX
CONTINUE:
    MOV AX,100H
    INT 21H
    CMP AL,97         ;比较
    JAE CMPA          ;转移
    JMP NEXT
CMPA:
    CMP AL,122
    JA NEXT
    SUB AL,32
    MOV DS:[0],AL
    LEA DX,X
    MOV AX,0900H      ;中断
    INT 21H
    JMP CONTINUE
NEXT:    
    MOV AX,4C00H
    INT 21H
CODE ENDS
END START

```
### 效果图
![参考](https://img-blog.csdnimg.cn/20210530222117228.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NjE4NTIx,size_16,color_FFFFFF,t_70#pic_center)

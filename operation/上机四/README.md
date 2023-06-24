分支结合循环程序设计
## 题目内容
根据成绩数组 score 中保存的 10 个学生的成绩，统计相应学生的名次并填入名次数组 rank 中(假设 10 名学生的成绩为 80,60,49,86,100,79,85,86,99,59)
### 流程图
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210603141057516.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NjE4NTIx,size_16,color_FFFFFF,t_70#pic_center)

> 1. 在使用内层循环的时候，首先将外层循环的计数器CX入栈，然后内层循环结束的时候再将CX出栈。
> 2. 取数组的时候，可以采取寄存器相对寻址方式，这种寻址方式在上机二的过程中用到过
### 效果图
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210603141245903.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NjE4NTIx,size_16,color_FFFFFF,t_70#pic_center)
**80,60,49,86,100,79,85,86,99,59对应的排名分别为：6,8,10,3,1,7,5,3,2,9**
### 实现代码
 

```bash
.model small
.data
score db 80,60,49,86,100,79,85,86,99,59
rank db 10 dup(?)
.code
start:
mov ax, @data
mov ds, ax
mov si, 0     ;变址寄存器置0
mov cx, 10    ;数据段
lp1:
mov al, 1
mov di, 0     ;di地址
push cx
mov cx, 10
lp2:
mov ah, score[di]
cmp ah, score[si]
jbe next      ;低转
inc al
next:
inc di
loop lp2
pop cx
mov rank[si], al
inc si
loop lp1

mov ax, 4c00h
int 21h
end start
```
### 实现效果
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210606231635110.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NjE4NTIx,size_16,color_FFFFFF,t_70#pic_center)

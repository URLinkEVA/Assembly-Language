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

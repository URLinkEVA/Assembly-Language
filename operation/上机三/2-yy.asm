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

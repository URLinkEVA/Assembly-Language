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

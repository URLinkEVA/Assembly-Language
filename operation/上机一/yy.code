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

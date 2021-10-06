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

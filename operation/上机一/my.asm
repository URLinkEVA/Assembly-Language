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

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


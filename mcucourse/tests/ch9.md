# 1
假如89S51单片机的P2.7连8255的CS端，89S51的P2.1～P2.0连8255的A1～A0，那么：

(1).试问8255端口A的地址为       (无关项选“1”)

8255控制口的地址为          (无关项选“1”)

(2).用指令写控制字。要求：A口、B口：方式0输入， C口：方式0输出。

(3).用置位/复位控制字的方法,将PC2置位（=1）、PC5复位（=0）。

```
（1） 7CFFH     7FFFH

（2） MOV A,#92H   
          MOV  DPTR, #7FFFH
          MOVX @DPTR, A

（3）MOV DPTR, #7FFFH
    ​     MOV A,#80H
    ​    ​ MOV @DPTR, A
         MOV A, #05H  
         MOV @DPTR, A
         MOV A, #0AH  
         MOVX @DETR,A
```


# 2
在AT89C51单片机上扩展一片8255，使B口可接1个数码管，PC0接共阴极，使用C口的置位/复位控制字，使LED数码管显示“P”字闪烁（已知AT89C51的P2.4与8255的CS相连，P0.3连8255的A1，P0.2连8255的A0）。

要求：（1）画出简要的硬件连接图

2）分析出8255的端口地址（无关项取“1”）

3）编程实现“F”字闪烁功能

(说明：程序中先要对8255初始化，“F”字亮灭的延迟子程序可直接用ACALL DEY调用)。

```
	ORG 0000H
	MOV A, #82H
	MOV DPTR, #0EFFFH
	MOVX @DPTR, A
	MOV DPTR, #0EFF7H
	MOV A, #71H
	MOVX @DPTR, A
	
	MOV A, #80H
	MOV DPTR, #0EFFFH
	MOVX @DPTR, A
	MOV A, #01
	
LOOP:
	XRL A, #01H
	MOVX @DPTR, A
	ACALL DEY
	SJMP LOOP
	END
```

# 思考练习
1.简述线选法和译码法的优缺点。

线选法
- 优点：连接简单，成本低
- 缺点：芯片地址空间不连续，存在地址重叠

译码法
- 硬件电路稍复杂，需要译码器
- 可充分利用存储空间，全译码可避免地址重叠

2.用6116（2K*8）构成4K的数据存储系统。要求采用线选法产生片选信号，并计算6116的地址范围。
```
需要两片6116
A15A14A13A12A11
1   1  1  0  1
1   1  1  1  0
E800-EFFFH
F000-F7FFH
```


3.地址译码关系如图，回答以下问题：

1）属于完全译码还是部分译码？

2）片内译码线和片外译码线各有多少根？

3）所占用的全部地址范围为多少？

![](https://github.com/URLinkEVA/Assembly-Language/raw/main/imgs/1.jpg)

2000H-27FFH,6000H-67FFH


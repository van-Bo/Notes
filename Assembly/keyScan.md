## 实验内容
1. 按照给定的参考图连接好实验接线图
2. 编程: 使得在键盘阵列上每按一个键后，在数码管上有相应字符显示出来，按"E"退出程序。

<img src="./images/8255 键盘扫描及数码管显示实验线路图.png" alt="linking diagram" width="50%">

## 实验源码
```asm
;=======================================================
; 文件名: keyScan.asm
; 功能描述: 键盘及数码管显示实验，通过 8255 控制。
;     8255 的 B 口控制数码管的段显示，A 口控制键盘列扫描
;     及数码管的位驱动，C 口控制键盘的行扫描。
;     按下按键，该按键对应的位置将按顺序显示在数码管上。
;=======================================================

IOY0         EQU   0600H          ;片选 IOY0 对应的端口始地址
MY8255_A     EQU   IOY0+00H*2     ;8255 的 A 口地址
MY8255_B     EQU   IOY0+01H*2     ;8255 的 B 口地址
MY8255_C     EQU   IOY0+02H*2     ;8255 的 C 口地址
MY8255_CON   EQU   IOY0+03H*2     ;8255 的控制寄存器地址

SSTACK  SEGMENT STACK
        DW 16 DUP(?)
SSTACK  ENDS        

DATA    SEGMENT
DTABLE  DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H
        DB 7FH,6FH,77H,7CH,39H,5EH,79H,71H
DATA    ENDS

CODE    SEGMENT
        ASSUME CS:CODE,DS:DATA
START:  MOV AX,DATA
        MOV DS,AX
        MOV SI,3000H
        MOV AL,00H
        MOV [SI],AL                 ;清显示缓冲
        MOV [SI+1],AL
        MOV [SI+2],AL
        MOV [SI+3],AL
        MOV [SI+4],AL
        MOV [SI+5],AL
        MOV DI,3005H
        MOV DX,MY8255_CON           ;写 8255 控制字
        MOV AL,81H
        OUT DX,AL

BEGIN:  CALL DIS                    ;调用显示子程序
        CALL CLEAR                  ;清屏
        CALL CCSCAN                 ;扫描
        JNZ INK1
        JMP BEGIN

INK1:   CALL DIS
        CALL DALLY
        CALL DALLY
        CALL CLEAR
        CALL CCSCAN
        JNZ INK2                    ;有键按下，转到 INK2
        JMP BEGIN

;确定按下键的位置
INK2:   MOV CH,0FEH
        MOV CL,00H
COLUM:  MOV AL,CH
        MOV DX,MY8255_A 
        OUT DX,AL
        MOV DX,MY8255_C 
        IN AL,DX

L1:     TEST AL,01H                     ;is L1?
        JNZ L2
        MOV AL,00H                      ;L1
        JMP KCODE
L2:     TEST AL,02H                     ;is L2?
        JNZ L3
        MOV AL,04H                      ;L2
        JMP KCODE
L3:     TEST AL,04H                     ;is L3?
        JNZ L4
        MOV AL,08H                      ;L3
        JMP KCODE
L4:     TEST AL,08H                     ;is L4?
        JNZ NEXT
        MOV AL,0CH                      ;L4
KCODE:  ADD AL,CL
        CMP AL,0EH                   ; 检查按键是否为 "E"
        JZ EXIT                      ; 如果是 "E" 键，则退出
        CALL PUTBUF
        PUSH AX

KON:    CALL DIS
        CALL CLEAR
        CALL CCSCAN
        JNZ KON
        POP AX
NEXT:   INC CL
        MOV AL,CH
        TEST AL,08H
        JZ KERR
        ROL AL,1
        MOV CH,AL
        JMP COLUM
KERR:   JMP BEGIN
EXIT:   MOV AX,4C00H                ; DOS退出程序
        INT 21H                     ; 中断服务

CCSCAN: MOV AL,00H                  ;键盘扫描子程序
        MOV DX,MY8255_A  
        OUT DX,AL
        MOV DX,MY8255_C 
        IN  AL,DX
        NOT AL
        AND AL,0FH
        RET

CLEAR:  MOV DX,MY8255_B             ;清屏子程序
        MOV AL,00H
        OUT DX,AL
        RET
        
DIS:    PUSH AX                     ;显示子程序
        MOV SI,3000H
        MOV DL,0DFH
        MOV AL,DL
AGAIN:  PUSH DX
        MOV DX,MY8255_A 
        OUT DX,AL
        MOV AL,[SI]
        MOV BX,OFFSET DTABLE
        AND AX,00FFH
        ADD BX,AX
        MOV AL,[BX]
        MOV DX,MY8255_B 
        OUT DX,AL
        CALL DALLY
        INC SI
        POP DX
        MOV AL,DL
        TEST AL,01H
        JZ  OUT1
        ROR AL,1
        MOV DL,AL
        JMP AGAIN
OUT1:   POP AX
        RET

DALLY:  PUSH CX                     ;延时子程序
        MOV CX,0006H
T1:     MOV AX,009FH
T2:     DEC AX
        JNZ T2
        LOOP T1
        POP CX
        RET

PUTBUF: MOV SI,DI                   ;存键盘值到相应位的缓冲中
        MOV [SI],AL
        DEC DI
        CMP DI,2FFFH
        JNZ GOBACK
        MOV DI,3005H
GOBACK: RET

CODE    ENDS
        END START
```

## 要点分析

### 数据段定义
- 定义了一个数码管段码表(共阴极段码), 用于将数字和字母转换为数码管显示
```asm
DATA    SEGMENT
DTABLE  DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H
        DB 7FH,6FH,77H,7CH,39H,5EH,79H,71H
DATA    ENDS
```

### 清除显示缓存、初始化 8255 控制字
- 清除显示缓冲区 `3000H` 到 `3005H`, 6 个缓冲区分别对应 6 个显示数码管
- 8255 工作方式控制字设置为: `1000 0001`, C 口(低 4 位)为输入, C 口(高 4 位)为输出, B 口为输出(方式 0), A 口为输出(方式 0)
```asm
CODE    SEGMENT
        ASSUME CS:CODE,DS:DATA
START:  MOV AX, DATA
        MOV DS, AX
        MOV SI, 3000H
        MOV AL, 00H
        MOV [SI], AL                 ;清显示缓冲
        MOV [SI+1], AL
        MOV [SI+2], AL
        MOV [SI+3], AL
        MOV [SI+4], AL
        MOV [SI+5], AL
        MOV DI, 3005H

        MOV DX, MY8255_CON           ;写 8255 控制字
        MOV AL, 81H
        OUT DX, AL
```

### 主循环
- 调用显示子程序 `DIS`, 清屏子程序 `CLEAR` 和键盘扫描子程序 `CCSCAN`
- 如果检测到按键, 则跳转到 `INK1` 处理, 否则返回 `BEGIN` 继续循环
```asm
BEGIN:  CALL DIS                    ;调用显示子程序
        CALL CLEAR                  ;清屏
        CALL CCSCAN                 ;扫描
        JNZ INK1
        JMP BEGIN
```

### 按键处理
- 在 `INK1` 标记处, 再次检测按键, 并进行延时, 确定稳定检测
- `INK2` 标记处, 开始检测按键位置, 初始化 `CH` 和 `CL`, 其中 `CH` 为列扫描状态, `CL` 列偏移值(初值为零)
```asm
INK1:   CALL DIS
        CALL DALLY
        CALL DALLY
        CALL CLEAR
        CALL CCSCAN
        JNZ INK2                    ;有键按下，转到 INK2
        JMP BEGIN

;确定按下键的位置
INK2:   MOV CH,0FEH
        MOV CL,00H
```

### COLUM 段落
- `OUT DX,AL` 启动列扫描, 将当前列设置为 `0FEH`
- 对照实验线路图, 可知当前键盘及数码管显示单元的列线状态 `X1-X6` 为 `011 111`, 由 8255 的 PortA 写入
- `IN AL,DX` 读取行扫描状态, 检测具体哪个按键被按下, 由 8255 的 PortC(低 4 位) 从键盘及数码管显示单元读入 
```asm
COLUM:  MOV AL,CH
        MOV DX,MY8255_A 
        OUT DX,AL
        MOV DX,MY8255_C 
        IN AL,DX
```

### 检测按键行线信号
- 使用 `TEST` 逐行检测按键状态, 判断按键被按下的位置(按键状态由 COLUM 段落读入到 `AL`)
- 此时判定第 1 列, 第 1 - 4 行分别对应 0、4、8、C
- `ADD AL,CL`: `CL` 为列偏移值, 获取按键所对应的码值
- 若检测到按键信号, 则原先存储按键行线状态的 `AL` 将存储按键所对应的值, 接着, 转入 `KCODE` 标号
- 在 `KCODE` 标号下, 若按下的键是 `E`, 则退出程序
```asm
L1:     TEST AL,01H                     ;is L1?
        JNZ L2
        MOV AL,00H                      ;L1
        JMP KCODE
L2:     TEST AL,02H                     ;is L2?
        JNZ L3
        MOV AL,04H                      ;L2
        JMP KCODE
L3:     TEST AL,04H                     ;is L3?
        JNZ L4
        MOV AL,08H                      ;L3
        JMP KCODE
L4:     TEST AL,08H                     ;is L4?
        JNZ NEXT
        MOV AL,0CH                      ;L4
KCODE:  ADD AL,CL
        CMP AL,0EH                   ; 检查按键是否为 "E"
        JZ EXIT                      ; 如果是 "E" 键，则退出
        CALL PUTBUF
        PUSH AX
```

### 显示和清屏循环
- `KON` 段落是一个按键检测和显示循环, 确保在按键被松开之前, 一直显示当前按键的值
  - `DIS` 子程序被调用, 刷新数码管显示, 将当前缓冲区的内容显示出来
  - `CLEAR` 子程序被调用, 清除数码管显示, 以便下次显示更新
  - `CCSCAN` 子程序被调用, 检测当前是否有按键按下
- `NEXT` 段落处理下一次的列扫描
  - `INC CL` 将列偏移值递增, 用于在 `KCODE` 标号下确定按下的按键所对应的码值
  - `MOV AL,CH : TEST AL,08H : JZ KERR` : 判定当前是否已经扫描到第 4 列(最后一列), 若已经位于最后一列, 跳转至 `BEGIN` 从第 1 列开始重新扫描, 否则列扫描信号将会进行循环左移的操作(实现列线信号的递增), 并跳转至 `COLUM` 进行新的列线信号向 8255 的写入操作, 读取行线信号
- `EXIT` 段落处理退出程序的逻辑
- `NOV AX, 4C00H : INT 21H` DOS 服务调用功能号(存储在 `AH` 中) `4CH` (终止进程并返回控制给操作系统), 调用 DOS 中断 21H 服务中, 调用的指定的功能是 `4CH`
```asm
KON:    CALL DIS
        CALL CLEAR
        CALL CCSCAN
        JNZ KON
        POP AX
NEXT:   INC CL
        MOV AL,CH
        TEST AL,08H
        JZ KERR
        ROL AL,1
        MOV CH,AL
        JMP COLUM
KERR:   JMP BEGIN
EXIT:   MOV AX,4C00H                ; DOS 退出程序
        INT 21H                     ; 中断服务
```

### 键盘扫描子程序
- 所有的列线信号均有效(低电平)
- 读取行线信号(低电平表示该行存在按键按下)到 `AL`
- `NOT AL` 将判定按键按下的依据信号由低电平转化为高电平
```asm
CCSCAN: MOV AL,00H                  ;键盘扫描子程序
        MOV DX,MY8255_A  
        OUT DX,AL
        MOV DX,MY8255_C 
        IN  AL,DX
        NOT AL
        AND AL,0FH
        RET
```

### 清屏子程序
- 8255 PortB 控制共阴极数码管的显示, 电位赋值为低电平即可实现清屏的操作
```asm
CLEAR:  MOV DX,MY8255_B             ;清屏子程序
        MOV AL,00H
        OUT DX,AL
        RET
```

### 显示子程序
- 初始化部分:
  - `MOV SI,3000H` 设置 `SI` 为显示缓冲区的起始地址
  - `MOV DL,0DFH` 设置 `DL` 为初始控制值, 用于控制数码管显示的位置 >> 1101 1111
  - 注意此处是从第 6 个数码管开始显示的
- `MOV DX,MY8255_Y : OUT DX,AL` 通过对 8255 PortA 的设定来设置当前显示数码管的位置
```asm
DIS:    PUSH AX                     ;显示子程序
        MOV SI,3000H
        MOV DL,0DFH
        MOV AL,DL
AGAIN:  PUSH DX
        MOV DX,MY8255_A 
        OUT DX,AL
        MOV AL,[SI]                 ;读取缓冲区中的数据
        MOV BX,OFFSET DTABLE        ;将 BX 设置为段码表的起始地址
        AND AX,00FFH                ;使用 AND 指令确保 AX 中的值在 0-15 的范围内
        ADD BX,AX                   ;根据起始、偏移地址获取真实地址
        MOV AL,[BX]                 ;将段码表中的目标值加载到 AL 寄存器中
        MOV DX,MY8255_B 
        OUT DX,AL

        CALL DALLY                  ;调用延时子程序, 增加稳定性
        INC SI
        POP DX
        MOV AL,DL                   ;堆栈恢复后的 DL 存储当前显示数码管的位置
        TEST AL,01H                 ;测试是否显示到了第一个数码管
        JZ  OUT1                    ;若最低位为 0, 即已经显示到了第一个数码管, 则跳出循环
        ROR AL,1
        MOV DL,AL
        JMP AGAIN
OUT1:   POP AX
        RET
```

### 延时子程序
- 用于在显示和键盘扫描之间增加延时
```asm
DALLY:  PUSH CX                     ;延时子程序
        MOV CX,0006H
T1:     MOV AX,009FH
T2:     DEC AX
        JNZ T2
        LOOP T1
        POP CX
        RET
```

### 存储键盘值到缓冲区
- `DI` 存储的初值为 `3005H`, 对应的是数码管 6 的缓冲区地址
```asm
PUTBUF: MOV SI,DI                   ;存键盘值到相应位的缓冲中
        MOV [SI],AL
        DEC DI
        CMP DI,2FFFH
        JNZ GOBACK
        MOV DI,3005H
GOBACK: RET
```
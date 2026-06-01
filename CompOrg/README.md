# 计算机组成原理 (Computer Organization)

**所属院校**：Chang'an University
**实验平台**：CMA 组成原理实验箱 / TDX-CMX 通用实验平台
**仿真工具**：Logisim, Mars4_5
**主要内容**：课程设计、章节复习、虚拟仿真

## 模块简介

本目录是个人 `Notes` 知识库下的计算机组成原理专栏，归档了本科《计算机组成原理》课程的学习资料。内容分为三部分：基于 CMA/TDX-CMX 实验箱的课程设计与微指令编程、按章节整理的课堂重点与习题截图、以及基于 Logisim 的虚拟仿真实验。

## 目录结构

```
CompOrg/
├── README.md                       # 本文件
├── CourseDesign/                   # 课程设计
│   ├── Docs/                       #   实验指导书 & 设计报告
│   └── code/                       #   微指令 / 汇编源码
├── CourseWareScreenShot/           # 章节复习截图
│   ├── 运算方法和运算器/
│   ├── 指令系统/
│   ├── 中央处理器/
│   ├── 存储系统/
│   ├── 总线系统/
│   └── 输入输出系统/
└── Logisim虚拟仿真/                # Logisim 虚拟仿真实验
    ├── Docs/                       #   实验指导书
    └── ...                         #   工具 & 电路文件
```

## 课程设计

基于 CMA 组成原理实验箱与 TDX-CMX 通用实验平台，完成模型机微指令设计与调试。

| 文件 | 说明 |
|---|---|
| `Docs/CMA组成原理与系统结构.pdf` | 实验箱硬件架构说明 |
| `Docs/TDX-CMX组成原理通用.pdf` | 通用实验指导书 |
| `Docs/《计算机组成原理课程设计》——only for task3.pdf` | Task 3 实验报告 |
| `Docs/《计算机组成原理课程设计》模板参考.pdf` | 课程设计报告模板 |
| `code/demoForTask3.txt` | Task 3 微指令演示代码 |

## 章节复习截图

复习资料按课程章节分类整理，内容为期末备考时对课堂重点、习题及典型考题的截图，覆盖面有限。

| 章节 | 目录 | 截图数 |
|---|---|---|
| 运算方法与运算器 | `CourseWareScreenShot/运算方法和运算器/` | 1 |
| 指令系统 | `CourseWareScreenShot/指令系统/` | 4 |
| 中央处理器 | `CourseWareScreenShot/中央处理器/` | 12 |
| 存储系统 | `CourseWareScreenShot/存储系统/` | 3 |
| 总线系统 | `CourseWareScreenShot/总线系统/` | 5 |
| 输入输出系统 | `CourseWareScreenShot/输入输出系统/` | 8 |

## Logisim 虚拟仿真

使用 Logisim 与 Mars4_5 工具完成虚拟仿真实验。

| 文件 | 说明 |
|---|---|
| `Docs/【2022版】计算机组成原理实验指导书--虚拟仿真部分NEW.zip` | 虚拟仿真实验指导书 |
| `alu.circ` | Logisim ALU 电路工程文件 |
| `cache.asm` | MIPS 汇编程序（Cache 映射与性能分析） |
| `Mars4_5.jar` | MIPS 汇编器与运行时模拟器 |
| `Camera.jar` | Cache 可视化分析工具 |
| `logisim-hust-20200118.zip` | Logisim 发行版 (HUST 定制) |
| `jre-8u421-windows-x64.7z` | Java 运行环境 (JRE 8) |

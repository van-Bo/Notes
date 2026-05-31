# 数字电路与逻辑设计实验归档 (Digital Logic Design Labs)

**所属院校**：Chang'an University
**硬件平台**：Digilent Basys 3 (Artix-7 FPGA)
**开发环境**：Vivado
**主要语言**：Verilog / SystemVerilog

## 模块简介
本目录是个人 `Notes` 知识库下的数字逻辑实验专栏，完整记录了个人本科《数字逻辑》课程的系列实验内容。从基础的门电路抽象，到复杂的有限状态机(FSM)设计，再到实现底层的 VGA 显示驱动，涵盖了数字电路设计的核心知识体系。所有实验均已通过 Basys 3 硬件平台的上板验证。

## 实验目录结构

| 实验编号 | 目录名称 | 核心知识点与实现功能 |
| :---: | :--- | :--- |
| **Lab1** | `Lab1_Basic_Gates` | 基础逻辑门与组合逻辑实现，熟悉 Vivado 流程与引脚约束。 |
| **Lab2** | `Lab2_Combinational_Logic` | 复杂组合逻辑电路设计，包含数据选择器、译码器等。 |
| **Lab3** | `Lab3_Sequential_Logic` | 时序逻辑电路入门，触发器、计数器与分频器设计。 |
| **Lab4** | `Lab4_Traffic_Signal_Design` | 综合设计：基于有限状态机 (FSM) 的交通信号灯控制器。 |
| **Lab5** | `Lab5_VGA_Scrolling_Numbers` | 接口驱动：VGA 显示控制器设计，实现屏幕数字滚动效果。 |

## 使用说明
1. **代码精简**：为保证仓库轻量化，本项目已通过 `.gitignore` 过滤了 Vivado 编译产生的 `.runs`、`.cache` 等庞大的临时文件夹。
2. **工程恢复**：Clone 本仓库到本地后，进入对应 Lab 的 `Project` 文件夹，**直接双击 `.xpr` 文件**即可在 Vivado 中无损恢复完整工程及源码。
3. **实验报告**：每个实验目录下的 `Docs/` 文件夹中均附有详细的 PDF 格式实验报告(可能包含真值表、卡诺图化简、仿真波形及上板效果说明)、相关的参考资料以及测试视频(only for lab5)。

## 成果演示 (Demo)

**Lab 5: VGA 屏幕数字滚动显示实验**:[点击此处在 YouTube 观看实际板级验证效果](https://youtu.be/-x_mp_gdFbU)
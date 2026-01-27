# 💻 Computer Organization & Architecture | 计算机组成原理

> **Institution**: Chang'an University
> **Status**: Archived (Undergraduate Coursework)

## 📖 简介 (Introduction)

本目录归档了《计算机组成原理》课程（袁春风版本）的学习资料。资料主要分为两大部分：基于 **CMA/TDX-CMX** 实验箱的**课程设计**，以及按章节整理的**复习知识库**（包含部分重点摘要、课堂习题与典型考题，这部分是期末备考时，对于重点内容的截图）。

---

## 🛠️ 课程设计 (Course Design)

本部分包含课程设计的相关文档与代码，主要基于 **CMA 组成原理与系统结构** 及 **TDX-CMX** 通用实验平台。

### 📂 文档资料 (Docs)

* **指导手册**:
  * `CMA组成原理与系统结构.pdf`: 实验箱硬件架构说明。
  * `TDX-CMX组成原理通用.pdf`: 通用实验指导书。

* **设计任务**:
  * `《计算机组成原理课程设计》——only for task3.doc`: 针对 Task 3 的具体设计的实验报告。
  * 模板参考: 标准的课程设计报告模板。

### 💻 核心代码 (Source Code)

* **Task 3 实现**:
  * [`demoForTask3.txt`](./CourseDesign/code/demoForTask3.txt): 针对任务 3 的汇编/微指令演示代码。

---

## 📚 知识库与复习 (Knowledge Base by Chapter)

> **说明**: 本部分截图资料已按章节归类，涵盖了课堂重点 (Highlights)、习题 (Exercises) 及相关考题，不太全面，仅仅是个人复习时所截取。

1. [中央处理器](./CourseWareScreenShot/中央处理器/)
2. [存储系统](./CourseWareScreenShot/存储系统/)
3. [总线系统](./CourseWareScreenShot/总线系统/)
4. [指令系统](./CourseWareScreenShot/指令系统/)
5. [输入输出系统](./CourseWareScreenShot/输入输出系统/)
6. [运算方法与运算器](./CourseWareScreenShot/运算方法和运算器/)

---

## Logisim 虚拟仿真

使用 Logisim 工具，参考实验指导书，进行虚拟仿真。

* `Mars4_5.jar`、`cache.asm`、`Camera.jar`是虚拟仿真 Cache 映射、性能的环境工具，具体使用参考实验指导书
* `alu.circ` 是 Logisim 绘制电路的工程文件

## 🚀 快速开始 (Quick Start)

1. **查阅复习资料**: 进入 `CourseWareScreenShot/` 目录下对应的章节文件夹，查看重点与习题截图。
2. **运行实验代码**: 确保连接 **TDX-CMX** 实验箱，参考 `CourseDesign/Docs/` 中的手册加载 `demoForTask3.txt`。

# 🐧 Operating System Labs | 操作系统实验

本目录包含操作系统课程的一系列实验代码与总结，主要基于 **C++** 和 **Linux** 环境，重点探讨进程管理、线程同步与互斥、死锁避免等核心问题。

## 🧪 实验内容列表

### Lab 01: 进程同步与互斥 (Process Synchronization)

* **主题**: 经典 **读者-写者问题 (Reader-Writer Problem)** 的实现。
* **核心代码**:
  * `demo01.cpp`: **读者优先**策略 (Reader Priority)。
  * `demo03.cpp`: **写者优先** (读写公平) 策略 (Writer Priority)。
* **技术点**: 使用 `std::mutex`, `std::unique_lock`, `std::thread` 进行多线程编程。

### Lab 02: 银行家算法 (Banker's Algorithm)

* **主题**: 死锁避免 (Deadlock Avoidance)。
* **内容**: 模拟系统资源分配，通过安全性检查算法判断当前状态是否安全。
* **文件**: `demo.cpp`, `demoPlus.cpp`, `config.txt` (资源配置文件)。

### Lab 03: 进程控制与通信 (Process Control & IPC)

* **主题**: Linux 进程操作。
* **内容**:
  * `lockf`: 文件锁测试。
  * `signal`: 信号处理 (Kill 信号)。

### Lab 04: 进程间通信 (Advanced IPC)

* **主题**: 消息队列与共享内存。
* **演示**: `sender-receiver` 模式的通信演示。

## 📂 资料说明 (Docs & Images)

* **`docs/`**:
  * `2025春操作系统课内实验安排1.pdf`
  * `Linux进程实验学习.pdf`
* **`images/`**: 存放所有实验的控制台运行截图 (Log Output)，用于验证算法正确性。

## 🚀 运行方式

大部分 C++ 实验代码为单文件或简单的多文件结构，配置了 `config.txt` 作为输入。

```bash
# 编译示例 (以读者写者问题为例)
g++ -std=c++11 lab01/demo01.cpp -o reader_writer -lpthread

# 运行
./reader_writer

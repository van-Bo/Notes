# 进程的创建

## test01

### test01 测试源码

```cpp
/*
* Filename: test01.cpp
*/
#include <stdio.h>
#include <unistd.h>
int main() {
    pid_t pid1, pid2;
    printf("a0 ");
    pid1 = fork();
    if (pid1 == 0) {
        printf("b ");
        return 0;
    }
    printf("a1 ");
    pid2 = fork();
    if (pid2 == 0) {
        printf("c ");
        return 0;
    }
    printf("a2 ");
    return 0;
}
```

## test01 调试输出

```text
a0 a1 a2 a0 b a0 a1 c   /* 一种可能的情况 X Y Z */
a0 a1 a2 a0 a1 c a0 b   /* 一种可能的情况 X Z Y */
a0 b a0 a1 a2 a0 a1 c   /* 一种可能的情况 Y X Z */
...
/*
* 主进程的输出记为 X <a0, a1, a2>
* 子进程 1 的输出记为 Y <a0, b>
* 子进程 2 的输出记为 Z <a0, a1, c>
*/
```

## fork() 导致输出重复的原因

当调用 `fork()` 时，可能会看到重复的输出。以下是出现这种情况的主要原因：

### 1. 缓冲区复制

- **Fork 的机制：**  
  当调用 `fork()` 时，操作系统会复制父进程的整个内存空间，包括代码、全局变量、堆数据以及 **标准输出缓冲区**。
- **未刷新输出：**  
  如果在 `fork()` 之前调用了 `printf()` 输出内容，但没有换行符 (`\n`) 或没有显式调用 `fflush(stdout);` 刷新缓冲区，这些内容仍保存在缓冲区中，并在 fork 时被复制到子进程中。

### 2. 缓冲区重复刷新

- **各自刷新：**  
  父进程和子进程在各自退出或继续执行输出时，会各自刷新它们的输出缓冲区。这样，相同的输出内容（例如 `"a0 "` 或 `"a1 "`）会在多个进程中被分别输出一次，导致重复。
- **继承未清空的缓冲区：**  
  由于 fork 前的数据没有被刷新，子进程继承了父进程的未清空缓冲区，退出时将同样的数据输出，进一步加剧了输出重复的问题。

### 3. 进程调度不确定性

- **并发执行：**  
  父进程和子进程是同时运行的，操作系统调度各进程的顺序是不确定的，各进程何时刷新缓冲区的时间也会有所不同。
- **输出顺序随机：**  
  因为刷新时机和进程切换的随机性，不同的进程可能在不同时间刷新并输出它们复制过来的缓冲区内容，从而出现各种顺序的输出组合。

### 4. 输出格式问题

- **缺少换行符：**  
  如果没有换行符 (`\n`)，输出将更多依赖于缓冲区的刷新时机。程序退出或显式调用 `fflush(stdout);` 时都会刷新缓冲区，这使得 fork 后复制的缓冲区内容更容易被重复输出。

## 总结

当调用 `fork()` 时，父进程未刷新到终端的输出缓冲区会被复制到子进程中。由于每个进程在退出或执行进一步输出时都独立刷新各自的缓冲区，导致同一份数据被多次输出。为避免这种重复输出，建议在调用 `fork()` 之前使用 `fflush(stdout);` 或在输出内容中包含换行符来及时刷新缓冲区。

## test02

### test02 测试源码

```cpp
/*
* Filename: test02.cpp
* Description: 相较于 test01.cpp 添加了 fflush(stdout)，可刷新标准输出缓冲区
*/
#include <stdio.h>
#include <unistd.h>

int main() {
    pid_t pid1, pid2;
    printf("a0 ");
    fflush(stdout);
    pid1 = fork();
    if (pid1 == 0) {
        printf("b ");
        fflush(stdout);
        return 0;
    }
    printf("a1 ");
    fflush(stdout);
    pid2 = fork();
    if (pid2 == 0) {
        printf("c ");
        fflush(stdout);
        return 0;
    }
    printf("a2 ");
    fflush(stdout);
    return 0;
}
```

## test02 调试输出

```text
a0 a1 b a2 c    /* 一种可能的输出 */
a0 a1 a2 b c    /* 一种可能的输出 */
a0 a1 a2 c b    /* 一种可能的输出 */
...
```

## 显示结果及原因分析

- 各进程输出时的相对顺序由 **操作系统调度** 决定，因此最终在终端上的输出顺序会有所不同，但各个进程各自输出的内容始终保持为：
  - 父进程：a0 a1 a2
  - 子进程1：b
  - 子进程2：c

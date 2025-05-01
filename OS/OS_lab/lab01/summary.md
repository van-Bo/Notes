# 读者-写者问题：读者优先与写者优先`C/C++`实现

## 1. **问题背景**
在操作系统和并发编程中，**读者-写者问题（Reader-Writer Problem）** 是一个经典的同步问题：
- **读者**（Reader）可以并发读取共享资源，但不得修改。
- **写者**（Writer）必须**独占**资源，即写入时**不允许读者或其他写者访问**。

该问题的解决方案通常分为**两种策略**：
1. **读者优先**（Reader Priority）：保证读者可以连续访问资源，不让写者频繁阻塞读者。
2. **写者优先**（Writer Priority）：保证写者不会长时间等待，防止读者无限占用资源。从优先级角度考虑，准确来说是**读写公平法**

---

## 2. **读者优先（Reader Priority）实现**

### **代码分析**
**读者优先策略** 允许多个读者同时访问资源，但**写者必须等待所有读者退出后才能执行**。关键点：
- 使用 `std::mutex resourceMutex` 来控制对共享资源的访问。
- 使用 `std::mutex readerCountMutex` 保护 `readerCount`，防止多个线程同时修改它。
- **第一个读者锁定 `resourceMutex`**，**最后一个读者释放 `resourceMutex`**，保证多个读者可以并发访问。

### **核心代码01**
```cpp
/*
* Filename：demo01.cpp
* Created: 2025-05-01
* Description: Implementation of Reader-Writer problem with reader priority
// NOTE 作用域限制 {} 和 unlock() 的等效
    - std::unique_lock<std::mutex> 采用 RALL (资源获取即初始化)原则，即它在变量作用域结束时自动释放锁，
    不需要手动调用 unlock()；
    - 通过包裹代码块 {}，可以控制锁的作用域，确保临界区代码执行后自动释放锁，不影响其他进程
// HINT 
    resourceMutex 使用 mutex.lock()、mutex.unlock() 进行锁管理
    readerCountMutex 使用 std::unique_lock<std::mutex> 通过作用域 {} 进行锁管理
*/
#include <iostream>
#include <thread>
#include <mutex>
#include <condition_variable>
#include <vector>
#include <chrono>
#include <fstream>
#include <sstream>

std::mutex resourceMutex;
std::mutex readerCountMutex;
int readerCount = 0;  // 记录当前有多少个读者

void reader(int id, int time) {
    {
        std::unique_lock<std::mutex> lock(readerCountMutex);
        readerCount++;
        if (readerCount == 1) {  // 第一个读者需要锁定资源，防止写者写入
            resourceMutex.lock();
        }
    }   

    // 读者正在读取
    auto now = std::chrono::system_clock::now();
    auto now_c = std::chrono::system_clock::to_time_t(now);
    std::printf("[%lld] Reader %d is reading...\n", now_c, id); // 加盖时间戳
    std::this_thread::sleep_for(std::chrono::milliseconds(time));

    {
        std::unique_lock<std::mutex> lock(readerCountMutex);
        readerCount--;
        if (readerCount == 0) {  // 最后一个读者释放资源，让写者可以写入
            resourceMutex.unlock();
        }
    }
}

void writer(int id, int time) {
    std::unique_lock<std::mutex> lock(resourceMutex);  // 写者需要独占资源
    auto now = std::chrono::system_clock::now();
    auto now_c = std::chrono::system_clock::to_time_t(now); // 加盖时间戳
    std::printf("[%lld] Writer %d is writing...\n", now_c, id);
    std::this_thread::sleep_for(std::chrono::milliseconds(time));
}

int main() {
    std::vector<std::thread> threads;
    std::ifstream file("C:/Users/lenovo/Desktop/Code for CCCC/OS_lab/lab01/config.txt");
    int id, time;
    char type;

    if (!file)
    {
        std::cerr << "Error opening configuration file!!!\n";
        system("pause");
        return 1;
    }
    
    std::string line = "";
    while (std::getline(file, line))
    {
        if (line.empty() || line[0] == '#') // 跳过空行、注释
            continue;
        std::istringstream iss(line);
        
        if (!(iss >> id >> type >> time))
        {
            std::cerr << "Invalid line format: " << line << std::endl;
            continue;
        }

        if (type == 'R')
            threads.emplace_back(reader, id, time);
        else if (type == 'W')
            threads.emplace_back(writer, id ,time);
    }
    for (auto& t : threads) {
        t.join();
    }

    system("pause");
    return 0;
}
```
### **核心代码02**
```cpp
/*
* Filename：demo02.cpp
* Created: 2025-05-01
* Description: Implementation of Reader-Writer problem with reader priority
// NOTE 作用域限制 {} 和 unlock() 的等效
    - std::unique_lock<std::mutex> 采用 RALL (资源获取即初始化)原则，即它在变量作用域结束时自动释放锁，
    不需要手动调用 unlock()；
    - 通过包裹代码块 {}，可以控制锁的作用域，确保临界区代码执行后自动释放锁，不影响其他进程
// HINT 
    resourceMutex 使用 mutex.lock()、mutex.unlock() 进行锁管理
    readerCountMutex 使用 mutex.lock()、mutex.unlock() 进行锁管理
*/
#include <iostream>
#include <thread>
#include <mutex>
#include <condition_variable>
#include <vector>
#include <chrono>
#include <fstream>
#include <sstream>

std::mutex resourceMutex;
std::mutex readerCountMutex;
int readerCount = 0;  // 记录当前有多少个读者

void reader(int id, int time) {
    readerCountMutex.lock();
    readerCount++;
    if (readerCount == 1) {  // 第一个读者需要锁定资源，防止写者写入
        resourceMutex.lock();
    }
    readerCountMutex.unlock();

    // 读者正在读取
    auto now = std::chrono::system_clock::now();
    auto now_c = std::chrono::system_clock::to_time_t(now);
    std::printf("[%lld] Reader %d is reading...\n", now_c, id); // 加盖时间戳
    std::this_thread::sleep_for(std::chrono::milliseconds(time));

    readerCountMutex.lock();
    readerCount--;
    if (readerCount == 0) {  // 最后一个读者释放资源，让写者可以写入
        resourceMutex.unlock();
    }
    readerCountMutex.unlock();
}

void writer(int id, int time) {
    resourceMutex.lock();  // 写者需要独占资源
    auto now = std::chrono::system_clock::now();
    auto now_c = std::chrono::system_clock::to_time_t(now); // 加盖时间戳
    std::printf("[%lld] Writer %d is writing...\n", now_c, id);
    std::this_thread::sleep_for(std::chrono::milliseconds(time));
    resourceMutex.unlock();
}

int main() {
    std::vector<std::thread> threads;
    std::ifstream file("C:/Users/lenovo/Desktop/Code for CCCC/OS_lab/lab01/config.txt");
    int id, time;
    char type;

    if (!file)
    {
        std::cerr << "Error opening configuration file!!!\n";
        system("pause");
        return 1;
    }
    
    std::string line = "";
    while (std::getline(file, line))
    {
        if (line.empty() || line[0] == '#') // 跳过空行、注释
            continue;
        std::istringstream iss(line);
        
        if (!(iss >> id >> type >> time))
        {
            std::cerr << "Invalid line format: " << line << std::endl;
            continue;
        }

        if (type == 'R')
            threads.emplace_back(reader, id, time);
        else if (type == 'W')
            threads.emplace_back(writer, id ,time);
    }
    for (auto& t : threads) {
        t.join();
    }

    system("pause");
    return 0;
}
```

---

## 3. **写者优先（Writer Priority）实现**

### **代码分析**
**写者优先策略** 使得写者不必长时间等待读者完成，它在后续的读者执行时优先获取资源：
- 额外增加 `std::mutex writerIsWaiting` 控制写者调度
- 在 `reader()` 中，如果有写者等待准备/正在进行，读者必须阻塞，让写者优先
- 读者不能连续占用资源，必须等待写者完成后再执行

### **核心代码**
```cpp
/*
* Filename：demo03.cpp
* Created: 2025-05-01
* Description: Implementation of Reader-Writer problem with writer priority
// NOTE 作用域限制 {} 和 unlock() 的等效
    - std::unique_lock<std::mutex> 采用 RALL (资源获取即初始化)原则，即它在变量作用域结束时自动释放锁，
    不需要手动调用 unlock()；
    - 通过包裹代码块 {}，可以控制锁的作用域，确保临界区代码执行后自动释放锁，不影响其他进程
// HINT 
    resourceMutex 使用 mutex.lock()、mutex.unlock() 进行锁管理
    readerCountMutex 使用 mutex.lock()、mutex.unlock() 进行锁管理
    writerIsWaiting 使用 mutex.lock()、mutex.unlock() 进行锁管理
*/
#include <iostream>
#include <thread>
#include <mutex>
#include <condition_variable>
#include <vector>
#include <chrono>
#include <fstream>
#include <sstream>

std::mutex resourceMutex;
std::mutex readerCountMutex;
std::mutex writerIsWaiting;
int readerCount = 0;  // 记录当前有多少个读者

void reader(int id, int time) {
    writerIsWaiting.lock();

    readerCountMutex.lock();
    readerCount++;
    if (readerCount == 1) {  // 第一个读者需要锁定资源，防止写者写入
        resourceMutex.lock();
    }
    readerCountMutex.unlock();

    writerIsWaiting.unlock();

    // 读者正在读取
    auto now = std::chrono::system_clock::now();
    auto now_c = std::chrono::system_clock::to_time_t(now);
    std::printf("[%lld] Reader %d is reading...\n", now_c, id); // 加盖时间戳
    std::this_thread::sleep_for(std::chrono::milliseconds(time));

    readerCountMutex.lock();
    readerCount--;
    if (readerCount == 0) {  // 最后一个读者释放资源，让写者可以写入
        resourceMutex.unlock();
    }
    readerCountMutex.unlock();
}

void writer(int id, int time) {
    writerIsWaiting.lock();

    resourceMutex.lock();  // 写者需要独占资源
    auto now = std::chrono::system_clock::now();
    auto now_c = std::chrono::system_clock::to_time_t(now); // 加盖时间戳
    std::printf("[%lld] Writer %d is writing...\n", now_c, id);
    std::this_thread::sleep_for(std::chrono::milliseconds(time));
    resourceMutex.unlock();

    writerIsWaiting.unlock();
}

int main() {
    std::vector<std::thread> threads;
    std::ifstream file("C:/Users/lenovo/Desktop/Code for CCCC/OS_lab/lab01/config.txt");
    int id, time;
    char type;

    if (!file)
    {
        std::cerr << "Error opening configuration file!!!\n";
        system("pause");
        return 1;
    }
    
    std::string line = "";
    while (std::getline(file, line))
    {
        if (line.empty() || line[0] == '#') // 跳过空行、注释
            continue;
        std::istringstream iss(line);
        
        if (!(iss >> id >> type >> time))
        {
            std::cerr << "Invalid line format: " << line << std::endl;
            continue;
        }

        if (type == 'R')
            threads.emplace_back(reader, id, time);
        else if (type == 'W')
            threads.emplace_back(writer, id ,time);
    }
    for (auto& t : threads) {
        t.join();
    }

    system("pause");
    return 0;
}
```

/*
* Filename：demo01.cpp
* Created: 2025-05-01
* Modified: 2025-05-08
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
#include <Windows.h>

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
    std::printf("[%lld] Reader %d (Thread ID: 0x%lx) is reading...\n", now_c, id, GetCurrentThreadId());
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
    std::printf("[%lld] Writer %d (Thread ID: 0x%lx) is writing...\n", now_c, id, GetCurrentThreadId());
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

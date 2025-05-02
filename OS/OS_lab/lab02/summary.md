# 银行家算法实现：基本版 & 增强版

## 📌 概述
本项目实现了 **银行家算法**，用于处理多个进程对有限资源的请求，并根据 **安全性分析** 进行决策：
- **`demo.cpp`（基本版）：** 实现 **单个进程资源请求**，并在终端输出决策反馈结果。
- **`demoPlus.cpp`（增强版）：** 支持 **批量化进程请求**，并增加 **日志记录**，将资源分配过程输出至 `log.txt`。

---

## 📌 银行家算法介绍
**银行家算法（Banker's Algorithm）** 是一种 **避免死锁的资源分配算法**，用于管理多个进程对有限资源的请求，以确保系统始终保持 **安全状态**。其基本流程如下：
1. **读取资源分配情况**（`config.txt` 或 `configPlus.txt`）。
2. **每个进程请求资源**：
   - **检查请求是否合法**（不能超过 `max` 或当前 `available`）。
   - **临时分配资源**，然后运行 **安全性检查（`isSafe()`）**。
   - **如果系统安全，则正式分配资源；否则回滚请求**。
3. **如果进程满足 `max`，释放该进程的资源**，并更新 `available` 状态。

---

## 📌 代码功能对比

| 功能 | `demo.cpp` | `demoPlus.cpp` |
|------|---------|-------------|
| 读取 `config.txt` 初始化进程资源 | ✅ | ✅ |
| **单次资源请求** | ✅ | ✅ |
| **批量资源请求序列** | ❌ | ✅ |
| **日志记录 (`log.txt`)** | ❌ | ✅ |
| **资源安全性检查 (`isSafe()`)** | ✅ | ✅ |
| **请求失败处理（超出 `max` 或不安全）** | ✅ | ✅ |
| **满足最大需求时释放资源** | ❌ | ✅ |
| **完整输出 `max` / `allocation` / `need` / `available`** | ❌ | ✅ |

---

## 📌 代码实现逻辑

### **1️⃣ 读取资源配置文件**
代码首先 **从 `config.txt` 或 `configPlus.txt` 读取初始资源分配情况**：
- **`numProcesses` & `numResources`** 记录 **进程数** 和 **资源类别数**。
- **`available`** 记录 **当前可用资源**。
- **`maximum`** 记录 **每个进程最大资源需求**。
- **`allocation`** 记录 **当前已分配的资源**。
- **`need = max - allocation`** 计算 **每个进程还需要多少资源**。

### **2️⃣ 资源请求处理**
每次进程请求资源时：
1. **检查请求是否合法**：
   - **不能超过 `need`（进程最大需求）**。
   - **不能超过 `available`（当前系统可用资源）**。
2. **临时分配资源**：
   - 先 **尝试分配资源**，然后运行 **安全性检查**。
   - 如果系统 **仍然处于安全状态**，则正式分配资源；
   - 否则 **回滚请求，拒绝分配**。

### **3️⃣ 安全性检查（`isSafe()`）**
银行家算法的核心是 **安全性检查**：
- 创建一个 **临时 `work` 数组**，模拟资源分配情况。
- **遍历所有进程**，如果某个进程的 `need` 小于 `work`，说明它可以顺利执行：
  - 该进程执行后 **释放资源**，更新 `work`。
  - 标记为 **完成**（`finish[i] = true`）。
- **如果所有进程都能成功执行**，说明系统 **处于安全状态**，否则回滚分配。

### **4️⃣ 资源释放**
如果某进程的 `need == 0`（即已满足所有最大需求）：
- **释放该进程的所有资源**。
- **更新 `available`**，使其他进程可以使用这些资源。

---

## 📌 核心代码实现

### **核心代码1**
```cpp
/*
* Filename: demo.cpp
* Created: 2025-05-02
* Description: Implementation of Bankers' Algorithm
* 工作流程的详细陈述: 
    1. 读取文件 config.txt 进行进程、资源信息的初始化工作
    2. 可以针对某一进程请求，根据当前系统资源的分配情况，来进行是否分配的决策，并进行一次执行
    3. 同时，可以将决策相关的反馈信息打印输出至终端
*/
#include <iostream>
#include <fstream>
#include <vector>
#include <sstream>

using namespace std;

class BankersAlgorithm {
    int numProcesses, numResources;
    vector<int> available;
    vector<vector<int>> maximum;
    vector<vector<int>> allocation;
    vector<vector<int>> need;
    vector<int> processIDs;

public:
    void readData(const string& filename) {
        ifstream file(filename);
        if (!file) {
            cerr << "Error opening configuration file!!!" << endl;
            return;
        }

        string line = "";
        bool isReadingForTheFirstLine = true;   // 获取首行信息的标记
        while (getline(file, line)) {
            if (line.empty() || line[0] == '#') // 跳过空行、注释
                continue;

            stringstream ss(line);

            int processID;
            char separator;

            if (isReadingForTheFirstLine)   // 获取首行信息
            {
                string numProcessesStr, numResourcesStr;
                getline(ss, numProcessesStr, '|');
                getline(ss, numResourcesStr, '|');
                stringstream numProcessesStream(numProcessesStr);
                stringstream numResourcesStream(numResourcesStr);
                numProcessesStream >> numProcesses;
                numResourcesStream >> numResources;

                string availableStr;
                getline(ss, availableStr, '|');
                stringstream availStream(availableStr);
                int value;
                for (int i = 0; i < numResources; i ++)
                {
                    availStream >> value;
                    available.push_back(value);
                }
                isReadingForTheFirstLine = false;
                continue;
            }

            string processIDValue;                  // 读取 processID
            getline(ss, processIDValue, '|');
            processID = stoi(processIDValue);
            processIDs.push_back(processID);

            vector<int> maxValues, allocValues, needValues;
            int value;
            
            string maxStr;                          // 读取 max
            getline(ss, maxStr, '|');
            stringstream maxStream(maxStr);
            for (int i = 0; i < numResources; i++) {
                maxStream >> value;
                maxValues.push_back(value);
            }

            string allocStr;                        // 读取 allocation
            getline(ss, allocStr, '|');
            stringstream allocStream(allocStr);
            for (int i = 0; i < numResources; i++) {
                allocStream >> value;
                allocValues.push_back(value);
            }

            maximum.push_back(maxValues);
            allocation.push_back(allocValues);

            for (int i = 0; i < numResources; i ++)
                needValues.push_back(maxValues[i] - allocValues[i]);
            need.push_back(needValues);

        }

        file.close();
    }

    void setAvailableResources(vector<int> avail) {
        available = avail;
    }

    bool isSafe() {
        vector<int> work = available;
        vector<bool> finish(processIDs.size(), false);
        vector<int> safeSeq;

        int count = 0;
        while (count < processIDs.size()) {
            bool found = false;     // 标记本轮扫描是否存在可分配项，若没有，则说明进入了不安全状态
            for (int i = 0; i < processIDs.size(); i++) {
                if (!finish[i]) {                       // 遍历进程表项中的未完进程
                    bool possible = true;
                    for (int j = 0; j < numResources; j++)
                        if (need[i][j] > work[j]) {
                            possible = false;
                            break;
                        }

                    if (possible) {
                        for (int j = 0; j < numResources; j++)
                            work[j] += allocation[i][j];
                        safeSeq.push_back(processIDs[i]);
                        finish[i] = true;
                        found = true;
                        count++;
                    }
                }
            }
            if (!found) return false;
        }

        cout << "Safe Sequence: ";
        for (int i : safeSeq) cout << "p"<< i << " ";
        cout << endl;
        return true;
    }

    bool requestResource(int processID, vector<int> request) {
        int index = -1;
        for (int i = 0; i < processIDs.size(); i++) {
            if (processIDs[i] == processID) {
                index = i;
                break;
            }
        }

        if (index == -1) {
            printf("Process %d is not existing!!!\n", processID);
            return false;
        }

        for (int i = 0; i < numResources; i++) {
            if (request[i] > need[index][i]) {
                printf("Error: The request exceeds the process's maximum demand!!!\n");
                return false;
            }
            if (request[i] > available[i])
            {
                printf("Error: The request exceeds the currently available system resources!!!\n");
                return false;
            }
        }

        for (int i = 0; i < numResources; i++) {    // 预分配
            available[i] -= request[i];
            allocation[index][i] += request[i];
            need[index][i] -= request[i];
        }

        if (!isSafe()) {
            for (int i = 0; i < numResources; i++) {
                available[i] += request[i];
                allocation[index][i] -= request[i];
                need[index][i] += request[i];
            }
            printf("Hint: The request has led to an unsafe system and has been rolled back >_<\n");
            return false;
        }

        cout << "Fine: The request was successfully granted ^_^\n";
        return true;
    }
};

int main() {
    BankersAlgorithm bank;
    bank.readData("C:/Users/lenovo/Desktop/Code for CCCC/OS_lab/lab02/config.txt");

    // prcess 1 request rescource
    vector<int> request = {1, 0, 2};
    int processID = 1;
    bank.requestResource(processID, request);

    system("pause");
    return 0;
}
```

### **核心代码2**
```cpp
/*
* Filename: demoPlus.cpp
* Created: 2025-05-02
* Description: Implementation of Bankers' Algorithm(Plus)
* 工作流程的详细陈述: 
    1. 读取文件 configPlus.txt 进行进程、资源信息的初始化工作
    2. 可以针对一系列的进程请求序列，根据当前系统资源的分配情况，来进行是否分配的决策，并执行（连续批量化处理）
    3. 执行同时会生成相关的日志信息至文件 log.txt
*/
#include <iostream>
#include <fstream>
#include <vector>
#include <sstream>

using namespace std;

class BankersAlgorithm {
    int numProcesses, numResources;
    vector<int> available;
    vector<vector<int>> maximum;
    vector<vector<int>> allocation;
    vector<vector<int>> need;
    vector<int> processIDs;
    ofstream logFile;  // 日志文件对象

public:
    BankersAlgorithm() {
        logFile.open("C:/Users/lenovo/Desktop/Code for CCCC/OS_lab/lab02/log.txt", ios::out);  // 创建日志文件
        if (!logFile) {
            cerr << "Error creating log file!" << endl;
            exit(1);
        }
        log("Banker's Algorithm Execution Started\n");
    }

    ~BankersAlgorithm() {
        logFile.close();  // 关闭日志文件
    }

    void log(const string &message) {
        logFile << message << endl;
        cout << message << endl; // 控制台同时输出
    }

    void readData(const string& filename) {
        ifstream file(filename);
        if (!file) {
            cerr << "Error opening configuration file!!!" << endl;
            exit(1);
        }

        string line = "";
        bool isReadingForTheFirstLine = true;
        log("Reading configuration from file...");

        while (getline(file, line)) {
            if (line.empty() || line[0] == '#') continue;

            stringstream ss(line);

            if (isReadingForTheFirstLine) {
                string numProcessesStr, numResourcesStr;
                getline(ss, numProcessesStr, '|');
                getline(ss, numResourcesStr, '|');
                stringstream numProcessesStream(numProcessesStr);
                stringstream numResourcesStream(numResourcesStr);
                numProcessesStream >> numProcesses;
                numResourcesStream >> numResources;

                string availableStr;
                getline(ss, availableStr, '|');
                stringstream availStream(availableStr);
                int value;
                for (int i = 0; i < numResources; i++) {
                    availStream >> value;
                    available.push_back(value);
                }
                isReadingForTheFirstLine = false;
                continue;
            }

            string processIDValue;
            getline(ss, processIDValue, '|');
            int processID = stoi(processIDValue);
            processIDs.push_back(processID);

            vector<int> maxValues, allocValues, needValues;
            int value;

            string maxStr;
            getline(ss, maxStr, '|');
            stringstream maxStream(maxStr);
            for (int i = 0; i < numResources; i++) {
                maxStream >> value;
                maxValues.push_back(value);
            }

            string allocStr;
            getline(ss, allocStr, '|');
            stringstream allocStream(allocStr);
            for (int i = 0; i < numResources; i++) {
                allocStream >> value;
                allocValues.push_back(value);
            }

            maximum.push_back(maxValues);
            allocation.push_back(allocValues);

            for (int i = 0; i < numResources; i++)
                needValues.push_back(maxValues[i] - allocValues[i]);

            need.push_back(needValues);
        }

        log("Configuration loaded successfully.");
        printAllocationState(); // 记录初始资源分配情况
        file.close();
    }

    void printAllocationState() {
        log("\nCurrent Resource Allocation:");
        for (int i = 0; i < numProcesses; i++) {
            string maxStr = "Process " + to_string(processIDs[i]) + " - Max: [";
            string allocatedStr = " - Allocated: [";
            string needStr = " - Need: [";
    
            for (int j = 0; j < numResources; j++) {
                maxStr += to_string(maximum[i][j]);
                allocatedStr += to_string(allocation[i][j]);
                needStr += to_string(need[i][j]);
                
                if (j < numResources - 1) { // 添加空格分隔
                    maxStr += " ";
                    allocatedStr += " ";
                    needStr += " ";
                }
            }
    
            maxStr += "]";
            allocatedStr += "]";
            needStr += "]";
            log(maxStr + allocatedStr + needStr); // 一行日志，包含 max、allocation、need
        }
    
        log("\nAvailable Resources:");
        string availableStr = "[";
        for (int j = 0; j < numResources; j++) {
            availableStr += to_string(available[j]);
            if (j < numResources - 1) availableStr += " ";
        }
        availableStr += "]";
        log(availableStr);
        log("----------------------------");
    }
    
    

    bool isSafe() {
        vector<int> work = available;
        vector<bool> finish(processIDs.size(), false);
        vector<int> safeSeq;

        int count = 0;
        while (count < processIDs.size()) {
            bool found = false;
            for (int i = 0; i < processIDs.size(); i++) {
                if (!finish[i]) {
                    bool possible = true;
                    for (int j = 0; j < numResources; j++)
                        if (need[i][j] > work[j]) {
                            possible = false;
                            break;
                        }

                    if (possible) {
                        for (int j = 0; j < numResources; j++)
                            work[j] += allocation[i][j];
                        safeSeq.push_back(processIDs[i]);
                        finish[i] = true;
                        found = true;
                        count++;
                    }
                }
            }
            if (!found) return false;
        }

        log("Safe sequence found: ");
        for (int i : safeSeq) log("p" + to_string(i) + " ");
        return true;
    }

    bool requestResource(int processID, vector<int> request) {
        log("\nProcess " + to_string(processID) + " requests resources: [" +
            to_string(request[0]) + " " + to_string(request[1]) + " " + to_string(request[2]) + "]");
        
        int index = -1;
        for (int i = 0; i < processIDs.size(); i++) {
            if (processIDs[i] == processID) {
                index = i;
                break;
            }
        }

        if (index == -1) {
            log("Error: Process " + to_string(processID) + " does not exist!");
            log("----------------------------");
            return false;
        }

        for (int i = 0; i < numResources; i++) {
            if (request[i] > need[index][i]) {
                log("Error: The request exceeds the process's maximum demand!");
                log("----------------------------");
                return false;
            }
            if (request[i] > available[i]) {
                log("Error: The request exceeds the currently available system resources!");
                log("----------------------------");
                return false;
            }
        }

        for (int i = 0; i < numResources; i++) {
            available[i] -= request[i];
            allocation[index][i] += request[i];
            need[index][i] -= request[i];
        }

        if (!isSafe()) {
            for (int i = 0; i < numResources; i++) {
                available[i] += request[i];
                allocation[index][i] -= request[i];
                need[index][i] += request[i];
            }
            log("Hint: The request has led to an unsafe system and has been rolled back.");
            log("----------------------------");
            return false;
        }

        log("Success: The request was granted.");
        // 测试此次分配是否已经满足此次请求资源进程所需的最大需求
        int cnt = 0;
        for (int i = 0; i < numResources; i ++)
            cnt += need[index][i];
        if (cnt == 0)  // 该进程释放所有资源
        {
            for (int i = 0; i < numResources; i ++)
                available[i] += allocation[index][i];
            for (int i = 0; i < numResources; i ++)
                need[index][i] = 0, allocation[index][i] = 0;
            log("Congratulation: this granted request can satisfy all max resources of  this process.");
            log("The allocated resources to this process have been released!!!");
        }
        
        printAllocationState();
        return true;
    }
};

int main() {
    BankersAlgorithm bank;
    bank.readData("C:/Users/lenovo/Desktop/Code for CCCC/OS_lab/lab02/configPlus.txt");

    vector<vector<int>> requestSequence = {
        {1, 0, 2, 2},  // ✅ 安全，成功分配
        {0, 1, 4, 1},  // ❌ 超出系统资源数，拒绝
        {2, 3, 2, 0},  // ❌ 超出最大需求，拒绝
        {0, 7, 3, 3},  // ✅ 安全，成功分配
        {4, 1, 0, 0},  // ❌ processID 不存在，拒绝
        {1, 1, 0, 0},  // ✅ 安全，成功分配，达到 max, 并成功释放资源
    };
    

    for (const auto& request : requestSequence) {
        int processID = request[0];
        vector<int> resourceRequest = {request[1], request[2], request[3]};
        bank.requestResource(processID, resourceRequest);
    }

    system("pause");
    return 0;
}
```


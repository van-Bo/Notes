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

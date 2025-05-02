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

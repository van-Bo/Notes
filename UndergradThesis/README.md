# 本科毕业设计 (Undergraduate Thesis)

**所属院校**：Chang'an University
**学号**：2022901300
**课题方向**：Digital Twin Enabled Task Offloading for IoVs
**技术方案**：A3C 强化学习 + LSTM 预测

## 模块简介

本目录归档了本科毕业设计《Digital Twin Enabled Task Offloading for IoVs: A Learning-Based Approach》的全部材料。课题研究数字孪生驱动的车联网计算任务卸载问题，通过 A3C 深度强化学习算法进行卸载决策优化，并引入 LSTM 网络对车联网动态环境（信道速率、MEC 资源、任务到达率等）进行预测建模。

## 目录结构

```
UndergradThesis/
├── README.md                     # 本文件
├── 2022901300-WYB-源代码.zip      # 实验源代码工程
└── Docs/
    ├── 2022901300-WYB-论文正文.pdf  # 毕业论文终稿
    ├── 2022901300-WYB-任务书.pdf   # 毕业设计任务书
    ├── 2022901300-WYB-开题报告.pdf  # 开题报告
    └── 2022901300-WYB-外文翻译.pdf  # 外文文献翻译
```

## 论文文档

| 文件 | 说明 |
|---|---|
| `Docs/2022901300-WYB-论文正文.pdf` | 毕业论文终稿 |
| `Docs/2022901300-WYB-任务书.pdf` | 毕业设计任务书（含课题要求与技术指标） |
| `Docs/2022901300-WYB-开题报告.pdf` | 开题报告（含文献综述与研究方案） |
| `Docs/2022901300-WYB-外文翻译.pdf` | 外文参考文献翻译 |

## 源代码工程

`2022901300-WYB-源代码.zip` 解压后包含以下模块：

| 目录/文件 | 说明 |
|---|---|
| `agent/` | A3C 强化学习智能体（Actor-Critic 网络、LSTM 预测器） |
| `env/` | 车联网环境模拟（MEC 服务器、云服务器、车辆终端、无线信道） |
| `config/` | 实验参数与超参数配置 |
| `results/` | 实验输出：训练日志、模型权重 (.pth)、图表、结果分析 |
| `main.py` | 主程序入口 |
| `evaluate.py` | 模型评估脚本 |
| `train_lstm.py` | LSTM 预测模型训练 |
| `run_experiments.py` | 批量实验运行脚本 |
| `Docs/` | 参考论文 PDF |

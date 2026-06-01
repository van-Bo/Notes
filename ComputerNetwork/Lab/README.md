# 计算机网络实验 (Computer Network Lab)

**所属院校**：Chang'an University
**模拟平台**：GNS3
**抓包工具**：Wireshark
**设备系统**：Cisco IOS (c3660 / c3745)
**涉及协议**：DHCP, DNS, HTTP, ICMP, RIP, ARP, 802.1Q

## 模块简介

本目录是个人 `Notes` 知识库下的计算机网络实验专栏，记录了本科《计算机网络》课程的 GNS3 实验内容。实验通过 GNS3 模拟 Cisco 路由交换设备，构建多子网、多 VLAN 的网络拓扑，并使用 Wireshark 对 DHCP、DNS、HTTP、ICMP、RIP、ARP 等核心协议进行抓包分析。

## 实验拓扑

![网络拓扑图](./images/网络拓扑.bmp)

实验基于两台交换机 (ESW1/ESW2) 与多台路由器互联，划分 VLAN 10/20/30/80 四个子网，通过 RIP v2 实现动态路由，并在 ESW1 上配置 DHCP Server 为终端分配地址。

## 目录结构

```
Lab/
├── README.md                   # 本文件
├── Docs/
│   └── IP网络划分.pdf           # IP 地址规划文档
├── demo02/
│   ├── demo02.gns3             # GNS3 项目文件
│   └── project-files/
│       ├── captures/           # Wireshark 抓包文件 (.pcap)
│       ├── dynamips/*/configs/ # 路由器 startup-config 配置文件
│       └── vpcs/*/startup.vpc  # 虚拟 PC 启动配置
└── images/
    ├── 网络拓扑.bmp             # 实验拓扑截图
    └── 抓包信息.bmp             # 协议抓包截图
```

> Cisco IOS 镜像文件因版权及体积原因不存放于本仓库。如需复现实验，请自行准备 c3660 / c3745 镜像并配置 GNS3 Dynamips 路径。

## 抓包文件说明

`demo02/project-files/captures/` 中共 10 个抓包文件，覆盖以下协议：

| 文件 | 分析内容 |
|---|---|
| `Capture_for_DHCP.pcap` | DHCP 地址分配流程 (Discover → Offer → Request → ACK) |
| `Capture_for_DHCP(demo).pcap` | DHCP 流程备选抓包 |
| `Capture_for_DNS.pcap` | DNS 域名解析请求与响应 |
| `Capture_for_HTTP.pcap` | HTTP 请求/响应报文与 TCP 承载 |
| `Capture_for_ICMP1.pcap` | ICMP Echo Request/Reply (ping) |
| `Capture_for_ICMP2.pcap` | ICMP 补充抓包 |
| `Capture_for_RIP.pcap` | RIP v2 路由更新报文分析 |
| `Capture_for_trunk.pcap` | 802.1Q Trunk 链路帧格式 |
| `demo.pcap` | 综合演示抓包 |
| `demoARP.pcap` | ARP 地址解析过程 |

## 设备配置文件

路由器/交换机配置文件位于 `demo02/project-files/dynamips/*/configs/`：

| 配置文件 | 对应设备 | 关键功能 |
|---|---|---|
| `i1_startup-config.cfg` | ESW1 | 三层交换：VLAN 划分、DHCP Pool、RIP v2、Trunk |
| `i2_startup-config.cfg` | R1 | 路由器：RIP v2、静态路由、PPP/CHAP 认证 |
| `i3_startup-config.cfg` | R2 | 路由器：RIP v2、Loopback、PPP/CHAP 认证 |
| `i4_startup-config.cfg` | ESW2 | 二层交换：VLAN 10 接入、Trunk |
| `i5_startup-config.cfg` | WWW | Web 服务器 |
| `i5_private-config.cfg` | WWW | Web 服务器私有配置 |
| `i6_startup-config.cfg` | DNS | DNS 服务器 |

## 复现说明

1. 在 GNS3 中打开 `demo02/demo02.gns3`
2. 确保 GNS3 已配置 c3660 / c3745 IOS 镜像路径
3. 启动所有设备，等待 RIP 收敛（约 30–60 秒）
4. 在目标链路上右键 → Start Capture 即可调用 Wireshark 抓包分析

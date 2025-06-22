# VS Code C++ 项目构建与调试配置详解 (`tasks.json` & `launch.json`)

## 核心理念：分工与协作

| 操作 Action | 快捷键 Shortcut | 主要配置文件 | 核心职能 |
| --- | --- | --- | --- |
| 构建 Build | `Ctrl+Shift+B` | `task.json` | **仅编译** 代码，生成可执行文件 |
| 调试 Debug | `F5` | `launch.json` | **先编译，后运行**，并附加调试器 |

在 VS Code 中，对于 C++ 这类编译型语言，“构建”（编译代码）和 “调试”（运行并检查程序）是两个独立但又需要协作的过程。`tasks.json` 和 `launch.json` 就是分别管理这两个过程的配置文件。

我们可以用一个生动的比喻来理解它们的关系：

* `tasks.json`：**相当于餐厅的“后厨”**。它的职责是根据 “菜谱”（your code）制作 “菜品”（可执行程序 `.exe`）。它只管把原材料（`.cpp` 文件）加工好。
* `launch.json`：**相当于餐厅的“前厅服务员”**。它的职责是把后厨做好的 “菜品” 端给 “顾客”（调试器），并按照顾客的要求（例如，是否需要一个单独的 “包间”`externalConsole`）来提供服务。
* `preLaunchTask` 字段：**是前厅和服务员之间的关键指令——“上菜！”**。它告诉服务员（`launch.json`）：“在我把菜端给顾客之前，先去通知后厨（`tasks.json`）把这道菜（由 `label` 指定）做出来。”

## 1. tasks.json - 构建任务配置文件

该文件定义了 VS Code 如何调用外部工具（如编译器 `g++`）来执行任务。我们的核心任务就是**编译源代码**。

### 配置文件 (`.vscode/tasks.json`)

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "type": "cppbuild",
            "label": "Build Calculator Project",
            "command": "D:/VScode/MinGW/TDM-GCC-64/bin/g++.exe",
            "args": [
                "-fdiagnostics-color=always",
                "-fexec-charset=GBK",
                "-g",
                "${workspaceFolder}/main.cpp",
                "${workspaceFolder}/lexer.cpp",
                "${workspaceFolder}/parser.cpp",
                "-o",
                "${workspaceFolder}/output/calculator.exe"
            ],
            "options": {
                "cwd": "${workspaceFolder}"
            },
            "problemMatcher": [
                "$gcc"
            ],
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "detail": "Build the multi-file calculator project."
        }
    ]
}
```

### 关键字段详解（`.vscode/tasks.json`）

`"label": "Build Calculator Project"`
**作用**：任务的 “名字”，一个人类可读的标签。这个名字非常重要，因为 `launch.json` 将通过它来调用此任务。

`"command": "..."`
**作用**：要执行的外部命令，这里是你的 `g++.exe` 编译器的完整路径。

`"args": [ ... ]`
**作用**：一个字符串数组，包含了所有传递给 `command` 的命令行参数。
    `-g`：告诉编译器生成调试信息，这是让 `GDB` 调试器能够工作的关键。
    `"${workspaceFolder}/main.cpp", ...：`核心修改。这里我们明确列出了所有需要一起编译的源文件。`${workspaceFolder}` 是 VS Code 的一个变量，代表你当前打开的项目根文件夹。
    `-o "${workspaceFolder}/output/calculator.exe"`：`-o` 参数用于指定输出文件的路径和名称。我们将其固定为项目 `output` 目录下的 `calculator.exe`。

`"options": { "cwd": "${workspaceFolder}" }`
**作用**：cwd (Current Working Directory) 指定了执行 `command` 时的工作目录。将其设置为项目根目录是最佳实践，可以确保所有相对路径（如源文件名）都能被正确解析。

`"group": { "isDefault": true }`
**作用**：将此任务设置为默认的“构建”任务。这样，当你按下 `Ctrl+Shift+B`（默认的构建快捷键）时，VS Code 会自动运行这个任务。

## 2. launch.json - 调试会话配置文件

该文件告诉 VS Code 的调试器（Debugger）如何启动、附加和控制你的程序。

### 配置文件（`.vscode/launch.json`）

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug Calculator Project",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}/output/calculator.exe",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": true,
            "MIMode": "gdb",
            "miDebuggerPath": "D:\\VScode\\MinGW\\TDM-GCC-64\\bin\\gdb.exe",
            "setupCommands": [
                {
                    "description": "为 gdb 启用整齐打印",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                },
                {
                    "description": "将反汇编风格设置为 Intel",
                    "text": "-gdb-set disassembly-flavor intel",
                    "ignoreFailures": true
                }
            ],
            "preLaunchTask": "Build Calculator Project"
        }
    ]
}
```

### 关键字段详解（`./vscode/launch.json`）

`"name": "Debug Calculator Project"`
**作用**：此调试配置的名称。它会显示在 VS Code 左侧 “运行和调试” 面板的下拉菜单中。

`"program": "${workspaceFolder}/output/calculator.exe"`
**作用**：要启动并调试的程序的完整路径。这个路径必须与 `tasks.json` 中 `-o` 参数指定的输出路径完全一致。这是确保“前厅”能拿到“后厨”刚做好的那道菜的关键。

`"cwd": "${workspaceFolder}"`
**作用**：为你正在调试的程序设置工作目录。确保它与构建时的工作目录一致，可以避免很多潜在问题。

`"externalConsole": true`
**作用**：`true` 表示启动调试时，会弹出一个独立的外部控制台窗口（Windows上是cmd.exe或powershell）来运行你的程序，而不是使用 VS Code 内置的“调试控制台”。

`"preLaunchTask": "Build Calculator Project"`
**作用**：连接“后厨”与“前厅”的桥梁。它告诉调试器：“在启动 `program` 之前，请先去 `tasks.json` 文件里找到 `label` 为 `Build Calculator Project` 的那个任务，并执行它。” 这确保了你每次调试的都是最新编译的版本。

## 💱工作流程如何串联

当你按下 F5（开始调试）时，VS Code 内部的完整流程如下：

1. `launch.json` 响应 `F5` 事件，找到名为 `"Debug Calculator Project"` 的配置。
2. 它检查到 `"preLaunchTask": "Build Calculator Project"` 字段。
3. 它暂停启动，转而去 `tasks.json` 中寻找 `label` 为 `"Build Calculator Project"` 的任务。
4. 找到后，执行该任务：调用 `g++`，将 `calculator.cpp, lexer.cpp, parser.cpp, ...` 编译链接成一个 `calculator.exe` 文件，并存放在 `output` 文件夹中。
5. 构建任务成功结束后，`launch.json` 的流程继续。
6. 它启动 `"program"` 字段指定的 `output/calculator.exe` 程序，并根据配置（如 `externalConsole: true`）为其提供运行环境。
7. `GDB` 调试器附加到新启动的程序上，调试会话正式开始。

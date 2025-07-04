#ifndef COLORS_H
#define COLORS_H

#include <string>

// 使用命名空间来组织颜色代码，避免命名冲突
namespace Color {
    // 功能代码
    const std::string RESET       = "\033[0m";  // 重置所有颜色和样式
    const std::string BOLD        = "\033[1m";

    // 普通颜色
    const std::string BLACK       = "\033[30m";
    const std::string RED         = "\033[31m";
    const std::string GREEN       = "\033[32m";
    const std::string YELLOW      = "\033[33m";
    const std::string BLUE        = "\033[34m";
    const std::string MAGENTA     = "\033[35m";
    const std::string CYAN        = "\033[36m";
    const std::string WHITE       = "\033[37m";

    // 加粗亮色
    const std::string BOLD_BLACK  = "\033[1;30m";
    const std::string BOLD_RED    = "\033[1;31m";
    const std::string BOLD_GREEN  = "\033[1;32m";
    const std::string BOLD_YELLOW = "\033[1;33m";
    const std::string BOLD_BLUE   = "\033[1;34m";
    const std::string BOLD_MAGENTA= "\033[1;35m";
    const std::string BOLD_CYAN   = "\033[1;36m";
    const std::string BOLD_WHITE  = "\033[1;37m";
}

#endif // COLORS_H
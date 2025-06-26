#ifndef PARSER_H
#define PARSER_H

#include "lexer.h"
#include <string>
#include <vector>
#include <map>
#include <stdexcept> // For std::runtime_error

// 定义解析器的工作模式
enum class ParseMode {
    INTERPRET, // 解释器模式：直接计算结果
    COMPILE    // 编译器模式：生成中间代码和符号表
};

class Parser {
public:
    // 构造函数现在需要一个额外的 mode 参数来指定工作模式
    // 默认值为 INTERPRET，以兼容你现有的测试框架
    Parser(Lexer& lexer, ParseMode mode = ParseMode::INTERPRET);

    // --- 公共结果获取方法 ---

    // 驱动整个解析过程，必须先调用这个
    void parse();

    // 在 INTERPRET 模式下，调用此方法获取最终的整数结果
    int get_final_result() const;
    
    // 在 COMPILE 模式下，调用此方法获取生成的所有中间代码
    const std::vector<std::string>& get_intermediate_code() const;

    // 在 COMPILE 模式下，调用此方法打印符号表
    void print_symbol_table() const;

private:
    // --- 内部状态 ---
    Lexer& lexer_;
    Token current_token_;
    ParseMode mode_; // 保存当前的工作模式

    // --- 编译器模式专用成员 ---
    int temp_var_counter_;  // 用于生成临时变量名
    std::vector<std::string> intermediate_code_;
    std::map<std::string, std::string> symbol_table_; // <name, type>

    // --- 解释器模式专用成员 ---
    std::map<std::string, int> temp_values_; // <name, value>
    std::string final_result_variable_; // 记录最后一个临时变量名，用于判定是否扫描到字符串结束符

    // --- 内部辅助方法 ---
    void error(const std::string& message) const;
    void eat(TokenType type);
    std::string new_temp();
    template<typename Func>
    std::string binary_op_parser(std::string (Parser::*next_level_func)(), 
                           TokenType OP_TOKEN1, TokenType OP_TOKEN2, Func operation);

    // --- 解析函数 (统一返回 string) ---
    std::string factor();
    std::string mul_expr();
    std::string add_expr();
    std::string shift_expr();
    std::string bitwise_and();
    std::string bitwise_or();
    std::string expr();

    // --- 解释器模式专用辅助方法 ---
    int get_value(const std::string& name) const;
};

#endif // PARSER_H
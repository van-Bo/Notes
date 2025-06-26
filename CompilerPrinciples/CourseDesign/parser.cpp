#include "parser.h"
#include <iostream> // For printing symbol table

// 构造函数：初始化所有成员
Parser::Parser(Lexer& lexer, ParseMode mode)
    : lexer_(lexer), 
      current_token_({TokenType::EOF_TOKEN, 0}), 
      mode_(mode),
      temp_var_counter_(0),
      final_result_variable_("") {}

// --- 公共方法实现 ---

void Parser::parse() {
    current_token_ = lexer_.get_next_token();
    final_result_variable_ = expr(); // expr() 现在返回最后一个临时变量名

    // 检查表达式后面是否还有多余的 token
    if (current_token_.type != TokenType::EOF_TOKEN) {
        error("Unexpected characters at the end of the expression.");
    }
}

int Parser::get_final_result() const {
    if (mode_ != ParseMode::INTERPRET) {
        error("get_final_result() can only be called in INTERPRET mode.");
    }
    return get_value(final_result_variable_);
}

const std::vector<std::string>& Parser::get_intermediate_code() const {
    if (mode_ != ParseMode::COMPILE) {
        error("get_intermediate_code() can only be called in COMPILE mode.");
    }
    return intermediate_code_;
}

void Parser::print_symbol_table() const {
    if (mode_ != ParseMode::COMPILE) {
        error("print_symbol_table() can only be called in COMPILE mode.");
    }
    std::cout << "\n--- Symbol Table ---" << std::endl;
    std::cout << "| Name\t| Type\t|" << std::endl;
    std::cout << "--------------------" << std::endl;
    for (const auto& pair : symbol_table_) {
        std::cout << "| " << pair.first << "\t| " << pair.second << "\t|" << std::endl;
    }
    std::cout << "--------------------" << std::endl;
}

// --- 内部辅助方法实现 ---

void Parser::error(const std::string& message) const{
    throw std::runtime_error("Parser error: " + message);
}

void Parser::eat(TokenType type) {
    if (current_token_.type == type) {
        current_token_ = lexer_.get_next_token();
    } else {
        error("Unexpected token. Expected " + to_string(type) + 
              ", but got " + to_string(current_token_.type));
    }
}

std::string Parser::new_temp() {
    std::string temp_name = "t" + std::to_string(temp_var_counter_++);
    if (mode_ == ParseMode::COMPILE) {
        symbol_table_[temp_name] = "int"; // 在符号表中注册新的临时变量
    }
    return temp_name;
}

// 解释器模式专用：根据名字获取值 (可能是立即数，也可能在 temp_values_ 中)
int Parser::get_value(const std::string& name) const {
    // 检查它是否是一个数字字符串
    if (isdigit(name[0]) || (name[0] == '-' && isdigit(name[1]))) {
        return std::stoi(name);
    }
    // 否则，它一定是我们创建的临时变量，去 map 里查找
    return temp_values_.at(name);
}


// --- 解析函数实现 (双模式逻辑) ---
// factor -> INTEGER | LPAREN expr RPAREN | (PLUS | MINUS) factor
std::string Parser::factor() {
    Token token = current_token_;

    if (token.type == TokenType::INTEGER) {
        eat(TokenType::INTEGER);
        std::string num_str = std::to_string(token.value);
        if (mode_ == ParseMode::COMPILE) {
            // 编译器模式：为数字创建一个临时变量
            std::string temp_name = new_temp();
            intermediate_code_.push_back(temp_name + " = " + num_str);
            return temp_name;
        } else {
            // 解释器模式：直接返回数字的字符串形式
            return num_str;
        }
    } else if (token.type == TokenType::LPAREN) {
        eat(TokenType::LPAREN);
        std::string result_name = expr();
        eat(TokenType::RPAREN);
        return result_name; // 直接返回括号内表达式的结果名
    } else if (token.type == TokenType::PLUS) {
        eat(TokenType::PLUS);
        return factor(); // 一元正号，直接返回
    } else if (token.type == TokenType::MINUS) {
        eat(TokenType::MINUS);
        std::string operand_name = factor();
        std::string temp_name = new_temp();
        if (mode_ == ParseMode::COMPILE) {
            intermediate_code_.push_back(temp_name + " = -" + operand_name);
        } else {
            temp_values_[temp_name] = -get_value(operand_name);
        }
        return temp_name;
    }

    error("Invalid syntax in factor.");
    return ""; // Should not reach here
}

// 模板函数，用于处理所有二元操作
// OP_TOKEN1, OP_TOKEN2 是 TokenType
// op_char 是运算符的字符串表示
// operation 是一个 lambda 函数，用于在解释器模式下执行计算
template<typename Func>
std::string Parser::binary_op_parser(std::string (Parser::*next_level_func)(), 
                                   TokenType OP_TOKEN1, TokenType OP_TOKEN2, Func operation) {
    // 调用下一层级的函数
    std::string result_name = (this->*next_level_func)();

    while (current_token_.type == OP_TOKEN1 || current_token_.type == OP_TOKEN2) {
        Token op_token = current_token_;
        eat(op_token.type);
        std::string right_name = (this->*next_level_func)();
        
        std::string temp_name = new_temp();
        std::string op_char = to_string(op_token.type);

        if (mode_ == ParseMode::COMPILE) {
            intermediate_code_.push_back(temp_name + " = " + result_name + " " + op_char + " " + right_name);
        } else {
            // 在解释器模式下，需要区分具体是哪个操作符
            if (op_token.type == OP_TOKEN1) {
                 temp_values_[temp_name] = operation(get_value(result_name), get_value(right_name), OP_TOKEN1);
            } else {
                 temp_values_[temp_name] = operation(get_value(result_name), get_value(right_name), OP_TOKEN2);
            }
        }
        result_name = temp_name;
    }
    return result_name;
}

// mul_expr -> factor ((MUL | DIV) factor)*
std::string Parser::mul_expr() {
    return binary_op_parser(&Parser::factor, TokenType::MUL, TokenType::DIV, 
        [](int a, int b, TokenType op) { 
            if (op == TokenType::DIV && b == 0) throw std::runtime_error("Division by zero.");
            return (op == TokenType::MUL) ? a * b : a / b;
        });
}

// add_expr -> mul_expr ((PLUS | MINUS) mul_expr)*
std::string Parser::add_expr() {
    return binary_op_parser(&Parser::mul_expr, TokenType::PLUS, TokenType::MINUS, 
        [](int a, int b, TokenType op) { 
            return (op == TokenType::PLUS) ? a + b : a - b;
        });
}

// shift_expr -> add_expr ((LSHIFT | RSHIFT) add_expr)*
std::string Parser::shift_expr() {
    return binary_op_parser(&Parser::add_expr, TokenType::LSHIFT, TokenType::RSHIFT, 
        [](int a, int b, TokenType op) { 
            return (op == TokenType::LSHIFT) ? a << b : a >> b;
        });
}

// bitwise_and -> shift_expr (AND shift_expr)*
std::string Parser::bitwise_and() {
     return binary_op_parser(&Parser::shift_expr, TokenType::AND, TokenType::AND,
        [](int a, int b, TokenType op) { return a & b; });
}

// bitwise_or -> bitwise_and (OR bitwise_and)*
std::string Parser::bitwise_or() {
    return binary_op_parser(&Parser::bitwise_and, TokenType::OR, TokenType::OR,
        [](int a, int b, TokenType op) { return a | b; });
}

// expr -> bitwise_or
std::string Parser::expr() {
    return bitwise_or();
}
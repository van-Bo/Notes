#include <iostream>
#include <string>
#include <vector>
#include <cctype>   // for isspace, isdigit
#include <stdexcept> // for std::runtime_error
#include <map>
#include "lexer.h"

// --- 辅助函数：将 TokenType 转换为字符串，方便打印 ---
std::string to_string(TokenType type) {
    // 使用一个 map 来映射枚举到字符串
    static const std::map<TokenType, std::string> type_map = {
        {TokenType::INTEGER, "INTEGER"}, {TokenType::PLUS, "PLUS"},
        {TokenType::MINUS, "MINUS"},   {TokenType::MUL, "MUL"},
        {TokenType::DIV, "DIV"},       {TokenType::LPAREN, "LPAREN"},
        {TokenType::RPAREN, "RPAREN"}, {TokenType::LSHIFT, "LSHIFT"},
        {TokenType::RSHIFT, "RSHIFT"}, {TokenType::AND, "AND"},
        {TokenType::OR, "OR"},         {TokenType::EOF_TOKEN, "EOF"}
    };
    return type_map.at(type);
}

// 重载 << 操作符，方便直接用 std::cout 打印 Token
std::ostream& operator<<(std::ostream& os, const Token& token) {
    os << "Token(" << to_string(token.type) << ", ";
    if (token.type == TokenType::INTEGER) {
        os << token.value;
    } else {
        os << "None";
    }
    os << ")";
    return os;
}


Lexer::Lexer(std::string text) : text_(std::move(text)), pos_(0) {
    current_char_ = pos_ < text_.length() ? text_[pos_] : '\0';
}

// 词法分析的核心，获取下一个Token
Token Lexer::get_next_token() {
    while (current_char_ != '\0') {
        if (isspace(current_char_)) {
            skip_whitespace();
            continue;
        }

        if (isdigit(current_char_)) {
            return {TokenType::INTEGER, get_number()};
        }

        // --- 处理双字符操作符 ---
        if (current_char_ == '<' && peek() == '<') {
            advance(); advance();
            return {TokenType::LSHIFT, 0};
        }
        if (current_char_ == '>' && peek() == '>') {
            advance(); advance();
            return {TokenType::RSHIFT, 0};
        }

        // --- 处理单字符操作符 ---
        switch (current_char_) {
            case '+': advance(); return {TokenType::PLUS, 0};
            case '-': advance(); return {TokenType::MINUS, 0};
            case '*': advance(); return {TokenType::MUL, 0};
            case '/': advance(); return {TokenType::DIV, 0};
            case '(': advance(); return {TokenType::LPAREN, 0};
            case ')': advance(); return {TokenType::RPAREN, 0};
            case '&': advance(); return {TokenType::AND, 0};
            case '|': advance(); return {TokenType::OR, 0};
        }

        // 如果以上都不是，则是未知符号
        error();
    }
    // 到达文本末尾
    return {TokenType::EOF_TOKEN, 0};
}

void Lexer::advance() {
    pos_++;
    current_char_ = pos_ < text_.length() ? text_[pos_] : '\0';
}

void Lexer::skip_whitespace() {
    while (current_char_ != '\0' && isspace(current_char_)) {
        advance();
    }
}

char Lexer::peek() {
    size_t peek_pos = pos_ + 1;
    if (peek_pos < text_.length()) {
        return text_[peek_pos];
    }
    return '\0';
}

int Lexer::get_number() {
    size_t start_pos = pos_;

    // 检查十六进制
    if (current_char_ == '0' && (peek() == 'x' || peek() == 'X')) {
        advance(); advance(); // 跳过 "0x"
        start_pos = pos_; // 记录数字部分的起始位置
        while (current_char_ != '\0' && isxdigit(current_char_)) {
            advance();
        }
        // [Edge Case Handling] 检查是否至少读到了一个十六进制数字
        if (pos_ == start_pos) {
            error(); // 如果一个都没读到，说明 "0x" 后面跟了非法字符，报错
        }
        std::string num_str = text_.substr(start_pos, pos_ - start_pos);
        return std::stoi(num_str, nullptr, 16);
    }

    // 检查二进制
    if (current_char_ == '0' && (peek() == 'b' || peek() == 'B')) {
        advance(); advance(); // 跳过 "0b"
        start_pos = pos_;
        while (current_char_ != '\0' && (current_char_ == '0' || current_char_ == '1')) {
            advance();
        }
        // [Edge Case Handling] 检查是否至少读到了一个二进制数字
        if (pos_ == start_pos) {
            error(); // 如果一个都没读到，说明 "0b" 后面跟了非法字符，报错
        }
        std::string num_str = text_.substr(start_pos, pos_ - start_pos);
        return std::stoi(num_str, nullptr, 2);
    }
    
    // 默认为十进制 (十进制不存在 [Edge Case Handling] 错误，因为 get_number 的入口就保证了至少有一位数字)
    while (current_char_ != '\0' && isdigit(current_char_)) {
        advance();
    }
    std::string num_str = text_.substr(start_pos, pos_ - start_pos);
    return std::stoi(num_str, nullptr, 10);
}
    
void Lexer::error() {
    throw std::runtime_error("Lexer error: Invalid character '" + std::string(1, current_char_) + "' at position " + std::to_string(pos_));
}
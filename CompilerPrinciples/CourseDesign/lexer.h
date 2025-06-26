#ifndef LEXER_H
#define LEXER_H

#include <string>
#include <vector>
#include <iostream>
#include <map>

// Token 类型定义
enum class TokenType {
    // Data types
    INTEGER,
    // Operators
    PLUS, MINUS, MUL, DIV,
    LPAREN, RPAREN, // Left Parenthesis, Right Parenthesis
    // Bitwise Operators
    LSHIFT, RSHIFT, AND, OR,
    // End of file marker
    EOF_TOKEN // 'EOF' is a macro in C++, so we use a different name
};

// Token 结构体定义
struct Token {
    TokenType type;
    int value = 0;
};

// 全局辅助函数声明 (方便外部使用)
std::string to_string(TokenType type);
std::ostream& operator<<(std::ostream& os, const Token& token);

// Lexer 类的声明
class Lexer {
public:
    Lexer(std::string text);
    Token get_next_token();

private:
    std::string text_;
    size_t pos_;
    char current_char_;

    void advance();
    void skip_whitespace();
    char peek();
    int get_number();
    void error();
};

#endif // LEXER_H
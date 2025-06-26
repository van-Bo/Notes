#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <sstream>
#include <optional>
#include <algorithm>

#include "parser.h"
#include "colors.h" // 包含调色板

// =============================================================================
// 模式一：自我评测框架 (Interpreter Mode)
// =============================================================================
enum class ExpectationType { VALUE, ERROR };

struct TestCase 
{ 
    std::string original_line; 
    std::string clean_expression; 
    std::optional<ExpectationType> expectation; 
    int expected_value = 0; 
};
int total_tests = 0; int passed_tests = 0;

TestCase parse_test_line(const std::string& line) {
    TestCase tc; tc.original_line = line; std::string trimmed_line = line;
    trimmed_line.erase(0, trimmed_line.find_first_not_of(" \t"));
    if (trimmed_line.empty() || trimmed_line[0] == '#') { tc.clean_expression = ""; return tc; }
    std::string temp_line = line; 
    std::string expectation_marker = "// expect:"; 
    size_t marker_pos = temp_line.find(expectation_marker);
    if (marker_pos != std::string::npos) {
        std::string expectation_str = temp_line.substr(marker_pos + expectation_marker.length());
        expectation_str.erase(0, expectation_str.find_first_not_of(" \t")); 
        expectation_str.erase(expectation_str.find_last_not_of(" \t") + 1);
        if (expectation_str == "error") { tc.expectation = ExpectationType::ERROR;
        } else {
            tc.expectation = ExpectationType::VALUE;
            try { tc.expected_value = std::stoi(expectation_str); } catch (...) { tc.expectation.reset(); }
        }
        temp_line = temp_line.substr(0, marker_pos);
    }
    size_t comment_pos = temp_line.find('#');
    if (comment_pos != std::string::npos) temp_line = temp_line.substr(0, comment_pos);
    temp_line.erase(0, temp_line.find_first_not_of(" \t")); 
    temp_line.erase(temp_line.find_last_not_of(" \t") + 1);
    tc.clean_expression = temp_line; return tc;
}

void run_test_case(const TestCase& tc) {
    if (tc.clean_expression.empty()) return;
    std::cout << Color::BOLD << "[RUNNING] " << Color::RESET << tc.original_line << std::endl;
    bool should_count = tc.expectation.has_value();
    if(should_count) total_tests++;
    try {
        Lexer lexer(tc.clean_expression);
        Parser parser(lexer, ParseMode::INTERPRET);

        parser.parse();
        
        int actual_result = parser.get_final_result();
        if (should_count && tc.expectation == ExpectationType::ERROR) {
            std::cout << Color::BOLD_RED << "  [ FAIL! ]" << Color::RESET << " Expected an error, but got result: " << actual_result << std::endl;
        } else if (should_count && tc.expectation == ExpectationType::VALUE) {
            if (actual_result == tc.expected_value) {
                std::cout << Color::BOLD_GREEN << "  [  OK   ]" << Color::RESET << " Passed." << std::endl;
                passed_tests++;
            } else {
                std::cout << Color::BOLD_RED << "  [ FAIL! ]" << Color::RESET << " Expected " << tc.expected_value << ", but got " << actual_result << std::endl;
            }
        } else {
            std::cout << Color::YELLOW << "  = " << actual_result << Color::RESET << std::endl;
        }
    } catch (const std::exception& e) {
        if (should_count && tc.expectation == ExpectationType::ERROR) {
            std::cout << Color::BOLD_GREEN << "  [  OK   ]" << Color::RESET << " Passed. Got expected error." << std::endl;
            passed_tests++;
        } else if (should_count && tc.expectation == ExpectationType::VALUE) {
            std::cout << Color::BOLD_RED << "  [ FAIL! ]" << Color::RESET << " Expected " << tc.expected_value << ", but got an error: " << e.what() << std::endl;
        } else {
            std::cerr << Color::RED << "  ERROR: " << e.what() << Color::RESET << std::endl;
        }
    }
    std::cout << Color::BOLD_BLACK << "-----------------------------------------------------" << Color::RESET << std::endl;
}

void run_self_assessment() {
    total_tests = 0; passed_tests = 0;
    std::string filename;
    std::cout << "\nEnter the test file path (e.g., tests/batch1.txt or tests/batch2.txt): ";
    std::getline(std::cin, filename);

    std::ifstream file(filename);
    if (!file.is_open()) {
        std::cerr << Color::BOLD_RED << "Fatal: Could not open test file: " << filename << Color::RESET << std::endl;
        return;
    }
    std::cout << Color::BOLD_MAGENTA << "\n======= Running Self-Assessment from: " << filename << " =======" << Color::RESET << std::endl;
    std::string line;
    while (std::getline(file, line)) { 
        run_test_case(parse_test_line(line)); 
    }
    file.close();

    std::cout << Color::BOLD_MAGENTA << "\n======= ASSESSMENT SUMMARY =======" << Color::RESET << std::endl;
    if(total_tests > 0) {
        std::cout << "  Total Assertions: " << total_tests << std::endl;
        std::cout << Color::GREEN << "  Passed: " << passed_tests << Color::RESET << std::endl;
        std::cout << Color::RED << "  Failed: " << total_tests - passed_tests << Color::RESET << std::endl;
        double pass_rate = static_cast<double>(passed_tests) / total_tests * 100.0;
        std::cout.precision(2);
        std::cout << "  Pass Rate: " << std::fixed << pass_rate << "%" << std::endl;
    } else {
        std::cout << "  No test assertions (// expect:) found in file." << std::endl;
    }
    std::cout << Color::BOLD_MAGENTA << "================================" << Color::RESET << std::endl;
}

// =============================================================================
// 模式二：编译到单个文件 (Compiler Mode)
// =============================================================================
void run_compilation_to_single_file() {
    std::string in_filename;
    std::cout << "\nEnter the input file with expressions (e.g., tests/batch1.txt or tests/batch2.txt): ";
    std::getline(std::cin, in_filename);

    std::ifstream file(in_filename);
    if (!file.is_open()) {
        std::cerr << Color::BOLD_RED << "Fatal: Could not open input file: " << in_filename << Color::RESET << std::endl;
        return;
    }
    std::string base_filename = "output/compilation_result";
    std::ofstream tac_file(base_filename + ".tac");
    std::ofstream sym_file(base_filename + ".sym");
    std::cout << Color::BOLD_MAGENTA << "\n======= Compiling expressions from: " << in_filename << " =======" << Color::RESET << std::endl;
    std::string line;
    int expression_count = 1;
    while (std::getline(file, line)) {
        std::string trimmed_line = line;
        trimmed_line.erase(0, trimmed_line.find_first_not_of(" \t"));
        if (trimmed_line.empty() || trimmed_line[0] == '#') continue;
        size_t comment_pos = line.find('#');
        if (comment_pos != std::string::npos) line = line.substr(0, comment_pos);
        size_t expect_pos = line.find("//");
        if (expect_pos != std::string::npos) line = line.substr(0, expect_pos);
        line.erase(line.find_last_not_of(" \t") + 1);
        if (line.empty()) continue;

        std::cout << "Compiling expression #" << expression_count << ": \"" << line << "\"" << std::endl;
        tac_file << "--- TAC for Expression #" << expression_count << ": \"" << line << "\" ---\n";
        sym_file << "--- Symbol Table for Expression #" << expression_count << ": \"" << line << "\" ---\n";
        try {
            Lexer lexer(line);
            Parser parser(lexer, ParseMode::COMPILE);
            parser.parse();
            
            const auto& code = parser.get_intermediate_code();
            for (const auto& code_line : code) { 
                tac_file << code_line << std::endl; 
            }
            std::streambuf* coutbuf = std::cout.rdbuf(); std::cout.rdbuf(sym_file.rdbuf());
            parser.print_symbol_table();
            std::cout.rdbuf(coutbuf);
            std::cout << Color::GREEN << "  -> Success." << Color::RESET << std::endl;
        } catch (const std::exception& e) {
            tac_file << "Error: " << e.what() << std::endl;
            sym_file << "Error: " << e.what() << std::endl;
            std::cerr << Color::RED << "  -> Error: " << e.what() << Color::RESET << std::endl;
        }
        tac_file << "\n"; sym_file << "\n";
        expression_count++;
    }
    tac_file.close(); sym_file.close(); file.close();
    std::cout << Color::BOLD_MAGENTA << "=======================================================" << Color::RESET << std::endl;
    std::cout << Color::BOLD_GREEN << "Compilation finished." << Color::RESET << std::endl;
    std::cout << "Results saved to:" << std::endl;
    std::cout << "  -> " << base_filename << ".tac" << std::endl;
    std::cout << "  -> " << base_filename << ".sym" << std::endl;
    std::cout << Color::BOLD_MAGENTA << "=======================================================" << Color::RESET << std::endl;
}

// =============================================================================
// 主程序入口：菜单循环
// =============================================================================
int main() {
    while (true) {
        std::cout << Color::BOLD_BLUE << "\n===== Main Menu =====" << std::endl;
        std::cout << "1. Run Self-Assessment (Interpreter Mode)" << std::endl;
        std::cout << "2. Compile Expressions to a Single File (Compiler Mode)" << std::endl;
        std::cout << "3. Exit" << std::endl;
        std::cout << "=====================" << Color::RESET << std::endl;
        std::cout << "Enter your choice: ";
        std::string choice;
        std::getline(std::cin, choice);
        if (choice == "1") {
            run_self_assessment();
        } else if (choice == "2") {
            run_compilation_to_single_file();
        } else if (choice == "3") {
            std::cout << "Goodbye!" << std::endl;
            break;
        } else {
            std::cerr << Color::RED << "Invalid choice. Please enter 1, 2, or 3." << Color::RESET << std::endl;
        }
    }
    return 0;
}
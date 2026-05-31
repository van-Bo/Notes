`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/29 12:06:28
// Design Name: 
// Module Name: demo01topv
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module demo01topv(
    input wire[1:0] sw,
    output wire[6:0] led
);
    NOT A(.SW0(sw[0]), .LED0(led[0]));
    AND B(.SW0(sw[0]), .SW1(sw[1]), .LED1(led[1]));
    OR C(.SW0(sw[0]), .SW1(sw[1]), .LED2(led[2]));
    NAND D(.SW0(sw[0]), .SW1(sw[1]), .LED3(led[3]));
    NOR E(.SW0(sw[0]), .SW1(sw[1]), .LED4(led[4]));
    XOR F(.SW0(sw[0]), .SW1(sw[1]), .LED5(led[5]));
    NXOR G(.SW0(sw[0]), .SW1(sw[1]), .LED6(led[6]));
endmodule

//反相器
module NOT(
    input wire SW0,
    output wire LED0
);
    assign LED0 = ~SW0;
endmodule

//2输入与门
module AND (
    input wire SW0, SW1,
    output wire LED1    
);
    assign LED1 = SW0 & SW1;
endmodule

//2输入或门
module OR (
    input wire SW0, SW1,
    output wire LED2
);
    assign LED2 = SW0 | SW1;
endmodule

//2输入与非门
module NAND (
    input wire SW0, SW1,
    output wire LED3
);
    assign LED3 = ~(SW0 & SW1);
endmodule

//2输入或非门
module NOR (
    input wire SW0, SW1,
    output wire LED4
);
    assign LED4 = ~(SW0 | SW1);
endmodule

//2输入异或门
module XOR (
    input wire SW0, SW1,
    output wire LED5
);
    assign LED5 = SW0 ^ SW1;     
endmodule

//2输入同或门
module NXOR (
    input wire SW0, SW1,
    output wire LED6
);
    assign LED6 = ~(SW0 ^ SW1);
endmodule
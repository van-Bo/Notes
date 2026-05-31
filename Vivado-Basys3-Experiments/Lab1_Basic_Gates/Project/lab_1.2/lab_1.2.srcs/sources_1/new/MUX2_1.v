`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/30 01:29:31
// Design Name: 
// Module Name: MUX2_1
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

//2选1数据选择器
module MUX2_1(
    input s,
    input a, b,
    output out
    );
    wire ns, a1, b1;
    not U1(ns, s);
    and U2(b1, b, s);
    and U3(a1, a, ns);
    or U4(out, a1, b1);
endmodule

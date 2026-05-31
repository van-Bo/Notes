`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/30 01:33:06
// Design Name: 
// Module Name: MUX4_1
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


module MUX4_1(
    input wire[1:0] s,
    input wire[3:0] d,
    output y
    );
    wire a, b;
    MUX2_1 U1(s[0], d[0], d[1], a);
    MUX2_1 U2(s[0], d[2], d[3], b);
    MUX2_1 U3(s[1], a, b, y);
endmodule

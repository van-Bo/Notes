`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/10 22:49:08
// Design Name: 
// Module Name: mux7seg_top
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


module mux7seg_top(
    input  btnU,
    input  btnL,
    input  btnD,
    input  btnR,
    input [15:0] sw,
    output wire [0:6] seg,
    output wire [3:0] an,
    output wire dp 
    );

    wire [3:0] bottons = {btnU, btnL, btnD, btnR};
    mux7seg test_top(.x(sw), .btn(bottons[3:0]), .aToG(seg[0:6]), .an(an[3:0]), .dp(dp));
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/30 01:37:58
// Design Name: 
// Module Name: MUX4_1_top
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


module MUX4_1_top(
    input wire[5:0] sw,
    output wire[0:0] led
    );
    MUX4_1 M1(.s(sw[1:0]), .d(sw[5:2]), .y(led[0]));
endmodule

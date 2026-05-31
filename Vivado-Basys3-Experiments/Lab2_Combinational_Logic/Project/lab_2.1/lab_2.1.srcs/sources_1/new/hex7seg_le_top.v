
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/08 20:09:06
// Design Name: 
// Module Name: hex7seg_le_top
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

`timescale 1ns / 1ps
module hex7seg_le_top(
    input wire [3:0] sw,
    output wire [0:6] seg
    );

    hex7seg_le test_top(.x(sw[3:0]), .aToG(seg[0:6]));
endmodule

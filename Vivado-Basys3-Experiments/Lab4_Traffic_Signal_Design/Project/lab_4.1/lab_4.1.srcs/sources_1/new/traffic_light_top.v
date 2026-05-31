`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/22 12:33:57
// Design Name: 
// Module Name: traffic_light_top
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


module traffic_light_top(clk, sw, led[5:0]);
    input clk;
    input [3:0] sw;
    output [5:0] led;

    wire divClk;
    div div_clock(.clk(clk), .reset(sw[3]), .divClk(divClk));
    
    wire [1:0] La, Lb;
    tl_controller tl_ctrol(.clk(divClk), .reset(sw[3]), .Ta(sw[0]), .Tb(sw[1]), .La(La), .Lb(Lb), .LedA(led[2:0]), .LedB(led[5:3]));

endmodule

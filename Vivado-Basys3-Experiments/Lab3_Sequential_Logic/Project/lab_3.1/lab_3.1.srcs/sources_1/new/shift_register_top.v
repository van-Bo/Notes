`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/09 19:50:49
// Design Name: 
// Module Name: shift_register_top
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


module shift_register_top(
        input clk,
        input wire [12:0] sw,
        output wire [7:0] led
    );

    wire clk_div;     

    clock_divide dv_clk(.clk(clk), .resetn(sw[12]), .clk_div(clk_div));
    shift_register sh_r(.clrn(sw[12]), .s1(sw[9]), .s0(sw[8]), .Dsr(sw[11]), .Dsl(sw[10]),
                        .D(sw[7:0]), .clk(clk_div), .Q(led[7:0]));
endmodule

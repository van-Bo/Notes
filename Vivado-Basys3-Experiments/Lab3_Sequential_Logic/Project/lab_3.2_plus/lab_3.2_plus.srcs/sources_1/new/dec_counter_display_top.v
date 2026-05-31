`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/10 21:28:01
// Design Name: 
// Module Name: dec_counter_display_top
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


module dec_counter_display_top(clk, sw, an, seg);
    input clk;
    input [1:0] sw;
    output [3:0] an;
    output [0:6] seg;

    wire divClk;
    clock_divide clk_div(.clk(clk), .resetn(1), .divClk(divClk));

    wire [3:0] dec0, dec1, dec2, dec3;
    dec_counter dec_cnter(.clk(divClk), .reset(sw[0]), .enable(sw[1]), 
                          .dec0(dec0), .dec1(dec1), .dec2(dec2), .dec3(dec3));
    
    bcd_decoder bcd_dcdr(.clk(clk), .dec0(dec0), .dec1(dec1), .dec2(dec2), .dec3(dec3),
                         .an(an[3:0]), .seg(seg[0:6]));
endmodule

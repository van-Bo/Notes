`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/11 15:34:15
// Design Name: 
// Module Name: vga_top
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


module vga_top(clk, sw, vgaRed, vgaGreen, vgaBlue, Hsync, Vsync);
    input clk;
    input [1:0] sw;
    
    output [3:0] vgaRed;
    output [3:0] vgaGreen;
    output [3:0] vgaBlue;
    output Hsync, Vsync;

    wire divClk;
    divide_clock div_clk(.clk(clk), .reset(sw[0]), .divClk(divClk));
    VGA_controller vga_contr(.clk(divClk), .reset(sw[0]), .en_shift(sw[1]),
                .vga_hs(Hsync), .vga_vs(Vsync), .vga_rgb({vgaRed[3:0], vgaGreen[3:0], vgaBlue[3:0]}));

endmodule

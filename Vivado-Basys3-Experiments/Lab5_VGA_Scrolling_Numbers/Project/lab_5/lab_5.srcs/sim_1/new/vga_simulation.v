`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/14 23:26:37
// Design Name: 
// Module Name: vga_simulation
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


module vga_simulation();
    reg clk, reset, en_shift;

    wire [3:0] vgaRed, vgaGreen, vgaBlue;
    wire vga_hs, vga_vs;
    wire [9:0] cnt_hs, cnt_vs;

    always #0.5 clk = ~clk;

    VGA_controller vga_contr(.clk(clk), .reset(reset), .en_shift(en_shift), 
                             .vga_hs(vga_hs), .vga_vs(vga_vs), .vga_rgb({vgaRed, vgaGreen, vgaBlue}), .cnt_hs(cnt_hs), .cnt_vs(cnt_vs));

    initial begin
        #0  
            clk = 0;
            reset = 1;
            en_shift = 0;
        #20
            reset = 0;
        #200    
            en_shift = 0;
        #200 
            en_shift = 0;
        #200
            en_shift = 0;
        #200 en_shift = 0;
        #200 en_shift = 0;
        #200 $finish;
    end
endmodule

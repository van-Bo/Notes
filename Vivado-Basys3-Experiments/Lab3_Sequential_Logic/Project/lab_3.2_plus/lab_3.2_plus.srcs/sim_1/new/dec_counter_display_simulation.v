`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/10 21:38:05
// Design Name: 
// Module Name: dec_counter_display_simulation
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


module dec_counter_display_simulation();
    reg clk, reset, enable;
    wire [3:0] dec0, dec1, dec2, dec3;
    wire [3:0] an;
    wire [6:0] seg;

    always #5 clk = ~clk;
    dec_counter dec_cnter(.clk(clk), .reset(reset), .enable(enable),
                          .dec0(dec0), .dec1(dec1), .dec2(dec2), .dec3(dec3));

    bcd_decoder bcd_dcdr(.clk(clk),.dec0(dec0), .dec1(dec1), .dec2(dec2), .dec3(dec3),
                         .an(an[3:0]), .seg(seg[6:0]));

    initial begin
        #0  clk = 0;
            reset = 1;

        #20 reset = 0;
            enable = 1;
        
        #2000 $finish;
    end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/10 23:47:20
// Design Name: 
// Module Name: timer_tb
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


module timer_tb();
    reg clk, reset, enable;
    wire [3:0] M, SS1, SS0, D;
    wire [3:0] an;
    wire [0:6] seg;

    always #5 clk = ~clk;

    timer tmr(.clk(clk), .reset(reset), .enable(enable), 
              .M(M), .SS1(SS1), .SS0(SS0), .D(D));
    display dspy(.clk(clk), .M(M), .SS1(SS1), .SS0(SS0), .D(D),
                 .an(an[3:0]), .seg(seg[0:6]));

    initial begin
        #0  clk = 0;
            reset = 1;
            enable = 0;
        #20 reset = 0;
            enable = 1;
        #2000 $finish;
    end
endmodule

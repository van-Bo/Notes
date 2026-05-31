`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/11 18:29:06
// Design Name: 
// Module Name: stop_watch_top
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


module stop_watch_top(clk, sw, an, seg);
    input clk;
    input [1:0] sw;
    output [3:0] an;
    output [0:6] seg;

    wire divClk;
    div dv(.clk(clk), .resetn(1), .divClk(divClk));

    wire [3:0] M, SS1, SS0, D;
    timer tmr(.clk(divClk), .reset(sw[0]), .enable(sw[1]),
              .M(M[3:0]), .SS1(SS1[3:0]), .SS0(SS0[3:0]), .D(D[3:0]));

    display dpy(.clk(clk), .M(M[3:0]), .SS1(SS1[3:0]), .SS0(SS0[3:0]), .D(D[3:0]),
                .an(an[3:0]), .seg(seg[0:6]));

endmodule

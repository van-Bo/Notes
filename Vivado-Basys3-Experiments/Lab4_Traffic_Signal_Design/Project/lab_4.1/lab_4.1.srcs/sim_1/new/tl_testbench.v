`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/13 20:26:18
// Design Name: 
// Module Name: tl_testbench
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


module tl_testbench();
    reg clk, reset;
    reg Ta, Tb;
    wire [1:0] La, Lb;
    wire [2:0] LedA, LedB;

    always #5 clk = ~clk;
    //wire divClk;
    //div div_clock(.clk(clk), .reset(reset), .divClk(divClk));
    tl_controller tl_ctrer(.clk(clk), .reset(reset), .Ta(Ta), .Tb(Tb), .La(La), .Lb(Lb), .LedA(LedA), .LedB(LedB));

    initial begin
        #0  clk = 0; 
            reset = 1;
            Ta = 0;
            Tb = 0;
        #20 reset = 0;  //东西方向有人，南北方向无人
            Ta = 1;
            Tb = 0;
        #20 Ta = 0;     //东西、南北方向均无人
            Tb = 0;
        #20 Ta = 0;     //东西方向无人，南北方向有人
            Tb = 1;     
        #20 Ta = 0;     //东西、南北方向均无人
            Tb = 0;
        #20 Ta = 0;     //东西、南北方向均无人
            Tb = 0;
        #20 Ta = 1;     //东西、南北方向均有人
            Tb = 1;
        #20 $finish;
    end
endmodule

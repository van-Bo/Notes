`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/09 19:49:23
// Design Name: 
// Module Name: clock_divide
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


module clock_divide(clk, resetn, clk_div);
    input clk;              //系统时钟
    input resetn;           //复位信号
    output reg  clk_div;    //分频时钟

    //parameter n = 26'd50_000_000;
    reg [25:0] cnt = 0; //计数器     

    always @(posedge clk, negedge resetn) 
    begin
        if (!resetn)        //复位
        begin
            cnt <= 0;
            clk_div <= 0;
        end
        else
        begin
            if (cnt == 49_999_999)   //计数器达到最大值
            begin
                clk_div <= ~clk_div;
                cnt <= 0;
            end                 //计数器加1
            else
                cnt <= cnt + 1;
        end
    end 

endmodule

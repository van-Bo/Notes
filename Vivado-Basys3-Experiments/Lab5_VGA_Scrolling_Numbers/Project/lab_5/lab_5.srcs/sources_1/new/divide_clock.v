`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/27 23:04:05
// Design Name: 
// Module Name: divide_clock
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


module divide_clock(clk, reset, divClk);
    input clk, reset;
    output reg divClk;

    reg cnt;

    always @(posedge clk, posedge reset)
    begin
        if (reset)
        begin
            cnt <= 1'b0;
            divClk <= 1'b0;
        end
        else
        begin
            if (cnt == 1)
            begin
               divClk <= ~divClk;
               cnt <= 1'b0; 
            end
            else
                cnt <= cnt + 1;
        end 
    end
endmodule

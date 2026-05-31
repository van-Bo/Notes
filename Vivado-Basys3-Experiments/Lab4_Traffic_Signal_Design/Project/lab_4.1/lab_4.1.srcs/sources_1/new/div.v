`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/13 19:23:23
// Design Name: 
// Module Name: div
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


module div(clk, reset, divClk);
    input clk, reset;
    output reg divClk;

    parameter n = 29'd500_000_000;
    //parameter n = 29'd10;
    reg [27:0] cnt;

    always @(posedge clk, posedge reset)
    begin
        if (reset)
        begin
            divClk <= 0;
            cnt <= 0;
        end 
        else 
        begin
            if (cnt == n / 2 - 1)
            begin
                divClk <= ~divClk;
                cnt <= 0;
            end 
            else 
                cnt <= cnt + 1;
        end
    end
endmodule

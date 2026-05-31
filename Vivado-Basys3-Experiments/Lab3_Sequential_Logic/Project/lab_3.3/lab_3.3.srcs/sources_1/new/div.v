`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/10 23:24:09
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

//make the 10Hz(period 0.1s) divClk
module div(clk, resetn, divClk);
    input clk, resetn;
    output reg divClk;

    parameter n = 24'd10_000_000;
    reg [22:0] cnt;

    always @(posedge clk, negedge resetn)
    begin
        if (!resetn)
            divClk <= 0;
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

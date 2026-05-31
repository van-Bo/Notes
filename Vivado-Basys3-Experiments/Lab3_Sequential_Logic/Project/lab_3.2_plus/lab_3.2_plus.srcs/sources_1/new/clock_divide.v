`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/10 20:48:42
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


module clock_divide(clk, resetn, divClk);
    input clk, resetn;
    output reg divClk;

    parameter n = 20'd1000_000;
    reg [18:0] cnt;
    always @(posedge clk, negedge resetn)
    begin
        if (!resetn)
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

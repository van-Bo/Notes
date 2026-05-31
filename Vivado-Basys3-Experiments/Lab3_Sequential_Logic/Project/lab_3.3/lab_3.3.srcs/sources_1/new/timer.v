`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/10 22:59:35
// Design Name: 
// Module Name: timer
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


module timer(clk, reset, enable, M, SS0, SS1, D);
    input clk, reset, enable;
    output reg [3:0] D;
    output reg [3:0] SS0;
    output reg [3:0] SS1;
    output reg [3:0] M;

    always @(posedge clk)
    begin
        if (reset)
        begin
            D <= 4'b0000;
            SS0 <= 4'b0000;
            SS1 <= 4'b0000;
            M <= 4'b0000;
        end
        else
        begin
            if (enable)
            begin
                if (D <= 4'b1000)   //处理D
                    D <= D + 1;
                else
                begin
                    D <= 0;
                    if (SS0 <= 4'b1000)    //处理SS0
                        SS0 <= SS0 + 1; 
                    else
                    begin
                        SS0 <= 0;
                        if (SS1 <= 4'b0100)   //处理SS1
                            SS1 <= SS1 + 1;
                        else
                        begin
                            SS1 <= 0;
                            if (M <= 4'b1000)   //处理M
                                M <= M + 1;
                            else 
                                M <= 0;
                        end 
                    end
                end
            end
        end
    end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/09 19:28:24
// Design Name: 
// Module Name: shift_register
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


module shift_register(clrn, s1, s0, Dsr, Dsl, D, clk, Q);
    input clrn, s1, s0, Dsr, Dsl;
    input [7:0] D;
    input clk;
    output reg [7:0] Q;

    integer k;

    always @(posedge clk, negedge clrn)
    begin
        if (!clrn)
        begin
            Q <= 8'b00_000_000;
        end
        else
        begin
            case ({s1, s0})
                //保持
                2'b00:  Q <= Q;  
                
                //右移
                2'b01:  
                begin
                    for (k = 0; k <= 6; k = k + 1)  
                        Q[k] <= Q[k + 1];         
                    Q[7] <= Dsr;
                end
                
                //左移
                2'b10:  
                begin
                        for (k = 7; k >= 1; k = k - 1)  
                            Q[k] <= Q[k - 1];
                        Q[0] <= Dsl; 
                end

                //置位
                2'b11:  Q <= D;
            endcase
        end 
    end

endmodule

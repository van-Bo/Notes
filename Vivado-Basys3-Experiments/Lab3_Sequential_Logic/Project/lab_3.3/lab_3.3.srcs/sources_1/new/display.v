`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/10 23:32:13
// Design Name: 
// Module Name: display
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


module display(clk, M, SS1, SS0, D, an, seg);
    input clk;
    input [3:0] M, SS1, SS0, D;
    output reg [3:0] an;
    output reg [0:6] seg;

    reg [18:0] regN;
    reg [3:0] digit;

    always @(posedge clk)
        regN <= regN + 1;
    
    always @(*)
    begin
        case (regN[18:17])
            2'b00:
                begin
                    digit = D;
                    an = 4'b1110;
                end
            
            2'b01:
                begin
                    digit = SS0;
                    an = 4'b1101;
                end

            2'b10:
                begin
                    digit = SS1;
                    an = 4'b1011;
                end
            default: 
                begin
                    digit = M;
                    an = 4'b0111;
                end
        endcase
    end

    always @(*)
    begin
        case (digit)
            4'b0000: seg = 7'b0000001;
            4'b0001: seg = 7'b1001111;
            4'b0010: seg = 7'b0010010;
            4'b0011: seg = 7'b0000110;
            4'b0100: seg = 7'b1001100;
            4'b0101: seg = 7'b0100100;
            4'b0110: seg = 7'b0100000;
            4'b0111: seg = 7'b0001111;
            4'b1000: seg = 7'b0000000;
            4'b1001: seg = 7'b0000100; 
        endcase
    end

endmodule

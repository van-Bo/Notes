`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/10 21:14:12
// Design Name: 
// Module Name: bcd_decoder
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


module bcd_decoder(clk, dec0, dec1, dec2, dec3, an, seg);
    input clk;
    input [3:0] dec0, dec1, dec2, dec3;
    output reg [3:0] an;
    output reg [0:6] seg;

    reg [16:0] regN;
    reg [3:0] dec;

    always @(posedge clk)
        regN <= regN + 1;
    
    always @(*)
    begin
        case (regN[16:15])
            2'b00:
                begin
                    dec = dec0;
                    an = 4'b1110;
                end 
            2'b01:
                begin
                    dec = dec1;
                    an = 4'b1101;
                end
            2'b10:
                begin
                    dec = dec2;
                    an = 4'b1011;
                end
            default: 
                begin
                    dec = dec3;
                    an = 4'b0111;
                end
        endcase
    end

    always @(*)
    begin
        case (dec)
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

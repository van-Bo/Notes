
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/09 22:57:28
// Design Name: 
// Module Name: hex7seg_le
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

`timescale 1ns / 1ps
module hex7seg_le(
    input wire [3:0] x,
    output reg [6:0] aToG
    );

    always @(x) 

    case (x)
        0: aToG = 7'b0000001;
        1: aToG = 7'b1001111;
        2: aToG = 7'b0010010;
        3: aToG = 7'b0000110;
        4: aToG = 7'b1001100;
        5: aToG = 7'b0100100;
        6: aToG = 7'b0100000;
        7: aToG = 7'b0001111;
        8: aToG = 7'b0000000;
        9: aToG = 7'b0000100;
        'hA: aToG = 7'b0001000;
        'hB: aToG = 7'b1100000;
        'hC: aToG = 7'b0110001;
        'hD: aToG = 7'b1000010;
        'hE: aToG = 7'b0110000;
        'hF: aToG = 7'b0111000;
    endcase    

endmodule

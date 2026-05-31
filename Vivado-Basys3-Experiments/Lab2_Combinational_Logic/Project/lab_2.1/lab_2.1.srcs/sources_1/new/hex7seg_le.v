
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/08 19:42:39
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
//NOTE 16进制 7段译码器：a ~ g低电平有效
module hex7seg_le(
    input wire [3:0] x,
    output wire [6:0] aToG
    );

    // NOTE a
    assign aToG[6] = ~x[3] & ~x[2] & ~x[1] & x[0] 
                    | ~x[3] & x[2] & ~x[1] & ~x[0]
                    | x[3] & ~x[2] & x[1] & x[0]
                    | x[3] & x[2] & ~x[1] & x[0];
    // NOTE b
    assign aToG[5] = ~x[3] & x[2] & ~x[1] & x[0]
                    | x[2] & x[1] & ~x[0]
                    | x[3] & x[1] & x[0]
                    | x[3] & x[2] & ~x[0];
    // NOTE c
    assign aToG[4] = ~x[3] & ~x[2] & x[1] & ~x[0]
                    | x[3] & x[2] & ~x[0]
                    | x[3] & x[2] & x[1];
    // NOTE d
    assign aToG[3] = ~x[3] & ~x[2] & ~x[1] & x[0]
                    | ~x[3] & x[2] & ~x[1] & ~x[0]
                    | x[2] & x[1] & x[0]
                    | x[3] & ~x[2] & x[1] & ~x[0];
    // NOTE e
    assign aToG[2] = ~x[3] & x[0] 
                    | ~x[3] & x[2] & ~x[1]
                    | ~x[2] & ~x[1] & x[0];
    // NOTE f
    assign aToG[1] = ~x[3] & ~x[2] & x[0]
                    | ~x[3] & ~x[2] & x[1]
                    | ~x[3] & x[1] & x[0]
                    | x[3] & x[2] & ~x[1] & x[0];
    // NOTE g
    assign aToG[0] = ~x[3] & ~x[2] & ~x[1] 
                    | ~x[3] & x[2] & x[1] & x[0]
                    | x[3] & x[2] & ~x[1] & ~x[0];
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/10 22:30:34
// Design Name: 
// Module Name: mux7seg
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

//NOTE 复用7段显示管
module mux7seg(
    input wire [15:0] x,
    input wire [3:0] btn,
    output reg [6:0] aToG,
    output wire [3:0] an,
    output wire dp
    );

    wire [1:0] s;
    reg [3:0] digit;

    assign an = ~btn;
    assign s[1] = btn[2] | btn[3];
    assign s[0] = btn[1] | btn[3];
    assign dp = 1;

    //NOTE 4位 4选1MUX
    always @(*)
    case (s)
        0: digit = x[3:0]; 
        1: digit = x[7:4];
        2: digit = x[11:8];
        3: digit = x[15:12];
    endcase

    //NOTE 7段译码管hex7seg
    always @(*)
    case (digit)
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
        'hD: aToG = 7'b1000010;
        'hE: aToG = 7'b0110000;
        'hF: aToG = 7'b0111000; 
    endcase
endmodule

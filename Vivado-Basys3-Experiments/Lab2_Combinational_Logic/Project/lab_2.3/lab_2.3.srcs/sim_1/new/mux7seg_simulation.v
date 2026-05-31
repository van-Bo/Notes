`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/10 22:49:57
// Design Name: 
// Module Name: mux7seg_simulation
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


module mux7seg_simulation();
    reg [15:0] x;
    reg [3:0] bottons;
    wire [6:0] segments;
    wire [3:0] an;
    wire dp;

    mux7seg test_simulation(.x(x), .btn(bottons), .aToG(segments), .an(an), .dp(dp));

    initial begin
        #0  bottons = 4'b0001;
            x = 'h1234;
        #100 bottons = 4'b0010;
            x = 'h1234;
        #100 bottons = 4'b0100;
            x = 'h1234;
        #100 bottons = 4'b1000;
            x = 'h1234;
    end
endmodule

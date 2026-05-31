
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/09 23:15:08
// Design Name: 
// Module Name: hex7seg_le_simulation
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
module hex7seg_le_simulation();
    reg [3:0] switch;
    wire [6:0] aToG_seg;

    hex7seg_le test_simulation(.x(switch[3:0]), .aToG(aToG_seg[6:0]));

    initial begin
        #0  switch = 4'b0000;
        #50 switch = 4'b0001;
        #50 switch = 4'b0010;
        #50 switch = 4'b0011;
        #50 switch = 4'b0100;
        #50 switch = 4'b0101;
        #50 switch = 4'b0110;
        #50 switch = 4'b0111;
        #50 switch = 4'b1000;
        #50 switch = 4'b1001;
        #50 switch = 4'b1010;
        #50 switch = 4'b1011;
        #50 switch = 4'b1100;
        #50 switch = 4'b1101;
        #50 switch = 4'b1110;
        #50 switch = 4'b1111;
    end
endmodule

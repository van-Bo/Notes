`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/30 01:41:17
// Design Name: 
// Module Name: MUX4_1_simulation
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


module MUX4_1_simulation();
    reg[3:0] s;
    reg[1:0] sel;
    wire led;

    MUX4_1 test(.s(sel), .d(s), .y(led));

    initial begin
        #0  s=4'b0000;
            sel=2'b00;
        #10 s=4'b0001;
            sel=2'b00;
        #10 s=4'b0010;
            sel=2'b00;
        #10 s=4'b0011;
            sel=2'b00;
        #10 s=4'b0100;
            sel=2'b00;
        #10 s=4'b0101;
            sel=2'b00;
        #10 s=4'b0110;
            sel=2'b00;
        #10 s=4'b0111;
            sel=2'b00;
        #10 s=4'b1000;
            sel=2'b00;
        #10 s=4'b1001;
            sel=2'b00;
        #10 s=4'b1010;
            sel=2'b00;
        #10 s=4'b1011;
            sel=2'b00;
        #10 s=4'b1100;
            sel=2'b00;
        #10 s=4'b1101;
            sel=2'b00;
        #10 s=4'b1110;
            sel=2'b00;
        #10 s=4'b1111;
            sel=2'b00;

        #10 s=4'b0000;
            sel=2'b01;
        #10 s=4'b0001;
            sel=2'b01;
        #10 s=4'b0010;
            sel=2'b01;
        #10 s=4'b0011;
            sel=2'b01;
        #10 s=4'b0100;
            sel=2'b01;
        #10 s=4'b0101;
            sel=2'b01;
        #10 s=4'b0110;
            sel=2'b01;
        #10 s=4'b0111;
            sel=2'b01;
        #10 s=4'b1000;
            sel=2'b01;
        #10 s=4'b1001;
            sel=2'b01;
        #10 s=4'b1010;
            sel=2'b01;
        #10 s=4'b1011;
            sel=2'b01;
        #10 s=4'b1100;
            sel=2'b01;
        #10 s=4'b1101;
            sel=2'b01;
        #10 s=4'b1110;
            sel=2'b01;
        #10 s=4'b1111;
            sel=2'b01;

        #10 s=4'b0000;
            sel=2'b10;
        #10 s=4'b0001;
            sel=2'b10;
        #10 s=4'b0010;
            sel=2'b10;
        #10 s=4'b0011;
            sel=2'b10;
        #10 s=4'b0100;
            sel=2'b10;
        #10 s=4'b0101;
            sel=2'b10;
        #10 s=4'b0110;
            sel=2'b10;
        #10 s=4'b0111;
            sel=2'b10;
        #10 s=4'b1000;
            sel=2'b10;
        #10 s=4'b1001;
            sel=2'b10;
        #10 s=4'b1010;
            sel=2'b10;
        #10 s=4'b1011;
            sel=2'b10;
        #10 s=4'b1100;
            sel=2'b10;
        #10 s=4'b1101;
            sel=2'b10;
        #10 s=4'b1110;
            sel=2'b10;
        #10 s=4'b1111;
            sel=2'b10;

        #10 s=4'b0000;
            sel=2'b11;
        #10 s=4'b0001;
            sel=2'b11;
        #10 s=4'b0010;
            sel=2'b11;
        #10 s=4'b0011;
            sel=2'b11;
        #10 s=4'b0100;
            sel=2'b11;
        #10 s=4'b0101;
            sel=2'b11;
        #10 s=4'b0110;
            sel=2'b11;
        #10 s=4'b0111;
            sel=2'b11;
        #10 s=4'b1000;
            sel=2'b11;
        #10 s=4'b1001;
            sel=2'b11;
        #10 s=4'b1010;
            sel=2'b11;
        #10 s=4'b1011;
            sel=2'b11;
        #10 s=4'b1100;
            sel=2'b11;
        #10 s=4'b1101;
            sel=2'b11;
        #10 s=4'b1110;
            sel=2'b11;
        #10 s=4'b1111;
            sel=2'b11;
        #10 $finish;
    end
endmodule

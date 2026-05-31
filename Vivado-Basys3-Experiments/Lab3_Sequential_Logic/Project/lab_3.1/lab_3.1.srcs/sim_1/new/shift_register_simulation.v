`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/09 19:53:25
// Design Name: 
// Module Name: shift_register_simulation
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


module shift_register_simulation();

    reg clk;
    reg clrn;
    reg [1:0] select;
    reg [1:0] input_rl;
    reg [7:0] D;
    wire [7:0] led;

    always #5 clk = ~clk;

    shift_register sh_r_simulate(.clrn(clrn), .s1(select[1]), .s0(select[0]), .Dsr(input_rl[1]), .Dsl(input_rl[0]),
                                 .D(D), .clk(clk), .Q(led[7:0]));

    initial 
    begin
        #0  clk = 0;
            clrn = 1;
            input_rl = 2'b00;
            select = 2'b00;
        #10
            select = 2'b11;
            D = 8'b11100011;
        #10 select = 2'b11;
        #10 select = 2'b01;
            input_rl[1] = 0;
        #10 clrn = 0;
        #10 $finish;

    end

endmodule

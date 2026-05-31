`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/13 19:37:23
// Design Name: 
// Module Name: tl_controller
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


module tl_controller(clk, reset, Ta, Tb, La, Lb, LedA, LedB);
    input clk, reset;
    input Ta, Tb;
    output [1:0] La, Lb;
    output reg [2:0] LedA, LedB;

    reg [1:0] Y, y;
    parameter [1:0] S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
    parameter [1:0] green = 2'b00, yellow = 2'b01, red = 2'b10;

    always @(y, Ta, Tb)
    begin
        case(y)
            S0: if (Ta) Y <= S0;
                else Y <= S1;
            S1: Y <= S2;
            S2: if (Tb) Y <= S2;
                else Y <= S3;
            S3: Y <= S0;
        endcase
    end

    always @(posedge clk, posedge reset)
    begin
        if (reset)
        begin
            y[0] <= green;
            y[1] <= red;
        end
        else
        begin
            y[0] <= Y[0];
            y[1] <= Y[1];
        end
    end

    assign La[1] = y[1];
    assign La[0] = ~y[1] & y[0];
    assign Lb[1] = ~y[1];
    assign Lb[0] = y[1] & y[0];

    always @(La, Lb)
    begin
        if (La == green)
            LedA = 3'b100;
        else if (La == yellow)
            LedA = 3'b010;
        else if (La == red)
            LedA = 3'b001;
        
        if (Lb == green)
            LedB = 3'b100;
        else if (Lb == yellow)
            LedB = 3'b010;
        else if (Lb == red)
            LedB = 3'b001;
    end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/10 20:57:21
// Design Name: 
// Module Name: dec_counter
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


module dec_counter(clk, reset, enable, dec0, dec1, dec2, dec3);
    input clk, reset, enable;
    output reg [3:0] dec0, dec1, dec2, dec3;

    always @(posedge clk)
    begin
        if (reset)
        begin
            dec0 <= 4'b0000;
            dec1 <= 4'b0000;
            dec2 <= 4'b0000;
            dec3 <= 4'b0000;
        end
        else
        begin
            if (enable)
            begin
                if (dec0 <= 4'b1000)    //判断0号位
                    dec0 <= dec0 + 1;
                else
                begin
                    dec0 <= 0;
                    if (dec1 <= 4'b1000)    //判断1号位
                        dec1 <= dec1 + 1;
                    else
                    begin
                        dec1 <= 0;
                        if (dec2 <= 4'b1000)    //判断2号位
                            dec2 <= dec2 + 1;
                        else
                        begin
                            dec2 <= 0;
                            if (dec3 <= 4'b1000)    //判断3号位
                                dec3 <= dec3 + 1;
                            else
                            begin
                                dec3 <= 0;
                            end
                        end 
                    end
                end
            end
        end
    end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/29 13:11:08
// Design Name: 
// Module Name: demo01_simulation
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


module demo01_simulation();
    reg SW0, SW1;
    wire LED0, LED1, LED2, LED3, LED4, LED5, LED6;

    NOT TEST1(.SW0(SW0), .LED0(LED0));
    AND TEST2(.SW0(SW0), .SW1(SW1), .LED1(LED1));
    OR TEST3(.SW0(SW0), .SW1(SW1), .LED2(LED2));
    NAND TEST4(.SW0(SW0), .SW1(SW1), .LED3(LED3));
    NOR TEST5(.SW0(SW0), .SW1(SW1), .LED4(LED4));
    XOR TEST6(.SW0(SW0), .SW1(SW1), .LED5(LED5));
    NXOR TEST7(.SW0(SW0), .SW1(SW1), .LED6(LED6));

    initial begin
        #0  SW0 = 0;
            SW1 = 0;
        # 100 SW0 = 1;
             SW1 = 0;
        # 100 SW0 = 0;
             SW1 = 1;
        # 100 SW0 = 1;
             SW1 = 1;
        #100 $finish;
    end
endmodule

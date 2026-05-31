`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/27 23:15:00
// Design Name: 
// Module Name: VGA_controller
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


`define VGA_640x480x60

module VGA_controller(clk, reset, en_shift, vga_hs, vga_vs, vga_rgb);
    input clk, reset;
    input en_shift;
    output reg vga_hs;
    output reg vga_vs;

    wire en_hs;
    wire en_vs;
    wire en;

    wire [9:0] pos_x;
    wire [9:0] pos_y;

    output reg [11:0] vga_rgb;

    `ifdef VGA_640x480x60
    localparam HS_A = 96;   // 行脉冲区域
    localparam HS_B = 48;   // 行显示后沿
    localparam HS_C = 640;  // 行有效显示区域
    localparam HS_D = 16;   // 行显示前沿>
    localparam HS_E = 800;  // 行扫描周期

    localparam VS_A = 2;    // 场脉冲区域
    localparam VS_B = 33;   // 场显示后沿
    localparam VS_C = 480;  // 场有效显示区域
    localparam VS_D = 10;   // 场显示后沿
    localparam VS_E = 525;  // 场扫描周期
    `endif

    //NOTE 行计数器，对像素时钟计数（记录所在行已经扫描到的列数，计数器满代表一行结束）
    reg [9:0] cnt_hs;
    always @(posedge clk, posedge reset)
    begin
        if (reset)
            cnt_hs <= 0;
        else
        begin
            if (cnt_hs < HS_E - 1)
                cnt_hs <= cnt_hs + 1; 
            else
                cnt_hs <= 0;
        end
    end

    //NOTE 场计数器，对行计数（计数器满代表一帧结束）
    reg [9:0] cnt_vs;
    always @(posedge clk, posedge reset)
    begin
        if (reset)
            cnt_vs <= 0;
        else
        begin  
            if (cnt_hs == HS_E - 1)
            begin
                if (cnt_vs < VS_E - 1)
                    cnt_vs <= cnt_vs + 1;
                else
                    cnt_vs <= 0;
            end
            else
                cnt_vs <= cnt_vs;
        end
    end

    //NOTE 行同步信号（同步之前 vga_hs 信号为低，同步之后 vga_hs 信号为高）
    always @(posedge clk, posedge reset) 
    begin
        if (reset)
            vga_hs <= 1'b1;
        else
            if (cnt_hs < HS_A - 1)
                vga_hs <= 1'b0;
            else
                vga_hs <= 1'b1;
    end

    //NOTE 场同步信号（同步之前 vga_vs 信号为低，同步之后 vga_vs 信号为高）
    always @(posedge clk, posedge reset) 
    begin
        if (reset)
            vga_vs <= 1'b1;
        else
            if (cnt_vs < VS_A - 1)
                vga_vs <= 1'b0;
            else
                vga_vs <= 1'b1;
        
    end

    //NOTE 产生使能信号
    assign en_hs = (cnt_hs > HS_A + HS_B - 1) && (cnt_hs < HS_E - HS_D);
    assign en_vs = (cnt_vs > VS_A + VS_B - 1) && (cnt_vs < VS_E - VS_D);
    assign en = en_hs && en_vs;

    //NOTE 产生像素点坐标
    assign pos_x = en ? (cnt_hs - (HS_A + HS_B - 1'b1)) : 0;
    assign pos_y = en ? (cnt_vs - (VS_A + VS_B - 1'b1)) : 0;

    //NOTE 偏移运动时钟
    reg [24:0] shift_cnt;
    reg shift_clk;
    always @(posedge clk, posedge reset)
    begin
        if (reset)
        begin
            shift_clk <= 0;
            shift_cnt <= 0;
        end
        else
        begin
            if (shift_cnt == 25'd24_999_999)
            begin
                shift_clk <= ~shift_clk;
                shift_cnt <= 0;
            end
            else
                shift_cnt <= shift_cnt + 1;
        end
    end

    //NOTE 偏移运动标志位的变化
    reg [9:0] pos0;
    reg [9:0] pos1;
    reg [9:0] pos2;
    always @(posedge shift_clk, posedge reset)
    begin
        if (reset)
        begin
            pos0 <= 6;
            pos1 <= 16;
            pos2 <= 26;
        end
        else if (en_shift)
        begin
            pos0 <= (pos0 + 1) % 40;
            pos1 <= (pos1 + 1) % 40;
            pos2 <= (pos2 + 1) % 40;
        end 
        else
        begin
            pos0 <= 6;
            pos1 <= 16;
            pos2 <= 26; 
        end
    end


    always @(posedge clk, posedge reset)
    begin
        if (reset)
            vga_rgb <= 12'h000;
        else
        begin
            if (pos0 < (pos0 + 7) % 40 && pos1 < (pos1 + 7) % 40 && pos2 < (pos2 + 7) % 40 )    //NOTE pos0、pos1、pos2 处的数字均未被截断
            begin
                //NOTE 显示 pos0 处的数字 0
                if(pos_x[9:4] >= pos0 && pos_x[9:4] < pos0 + 8 && pos_y[9:4] >= 8 && pos_y[9:4] < 10)   //第 0 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos0 + 6 && pos_x[9:4] < pos0 + 8 && pos_y[9:4] >= 8 && pos_y[9:4] < 16)  //第 1 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos0 + 6 && pos_x[9:4] < pos0 + 8 && pos_y[9:4] >= 14 && pos_y[9:4] < 22) //第 2 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos0 && pos_x[9:4] < pos0 + 8 && pos_y[9:4] >= 20 && pos_y[9:4] < 22) //第 3 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos0 && pos_x[9:4] < pos0 + 2 && pos_y[9:4] >= 14 && pos_y[9:4] < 22) //第 4 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos0 && pos_x[9:4] < pos0 + 2 && pos_y[9:4] >= 8 && pos_y[9:4] < 16)  //第 5 段
                    vga_rgb = 12'h00f; 
                
                //NOTE 显示 pos1 处的数字 0
                else if(pos_x[9:4] >= pos1 && pos_x[9:4] < pos1 + 8 && pos_y[9:4] >= 8 && pos_y[9:4] < 10)  //第 0 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos1 + 6 && pos_x[9:4] < pos1 + 8 && pos_y[9:4] >= 8 && pos_y[9:4] < 16)  //第 1 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos1 + 6 && pos_x[9:4] < pos1 + 8 && pos_y[9:4] >= 14 && pos_y[9:4] < 22) //第 2 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos1 && pos_x[9:4] < pos1 + 8 && pos_y[9:4] >= 20 && pos_y[9:4] < 22) //第 3 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos1 && pos_x[9:4] < pos1 + 2 && pos_y[9:4] >= 14 && pos_y[9:4] < 22) //第 4 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos1 && pos_x[9:4] < pos1 + 2 && pos_y[9:4] >= 8 && pos_y[9:4] < 16)  //第 5 段
                    vga_rgb = 12'h00f;

                //NOTE 显示 pos2 处的数字 9
                else if (pos_x[9:4] >= pos2 && pos_x[9:4] < pos2 + 8 && pos_y[9:4] >= 8 && pos_y[9:4] < 10) //第 0 段
                    vga_rgb = 12'h00f;
                else if (pos_x[9:4] >= pos2 + 6 && pos_x[9:4] < pos2 + 8 && pos_y[9:4] >= 8 && pos_y[9:4] < 16) //第 1 段
                    vga_rgb = 12'h00f;
                else if (pos_x[9:4] >= pos2 + 6 && pos_x[9:4] < pos2 + 8 && pos_y[9:4] >= 14 && pos_y[9:4] < 22)    //第 2 段
                    vga_rgb = 12'h00f;
                else if (pos_x[9:4] >= pos2 && pos_x[9:4] < pos2 + 8 && pos_y[9:4] >= 20 && pos_y[9:4] < 22)    //第 3 段
                    vga_rgb = 12'h00f;
                else if (pos_x[9:4] >= pos2 && pos_x[9:4] < pos2 + 2 && pos_y[9:4] >= 8 && pos_y[9:4] < 16) //第 5 段
                    vga_rgb = 12'h00f;
                else if (pos_x[9:4] >= pos2 && pos_x[9:4] < pos2 + 8 && pos_y[9:4] >= 14 && pos_y[9:4] < 16)    //第 6 段
                    vga_rgb = 12'h00f;
                else 
                    vga_rgb = 12'h000;                      
            end
            else if (pos0 > (pos0 + 7) % 40 && pos1 < (pos1 + 7) % 40 && pos2 < (pos2 + 7) % 40)    //NOTE pos0处的数字被截断
            begin
                //NOTE 显示 pos0 处被截断的数字 0
                if(((pos_x[9:4] >= pos0 && pos_x[9:4] < 40) || (pos_x[9:4] >= 0 && pos_x[9:4] <= (pos0 + 7) % 40))    //第 0 段
                    && pos_y[9:4] >= 8 && pos_y[9:4] < 10)
                    vga_rgb <= 12'h00f;
                else if ((pos0 + 7) % 40 == 0 && (pos_x[9:4] == 39 || pos_x[9:4] == 0) && pos_y[9:4] >= 8 && pos_y[9:4] < 16)    //第 1 段（断离）
                    vga_rgb = 12'h00f;
                else if ((pos0 + 7) % 40 > 0 && pos_x[9:4] >= (pos0 + 6) % 40 && pos_x[9:4] <= (pos0 + 7) % 40  //第 1 段（未断离）
                    && pos_y[9:4] >= 8 && pos_y[9:4] < 16)
                    vga_rgb = 12'h00f;
                else if((pos0 + 7) % 40 == 0 && (pos_x[9:4] == 39 || pos_x[9:4] == 0) && pos_y[9:4] >= 14 && pos_y[9:4] < 22)    //第 2 段（断离）
                    vga_rgb = 12'h00f;
                else if ((pos0 + 7) % 40 > 0 && pos_x[9:4] >= (pos0 + 6) % 40 && pos_x[9:4] <= (pos0 + 7) % 40  //第 2 段（未断离）
                    && pos_y[9:4] >= 14 && pos_y[9:4] < 22)
                    vga_rgb = 12'h00f;
                else if(((pos_x[9:4] >= pos0 && pos_x[9:4] < 40) || (pos_x[9:4] >= 0 && pos_x[9:4] <= (pos0 + 7) % 40)) //第 3 段
                    && pos_y[9:4] >= 20 && pos_y[9:4] < 22)
                    vga_rgb <= 12'h00f;
                else if((pos0 + 1) % 40 == 0 && (pos_x[9:4] == 39 || pos_x[9:4] == 0) && pos_y[9:4] >= 14 && pos_y[9:4] < 22)     //第 4 段（断离）
                    vga_rgb = 12'h00f;
                else if ((pos0 + 1) % 40 < 40 && pos_x[9:4] >= pos0 && pos_x[9:4] <= (pos0 + 1) % 40    //第 4 段（未断离）
                    && pos_y[9:4] >= 14 && pos_y[9:4] < 22)
                    vga_rgb = 12'h00f;    
                else if((pos0 + 1) % 40 == 0 && (pos_x[9:4] == 39 || pos_x[9:4] == 0) && pos_y[9:4] >= 8 && pos_y[9:4] < 16)     //第 5 段（断离）
                    vga_rgb = 12'h00f;
                else if ((pos0 + 1) % 40 < 40 && pos_x[9:4] >= pos0 && pos_x[9:4] <= (pos0 + 1) % 40    //第 5 段（未断离）
                    && pos_y[9:4] >= 8 && pos_y[9:4] < 16)
                    vga_rgb = 12'h00f;

                //NOTE 显示 pos1 处的数字 0
                else if(pos_x[9:4] >= pos1 && pos_x[9:4] < pos1 + 8 && pos_y[9:4] >= 8 && pos_y[9:4] < 10)  //第 0 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos1 + 6 && pos_x[9:4] < pos1 + 8 && pos_y[9:4] >= 8 && pos_y[9:4] < 16)  //第 1 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos1 + 6 && pos_x[9:4] < pos1 + 8 && pos_y[9:4] >= 14 && pos_y[9:4] < 22) //第 2 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos1 && pos_x[9:4] < pos1 + 8 && pos_y[9:4] >= 20 && pos_y[9:4] < 22) //第 3 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos1 && pos_x[9:4] < pos1 + 2 && pos_y[9:4] >= 14 && pos_y[9:4] < 22) //第 4 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos1 && pos_x[9:4] < pos1 + 2 && pos_y[9:4] >= 8 && pos_y[9:4] < 16)  //第 5 段
                    vga_rgb = 12'h00f;

                //NOTE 显示 pos2 处的数字 9
                else if (pos_x[9:4] >= pos2 && pos_x[9:4] < pos2 + 8 && pos_y[9:4] >= 8 && pos_y[9:4] < 10) //第 0 段
                    vga_rgb = 12'h00f;
                else if (pos_x[9:4] >= pos2 + 6 && pos_x[9:4] < pos2 + 8 && pos_y[9:4] >= 8 && pos_y[9:4] < 16) //第 1 段
                    vga_rgb = 12'h00f;
                else if (pos_x[9:4] >= pos2 + 6 && pos_x[9:4] < pos2 + 8 && pos_y[9:4] >= 14 && pos_y[9:4] < 22)    //第 2 段
                    vga_rgb = 12'h00f;
                else if (pos_x[9:4] >= pos2 && pos_x[9:4] < pos2 + 8 && pos_y[9:4] >= 20 && pos_y[9:4] < 22)    //第 3 段
                    vga_rgb = 12'h00f;
                else if (pos_x[9:4] >= pos2 && pos_x[9:4] < pos2 + 2 && pos_y[9:4] >= 8 && pos_y[9:4] < 16) //第 5 段
                    vga_rgb = 12'h00f;
                else if (pos_x[9:4] >= pos2 && pos_x[9:4] < pos2 + 8 && pos_y[9:4] >= 14 && pos_y[9:4] < 16)    //第 6 段
                    vga_rgb = 12'h00f;
                else 
                    vga_rgb = 12'h000;
            end
            else if (pos0 < (pos0 + 7) % 40 && pos1 > (pos1 + 7) % 40 && pos2 < (pos2 + 7) % 40)    //NOTE pos1处的数字被截断
            begin
                //NOTE 显示 pos0 处的数字 0
                if(pos_x[9:4] >= pos0 && pos_x[9:4] < pos0 + 8 && pos_y[9:4] >= 8 && pos_y[9:4] < 10)   //第 0 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos0 + 6 && pos_x[9:4] < pos0 + 8 && pos_y[9:4] >= 8 && pos_y[9:4] < 16)  //第 1 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos0 + 6 && pos_x[9:4] < pos0 + 8 && pos_y[9:4] >= 14 && pos_y[9:4] < 22) //第 2 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos0 && pos_x[9:4] < pos0 + 8 && pos_y[9:4] >= 20 && pos_y[9:4] < 22) //第 3 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos0 && pos_x[9:4] < pos0 + 2 && pos_y[9:4] >= 14 && pos_y[9:4] < 22) //第 4 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos0 && pos_x[9:4] < pos0 + 2 && pos_y[9:4] >= 8 && pos_y[9:4] < 16)  //第 5 段
                    vga_rgb = 12'h00f; 
                
                //NOTE 显示 pos1 处的数字 0
                else if(((pos_x[9:4] >= pos1 && pos_x[9:4] < 40) || (pos_x[9:4] >= 0 && pos_x[9:4] <= (pos1 + 7) % 40))    //第 0 段
                    && pos_y[9:4] >= 8 && pos_y[9:4] < 10)
                    vga_rgb <= 12'h00f;
                else if ((pos1 + 7) % 40 == 0 && (pos_x[9:4] == 39 || pos_x[9:4] == 0) && pos_y[9:4] >= 8 && pos_y[9:4] < 16)    //第 1 段（断离）
                    vga_rgb = 12'h00f;
                else if ((pos1 + 7) % 40 > 0 && pos_x[9:4] >= (pos1 + 6) % 40 && pos_x[9:4] <= (pos1 + 7) % 40  //第 1 段（未断离）
                    && pos_y[9:4] >= 8 && pos_y[9:4] < 16)
                    vga_rgb = 12'h00f;
                else if((pos1 + 7) % 40 == 0 && (pos_x[9:4] == 39 || pos_x[9:4] == 0) && pos_y[9:4] >= 14 && pos_y[9:4] < 22)    //第 2 段（断离）
                    vga_rgb = 12'h00f;
                else if ((pos1 + 7) % 40 > 0 && pos_x[9:4] >= (pos1 + 6) % 40 && pos_x[9:4] <= (pos1 + 7) % 40  //第 2 段（未断离）
                    && pos_y[9:4] >= 14 && pos_y[9:4] < 22)
                    vga_rgb = 12'h00f;
                else if(((pos_x[9:4] >= pos1 && pos_x[9:4] < 40) || (pos_x[9:4] >= 0 && pos_x[9:4] <= (pos1 + 7) % 40)) //第 3 段
                    && pos_y[9:4] >= 20 && pos_y[9:4] < 22)
                    vga_rgb <= 12'h00f;
                else if((pos1 + 1) % 40 == 0 && (pos_x[9:4] == 39 || pos_x[9:4] == 0) && pos_y[9:4] >= 14 && pos_y[9:4] < 22)     //第 4 段（断离）
                    vga_rgb = 12'h00f;
                else if ((pos1 + 1) % 40 < 40 && pos_x[9:4] >= pos1 && pos_x[9:4] <= (pos1 + 1) % 40    //第 4 段（未断离）
                    && pos_y[9:4] >= 14 && pos_y[9:4] < 22)
                    vga_rgb = 12'h00f;    
                else if((pos1 + 1) % 40 == 0 && (pos_x[9:4] == 39 || pos_x[9:4] == 0) && pos_y[9:4] >= 8 && pos_y[9:4] < 16)     //第 5 段（断离）
                    vga_rgb = 12'h00f;
                else if ((pos1 + 1) % 40 < 40 && pos_x[9:4] >= pos1 && pos_x[9:4] <= (pos1 + 1) % 40    //第 5 段（未断离）
                    && pos_y[9:4] >= 8 && pos_y[9:4] < 16)
                    vga_rgb = 12'h00f;
                
                //NOTE 显示 pos2 处的数字 9
                else if (pos_x[9:4] >= pos2 && pos_x[9:4] < pos2 + 8 && pos_y[9:4] >= 8 && pos_y[9:4] < 10) //第 0 段
                    vga_rgb = 12'h00f;
                else if (pos_x[9:4] >= pos2 + 6 && pos_x[9:4] < pos2 + 8 && pos_y[9:4] >= 8 && pos_y[9:4] < 16) //第 1 段
                    vga_rgb = 12'h00f;
                else if (pos_x[9:4] >= pos2 + 6 && pos_x[9:4] < pos2 + 8 && pos_y[9:4] >= 14 && pos_y[9:4] < 22)    //第 2 段
                    vga_rgb = 12'h00f;
                else if (pos_x[9:4] >= pos2 && pos_x[9:4] < pos2 + 8 && pos_y[9:4] >= 20 && pos_y[9:4] < 22)    //第 3 段
                    vga_rgb = 12'h00f;
                else if (pos_x[9:4] >= pos2 && pos_x[9:4] < pos2 + 2 && pos_y[9:4] >= 8 && pos_y[9:4] < 16) //第 5 段
                    vga_rgb = 12'h00f;
                else if (pos_x[9:4] >= pos2 && pos_x[9:4] < pos2 + 8 && pos_y[9:4] >= 14 && pos_y[9:4] < 16)    //第 6 段
                    vga_rgb = 12'h00f;
                else 
                    vga_rgb = 12'h000;  

            end
            else    //NOTE pos2处的数字被截断
            begin
                //NOTE 显示 pos0 处的数字 0
                if(pos_x[9:4] >= pos0 && pos_x[9:4] < pos0 + 8 && pos_y[9:4] >= 8 && pos_y[9:4] < 10)   //第 0 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos0 + 6 && pos_x[9:4] < pos0 + 8 && pos_y[9:4] >= 8 && pos_y[9:4] < 16)  //第 1 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos0 + 6 && pos_x[9:4] < pos0 + 8 && pos_y[9:4] >= 14 && pos_y[9:4] < 22) //第 2 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos0 && pos_x[9:4] < pos0 + 8 && pos_y[9:4] >= 20 && pos_y[9:4] < 22) //第 3 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos0 && pos_x[9:4] < pos0 + 2 && pos_y[9:4] >= 14 && pos_y[9:4] < 22) //第 4 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos0 && pos_x[9:4] < pos0 + 2 && pos_y[9:4] >= 8 && pos_y[9:4] < 16)  //第 5 段
                    vga_rgb = 12'h00f; 
                
                //NOTE 显示 pos1 处的数字 0
                else if(pos_x[9:4] >= pos1 && pos_x[9:4] < pos1 + 8 && pos_y[9:4] >= 8 && pos_y[9:4] < 10)  //第 0 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos1 + 6 && pos_x[9:4] < pos1 + 8 && pos_y[9:4] >= 8 && pos_y[9:4] < 16)  //第 1 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos1 + 6 && pos_x[9:4] < pos1 + 8 && pos_y[9:4] >= 14 && pos_y[9:4] < 22) //第 2 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos1 && pos_x[9:4] < pos1 + 8 && pos_y[9:4] >= 20 && pos_y[9:4] < 22) //第 3 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos1 && pos_x[9:4] < pos1 + 2 && pos_y[9:4] >= 14 && pos_y[9:4] < 22) //第 4 段
                    vga_rgb = 12'h00f;
                else if(pos_x[9:4] >= pos1 && pos_x[9:4] < pos1 + 2 && pos_y[9:4] >= 8 && pos_y[9:4] < 16)  //第 5 段
                    vga_rgb = 12'h00f;

                //NOTE 显示 pos2 处的数字 9
                else if(((pos_x[9:4] >= pos2 && pos_x[9:4] < 40) || (pos_x[9:4] >= 0 && pos_x[9:4] <= (pos2 + 7) % 40))    //第 0 段
                    && pos_y[9:4] >= 8 && pos_y[9:4] < 10)
                    vga_rgb <= 12'h00f;
                else if ((pos2 + 7) % 40 == 0 && (pos_x[9:4] == 39 || pos_x[9:4] == 0) && pos_y[9:4] >= 8 && pos_y[9:4] < 16)    //第 1 段（断离）
                    vga_rgb = 12'h00f;
                else if ((pos2 + 7) % 40 > 0 && pos_x[9:4] >= (pos2 + 6) % 40 && pos_x[9:4] <= (pos2 + 7) % 40  //第 1 段（未断离）
                    && pos_y[9:4] >= 8 && pos_y[9:4] < 16)
                    vga_rgb = 12'h00f;
                else if((pos2 + 7) % 40 == 0 && (pos_x[9:4] == 39 || pos_x[9:4] == 0) && pos_y[9:4] >= 14 && pos_y[9:4] < 22)    //第 2 段（断离）
                    vga_rgb = 12'h00f;
                else if ((pos2 + 7) % 40 > 0 && pos_x[9:4] >= (pos2 + 6) % 40 && pos_x[9:4] <= (pos2 + 7) % 40  //第 2 段（未断离）
                    && pos_y[9:4] >= 14 && pos_y[9:4] < 22)
                    vga_rgb = 12'h00f;
                else if(((pos_x[9:4] >= pos2 && pos_x[9:4] < 40) || (pos_x[9:4] >= 0 && pos_x[9:4] <= (pos2 + 7) % 40)) //第 3 段
                    && pos_y[9:4] >= 20 && pos_y[9:4] < 22)
                    vga_rgb <= 12'h00f;   
                else if((pos2 + 1) % 40 == 0 && (pos_x[9:4] == 39 || pos_x[9:4] == 0) && pos_y[9:4] >= 8 && pos_y[9:4] < 16)     //第 5 段（断离）
                    vga_rgb = 12'h00f;
                else if ((pos2 + 1) % 40 < 40 && pos_x[9:4] >= pos2 && pos_x[9:4] <= (pos2 + 1) % 40    //第 5 段（未断离）
                    && pos_y[9:4] >= 8 && pos_y[9:4] < 16)
                    vga_rgb = 12'h00f;
                else if (((pos_x[9:4] >= pos2 && pos_x[9:4] < 40) || (pos_x[9:4] >= 0 && pos_x[9:4] <= (pos2 + 7) % 40))    //第 6 段
                    && pos_y[9:4] >= 14 && pos_y[9:4] < 16)
                    vga_rgb = 12'h00f;
                else 
                    vga_rgb = 12'h000;
            end
        end
    end

endmodule

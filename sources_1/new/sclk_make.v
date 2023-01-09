`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/03 18:30:04
// Design Name: 
// Module Name: sclk_make
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


module sclk_make
#(
    parameter freq_cnt=1,
              cnt_width=1,
              cpol=1
)
(
    input clk,
    input rst,
    input clk_cnt_en,
    output reg sclk
);

reg [cnt_width-1:0] clk_cnt;//sclk 발생 시키기 위한 cnt
    
//clk값을 clk_cnt로 freq_cnt까지 세기를 반복한다.
always @(posedge clk or negedge rst)
begin
    if(!rst)
        clk_cnt<='d0;
    else if(clk_cnt_en)//clk_cnt_en=1이면 sclk 발생 위해 카운트 시작함
    begin
        if(clk_cnt == freq_cnt)
            clk_cnt<='d0;
        else
            clk_cnt<=clk_cnt+1'b1;
    end
    else//rst상태도 아니고 clk_cnt_en 상태도 아니면 clk_cnt=0세지 않고 있기
        clk_cnt<='d0;//즉 클럭 안뜀
end

always @(posedge clk or negedge rst)
begin
    if(!rst)
        sclk<=cpol;
    else if(clk_cnt_en)
    begin
        if(clk_cnt==freq_cnt)
            sclk<=~sclk;
        else
            sclk<=sclk;
    end
    else
        sclk<=cpol;
end

endmodule

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

reg [cnt_width-1:0] clk_cnt;//sclk �߻� ��Ű�� ���� cnt
    
//clk���� clk_cnt�� freq_cnt���� ���⸦ �ݺ��Ѵ�.
always @(posedge clk or negedge rst)
begin
    if(!rst)
        clk_cnt<='d0;
    else if(clk_cnt_en)//clk_cnt_en=1�̸� sclk �߻� ���� ī��Ʈ ������
    begin
        if(clk_cnt == freq_cnt)
            clk_cnt<='d0;
        else
            clk_cnt<=clk_cnt+1'b1;
    end
    else//rst���µ� �ƴϰ� clk_cnt_en ���µ� �ƴϸ� clk_cnt=0���� �ʰ� �ֱ�
        clk_cnt<='d0;//�� Ŭ�� �ȶ�
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

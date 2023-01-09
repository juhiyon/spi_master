`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/03 18:23:31
// Design Name: 
// Module Name: top
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


module top
#(
    parameter clk_freq = 125000000,
              spi_freq = 9600,//���� ������ 5M�̴�
              data_width = 8,
              word_number=1,//���� ���� �ܾ� ����
              cpol = 0,//Ŭ���� ���ʿ� � �������� ����, �� sclk�� 0���� ������ ���̰�
              cpha = 0//������ �д� ���� ����,�� �츮�� positive edge ������ ���� ���̴�
)
(
    input clk,
    input rst,
    
    //tx(mosi)
    //input [data_width-1:0] data_in,//mosi(tx)�� ���� ������
    input start,//spi tx �����ϱ� ���� flag
    output mosi,
    
    //rx(miso)
    input miso,
    //output [data_width-1:0] data_out,//miso�� ���� ������
    
    output sclk,//spi bus clk
    output cs//spi slave select line    
);
 
     localparam  freq_cnt=(clk_freq/spi_freq)/2 -1,
                 total_word_number=word_number+1,//���� ���� ����+���๮��
                 total_data_width=data_width*total_word_number,//�� ���ڴ� 8��Ʈ�Ƿ� 8*�������� ����=shift ����
                 shift_width = $clog2(data_width),//log2(8)=3
                 cnt_width = $clog2(freq_cnt);
                 
wire sclk;
wire sampl_en;
wire shift_en;
wire clk_cnt_en;
wire [data_width-1:0]data_in="K";
wire [data_width-1:0] data_out;
                
    sclk_make #(freq_cnt,cnt_width,cpol) sclk_make(clk,rst,clk_cnt_en,sclk);//sclk
    sclk_edge #(cpol,cpha) sclk_edge(clk,rst,sclk,clk_cnt_en,sampl_en,shift_en);//sampl_en
    m_miso #(data_width) m_miso(clk,rst,sampl_en,miso,data_out);//data_out
    m_mosi #(data_width,shift_width,total_word_number) m_mosi(clk,rst,start,data_in,shift_en,clk_cnt_en,cs,mosi);//clk_cnt_en
    
endmodule

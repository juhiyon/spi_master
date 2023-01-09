`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/03 19:05:56
// Design Name: 
// Module Name: tb
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


module tb;
    reg clk;
    reg rst;
    
    //tx(mosi)
    //reg [8-1:0] data_in;//mosi(tx)로 보낼 데이터
    reg start;//spi tx 시작하기 위한 flag
    reg miso;
    wire mosi;
    
    //rx(miso)
    //wire [8-1:0] data_out;//miso로 받은 데이터
    
    wire sclk;//spi bus clk
    wire cs;//spi slave select line    


    top top(.clk(clk),.rst(rst),.start(start),.miso(miso),.mosi(mosi),.sclk(sclk),.cs(cs));
    parameter step =10;
    
always #(step/2) clk=~clk;

initial begin
    clk=1; rst=0; #step;
    rst=1; start=1; #step;
    start=0; miso=1'b1; #(step*400000);
    start=1;
end

endmodule

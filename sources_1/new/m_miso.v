module m_miso
#(
    parameter data_width=8
)
(
    input clk,
    input rst,
    input sampl_en,
    input miso,
    output reg [data_width-1:0] data_out
);
    
//ó�� data_out=0�̾��ٰ� sampl_en =1 ������ miso �� �ϳ��� �鿩�´�.
always @(posedge clk or negedge rst)
begin
if(!rst)
    data_out<='d0;
else if(sampl_en)
    data_out<={data_out[data_width-1:0],miso};
else
    data_out<=data_out;
end

endmodule
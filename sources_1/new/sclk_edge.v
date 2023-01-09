module sclk_edge
#(
    parameter cpol=1,
              cpha=1
)
(
    input clk,
    input rst,
    input sclk,
    input clk_cnt_en,
    output sampl_en,
    output shift_en
);
    
reg sclk_1;
reg sclk_2;

wire sclk_posedge;
wire sclk_negedge;

//sclk���� ��� ����
always @(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        sclk_1<=cpol;
        sclk_2<=cpol;
    end
    else if(clk_cnt_en)
    begin
        sclk_1<=sclk;
        sclk_2<=sclk_1;
    end
end

assign sclk_posedge = ~sclk_2 & sclk_1;//�ι�° ���� 0�̰� �ѹ� ���� 1�̸� posedge
assign sclk_negedge = sclk_2 & ~sclk_1;//�ι�° ���� 1�̰� �ѹ� ���� 0�̸� sclk_negedge=1, �� �ݴ�� 0

generate
    case (cpha)//���� �д� ����
        0 : assign sampl_en = sclk_posedge;//cpha�� 0�̸� posedge���� rx �� �а�
        1 : assign sampl_en = sclk_negedge;//cpha�� 1�̸� negedge���� rx �� �о��
        default : assign sampl_en = sclk_posedge;
    endcase
endgenerate

generate
 	case (cpha)
		0: assign shift_en = sclk_negedge;//chpa�� 0�̸� sclk�� neg���� ����Ʈ ��Ų��
 		1: assign shift_en = sclk_posedge;//chpa�� 1�̸� sclk�� pos���� ����Ʈ ��Ų��
		default: assign shift_en = sclk_posedge;
	endcase//sclk�� ������ ���� 
endgenerate

endmodule
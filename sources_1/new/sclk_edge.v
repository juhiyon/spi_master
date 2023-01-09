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

//sclk엣지 잡기 위해
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

assign sclk_posedge = ~sclk_2 & sclk_1;//두번째 전이 0이고 한번 전이 1이면 posedge
assign sclk_negedge = sclk_2 & ~sclk_1;//두번째 전이 1이고 한번 전이 0이면 sclk_negedge=1, 그 반대는 0

generate
    case (cpha)//엣지 읽는 규정
        0 : assign sampl_en = sclk_posedge;//cpha가 0이면 posedge마다 rx 값 읽고
        1 : assign sampl_en = sclk_negedge;//cpha가 1이면 negedge마다 rx 값 읽어라
        default : assign sampl_en = sclk_posedge;
    endcase
endgenerate

generate
 	case (cpha)
		0: assign shift_en = sclk_negedge;//chpa가 0이면 sclk가 neg마다 시프트 시킨다
 		1: assign shift_en = sclk_posedge;//chpa가 1이면 sclk가 pos마다 시프트 시킨다
		default: assign shift_en = sclk_posedge;
	endcase//sclk의 엣지에 따라서 
endgenerate

endmodule
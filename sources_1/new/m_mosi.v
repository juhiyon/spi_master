module m_mosi
#(
    parameter data_width=1,
              shift_width=1,
              total_word_number=1
)
(
    input clk,
    input rst,
    input start,
    input [data_width-1:0] data_in,
    input shift_en,
    output reg clk_cnt_en,
    output reg cs,
    output mosi
);

    localparam  idle = 3'b000,
                load = 3'b001,
                shift = 3'b010,
                done = 3'b100,
                t_cnt_width = $clog2(total_word_number);
                
reg [2:0] state_c;//spi master ���� ����
reg [2:0] state_n;//spi master ���� ����

reg [shift_width:0] shift_cnt;//����Ʈ ���� cnt
reg [data_width-1:0] data_reg;//tx�� ���� ������ ��� ����

reg [t_cnt_width:0] tt_cnt;//���� �ܾ� � ���´��� ���� ����

always @(posedge clk or negedge rst)//���� clk���� �ϳ�
begin
if(!rst)
    state_c<=idle;
else
    state_c<=state_n;
end

always @*
begin
    case (state_c)
        idle : state_n = start ? load : idle;//idle������ �� start�÷��װ� 1�̸� load
        load : state_n = shift;//load ���¸� shift ���·� �Ѿ��
        //shift : state_n = (shift_cnt==data_width) ? done : shift;
        shift : state_n = (tt_cnt==total_word_number) ? done : shift;
        done : state_n = idle;
    endcase        
end

always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        clk_cnt_en<=1'b0;
        data_reg<='d0;
        cs<=1'b1;//slave select���� 1�� �д�. 0�� �� ����
        shift_cnt<='d0;
        tt_cnt<='d0;
    end
    else//���� �ƴϸ� clk����
    begin
        case(state_n)
            idle : 
            begin
                clk_cnt_en<=1'b0;
                data_reg<='d0;
                cs<=1'd1;
                shift_cnt<='d0;
                tt_cnt<='d0;
            end
            load :
            begin
                clk_cnt_en<=1'b1;
                data_reg<=data_in;
                cs<=1'b0;
                shift_cnt<='d0;
                tt_cnt<='d0;
            end
            shift : 
            begin
                if(shift_en)
                begin
                    //���� tt_cnt=total_word_number-1�̸� datareg�� \n�־��ֱ�
                    //shift_cnt==data_with�� tt_cnt+1 ���ֱ�
                    if(shift_cnt==data_width-1)
                    begin
                        tt_cnt=tt_cnt+1;
                        shift_cnt<='d0;
                        //���⳪ �� else������ 
                        if(tt_cnt==total_word_number-1)
                        begin
                            data_reg<=8'h0D;
                        end
                    end
                    else
                    begin
                        shift_cnt<=shift_cnt+1'b1;
                        data_reg<={data_reg[data_width-2:0],1'b0};//�ֻ��� �����ͺ��� ������.
                    end
                end
                else
                begin
                    shift_cnt<=shift_cnt;
                    data_reg<=data_reg;
                    tt_cnt<=tt_cnt;
                end
                clk_cnt_en<=1'b1;
                cs<=1'b0;
            end
            done : 
            begin
                clk_cnt_en<=1'b0;
                data_reg<='d0;
                cs<=1'b1;
            end
            default : 
            begin
                clk_cnt_en<=1'b0;
                data_reg<='d0;
                cs<=1'b1;
            end
        endcase   
    end
end

assign mosi=data_reg[data_width-1];

endmodule
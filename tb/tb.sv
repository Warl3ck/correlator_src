`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2025 15:12:25
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


module tb();
    
    
    bit clk = 0;
    bit g_reset = 1;
    bit signed [16:0] i_I_arr_const [28480];
	bit signed [16:0] i_Q_arr_const [28480];
	bit mag_sq_stb;
	bit [31:0] cnt;
	bit [31:0] cnt_w;
	bit valid;
	
	int fd1, fd2, fd3, fd4, status1, status2, status3, status4;
	
    //	Clock generator
	initial forever #(4/2)	clk = ~clk;
	
	initial begin
		
		fd1 = $fopen("E:/Netlist/ITGLOBAL/wi_fi/Implementing-802.11-Transmitter-and-Receiver-blocks-in-MATLAB-master/waveform_i.txt", "r");
        for (int i = 0; i < 28480; i = i + 1) begin
            status1 = $fscanf(fd1, "%f\n", i_I_arr_const[i+1]);
        end
        $fclose(fd1);
        
        fd2 = $fopen("E:/Netlist/ITGLOBAL/wi_fi/Implementing-802.11-Transmitter-and-Receiver-blocks-in-MATLAB-master/waveform_q.txt", "r");
        for (int i = 0; i < 28480; i = i + 1) begin
            status2 = $fscanf(fd2, "%f\n", i_Q_arr_const[i+1]);
        end
        $fclose(fd2);
		
	end
    
    initial begin
		repeat(100) @(posedge clk);
		g_reset = 0;
	end
    
    always_ff @(posedge clk) begin
    
	if (g_reset) begin
        cnt <= '0;
        cnt_w <= 0;
        mag_sq_stb <= 1'b0;
        valid <= 1'b0;
	end
	else begin
        cnt_w <= (cnt_w == 5) ? 1 : cnt_w + 1;
        valid <= (cnt_w == 4) ? 1 : 0;
        cnt <= (cnt_w == 4) ? cnt + 1 : cnt;
        mag_sq_stb <= 1'b1;
    end
   end
    
    sync_short sync_short_inst 
	(
		.clock(clk),
		.reset(g_reset),
		.enable(1'b1),
		.min_plateau(100),
		.threshold_scale(1'b0),
		.sample_in({i_I_arr_const[cnt][16:1], i_Q_arr_const[cnt][16:1]}),
		.sample_in_strobe(valid),
		.demod_is_ongoing(),
		.short_preamble_detected()
	);
    
    
    
endmodule

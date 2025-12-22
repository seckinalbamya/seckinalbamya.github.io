//VHDLVerilog.com (VerilogVHDL.com) - 2025 
//PWM kontrolcusu testbench
`timescale 1ns / 1ns
module pwm_generator_tb
	#
	(
		parameter CLK_FREQ_c = 100_000_000,//CLK frekansi(Hz)
		parameter PWM_FREQ_c = 100,//PWM frekansi(Hz)
		parameter PWM_RESOLUTION_c = 10//PWM cozunurlugu bit degeri
	);
	
	localparam clock_period_c = 10;
	
	reg clk		= 1'b0;//clk
	reg reset_n	= 1'b0;//active low reset
	reg en		= 1'b0;//enable
	
	reg [PWM_RESOLUTION_c-1:0] pwm_value = 0;
	
	always #(clock_period_c/2) clk=~clk; //100MHz
	
	initial begin
		reset_n <= 1'b0;//reset aktif
		en <= 1'b0;
		#clock_period_c
		reset_n <= 1'b1;//reset pasif
		pwm_value <= 10'b0000000000;//0
		#1000000//1ms
		en <= 1;
		#15000000//15ms
		pwm_value <= 10'b0010000000;
		#20000000//20ms
		pwm_value <= 10'b0001000000;
		#20000000//20ms
		pwm_value <= 10'b1000000000;
		#20000000//20ms
		pwm_value <= 10'b1111111111;
		en <= 0;
		#3500000//3.5ms
		pwm_value <= 10'b1111111111;
		en <= 1;
		#15000000//15ms
		en <= 0;
		pwm_value <= 10'b0000000000;
		
		$stop;
		
		end

	pwm_generator
	#(
		.CLK_FREQ_c		  (CLK_FREQ_c),	
		.PWM_FREQ_c		  (PWM_FREQ_c),
		.PWM_RESOLUTION_c (PWM_RESOLUTION_c)
	)
	DUT
	(
		.CLK_i		 (clk),
		.RESET_n_i	 (reset_n),

		.EN_i		 (en),
		.PWM_VALUE_i (pwm_value),

		.PWM_o		 ()
	);
		
endmodule
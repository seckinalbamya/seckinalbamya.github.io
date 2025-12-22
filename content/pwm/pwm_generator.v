//VHDLVerilog.com (VerilogVHDL.com) - 2025 
//PWM Kontrolcusu

module pwm_generator
#(
	parameter CLK_FREQ_c		= 100_000_000,//CLK frekansi(Hz)
	parameter PWM_FREQ_c		= 100,//PWM frekansi(Hz)periyodu(T)
	parameter PWM_RESOLUTION_c	= 10//PWM cozunurlugu bit degeri
)
(
	input CLK_i,//CLK input
	input RESET_n_i,//active low reset
	
	input EN_i,		
	input [PWM_RESOLUTION_c-1:0] PWM_VALUE_i,
	
	output reg PWM_o		
);


    //pwm_tick_counter signalinin bit deringligini hesaplamak icin kullanilacak olan logaritma fonksiyonu
    //Xilinx Language Templates'ten alinmistir (***).
    function integer clogb2;
    input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
    endfunction

	//1 birim duty icin gereken clock vuruş sayisinin hesaplanip saklandigi sabit 
	localparam pwm_tick_counter_limit_c = (CLK_FREQ_c + ((PWM_FREQ_c * (2**PWM_RESOLUTION_c))/2) ) / (PWM_FREQ_c * (2**PWM_RESOLUTION_c));
	reg [clogb2(pwm_tick_counter_limit_c)-1:0] pwm_tick_counter = {clogb2(pwm_tick_counter_limit_c){1'b0}};//zaman sayaci icin signal tanimlamasi
	reg pwm_tick = 1'b0;//birim duty gectiginde tetiklenecek olan signalin tanimlamasi 
	reg [PWM_RESOLUTION_c-1:0] pwm_duty_counter = 0;//duty counter sayaci icin signal tanimlamasi
	reg [PWM_RESOLUTION_c-1:0] pwm_value = 0;//PWM girdisinin periyot basinda orneklenip saklandigi signal
	
	always@(posedge CLK_i)
	begin
		if(~RESET_n_i) begin //sync reset
		
				//Cikis sifirlamasi
				PWM_o <= 1'b0;
			
				//reset durumundaki signal sifirlama
				pwm_value		 <= 0;//PWM degerini saklayan registeri sifirla
				pwm_tick_counter <= 0;//zaman sayacini sifirla
				pwm_tick		 <= 1'b0;//periyot sayacini tetikleyen sinyali sifirla
				pwm_duty_counter <= 0;//periyot sayacini sifirla.
				
		end else begin
				
			if(EN_i) begin//ENABLE girisi aktif ise
			
				if(pwm_duty_counter == 0)//Periyot tamamlanmis ise yeni deger girdisi kabul et
					pwm_value <= PWM_VALUE_i;//PWM girdisini örnekle
				
				//birim duty periyodunu olcmek icin kullanilan sayac
                    if(pwm_tick_counter == (pwm_tick_counter_limit_c-1)) begin//birim duty periyodunun sonuna gelindiyse
                        pwm_tick_counter <= 0;//birim duty counterini sifirla
                        pwm_tick <= 1'b1;
                    end else begin
                        pwm_tick_counter <= pwm_tick_counter + 1;//birim duty counterini arttir.
                        pwm_tick <= 1'b0;
                    end
                    
				//PWM periyodunu olcmek icin kullanilan sayac
				if(pwm_tick == 1)//PWM periyodunun sonuna gelindiyse
					if(pwm_duty_counter == {PWM_RESOLUTION_c{1'b1}}) //PWM periyodunun sonuna gelindiyse(-1 tum bitlerin 1 olmasi durumudur)
						pwm_duty_counter <= 0;//duty counteri sifirla
					else
						pwm_duty_counter <= pwm_duty_counter + 1;//duty counteri arttir.
				
				if(pwm_duty_counter < pwm_value)//PWM Ton aninda ise
					PWM_o <= 1'b1;
				else//PWM Toff aninda ise
					PWM_o <= 1'b0;
				
			end else begin//ENABLE girisi pasif ise
				
				//Cikis sifirlamasi
                PWM_o <= 1'b0;
            
                //reset durumundaki signal sifirlama
                pwm_value         <= 0;//PWM degerini saklayan registeri sifirla
                pwm_tick_counter <= 0;//zaman sayacini sifirla
                pwm_tick         <= 1'b0;//periyot sayacini tetikleyen sinyali sifirla
                pwm_duty_counter <= 0;//periyot sayacini sifirla.
                
			end
		
		end
	end

endmodule
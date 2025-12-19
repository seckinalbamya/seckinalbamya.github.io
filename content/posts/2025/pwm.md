---
title: "VHDL ve Verilog ile PWM Sinyali Üretimi"
date: 2025-12-18
slug: /vhdl_verilog_ile_pwm_sinyali_uretimi/
description: VHDL ve Verilog ile PWM Sinyali Üretimi
image: images/pwm/pwm_kapak.png
categories:
  - fpga
  - vhdl
  - -verilog
tags:
  - fpga
  - vhdl
  - verilog
  - pwm
  - pulse width modulation
draft: false
---
**VHDL ve Verilog ile PWM Sinyali Üretimi**

PWM (Pulse Width Modulation), dijital sinyal çıktısının aktif olduğu süreyi değiştirerek çıktının değerinin kontrol edildiği, elektronik uygulamalarda yaygın kullanılan bir çıkış formatıdır. Bu çıkış formatıyla analog çıkışa denk bir sinyalin etkisi dijital bir sinyal ile oluşturulabilmektedir. Ayrıca PWM sinyalinin zaman parametreleri kullanılarak başka bir dijital sistemler arası veri aktarmak da mümkündür.

PWM, dijital sistemlerin hızlı anahtarlanması prensibine dayanır. Bir periyottaki açık kalınan süre (Ton) ve kapalı kalınan sürenin (Toff) değiştirilmesiyle çıkışa aktarılan gücün değiştirilmesi prensibiyle çalışır.PWM sinyalinin yapısı Şekil 1'de verilmiştir.

T: Periyot
Ton: Çıkışın aktif '1' olarak tutulduğu süre
Duty: Ton/T oranı olarak ifade edilmektedir.

<p align="center">
  <img src="https://vhdlverilog.com/images/pwm/sekil_1.webp" width="254"/>
  <br>
  <em>Şekil 1 - PWM sinyalinin yapısı</em>
</p>

Şekil 1'de görülen PWM sinyal yapısında çıkışa aktarılan güç bir periyot için Pmax*(Ton/T)'a eşittir. Bu matematiksel olarak aşağıdaki ifade ile ifade edilebilir.

<p align="left">
  <img src="https://vhdlverilog.com/images/pwm/pwm_tam_formul.png" width="426"/>
</p>
 
Eşitliğin sağdaki 0 ile çarpılan kısmı sıfır olacağından eşitlik aşağıdaki hale sadeleşir.

<p align="left">
  <img src="https://vhdlverilog.com/images/pwm/pwm_ozet_formul.png" width="256"/>
</p>

PWM sinyal formatı, bir periyot içerisindeki Ton/T oranı değiştirilerek çıkışa aktarılan gücün değiştirilmesi esasına dayanmaktadır. Örneğin %100 gücünde çalıştırılmak istenen bir sistemde Ton/T oranı = 1 olacak şekilde ayarlanması gerekirken %10 gücünde çalışması gereken bir sistemde Ton/T oranı 0,1 olacak şekilde ayarlanmalıdır.

Duty (doluluk) oranının değiştirilmesiyle çıkışta kontrol edilmek istenen sistemin çıkış gücü, voltajı veya konumu gibi çıktı değerlerinin değiştirilmesi mümkün olmaktadır. Duty değerinin değiştirilmesiyle çıktının ortalama aktif kaldığı süre değiştirilerek çıkış değerinin efektif olarak ayarlanması sağlanabilmektedir. Özellikle hızlı açılıp kapatılarak çalıştırılabilen sistemlerde (ısıtıcılar, aydınlatma ürünleri, motorlar, smps gibi) çıktının gücü, hızı gibi parametreleri bu yöntem ile kontrol edilebilmektedir. Çok hızlı şekilde (insan veya ölçüm yapan sistemin algılama frekansından yüksek frekansta) yapılan bu anahtarlama sayesinde gerçek bir analog kontrol ediliyorcasına çıktı elde edilebilmektedir.

Aşağıda VHDL ve Verilog donanım tasarım dillerinde PWM uygulaması yer almaktadır. Bu tasarımlarda generic olarak clock frekansı, PWM sinyalinin frekansı ve bu modülü kontroledecen PWM girdi değerinin çözünürlüğü generic olarak belirlenebilir şekilde bir tasarım yapılmıştır. Böylece girdi ve çıktı parametreleri isteğe göre ayarlanabilmektedir.

Birim çözünürlük için kaç clock gerektiği bilgisi pwm_tick_counter_limit_c adlı sabit değere generic parametreler kullanılarak sentezleme aşamasında hesaplanır ve yazılır. PWM_i adlı girdi her PWM periyodunun başında örneklenerek pwm_value isimli bir sinyale yazılır. pwm_tick_counter, pwm_tick_counter_limit_c-1 değerine ulaştığında yani 1 birim çözünürlük için gereken zaman tamamlandığında pwm_tick adlı sinyal 1 clock süresince '1' yapılır. pwm_tick '1' olduğunda PWM sinyalinin periyodunu birim çözünürlük biriminden saklayan pwm_duty_counter adlı bir sinyalin değeri bir arttırılır. PWM_i isimli girişten alınan değer ile pwm_duty_counter kıyaslanarak PWM sinyalinin Ton veya Toff durumlarından hangisinde olması gerektiği belirlenir. pwm_tick_counter değeri 0 ile pwm_value-1 değeri arasında ise çıktı '1' yapılarak Ton durumu gerçekleştirilirken pwm_tick_counter değerinin bu değerden büyük olması durumunda çıkış '0' yapılır.

VHDL'de yazılan PWM üretici kod aşağıda verilmiştir.
```vhdl
--VHDLVerilog.com (VerilogVHDL.com) - 2025 
--PWM Kontrolcusu

library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pwm_generator is
	generic
	(
		CLK_FREQ_c		: integer := 100_000_000;--CLK frekansi(Hz)
		PWM_FREQ_c		: integer := 100;--PWM frekansi(Hz)
		PWM_RESOLUTION_c: integer := 10--PWM cozunurlugu bit degeri
	);
	port
	(
		CLK_i			: in std_logic;--CLK input
		RESET_n_i		: in std_logic;--active low reset
		
		EN_i			: in std_logic;
		PWM_VALUE_i		: in std_logic_vector(PWM_RESOLUTION_c-1 downto 0);
		
		PWM_o			: out std_logic
	);
end entity;

architecture pwm_generator_beh of pwm_generator is

	--pwm_tick_counter signalinin bit deringligini hesaplamak icin kullanilacak olan logaritma fonksiyonu
	--Xilinx Language Templates'ten alinmistir.
	function clogb2( depth : natural) return integer is
		variable temp    : integer := depth;
		variable ret_val : integer := 0;
	begin
		while temp > 0 loop
			ret_val := ret_val + 1;
			temp    := temp / 2;
		end loop;

		return ret_val;
	end function;
	
	--1 birim duty icin gereken clock vuruş sayisinin hesaplanip saklandigi sabit 
	constant pwm_tick_counter_limit_c : integer := (CLK_FREQ_c + ((PWM_FREQ_c * (2**PWM_RESOLUTION_c))/2) ) / (PWM_FREQ_c * (2**PWM_RESOLUTION_c));
	signal pwm_tick_counter 		  : unsigned(clogb2(pwm_tick_counter_limit_c)-1 downto 0) := (others=>'0');--zaman sayaci icin signal tanimlamasi
	signal pwm_tick 				  : std_logic := '0';--1 birim duty gectiginde tetiklenecek olan signalin tanimlamasi 
	signal pwm_duty_counter 		  : unsigned(PWM_RESOLUTION_c-1 downto 0) := (others=>'0');--duty counter sayaci icin signal tanimlamasi
	signal pwm_value 			  	  : unsigned(PWM_RESOLUTION_c-1 downto 0) := (others=>'0');--PWM girdisinin periyot basinda orneklenip saklandigi signal
	
begin
	
	process(CLK_i)
	begin
	
		if rising_edge(CLK_i) then
		
			if RESET_n_i = '0' then--sync reset
			
				--Cikis sifirlamasi
				PWM_o <= '0';
			
				--reset durumundaki signal sifirlama
				pwm_value		 <= (others=>'0');--PWM degerini saklayan registeri sifirla
				pwm_tick_counter <= (others=>'0');--zaman sayacini sifirla
				pwm_tick		 <= '0';--periyot sayacini tetikleyen sinyali sifirla
				pwm_duty_counter <= (others=>'0');--periyot sayacini sifirla.
				
			else
				
				if EN_i = '1'  then--ENABLE girisi aktif ise
				
					if pwm_duty_counter = 0 then--Periyot tamamlanmis ise yeni deger girdisi kabul et
						pwm_value <= unsigned(PWM_VALUE_i);--PWM girdisini örnekle
					end if;
					
					--birim duty periyodunu olcmek icin kullanilan sayac
					if pwm_tick_counter = to_unsigned(pwm_tick_counter_limit_c-1,clogb2(pwm_tick_counter_limit_c)) then--birim duty periyodunun sonuna gelindiyse
						pwm_tick_counter <= (others=>'0');--birim duty counterini sifirla
						pwm_tick <= '1';
					else
						pwm_tick_counter <= pwm_tick_counter + 1;--birim duty counterini arttir.
						pwm_tick <= '0';
					end if;
					
					--PWM periyodunu olcmek icin kullanilan sayac
					if pwm_tick = '1' then--PWM periyodunun sonuna gelindiyse
						if pwm_duty_counter = (pwm_duty_counter'range => '1') then--PWM periyodunun sonuna gelindiyse(tum bitlerin 1 olmasi durumu)
							pwm_duty_counter <= (others=>'0');--duty counteri sifirla
						else
							pwm_duty_counter <= pwm_duty_counter + 1;--duty counteri arttir.
						end if;
					end if;
					
					if pwm_duty_counter < pwm_value then--PWM Ton aninda ise
						PWM_o <= '1';
					else--PWM Toff aninda ise
						PWM_o <= '0';
					end if;					
					
				else--ENABLE girisi pasif ise
					
					--Cikis sifirlamasi
					PWM_o <= '0';
				
					pwm_value		 <= (others=>'0');--PWM degerini saklayan registeri sifirla
					pwm_tick_counter <= (others=>'0');--zaman sayacini sifirla
					pwm_tick		 <= '0';--periyot sayacini tetikleyen sinyali sifirla
					pwm_duty_counter <= (others=>'0');--periyot sayacini sifirla.
					
				end if;
				
			end if;--RESET_n_i

		end if;--rising_edge
	
	end process;

end architecture;
```

Verilog'da yazılan, yukarıdaki kodun tamamen aynısı olan PWM üretici kod aşağıda verilmiştir.
```verilog
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
```

VHDL'de yazılan testbench kodu aşağıda verilmiştir.
```vhdl
--VHDLVerilog.com (VerilogVHDL.com) - 2025 
--PWM kontrolcusu testbench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pwm_generator_tb is
	
	generic
	(
		CLK_FREQ_c		: integer := 100_000_000;--CLK frekansi(Hz)
		PWM_FREQ_c		: integer := 100;--PWM frekansi(Hz)
		PWM_RESOLUTION_c: integer := 10--PWM cozunurlugu bit degeri
	);

end entity;

architecture DUT of pwm_generator_tb is

---------------------------------------------------------------------------------------------------	
--components
---------------------------------------------------------------------------------------------------
	component pwm_generator is
		generic
		(
			CLK_FREQ_c		: integer := 100_000_000;--CLK frekansi(Hz)
			PWM_FREQ_c		: integer := 100;--PWM frekansi(Hz)
			PWM_RESOLUTION_c: integer := 10--PWM cozunurlugu bit degeri
		);
		port
		(
			CLK_i			: in std_logic;--CLK input
			RESET_n_i		: in std_logic;--active low reset
			
			EN_i			: in std_logic;
			PWM_VALUE_i		: in std_logic_vector(PWM_RESOLUTION_c-1 downto 0);
			
			PWM_o			: out std_logic
		);
	end component;

---------------------------------------------------------------------------------------------------
--signals
---------------------------------------------------------------------------------------------------
	constant clock_period_c	: time := 10ns;--100MHz
	
	signal clk				: std_logic := '0';--clk
	signal reset_n			: std_logic := '1';--active low reset
	signal en				: std_logic := '0';--enable
	
	signal pwm_value		: std_logic_vector(PWM_RESOLUTION_c-1 downto 0) := (others=>'0');

begin
	
	--clock generator
	clock_process : 
	process
	begin
		clk <= '1';
		wait for clock_period_c/2;
		clk <= '0';
		wait for clock_period_c/2;
	end process;
	
	PWM_GENERATOR_TEST :
	process
	begin
		
		reset_n <= '0';--reset aktif
		en <= '0';
		wait for clock_period_c;
		reset_n <= '1';--reset pasif
		pwm_value <= "0000000000";--0
		wait for 1ms;
		en <= '1';
		wait for 15ms;
		pwm_value <= "0010000000";
		wait for 20ms;
		pwm_value <= "0001000000";
		wait for 20ms;
		pwm_value <= "1000000000";
		wait for 3.5ms;
		pwm_value <= "1111111111";
		en <= '0';
		wait for 15ms;
		pwm_value <= "1111111111";
		en <= '1';
		wait for 15ms;
		en <= '0';
		pwm_value <= "0000000000";
		
		wait;

	end process;

---------------------------------------------------------------------------------------------------
--instantiations
---------------------------------------------------------------------------------------------------
	DUT : pwm_generator
	generic map
	(
		CLK_FREQ_c		=> CLK_FREQ_c,	
		PWM_FREQ_c		=> PWM_FREQ_c,
		PWM_RESOLUTION_c=> PWM_RESOLUTION_c
	)
	port map
	(
		CLK_i			=> clk,
		RESET_n_i		=> reset_n,
		
		EN_i			=> en,
		PWM_VALUE_i		=> pwm_value,
		
		PWM_o			=> open
	);
	
end architecture;
```
Verilog'da yazılan, yukarıdaki testbench kodunun tamamen aynısı olan testbench kodu aşağıda verilmiştir.
```verilog
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
```
Yukarıdaki testbench kodlarının waveform çıktısı Şekil 2'de verilmiştir.

<p align="center">
  <img src="https://vhdlverilog.com/images/pwm/sekil_2.PNG" width="1783"/>
  <br>
  <em>Şekil 2 - Waveform çıktısı</em>
</p>

Bu içerikte kullanılan Şekil 1 [Learn Electronics India](https:////www.learnelectronicsindia.com/post/controlling-pwm-of-led-using-a-potentiometer) adresinden alınmıştır.

---
title: "VHDL ile Hareketli Ortalama Filtre (Moving Average Filter)"
date: 2025-08-28
slug: /vhdl_ile_hareketli_ortalama_filtre/
description: FPGA'de Statik Timing Analizi
image: images/moving_average_filter_kapak.jpg
categories:
  - fpga
  - vhdl
tags:
  - fpga
  - vhdl
  - hareketli ortalam filtre
  - moving average filter
draft: false
---

**Hareketli Ortalama Filtre (Moving Average Filter)**

Hareketli ortalama filtre (moving average filter) girdilerin sıralı şekilde ortalamasını alıp çıkartan bir filtredir. Ani ve rastgele değişen girdilere karşılık stabil bir çıktı üretir. Matematiksel olarak genişliği sabit olan bir Finite Impulse Response (FIR) fonksiyonu ile konvolüsyon işlemidir. Low pass karakteristiğine sahiptir. Zaman domaininde iyi çalışan bir filtre olmasına karşın frekans domaininde iyi sonuçlar vermez. 

Elektronik alanında analog dijital dönüştürücülerde (ADC) ve gürültülü girdi sinyallerinin filtrelenmesinde sıklıkla kullanılır. Finans alanında ise kıymetli varlıkların değerlerinin anlamlandırılmasında da kullanılmaktadır. Oldukça başarılı, anlaşılabilir ve algoritmik açıdan kolay implemente edilebilir yapıdadır.

En önemli parametresi pencere genişliğidir (window length). Pencere genişliği kaç tane girdinin ortalamasının alınacağını belirleyen parametredir. Matematiksel olarak ifadesi Şekil 1'de verilmiştir.
	
<p align="center">
  <img src="https://vhdlverilog.com/images/moving_average_filter/sekil_1.svg" width="710"/>
  <em>Şekil 1 - Hareketli ortalama filtrenin matematiksel ifadesi</em>
</p>


Şekil 2'de verilen GIF görselinde hareket eden pencerenin girdileri ve oluşturduğu çıktılar incelendiğinde algoritma daha iyi bir şekilde anlaşılabilir.

<p align="center">
  <img src="https://vhdlverilog.com/images/moving_average_filter/sekil_2.gif" width="710"/>
  <em>Şekil 2 - Hareketli ortalama filtrenin matematiksel ifadesi</em>
</p>


Yukarıdaki işlemde kırmızı renkli çıktı ve mavi renkli girdi indeksleri incelendiğinde ortalamanın sağlıklı alınabilmesi için pencerenin tamamen girdilerle dolması gerektiği anlaşılmaktadır. Tamamen girdiler ile dolan pencerenin ortanca elemanına ait indeksten itibaren verilen çıktılar anlamlı ve doğrudur. Filtreye uygulanan sinyalin giriş ve çıkış anında ortalamaya dahil edilecek katsayı miktarı pencere genişliğinden az olacağı için üretilen çıktılar yanıltıcı olabilmektedir.

Filtrenin özellikle gürültülü girdilere karşılık gösterdiği performans başarılıdır. Şekil 3'te görsel incelendiğinde soldaki ham veriye uygulanmış pencere genişliği 11 ve 51 örnek olan filtrelerin performansları görülebilir.

<p align="center">
  <img src="https://vhdlverilog.com/images/moving_average_filter/sekil_3.png" width="710"/>
  <em>Şekil 3 - Hareketli ortalama filtrenin çeşitli pencere genişliklerine göre çıktı örneği</em>
</p>

Mikrodenetleyici veya FPGA gibi aygıtlar üzerinde çalıştırılacak olan hareketli ortalama filtrede aynı çıktı sonuçlarını verecek sürekli hareketli ortalama filtre (continuous moving average filter) algoritması kullanılır. Bu algoritmanın yalnızca bir aşamasında toplama ve çıkarma, bir tane de bölme işlemi yapılarak yazılım ve donanımda yalınlık amaçlanır. Bahsedilen algoritma Şekil 4'te verilmiştir.
	
<p align="center">
  <img src="https://vhdlverilog.com/images/moving_average_filter/sekil_4.png" width="710"/>
  <em>Şekil 4 - İmplemente edilen algoritma</em>
</p>


&nbsp;&nbsp;&nbsp;&nbsp;Giriş verisi pencere uzunluğu kadar aşamadan oluşan bir pipeline yapısına sokulur. Sum adındaki bir sinyal ile ardışık girdiler sürekli olarak toplanırken pipeline yapısının son elemanı bu toplamdan sürekli olarak çıkarılır. Bu yapı sayesinde pencere uzunluğu kadar olan verilerin toplamı elde edilebilir. Girdinin sürekli gelmesi durumunda dahi toplama ve çıkarma işlemleri sayesinde yalnızca son gelen pencere genişliği tane verinin toplamı saklanır. Pencere genişliği parametresine göre verilerin toplamları elde edildikten sonra toplam pencere uzunluğu parametresine bölünerek ortalama değeri elde edilir.

<p align="center">
  <img src="https://vhdlverilog.com/images/moving_average_filter/sekil_5.gif" width="710"/>
  <em>Şekil 5 - İmplemente edilen algoritmanın işleyişi</em>
</p>
	
Şekil 5'te pencere genişliği 5 olan; sırasıyla 1,2,3,4,5,6,7,8 ve 9 değerindeki veri girişine karşılık algoritmanın işleyişi gösterilmiştir.
	
Bu yapı sayesinde pencere genişliğinden bağımsız olarak yalnızca bir toplama-çıkarma işlemi ve bir de bölme işlemi ile hareketli ortalama filtresi uygulanabilmektedir.

**VHDL ile hareketli ortalama filtre uygulaması:**

Yukarıda algoritması ifade edilen hareketli ortalama filtrenin VHDL ile yazılmış uygulaması aşağıda verilmiştir.

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

--VHDLVerilog.com (VerilogVHDL.com) - 2025 
--Hareketli ortalama filtresi (Moving average filter)
--Aşağıdaki yapı pencere boyutu tane (WINDOW_LENGTH_c) girdiyi aldıktan sonra çıktı üretmeye başlar.
--Girdi sinyali geçerli olduğu sürece çıktı verisini eşit ağırlıkta ortalama alarak günceller.
--Girdi sinyalinin geçersiz olduğu durumda ise ortalama alınacak penceredeki verileri ve çıktıyı güncellemeden bekler. 
--Bu beklemeden sonra yeni veri gelmesi durumunda hali hazırda kuyrukta(pipeline'da) bulunan veriler ile gelen verilerin ortalaması alınarak başlanır.
--Active low senkron reset ile hafızadaki pencere değerleri temizlenebilir.
--ROUND_TYPE_c generic parametresi "FLOOR" olarak ayarlandığında ortalama alınırken yapılan yuvarlama bir küçük tam sayıya;
--ROUND_TYPE_c generic parametresi "CEIL" olarak ayarlandığında ortalama alınırken yapılan yuvarlama bir büyük tam sayıya yuvarlanır.
--Girdi std_logic_vector olarak BITDEPTH_c generic parametresine bağlı uzunlukta ve unsigned olarak yapılmalıdır.
--Çıktı std_logic_vector olarak BITDEPTH_c generic parametresine bağlı uzunlukta ve unsigned olarak yapılmaktadır.


entity moving_average_filter is
	generic
	(
		BITDEPTH_c		: integer;--girdi ve çıktının bit derinliği
		WINDOW_LENGTH_c	: integer;--ortalama alınacak pencerenin boyutu
		ROUND_TYPE_c	: string--"FLOOR" veya "CEIL" olarak ayarlanmalıdır. Başka parametre seçilmemedilir.
	);
	port
	(
		CLK_i			: in std_logic;
		RESET_n_i		: in std_logic;--active low reset
		
		DATA_i			: in std_logic_vector(BITDEPTH_c-1 downto 0);
		DATA_VALID_i	: in std_logic;
		
		DATA_o			: out std_logic_vector(BITDEPTH_c-1 downto 0);
		DATA_VALID_o	: out std_logic
	);
end entity;

architecture moving_average_filter_beh of moving_average_filter is	

	--Girdileri toplayıp bir signale yazarken signal'in boyutu ceil(log2(WINDOW_LENGTH_c)) kadar büyür. 
	--Bu fonksiyon da log2 değerini küsüratlı ise bir üste yuvarlayarak hesaplar
	function ceil_log2( depth : natural) return integer is
		variable temp    : integer := depth;
		variable ret_val : integer := 0;
		begin
			while temp > 0 loop
				ret_val := ret_val + 1;
				temp    := temp / 2;
			end loop;
			return ret_val;
	end function;

	type data_pipeline_type is array (0 to WINDOW_LENGTH_c-1) of std_logic_vector(BITDEPTH_c-1 downto 0);--gelen verinin pipeline type'ı
	signal data_p : data_pipeline_type := (others=>(others=>'0'));--gelen verinin pipeline'ı
	
	signal data_valid_p : std_logic_vector(WINDOW_LENGTH_c-1 downto 0) := (others=>'0');--gelen verinin geçerli olup olmadığının pipeline'ı
	
	--gelen verilerin girdilerinin toplanacağı signal
	--Gelen verilerin boyutu her toplam işleminde(her seferinde en buyuk girdi geldiği senaryoda (en kotu senaryo)) kendi miktarınca artar.
	--orneğin pencere genisligi 3, bit derinliği 8 olsun. Üç adet 8 bitlik verinin toplamı en fazla 255*3=765 olur. 765 değeri ise 10 bit ile ifade edilir.
	--bu matematiksel olarak ifade edilmek istenirse BITDEPTH_c + ceil_log2(WINDOW_LENGTH_c) olarak ifade edilir.
	signal sum : integer range 0 to ((2**(BITDEPTH_c+ceil_log2(WINDOW_LENGTH_c)))-1) := 0;
	
begin
	
	process(CLK_i)
	begin
	
		if rising_edge(CLK_i) then
		
			if RESET_n_i = '0' then--sync reset
			
				--signal sıfırlama
				data_p 		<= (others=>(others=>'0'));
				data_valid_p<= (others=>'0');
				sum 		<= 0;
				
				--output sıfırlama
				DATA_o		<= (others=>'0');
				DATA_VALID_o<= '0';
			
			else
				
				--pipeline 0
				if DATA_VALID_i = '1' then--girdi geçerli ise
					data_p(0) 		<= DATA_i;--pipeline kuyruğuna ekleniyor.					
					sum		  		<= sum + to_integer(unsigned(DATA_i)) - to_integer(unsigned(data_p(WINDOW_LENGTH_c-1)));	
					
					--pipeline loop
					--generic şekilde WINDOW_LENGTH_c girdisine bağlı olarak bir önceki pipeline elemanlarını bir sonrakine aktarıyor
					for pipeline_index in 1 to WINDOW_LENGTH_c-1 loop
						data_p(pipeline_index) <= data_p(pipeline_index-1);
						data_valid_p(pipeline_index) <= data_valid_p(pipeline_index-1); 
					end loop;
				end if;		
				data_valid_p(0) <= DATA_VALID_i;--pipeline kuyruğundaki hangi elemenların geçerli oldugunu belirten sinyal
				
				--last pipeline 
				--pipeline'ların tamamı veri ile doluysa(pencere genişliği WINDOW_LENGTH_c'den az ise çıktı vermez)
				if data_valid_p(0) = '1' and data_valid_p(WINDOW_LENGTH_c-1) = '1' then
					--generic parametre oldugundan sentez araci tarafindan asagidakilerden birisi secilerek disari aktarilir.
					if ROUND_TYPE_c = "CEIL" then
						DATA_o		 <= std_logic_vector(to_unsigned(((sum+(WINDOW_LENGTH_c-1))/WINDOW_LENGTH_c),BITDEPTH_c));--çıkış veriliyor.
					else--"FLOOR"
						DATA_o		 <= std_logic_vector(to_unsigned((sum/WINDOW_LENGTH_c),BITDEPTH_c));--çıkış veriliyor.
					end if;
					DATA_VALID_o <= '1';--çıkış değeri gecerli.
				else
					DATA_o		 <= (others=>'0');--çıkış değeri geçerli değilken 0 olarak verilsin.
					DATA_VALID_o <= '0';--çıkış değeri geçerli degil.
				end if;
			
			end if;--RESET_n_i

		end if;--rising_edge
	
	end process;

end architecture;
```
	
VHDL konunun generic parametre bölümünde her bir girdinin bit derinliği BITDEPTH_c ile, pencere genişliği WINDOW_LENGTH_c ile ayarlanmalı, girdiler std_logic_vector olarak ve unsigned şekilde verilmelidir. Ayrıca aşağıda daha detaylı anlatılan bölme işleminin yuvarlama yönü de ROUND_TYPE_c generic parametresi ile ayarlanmalıdır.
	
Şekil 4'te verilen algoritma yapısına bağlı kalınarak WINDOW_LENGTH_c parametresine bağlı bir pipeline yapısı oluşturulmuş ve bu pipeline yapısına gelen veriler geçerli olduğunda (DATA_VALID_i = '1') veri eklenmiştir. WINDOW_LENGTH_c tane elemanı bulunan pipeline'ın elemanlarının geçerli olup olmadığı saklamak için WINDOW_LENGTH_c tane elemandan oluşan std_logic_vector dizisi (data_valid_p(index)) tanımlanmıştır. Bu std_logic_vector signali yeni veri geldiğinde veri ile senkron şekilde yeni indexe kaydırılmıştır.
	
Her clockta (DATA_VALID_i = '1' iken) yeni veri geldiğinde, sum adlı signal'e gelen veri yazılmış, pipeline'daki son veri ise bu signalden çıkartılmıştır. Böylece pencerenin genişliği artmadan verinin toplamı hesaplanmıştır. 
	
Sum adlı sinyal WINDOW_LENGTH_c tane girdinin toplamından oluşur. Her bir girdi BITDEPTH_c tane bit ile ifade edilmektedir. Dolayısıyla sum adlı signalin sınırları WINDOW_LENGTH_c tane BITDEPTH_c girdisinin alabileceği en büyük toplam değeri kadar olmalıdır. Bunun matematiksel karşılığı BITDEPTH_c + ceil_log2(WINDOW_LENGTH_c) ifadesidir.
	Bu ifadede WINDOW_LENGTH_c tane toplamın BITDEPTH_c'yi kaç bit büyüteceği hesaplanıp BITDEPTH_c değeri ile toplanmaktadır.

ceil_log2 fonksiyonu girdi değerinin 2 tabanında logaritmasını alır ve küsüratlı olması halinde üste yuvarlar. Bu da girdinin kaç bit ile ifade edilebileceğini hesaplar. Pencere genişliği girdi olarak verildiğinde toplama işleminin değer aralığını kaç bit büyütmesi gerektiğini hesaplar. Örnek olarak:
- WINDOW_LENGTH_c = 5 ve BITDEPTH_c = 8 olsun.
- Girdinin alabileceği değer aralığı 0-255 olur.
- 5 tane girdinin toplamı ise en az 5*0 = 0, en fazla 5*255 = 1275 olur.
- 1275 değerini ifade etmek için ceil_log2(1275) = 11 bite (unsigned) ihtiyaç duyulur.
		
Bu işlem yukarıda ifade edilen fonksiyon ile yapılmak istenirse:
- bit derinliği + ceil_log2(toplamdaki eleman sayısı)
- BITDEPTH_c + ceil_log2(WINDOW_LENGTH_c) = 8 + ceil_log2(5) = 11 elde edilir.

Pipeline dolduğunda (pipeline'ın ilk ve son verisi aynı anda geçerli ise) toplam değeri WINDOW_LENGTH_c parametresine bölünerek çıktı elde edilmiş ve çıktının geçerli olduğu bilgisi dışarıya aktarılmıştır. 

ROUND_TYPE_c adlı generic parametre ile bölme işlemi yapılırken sonucun küsüratlı çıkması halinde yukarı (CEIL) veya aşağı (FLOOR) yönde yapılıp yapılmaması seçilebilecek şekilde generic yazılmıştır. ROUND_TYPE_c, generic bir parametre, yani instantiation esnasında belirtilen sabit bir parametre olarak belirtilmiştir. Bundan dolayı seçilen parametre dışındaki diğer seçenekler asla çalışmayacağından dolayı sentez araçları tarafından sentezlenmez ve donanımda gereksiz yer işgal etmez. Buna karşılık çalışma esnasında çıkış bölmesinin floor mu ceil olacağı değiştirilemez.

**Testbench:**

Aşağıda verilen VHDL dilinde yazılmış testbench ile modüle çeşitli girdiler verilerek doğru çalışıp çalışmadığı test edilmiştir.

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity moving_average_filter_tb is
	
	generic
	(
		BITDEPTH_c		: integer := 8;--testbench'te kullanılacak olan girdi özellikleri buradan değiştirilmedilir.
		WINDOW_LENGTH_c	: integer := 5;
		ROUND_TYPE_c	: string  := "CEIL"--"CEIL" veya "FLOOR" dışında girdi yapılmamalıdır.
	);

end entity;

architecture DUT of moving_average_filter_tb is

---------------------------------------------------------------------------------------------------	
--components
---------------------------------------------------------------------------------------------------
	component moving_average_filter is
		generic
		(
			BITDEPTH_c		: integer;
			WINDOW_LENGTH_c	: integer;
			ROUND_TYPE_c	: string 
		);
		port
		(
			CLK_i			: in std_logic;
			RESET_n_i		: in std_logic;
			
			DATA_i			: in std_logic_vector(BITDEPTH_c-1 downto 0);
			DATA_VALID_i	: in std_logic;
			
			DATA_o			: out std_logic_vector(BITDEPTH_c-1 downto 0);
			DATA_VALID_o	: out std_logic
		);
	end component;

---------------------------------------------------------------------------------------------------
--signals
---------------------------------------------------------------------------------------------------
	constant clock_period	: time := 10ns;--100MHz
	
	signal clk				: std_logic := '1';
	signal reset_n			: std_logic := '1';--active low reset
	
	signal data				: std_logic_vector(BITDEPTH_c-1 downto 0) := (others=>'0');--test girdisi
	signal data_valid		: std_logic := '0';--test girdisinin geçerli olup olmadığını gösteren sinyal

begin
	
	--clock generator
	clock_process : 
	process
	begin
		clk <= '1';
		wait for clock_period/2;
		clk <= '0';
		wait for clock_period/2;
	end process;
	
	MOVING_AVERAGE_FILTER_TEST :
	process
	begin
	
		reset_n <= '0';--reset aktif
		wait for clock_period;
		reset_n <= '1';--reset pasif
		data <= x"01";
		data_valid <= '1';
		wait for clock_period;
		data <= x"02";
		wait for clock_period;
		data <= x"03";
		wait for clock_period;
		data <= x"04";
		wait for clock_period;
		data <= x"05";
		wait for clock_period;
		data <= x"06";
		wait for clock_period;
		data <= x"07";
		wait for clock_period;
		data <= x"08";
		wait for clock_period;
		data <= x"09";
		wait for clock_period;
		data <= x"0a";
		wait for clock_period;
		data <= x"0b";
		wait for clock_period;
		data <= x"0c";
		wait for clock_period;
		data <= x"0d";
		wait for clock_period;
		data <= x"0e";
		wait for clock_period;
		data <= x"0f";
		wait for clock_period;
		data <= x"10";
		wait for clock_period;
		data <= x"11";
		wait for clock_period;
		data <= x"12";
		wait for clock_period;
		data <= x"13";
		wait for clock_period;
		data <= x"14";
		wait for clock_period;
		data <= x"15";
		wait for clock_period;
		data <= x"16";
		wait for clock_period;
		data <= x"17";
		wait for clock_period;
		data <= x"18";
		wait for clock_period;
		data_valid <= '0';--girdi geçersiz ise nasıl davrandığı incelemek için eklendi.
		data <= x"19";
		wait for clock_period;
		data <= x"1a";
		wait for clock_period;
		data <= x"1b";
		wait for clock_period;
		data <= x"1c";
		wait for clock_period;
		data <= x"1d";
		wait for clock_period;
		data <= x"1e";
		wait for clock_period;
		data <= x"20";
		wait for clock_period;
		data <= x"21";
		wait for clock_period;
		data_valid <= '1';--girdi tekrar geçerli olduğunda pencerede kalan eski değerleri gözlemlemek için eklendi.
		data <= x"22";
		wait for clock_period;
		data <= x"23";
		wait for clock_period;
		data <= x"24";
		wait for clock_period;
		data <= x"25";
		wait for clock_period;
		data <= x"26";
		wait for clock_period;
		
		reset_n <= '0';--reset aktif!
		wait for clock_period;
		reset_n <= '1';--reset pasif!(data_valid hala aktif!)
	
		--Girdi bit sınırına yakın girdiler verilerek Owerflow durumunun incelenmesi için eklendi.
		--Ayrıca aşağıdaki girdiler ile ceil ve floor özellikleri de incelenebiliyor.
		data <= x"f9";
		wait for clock_period;
		data <= x"fa";
		wait for clock_period;
		data <= x"fb";
		wait for clock_period;
		data <= x"fc";
		wait for clock_period;
		data <= x"fd";
		wait for clock_period;
		data <= x"fe";
		wait for clock_period;
		data <= x"ff";
		wait for clock_period;
		data <= x"fe";
		wait for clock_period;
		data <= x"fd";
		wait for clock_period;
		data <= x"fc";
		wait for clock_period;
		data <= x"fb";
		wait for clock_period;
		data <= x"fa";
		wait for clock_period;
		data <= x"f9";
		wait for clock_period;
		----------------------
		wait for clock_period;
		reset_n <= '0';--reset aktif!
		wait for clock_period;
		reset_n <= '1';--reset pasif!(data_valid hala aktif!)
		----------------------
		--FLOOR ve CEIL çıktılarının doğru olup olmadığını gözlemek için eklendi.
		data <= x"05";
		wait for clock_period;
		data <= x"05";
		wait for clock_period;
		data <= x"05";
		wait for clock_period;
		data <= x"05";
		wait for clock_period;
		data <= x"05";--ortalama 5 olur ve çıktı elde edilir.(WINDOW_LENGHT_c=5 ise)
		wait for clock_period;
		data <= x"06";--ortalama (WINDOW_LENGHT_c=5 ise) 5,2 oluyor. CEIL'de çıkış = 6, FLOOR'da çıkış = 5 olur.
		wait for clock_period;
		----------------------
		wait for clock_period;
		reset_n <= '0';--reset aktif!
		wait for clock_period;
		reset_n <= '1';--reset pasif!(data_valid hala aktif!)
		----------------------
		--FLOOR ve CEIL çıktılarının doğru olup olmadığını gözlemek için eklendi.
		data <= x"05";
		wait for clock_period;
		data <= x"05";
		wait for clock_period;
		data <= x"05";
		wait for clock_period;
		data <= x"05";
		wait for clock_period;
		data <= x"05";--ortalama 5 olur ve çıktı elde edilir.(WINDOW_LENGHT_c=5 ise)
		wait for clock_period;
		data <= x"04";--ortalama (WINDOW_LENGHT_c=5 ise) 4,8 oluyor. CEIL'de çıkış = 5, FLOOR'da çıkış = 4 olur.
		wait for clock_period;
		
		data_valid <= '0';--SON
		wait;

	end process;

---------------------------------------------------------------------------------------------------
--instantiations
---------------------------------------------------------------------------------------------------
	DUT : moving_average_filter
	generic map
	(
		BITDEPTH_c		=> BITDEPTH_c,		
		WINDOW_LENGTH_c	=> WINDOW_LENGTH_c,
		ROUND_TYPE_c	=> ROUND_TYPE_c	
	)
	port map
	(
		CLK_i			=> clk,	
		RESET_n_i		=> reset_n,
		
		DATA_i			=> data,
		DATA_VALID_i	=> data_valid,
		
		DATA_o			=> open,
		DATA_VALID_o	=> open
	);

end architecture;
```


Sıralı girişlere karşılık filtrenin çıktılarının incelendiği senaryo Şekil 6'da verilmiştir.

<p align="center">
  <img src="https://vhdlverilog.com/images/moving_average_filter/sekil_6.PNG" width="1704"/>
  <em>Şekil 6 - Sıralı girişlere karşılık filtrenin çıktıları</em>
</p>

DATA_VALID_i = '0' olduğu durumda girdilere karşılık filtrenin çıktılarının incelendiği senaryo Şekil 7'de verilmiştir.
	
<p align="center">
  <img src="https://vhdlverilog.com/images/moving_average_filter/sekil_7.PNG" width="1679"/>
  <em>Şekil 7 - DATA_VALID_i = '0' olduğu durumda girdilere karşılık filtrenin çıktıları</em>
</p>

DATA_VALID_i = '0' değerinden sonra tekrar '1' olduğu durumda girdilere karşılık filtrenin çıktılarının incelendiği senaryo Şekil 8'de verilmiştir. Burada pipeline'daki eski değerlerin korunduğu görülmektedir.
	
<p align="center">
  <img src="https://vhdlverilog.com/images/moving_average_filter/sekil_8.PNG" width="1109"/>
  <em>Şekil 8 - DATA_VALID_i = '0' değerinden sonra tekrar '1' olduğu durumda girdilere karşılık filtrenin çıktıları</em>
</p>

Girdi olarak girdinin alabileceği en büyük sınıra yakın değerler verilerek overflow durumunun incelendiği senaryo Şekil 9'da verilmiştir.
	
<p align="center">
  <img src="https://vhdlverilog.com/images/moving_average_filter/sekil_9.PNG" width="1594"/>
  <em>Şekil 9 - Overflow durumunun incelenmesi</em>
</p>

ROUND_TYPE_c parametresi FLOOR ve CEIL yapılarak çıktıların incelendiği senaryo Şekil 10'da verilmiştir. Görselin sol tarafında floor, sağ tarafında ise ceil yuvarlama yapısı kullanılmıştır.

<p align="center">
  <img src="https://vhdlverilog.com/images/moving_average_filter/sekil_10.png" width="2222"/>
  <em>Şekil 10 - ROUND_TYPE_c parametresinin çıktıya etkisinin incelenmesi</em>
</p>

Bu yazı hazırlanırken [Wikipedia - Moving Average](https://en.wikipedia.org/wiki/Moving_average), [Analog Devices DSP Book](https://www.analog.com/media/en/technical-documentation/dsp-book/dsp_book_ch15.pdf) ve [Surf-VHDL - How to Implement Moving Average in VHDL](https://surf-vhdl.com/how-to-implement-moving-average-in-vhdl/)   kaynaklarından faydalanılmıştır.

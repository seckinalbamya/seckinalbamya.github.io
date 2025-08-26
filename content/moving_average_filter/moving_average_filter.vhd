library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

--VHDLVerilog.com (VerilogVHDL.com) - 2025 
--Hareketli ortalama filtresi (Moving average filter)
--Aşağıdaki yapı pencere boyutu tane (WINDOW_LENGHT_c) girdiyi aldıktan sonra çıktı üretmeye başlar.
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
		WINDOW_LENGHT_c	: integer;--ortalama alınacak pencerenin boyutu
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

	--Girdileri toplayıp bir signale yazarken signal'in boyutu ceil(log2(WINDOW_LENGHT_c)) kadar büyür. 
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

	type data_pipeline_type is array (0 to WINDOW_LENGHT_c-1) of std_logic_vector(BITDEPTH_c-1 downto 0);--gelen verinin pipeline type'ı
	signal data_p : data_pipeline_type := (others=>(others=>'0'));--gelen verinin pipeline'ı
	
	signal data_valid_p : std_logic_vector(WINDOW_LENGHT_c-1 downto 0) := (others=>'0');--gelen verinin geçerli olup olmadığının pipeline'ı
	
	--gelen verilerin girdilerinin toplanacağı signal
	--Gelen verilerin boyutu her toplam işleminde(her seferinde en buyuk girdi geldiği senaryoda (en kotu senaryo)) kendi miktarınca artar.
	--orneğin pencere genisligi 3, bit derinliği 8 olsun. Üç adet 8 bitlik verinin toplamı en fazla 255*3=765 olur. 765 değeri ise 10 bit ile ifade edilir.
	--bu matematiksel olarak ifade edilmek istenirse BITDEPTH_c + ceil_log2(WINDOW_LENGHT_c) olarak ifade edilir.
	signal sum : integer range 0 to ((2**(BITDEPTH_c+ceil_log2(WINDOW_LENGHT_c)))-1) := 0;
	
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
					sum		  		<= sum + to_integer(unsigned(DATA_i)) - to_integer(unsigned(data_p(WINDOW_LENGHT_c-1)));	
					
					--pipeline loop
					--generic şekilde WINDOW_LENGHT_c girdisine bağlı olarak bir önceki pipeline elemanlarını bir sonrakine aktarıyor
					for pipeline_index in 1 to WINDOW_LENGHT_c-1 loop
						data_p(pipeline_index) <= data_p(pipeline_index-1);
						data_valid_p(pipeline_index) <= data_valid_p(pipeline_index-1); 
					end loop;
				end if;		
				data_valid_p(0) <= DATA_VALID_i;--pipeline kuyruğundaki hangi elemenların geçerli oldugunu belirten sinyal
				
				--last pipeline 
				--pipeline'ların tamamı veri ile doluysa(pencere genişliği WINDOW_LENGHT_c'den az ise çıktı vermez)
				if data_valid_p(0) = '1' and data_valid_p(WINDOW_LENGHT_c-1) = '1' then
					--generic parametre oldugundan sentez araci tarafindan asagidakilerden birisi secilerek disari aktarilir.
					if ROUND_TYPE_c = "CEIL" then
						DATA_o		 <= std_logic_vector(to_unsigned(((sum+(WINDOW_LENGHT_c-1))/WINDOW_LENGHT_c),BITDEPTH_c));--çıkış veriliyor.
					else--"FLOOR"
						DATA_o		 <= std_logic_vector(to_unsigned((sum/WINDOW_LENGHT_c),BITDEPTH_c));--çıkış veriliyor.
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
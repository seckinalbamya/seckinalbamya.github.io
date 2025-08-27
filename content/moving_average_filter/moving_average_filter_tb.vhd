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

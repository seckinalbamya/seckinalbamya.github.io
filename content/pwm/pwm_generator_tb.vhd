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

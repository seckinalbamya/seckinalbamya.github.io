library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity axis_slave_interface is

	port
	(
		--CLK/Reset interface
		PIXEL_CLK_i		: in  std_logic;   -- pixel clock
		PIXEL_RESET_i	: in  std_logic;   -- PIXEL_CLK domain reset
		
		--HDMI Interface
		DATA_o			: out std_logic_vector(23 downto 0);
		DISPLAY_EN_i	: in  std_logic;
		SOF_o			: out std_logic;
		EOL_o			: out std_logic;
		
		--AXI4-Stream CLK/Reset interface
		ACLK			: in  std_logic;
		ARESETn			: in  std_logic;
		
		--AXI4-Stream slave (stream domain)
		S_AXIS_TDATA	: in  std_logic_vector(23 downto 0);
		S_AXIS_TVALID	: in  std_logic;
		S_AXIS_TREADY	: out std_logic;
		S_AXIS_TUSER	: in  std_logic;   -- Start of Frame (first pixel of frame)
		S_AXIS_TLAST 	: in  std_logic    -- End of Line
	);
end entity;

architecture axis_slave_interface_beh of axis_slave_interface is

	component axis_slave_line_buffer
		port
		(
			rst 	: in std_logic;
			wr_clk 	: in std_logic;
			rd_clk 	: in std_logic;
			din 	: in std_logic_vector(25 downto 0);
			wr_en 	: in std_logic;
			rd_en 	: in std_logic;
			dout 	: out std_logic_vector(25 downto 0);
			full 	: out std_logic;
			empty 	: out std_logic
		);
	end component;

	constant DW	: integer := 26;  -- [25]=SOF, [24]=EOL, [23:0]=RGB888

	-- FIFO sinyalleri
	signal wr_en		: std_logic;
	signal rd_en		: std_logic;
	signal fifo_full	: std_logic;
	signal fifo_empty	: std_logic;
	signal din			: std_logic_vector(DW-1 downto 0);
	signal dout			: std_logic_vector(DW-1 downto 0);

begin

	----------------------------------------------------------------------------
	-- Write side (ACLK / stream domain)
	----------------------------------------------------------------------------
	din           <= S_AXIS_TUSER & S_AXIS_TLAST & S_AXIS_TDATA;
	wr_en         <= S_AXIS_TVALID and (not fifo_full);
	S_AXIS_TREADY <= (not fifo_full);

	----------------------------------------------------------------------------
	-- Read side (PIXEL_CLK / video domain) - FWFT
	----------------------------------------------------------------------------
	rd_en <= DISPLAY_EN_i and (not fifo_empty);
	
	SOF_o <= dout(25) and (not fifo_empty);
	
	READ_OUT:
	process(PIXEL_CLK_i)
	begin
		if rising_edge(PIXEL_CLK_i) then
			if PIXEL_RESET_i = '1' then
				DATA_o <= (others=>'0');
				EOL_o  <= '0';
			else
				if DISPLAY_EN_i = '1' then
					if fifo_empty = '0' then
						DATA_o <= dout(23 downto 0);
						EOL_o  <= dout(24);
					else
						-- Underflow -> black, for protecting timing
						DATA_o <= (others=>'0');
						EOL_o  <= '0';
					end if;
				else
					EOL_o <= '0';
				end if;
			end if;
		end if;
	end process;

	----------------------------------------------------------------------------
	-- Async FIFO (CDC + buffering)
	----------------------------------------------------------------------------
	
	CDC_FIFO : axis_slave_line_buffer
	port map
	(
		rst     => not ARESETn,
		wr_clk 	=> ACLK,
		rd_clk 	=> PIXEL_CLK_i,
		din 	=> din,
		wr_en 	=> wr_en,
		rd_en 	=> rd_en,
		dout 	=> dout, 
		full 	=> fifo_full,
		empty 	=> fifo_empty
	);
	
end architecture;

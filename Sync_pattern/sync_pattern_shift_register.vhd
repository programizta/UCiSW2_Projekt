----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:24:52 03/24/2019 
-- Design Name: 
-- Module Name:    sync_pattern_shift_register - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sync_pattern_shift_register is
	Port( clk 		:	in std_logic;
			data_in	:	in std_logic;
			CE			:	in std_logic; -- ?
			Rst		:	in std_logic;
			y			:	out std_logic);	
end sync_pattern_shift_register;

architecture Behavioral of sync_pattern_shift_register is
	type state_type is (idle, active, decision, ledon);
	signal state, next_state : state_type;
	signal qs :	std_logic_vector (7 downto 0);
	signal most_significant_bit : std_logic := '1';
   signal mod5		: std_logic_vector(2 downto 0);
	signal mod8		: std_logic_vector(3 downto 0);
	signal Q			: std_logic_vector(7 downto 0);

begin
	Q <= qs;
	detection	: process(clk)
	begin
		if rising_edge(clk) and mod5 = "001" then
			qs(7 downto 0) <= qs(6 downto 0) & data_in;
		end if;
	end process detection;
	
	counter_mod5	: process(clk)
	begin
		if rising_edge(clk) then
			if state = idle then
				mod5 <= "000";
			else
            if mod5 = "100" then
               mod5 <= "000";
            else
               mod5 <= mod5 + 1;
            end if;
			end if;
		end if;
	end process counter_mod5;
	
	counter_mod8	: process(clk)
	begin
		if rising_edge(clk) and CE = '1' then
			if Rst = '1' then
				mod8 <= "0001";
			elsif mod8 = "1000" then
				mod8 <= "0001";
			else
				mod8 <= mod8 + 1;
			end if;
		end if;
	end process counter_mod8;
	
   change_state : process( Clk )
   begin
      if rising_edge( Clk ) then
         if Reset = '1' then
            state <= A;
         else
            state <= next_state;
         end if;
      end if;
   end process change_state;
   
	reader_inner_state_switch	: process(state, Do_Rdy)
		begin

         most_significant_bit <= Q(7);
         next_state <= state;
         
         case state is
            when idle =>
               if most_significant_bit = '0' then
                  next_state <= active;
               end if;
            when active =>
               if mod8 = 8 then
                  next_state <= decision;
               end if;
            when decision =>
               if Q = "01010100" then
                  next_state <= ledon;
               else 
                  next_state <= idle;
               end if;
             when ledon =>
               next_state <= null;
         end case;
         
--			if Q(7) = '1' and most_significant_bit = '1' then
--				next_state <= idle;
--			elsif Q(7) = '0' and most_significant_bit = '1' then
--				next_state <= active;
--			elsif Q(7) = '1' and most_significant_bit = '0' then
--				next_state <= active;
--			elsif Q(7) = '0' and most_significant_bit = '0' then
--				next_state <= decision;
--			elsif Q = "01010100" and mod8 = "1000" then
--				next_state <= ledon;
--			else next_state <= state;
--			end if;
--			most_significant_bit <= Q(7);
		end process reader_inner_state_switch;
      		
	if_ledon	:	process(state)
	begin
		if state = ledon then
			y <= '1';
		else y <= '0';
		end if;
	end process if_ledon;
	
end Behavioral;


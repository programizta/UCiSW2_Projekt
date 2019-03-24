--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:08:51 03/24/2019
-- Design Name:   
-- Module Name:   /home/peter/Desktop/UCiSW2 Projekt/I. Sync Pattern/Sync_pattern/register_test.vhd
-- Project Name:  Sync_pattern
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: sync_pattern_shift_register
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY register_test IS
END register_test;
 
ARCHITECTURE behavior OF register_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT sync_pattern_shift_register
    PORT(
         clk : IN  std_logic;
         clr : IN  std_logic;
         data_in : IN  std_logic;
         reg : OUT  std_logic_vector(7 downto 0);
         y : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal clr : std_logic := '0';
   signal data_in : std_logic := '1';

 	--Outputs
   signal reg : std_logic_vector(7 downto 0);
   signal y : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: sync_pattern_shift_register PORT MAP (
          clk => clk,
          clr => clr,
          data_in => data_in,
          reg => reg,
          y => y
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;

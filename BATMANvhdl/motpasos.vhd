library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity motpasos is
 port ( clk : in STD_LOGIC;
 direccion : in STD_LOGIC;
 entrar_maquina : in STD_LOGIC;
 rst : in STD_LOGIC;
 MOT : out STD_LOGIC_VECTOR(3 downto 0) 
);
end motpasos;

architecture behavioral of motpasos is

 signal div : std_logic_vector(17 downto 0);
 signal clks : std_logic;
 type estado is(RESET,sm0,sm1, sm2, sm3, sm4, sm5, sm6, sm7);
 signal pres_S, next_s : estado;
 signal motor : std_logic_vector(3 downto 0);
 
begin

process (Clk,rst)
 begin
	 if rst='0' then
	 	div <= (others=>'0');
	 elsif Clk'event and Clk='1' then
	 	div <= div + 1;
	 end if;
end process;

clks <= div(17);

 process (clks,rst)
 begin
	 if rst='0' then
	 	pres_S <= sm0;
	 elsif clks'event and clks='1' then
	 	pres_S <= next_s;
	 end if;
 end process;

 process (pres_S,entrar_maquina,rst,direccion)
 begin
 case(pres_S) is
	 when RESET => -- RESET
	 	if entrar_maquina='1' then 
			 if direccion='1' then
				 next_s <= sm7;
			 else
				 next_s <= sm0;
			 end if;
		 else
		 	next_s <= RESET;
		 end if; 
	 when sm0 => -- Estado 0
		 if entrar_maquina='1' then 
			 if direccion='1' then
				 next_s <= sm7;
			 else
				 next_s <= sm1;
			 end if;
		 else
		 	next_s <= RESET;
		 end if;
	 when sm1 => -- Estado 1
	 	if entrar_maquina='1' then 
			 if direccion='1' then
				 next_s <= sm0;
			 else
				 next_s <= sm2;
			 end if;
		 else
		 	next_s <= RESET;
		 end if; 
	 when sm2 => -- Estado 1
		 if entrar_maquina='1' then 
			 if direccion='1' then
				 next_s <= sm1;
			 else
				 next_s <= sm3;
			 end if;
		 else
		 	next_s <= RESET;
		 end if;
	 when sm3 => -- Estado 1
		 if entrar_maquina='1' then 
			 if direccion='1' then
				 next_s <= sm2;
			 else
				 next_s <= sm4;
			 end if;
		else
		 	next_s <= RESET;
		 end if;
	 when sm4 => -- Estado 1
		 if entrar_maquina='1' then 
			 if direccion='1' then
				 next_s <= sm3;
			 else
				 next_s <= sm5;
			 end if;
		else
		 	next_s <= RESET;
		 end if;
	 when sm5 => -- Estado 1
		 if entrar_maquina='1' then 
			 if direccion='1' then
				 next_s <= sm4;
			 else
				 next_s <= sm6;
			 end if;
		else
		 	next_s <= RESET;
		 end if;
	 when sm6 => -- Estado 1
		 if entrar_maquina='1' then 
			 if direccion='1' then
				 next_s <= sm5;
			 else
				 next_s <= sm7;
			 end if;
		else
		 	next_s <= RESET;
		 end if;
	when sm7 => -- Estado 1
			 if entrar_maquina='1' then 
				 if direccion='1' then
					 next_s <= sm6;
				 else
					 next_s <= sm1;
				 end if;
			else
		 	next_s <= RESET;
		 end if;	
	 when others => next_s <= RESET;
 end case;
 end process;
 
 
 
 process(pres_S)
 begin
 case pres_S is
 when RESET => motor <= "0000";
 when sm0 => motor <= "1000";
 when sm1 => motor <= "1100";
 when sm2 => motor <= "0100";
 when sm3 => motor <= "0110";
 when sm4 => motor <= "0010";
 when sm5 => motor <= "0011";
 when sm6 => motor <= "0001";
 when sm7 => motor <= "1001";
 when others => motor <= "0000";
 end case;
 end process;
 
 
 
 MOT<=motor;
 
 
 
end behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity RX is
 port( Clk : IN STD_LOGIC;
 LEDS : OUT STD_LOGIC_VECTOR(7 downto 0);
 RX_WIRE : IN STD_LOGIC);
end entity;
architecture behaivoral OF RX IS
 signal BUFF: STD_LOGIC_VECTOR(9 downto 0);
 signal Flag: STD_LOGIC := '0';
 signal PRE: INTEGER RANGE 0 TO 5208 := 0;
 signal INDICE: INTEGER RANGE 0 TO 9 := 0;
 signal PRE_val: INTEGER range 0 to 41600;
 signal baud: STD_LOGIC_VECTOR(2 downto 0);
 begin
 RX_dato : process(Clk)
 begin
	if (Clk'EVENT and Clk = '1') then
		if (Flag = '0' and RX_WIRE = '0') then--Aqui sabemos que se esta iniciando la comunicacion 
				Flag<= '1';--Indica que se esta recibiendo un caracter, en este if se enciene la bandera y se reinician los contadores. 
				INDICE <= 0;
				PRE <= 0;
		end if;
		if (Flag = '1') then
			BUFF(INDICE) <= RX_WIRE;
			if(PRE < PRE_val) then--cada vez que la bandera esta encendida este if incrementa el contador 
				PRE <= PRE + 1;--va de 0 a 5200
			else
				PRE <= 0;
			end if;
			if(PRE = PRE_val/2) then--En este caso, cada vez que vaya a la mitad de un ciclo manda un dato 
				if(INDICE < 9) then--EL preescalador define un tiempo en el que vamos a leer un dato. 
					INDICE <= INDICE + 1;--Cuando es menor que 9 sigue leyendo datos y guardandolos en el bufer.
				else
					if(BUFF(0) = '0' and BUFF(9)= '1') then--Cuando llega a 9 verifica que ya termino 
						LEDS <= BUFF(8 DOWNTO 1);
					else
						LEDS <= "00000000";--Si hay un error apaga los leds y reinicia todo 
					end if;
					Flag <= '0';
				end if;
			end if;
		end if;
	end if; 
 end process RX_dato;
 
  baud<="011";
  
 with (baud) select
 PRE_val <= 41600 when "000", -- 1200 bauds
 20800 when "001", -- 2400 bauds
 10400 when "010", -- 4800 bauds
 5200 when "011", -- 9600 bauds
 2600 when "100", -- 19200 bauds
 1300 when "101", -- 38400 bauds
 866 when "110", -- 57600 bauds
 432 when others; --115200 bauds
end architecture behaivoral;


--Sabemos que se inicia la comunicacion cuando el bit de inicio es cero
--EL error es que en el if de if (Flag = '0' and RX_WIRE = '1') RX_WIRE esta en 1 lo cual incactiva o deshabilita el buffer 
--Por lo que lee caracteres  pero no guarda nada, no hay cracateres que no han llegado por que siempre marcara error. 

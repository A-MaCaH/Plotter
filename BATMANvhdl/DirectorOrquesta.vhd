library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity DirectorOrquesta is
 port( 	Clk : IN STD_LOGIC;
 Rrorq : IN STD_LOGIC;
 MOT1 : out STD_LOGIC_VECTOR(3 downto 0);
 MOT2 : out STD_LOGIC_VECTOR(3 downto 0);
 servo : out STD_LOGIC);
end entity;

architecture behaivoral OF DirectorOrquesta IS
	component motpasos is
	 Port ( clk : in STD_LOGIC;
		 direccion : in STD_LOGIC;
		 entrar_maquina : in STD_LOGIC;
		 rst : in STD_LOGIC;
		 MOT : out STD_LOGIC_VECTOR(3 downto 0));
		 end component;
 

	 component RX is
	 Port ( Clk : IN STD_LOGIC;
		 LEDS : OUT STD_LOGIC_VECTOR(7 downto 0);
		 RX_WIRE : IN STD_LOGIC);
		 end component;
 
	 component Servomotor is
	 Port ( clk : in STD_LOGIC;
		 Pini : in STD_LOGIC;
		 Pfin : in STD_LOGIC;
		 Inc : in STD_LOGIC;
		 Dec : in STD_LOGIC;
		 control : out STD_LOGIC);	
		end component; 
 signal movlados : STD_LOGIC;
 signal movvertical : STD_LOGIC;
 Signal activar1 : STD_LOGIC;
 Signal activar2 : STD_LOGIC;
 Signal reset1 : STD_LOGIC;
 Signal reset2 : STD_LOGIC;
 Signal coordenada : STD_LOGIC_VECTOR(7 downto 0);
 Signal coordenadax : integer;
 Signal coordenaday : integer;
 Signal coordenadax0 : integer:=0;
 Signal coordenaday0 : integer:=0;
 signal 		 Piniorq :  STD_LOGIC;
 signal		 Pfinorq :  STD_LOGIC;
 signal		 Incorq :  STD_LOGIC;
 signal		 Decorq :  STD_LOGIC;
 signal dx : integer;
 signal dy : integer;
 signal i :natural:=0;
 signal activarBucle : bit :='0';
 

 begin
   R: RX port map (clk,coordenada,Rrorq);
	M1: motpasos port map(clk,movlados,activar1,reset1,MOT1);
	M2: motpasos port map(clk,movvertical,activar2,reset2,MOT2);
	S: Servomotor port map(clk,Piniorq,Pfinorq,Incorq,Decorq,servo);
	
	recibirCoordenadas : process (coordenada)
		variable contador : bit :='0';
	begin 
		if contador = '0' then 
			coordenadax<=to_integer(unsigned(coordenada));
			contador:='1';
		else
			coordenaday<=to_integer(unsigned(coordenada));
			contador:='0';
		end if;
	end process recibirCoordenadas;
	
	obtenerValores : process (coordenaday)
	begin
		dx<=abs(coordenadax-coordenadax0);
		dy<=abs(coordenaday-coordenaday0);
		if coordenadax0 < coordenadax then
			movlados<='1';--derecha
		else
			movlados<='0';--izquierda
		end if;
		if coordenaday0 < coordenaday then
			movvertical<='1';--arriba
			activarBucle <='1';
		else
			movvertical<='0';--abajo
			activarBucle <='1';
		end if;
	end process obtenerValores;
	
	bucle : process 
		variable over : integer := 0;
	begin 
		wait on clk until activarBucle ='1';
		if dx > dy then 
			if i < dx then
				over:=over+dy;
				activar1<='1';
				reset1<='1';
				if over >=dx then
					over:=over-dx;
					activar2<='1';
					reset2<='1';
				end if;
			else 
				activar1<='0';
				reset1<='0';
				activar2<='0';
				reset2<='0';
			end if;

		else
			if i < dy then
				over := over + dx;
				activar2<='1';
				reset2<='1';
				if over>=dy then
					over:=over-dx;
					activar1<='1';
					reset1<='1';
				end if;
		   else 	
				activar1<='0';
				reset1<='0';
				activar2<='0';
				reset2<='0';	
			end if;
		end if;
		i<=i+1;
	end process bucle;
	

 
 end architecture behaivoral;


 

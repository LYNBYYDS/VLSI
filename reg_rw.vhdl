library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_rw is
    port(
        -- global interface
            ck : in std_logic;
            reset_n		: in Std_Logic;
            vdd			: in bit;
            vss			: in bit;

        -- Write Port 32 bits
            wen         : in std_logic;
            wdata		: in std_logic_vector(31 downto 0);

        -- Read Port 32 bits
            reg_rd		: out std_logic_vector(31 downto 0);
            reg_v		: out std_logic;

	    -- Invalidate Port
            inval       : in std_logic);
end reg_rw;

architecture Behavior of reg_rw is
    signal data : std_logic_vector(31 downto 0);
    signal valitation : std_logic;
begin
    process(ck)
        begin
            if rising_edge(ck) then
                if reset_n = '0' then
                    valitation <= '1';
                else 
                    if wen = '1' and valitation = '0' then
                        data <= wdata;
                    end if;
                    if inval = '1' then
                        valitation <= '0';
                    end if ;
                end if;
            end if;
    end process;
    
    reg_rd <= data;
    reg_v <= valitation;
    

end Behavior;
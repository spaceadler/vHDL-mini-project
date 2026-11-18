-- tb_sanity_check.vhd - exhaustive testbench for the full adder
--
-- Drives all 8 combinations of the three input pins and checks the three LEDs.
-- A pin reads as logical 1 when it is tied to ground ('0'), and an LED is lit
-- when its output is '0'. Exactly one LED lights for a non-zero sum:
--   a + b + cin = 0 -> none, 1 -> o_s, 2 -> o_cout, 3 -> o_cout_s_a
--
--   ghdl -a --std=08 sanity_check.vhd tb_sanity_check.vhd
--   ghdl -e --std=08 tb_sanity_check
--   ghdl -r --std=08 tb_sanity_check

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sanity_check is
end entity tb_sanity_check;

architecture sim of tb_sanity_check is

    signal pin_a, pin_b, pin_cin    : std_logic := '1';     -- '1' = jumper not connected
    signal led_s, led_cout, led_3   : std_logic;

begin

    dut : entity work.sanity_check
        port map (
            i_a        => pin_a,
            i_b        => pin_b,
            i_cin      => pin_cin,
            o_s        => led_s,
            o_cout     => led_cout,
            o_cout_s_a => led_3);

    stim : process
        variable bits     : unsigned(2 downto 0);
        variable total    : natural;
        variable expected : std_logic_vector(2 downto 0);   -- (o_s, o_cout, o_cout_s_a), '0' = lit
        variable got      : std_logic_vector(2 downto 0);
        variable errors   : natural := 0;
    begin
        for i in 0 to 7 loop
            bits := to_unsigned(i, 3);              -- logical values of a, b, cin
            pin_a   <= not bits(2);
            pin_b   <= not bits(1);
            pin_cin <= not bits(0);
            wait for 10 ns;

            total := to_integer(bits(2 downto 2)) + to_integer(bits(1 downto 1))
                   + to_integer(bits(0 downto 0));
            case total is
                when 0      => expected := "111";
                when 1      => expected := "011";
                when 2      => expected := "101";
                when others => expected := "110";
            end case;

            got := led_s & led_cout & led_3;
            if got /= expected then
                report "a b cin = " & to_string(bits) & ": LEDs (s, cout, cout_s_a) = "
                     & to_string(got) & ", expected " & to_string(expected)
                     severity error;
                errors := errors + 1;
            end if;
        end loop;

        if errors = 0 then
            report "PASS: all 8 input combinations" severity note;
        else
            report "FAIL: " & integer'image(errors) & " error(s)" severity failure;
        end if;
        wait;
    end process;

end architecture sim;

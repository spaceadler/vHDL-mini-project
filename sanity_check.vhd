library ieee;
use ieee.std_logic_1164.all;

entity sanity_check is
    port (
        i_a         :   in std_logic;                           -- a is the first input.
        i_b         :   in std_logic;                           -- b is the second input.
        i_cin       :   in std_logic;                           -- cin is the carry from the previous theoretical operation.

        o_s         :   out std_logic;                          -- sum
        o_cout      :   out std_logic;                          -- and carry.
        o_cout_s_a  :   out std_logic);                         -- and operation on the sum and carry.

end entity sanity_check;

architecture hardware of sanity_check is

    signal w_a          :   std_logic;                          -- the idea is that when the cable is not connected, it's in a floating state.
    signal w_b          :   std_logic;                          -- in which, it's set to 1, which is the same value when it's connected to vcc.
    signal w_cin        :   std_logic;                          -- so we invert that, to make sure it's ONLY "1" when it's connected to gnd.
 
    signal w_ab_x       :   std_logic;                          -- transfer wires for a xor b.
    signal w_ab_a       :   std_logic;                          -- transfer wires for a and b.
    signal w_abx_c_a    :   std_logic;                          -- transfer wires for (a xor b) and i_cin.

    signal w_s          :   std_logic;                          -- carry signal for the sum,
    signal w_cout       :   std_logic;                          -- as well as the carry bit.

begin

    w_a         <= not      i_a;                                -- apply line 18.
    w_b         <= not      i_b;                                -- apply line 19.
    w_cin       <= not      i_cin;                              -- apply line 20.
 
    w_ab_x      <= w_a      xor w_b;                            -- apply line 22.
    w_ab_a      <= w_a      and w_b;                            -- apply line 23.
    w_abx_c_a   <= w_ab_x   and w_cin;                          -- apply line 24.

    w_s         <= w_ab_x   xor w_cin;                          -- apply line 26.
    w_cout      <= w_ab_a   or  w_abx_c_a;                      -- apply line 27.

    o_s         <= not (w_s     and not (w_cout and w_s));      -- LED is on only if sum is 1 but carry is 0.   PIN_3
    o_cout      <= not (w_cout  and not (w_cout and w_s));      -- LED is on only if sum is 0 but carry is 1.   PIN_7
    o_cout_s_a  <= not (w_cout  and w_s);                       -- LED is on only if sum is 1 and carry is 1.   PIN_9
end architecture hardware;

-- Oh my god this took so much time to write and make sure is correct, the amount of times I wrote this
-- with just "o_" only to change to "w_" wires, add "i_" wires, as well as fixing logic, rewriting to
-- make easier to read as well as write this documentation is just astronomical. 

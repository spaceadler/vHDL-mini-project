library ieee;
use ieee.std_logic_1164.all;

entity sanity_check is
    port (
        i_a         :   in std_logic;               -- a is the first input.
        i_b         :   in std_logic;               -- b is the second input.
        i_cin       :   in std_logic;               -- cin is the carry from the previous operation (full adder.)

        o_s         :   out std_logic;              -- output of the operation.
        o_cout      :   out std_logic);             -- whether if there's a carry bit or not.

end entity sanity_check;

architecture hardware of sanity_check is

    signal w_ab_x       :   std_logic;              -- transfer wires for a xor b.
    signal w_ab_a       :   std_logic;              -- transfer wires for a and b.
    signal w_ab_cin_a   :   std_logic;              -- transfer wires for o_ab_x and i_cin.

    signal w_a          :   std_logic;              -- purely aesthetic,
    signal w_b          :   std_logic;              -- just here to switch the
    signal w_cin        :   std_logic;              -- signal with a future "not".

begin

    w_a         <= not i_a;                         -- the idea is that when the cable is not connected, it's in a floating state.
    w_b         <= not i_b;                         -- in which, it's set to 1, which is the same value when it's connected to vcc.
    w_cin       <= not i_cin;                       -- so we invert that, to make sure it's ONLY "1" when it's connected to something, aka gnd.


    w_ab_x      <= w_a      xor w_b;                -- set the value of transfer wire per line 21.
    w_ab_a      <= w_a      and w_b;                -- set the value of transfer wire per line 22.
    w_ab_cin_a  <= w_ab_x   and w_cin;              -- set the value of transfer wire per line 23.

    o_cout      <= not (w_ab_a   or  w_ab_cin_a);   -- do a little not for the LED's...
    o_s         <= not (w_ab_x   xor w_cin);        -- ...this way, they're ON only when "initiated".

end architecture hardware;

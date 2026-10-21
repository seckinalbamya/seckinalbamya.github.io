---
title: "Libraries in VHDL and the Functions They Contain"
date: 2025-03-12
slug: /vhdl_libraries/
description: Libraries in VHDL and the Functions They Contain
image: images/vhdl_kutuphaneleri_en.png
categories:
  - vhdl
tags:
  - vhdl
  - ieee
  - synopsys
  - std_logic
  - numeric_std
  - std_logic_arith
  - library
  - package
draft: false
---

In a design written in VHDL, the "standard" package is available without any declaration being required. The types defined by the
standard package are given below.	

```
bit      	<= A type that can take the logic values '0' and '1'.
bit_vector	<= A multi-bit type made up of consecutive elements that can take the logic values '0' and '1'.
integer  	<= The type used for whole numbers. Unless its range is specified, it can take values between [-2147483648,2147483647] by default.
natural  	<= A type used for whole numbers. Unless its range is specified, it can take values between [0,2147483647] by default.
positive	<= A type used for whole numbers. Unless its range is specified, it can take values between [1,2147483647] by default.
boolean  	<= The type used for conditional expressions, which can take the value "false" or "true".
real     	<= Used for fractional numbers. It is a simulation-only type that cannot be synthesised into real hardware. Unless its range is specified, it can take values between [-1.7014111e+308,1.7014111e+308] by default.
time		<= Used to represent time in simulations. It is a simulation-only type that cannot be synthesised into real hardware.
character	<= The type used to represent characters.
string		<= The type used to represent character strings.
```

For more detailed information about the types mentioned above, **["standard.vhd"](https://github.com/seckinalbamya/seckinalbamya.github.io/blob/main/content/vhdl_libraries/standard.vhd)** can be examined.

## std_logic_1164 package

This is a package published by the IEEE in 1993. It contains types that can model the behaviour of digital electronic signals beyond just '0' and '1'. The "std_logic_1164" package defines arithmetic functions for std_logic/std_ulogic and for vectors of these types. Some of the functions it contains perform the same operations as those in the "numeric_std" library, but for the types they are defined on. 

The lines below can be added to the declaration section of the code in order to use it.
```
library IEEE;
use IEEE.std_logic_1164.all;
```

The types defined by the "std_logic_1164" package are given below.

```
std_ulogic			<= A type that can take the values 'U','X','0','1','Z','W','L','H','-'.
std_ulogic_vector   <= A type made up of multiple std_ulogic elements, each able to take the values 'U','X','0','1','Z','W','L','H','-'.
std_logic			<= The resolved version of std_ulogic. It can take the same values as std_ulogic.
std_logic_vector    <= The resolved version of std_ulogic_vector. It can take the same values as std_ulogic_vector.
```

If two values are driven onto the same signal using std_ulogic/std_ulogic_vector, a "multiple driver" error is produced.
In this situation the resolution function does not raise an error but produces an output according to a predefined table.

The values that the std_ulogic/std_logic and std_ulogic_vector/std_logic_vector types can take are given below.

```
'U' => Uninitialised; no value has been assigned.
'X' => Forcing unknown
'0' => Forcing '0'
'1' => Forcing '1'
'Z' => High impedance 
'W' => Weak unknown
'L' => Weak '0'     
'H' => Weak '1'     
'-' => Don't care ('1' or '0')
```

The functions defined in the std_logic_1164 package and the types they support are given below.

Logical operation functions:
```
and		 => Defined for std_ulogic/std_logic/std_ulogic_vector/std_logic_vector inputs, can take the output values ('U','X','0','1').
nand	 => Defined for std_ulogic/std_logic/std_ulogic_vector/std_logic_vector inputs, can take the output values ('U','X','0','1').
or		 => Defined for std_ulogic/std_logic/std_ulogic_vector/std_logic_vector inputs, can take the output values ('U','X','0','1').
nor		 => Defined for std_ulogic/std_logic/std_ulogic_vector/std_logic_vector inputs, can take the output values ('U','X','0','1').
xor  	 => Defined for std_ulogic/std_logic/std_ulogic_vector/std_logic_vector inputs, can take the output values ('U','X','0','1').
xnor 	 => Defined for std_ulogic/std_logic/std_ulogic_vector/std_logic_vector inputs, can take the output values ('U','X','0','1').
not  	 => Defined for std_ulogic/std_logic/std_ulogic_vector/std_logic_vector inputs, can take the output values ('U','X','0','1').
```

The operations performed by the functions above and examples of their use are given below.

```
c <= a and b; 	-- applies a logical and operation to signals a and b.
c <= a nand b;	-- applies a logical nand operation to signals a and b.
c <= a or b;	-- applies a logical or operation to signals a and b. 
c <= a nor b;	-- applies a logical nor operation to signals a and b.
c <= a xor b;	-- applies a logical xor operation to signals a and b.
c <= a xnor b;	-- applies a logical xnor operation to signals a and b.
c <= not a;		-- applies not to a and writes the result to signal c.
```

Conversion functions:
```
to_bit       		=> Defined for std_ulogic/std_logic inputs, returns a bit output.
to_bitvector 		=> Defined for std_ulogic_vector/std_logic_vector inputs, returns a bit_vector output.
to_stdulogic        => Defined for bit inputs, returns a std_ulogic output.
to_stdlogicvector   => Defined for bit_vector/std_ulogic_vector inputs, returns a std_logic_vector output.				
to_stdulogicvector  => Defined for bit_vector/std_logic_vector inputs, returns a std_ulogic_vector output.
```

The operations performed by the functions above and examples of their use are given below.
```
b <= to_bit(a);-- signal a, declared as std_ulogic/std_logic, is converted to type bit and written to signal b, which is declared as type bit.
b <= to_bitvector(a);-- signal a, declared as std_ulogic_vector/std_logic_vector, is converted to type bit_vector and written to signal b, which is declared as type bit_vector.
b <= to_stdulogic(a);-- signal a, declared as type bit, is converted to type std_ulogic and written to signal b, which is declared as type std_ulogic.
b <= to_stdlogicvector(a);-- signal a, declared as bit_vector/std_ulogic_vector, is converted to type std_logic_vector and written to signal b, which is declared as type std_logic_vector.
b <= to_stdulogicvector(a);-- signal a, declared as bit_vector/std_logic_vector, is converted to type std_ulogic_vector and written to signal b, which is declared as type std_ulogic_vector.
```

Rising/falling edge detection functions:
```
They produce a BOOLEAN output only when the signal changes. They are frequently applied to the clock signal in synchronous design methodologies.

rising_edge  is defined for std_ulogic/std_logic inputs and returns a boolean output.
falling_edge is defined for std_ulogic/std_logic inputs and returns a boolean output.
```

The operations performed by the functions above and examples of their use are given below.
```
rising_edge(clk);-- returns the boolean value TRUE on the rising edge of the clk signal.
falling_edge(clk);-- returns the boolean value TRUE on the falling edge of the clk signal.

if rising_edge(clk) then--if the rising edge of the clk signal is detected, the section up to the "end if" line is executed.
	--the area where the operations to be performed at the moment the clk signal triggers are written.
end if;
```
For more detailed information about the types, functions and operators mentioned above, **["std_logic_1164.vhd"](https://github.com/seckinalbamya/seckinalbamya.github.io/blob/main/content/vhdl_libraries/std_logic_1164.vhd)** can be examined.

## numeric_std package

The "numeric_std" package, created by the IEEE, defines arithmetic functions for vector types in VHDL. Some of the functions it contains perform the same operations as those in the "std_logic_1164" library, but for the types they are defined on. 

The functions defined by the "numeric_std" package are given below.
```
"abs" => Defined for SIGNED inputs, returns a SIGNED output.
"-"   => Defined for SIGNED/UNSIGNED/NATURAL/INTEGER inputs, returns a SIGNED/UNSIGNED output.
"+"   => Defined for SIGNED/UNSIGNED/NATURAL/INTEGER inputs, returns a SIGNED/UNSIGNED output.
"*"   => Defined for SIGNED/UNSIGNED/NATURAL/INTEGER inputs, returns a SIGNED/UNSIGNED output.
"/"   => Defined for SIGNED/UNSIGNED/NATURAL/INTEGER inputs, returns a SIGNED/UNSIGNED output.
"rem" => Defined for SIGNED/UNSIGNED/NATURAL/INTEGER inputs, returns a SIGNED/UNSIGNED output.
"mod" => Defined for SIGNED/UNSIGNED/NATURAL/INTEGER inputs, returns a SIGNED/UNSIGNED output.
```

Comparison operators:
```
">"  => Defined for SIGNED/UNSIGNED/NATURAL/INTEGER inputs, returns a BOOLEAN output.
"<"  => Defined for SIGNED/UNSIGNED/NATURAL/INTEGER inputs, returns a BOOLEAN output.
"<=" => Defined for SIGNED/UNSIGNED/NATURAL/INTEGER inputs, returns a BOOLEAN output.
">=" => Defined for SIGNED/UNSIGNED/NATURAL/INTEGER inputs, returns a BOOLEAN output.
"="  => Defined for SIGNED/UNSIGNED/NATURAL/INTEGER inputs, returns a BOOLEAN output.
"/=" => Defined for SIGNED/UNSIGNED/NATURAL/INTEGER inputs, returns a BOOLEAN output.

 if a > b then --evaluates to TRUE if signal a is greater than signal b.
	--
 end if;
 if a >= b then --evaluates to TRUE if signal a is greater than or equal to signal b.
	--
 end if;
 if a < b then --evaluates to TRUE if signal a is less than signal b.
	--
 end if;
 if a <= b then --evaluates to TRUE if signal a is less than or equal to signal b.
	--
 end if;
 if a = b then --evaluates to TRUE if signal a is equal to signal b.
	--
 end if;
 if a /= b then --evaluates to TRUE if signal a is not equal to signal b.
	--
 end if;
```

Shift and rotate functions
```
"SHIFT_LEFT"  => Defined for inputs whose first parameter is SIGNED/UNSIGNED and whose second parameter is NATURAL, returns a SIGNED/UNSIGNED output.
"SHIFT_RIGHT" => Defined for inputs whose first parameter is SIGNED/UNSIGNED and whose second parameter is NATURAL, returns a SIGNED/UNSIGNED output.
"ROTATE_LEFT" => Defined for inputs whose first parameter is SIGNED/UNSIGNED and whose second parameter is NATURAL, returns a SIGNED/UNSIGNED output.
"ROTATE_RIGHT"=> Defined for inputs whose first parameter is SIGNED/UNSIGNED and whose second parameter is NATURAL, returns a SIGNED/UNSIGNED output.

"sll" => Defined for inputs whose first parameter is SIGNED/UNSIGNED and whose second parameter is INTEGER, returns a SIGNED/UNSIGNED output.
"srl" => Defined for inputs whose first parameter is SIGNED/UNSIGNED and whose second parameter is INTEGER, returns a SIGNED/UNSIGNED output.
"rol" => Defined for inputs whose first parameter is SIGNED/UNSIGNED and whose second parameter is INTEGER, returns a SIGNED/UNSIGNED output.
"ror" => Defined for inputs whose first parameter is SIGNED/UNSIGNED and whose second parameter is INTEGER, returns a SIGNED/UNSIGNED output.

It is recommended to prefer the SHIFT_LEFT, SHIFT_RIGHT, ROTATE_LEFT and ROTATE_RIGHT functions over the sll, srl, rol and ror operators.

b <= SHIFT_LEFT(a,n);----shifts signal a left by n bits and assigns '0' to the new values entering from the right.
b <= SHIFT_RIGHT(a,n);----shifts signal a right by n bits and assigns '0' to the new values entering from the left.
b <= ROTATE_LEFT(a,n);----shifts signal a left by n bits; the bits shifted out on the left are appended back to the signal on the far right. This is called rotating left.
b <= ROTATE_RIGHT(a,n);----shifts signal a right by n bits; the bits shifted out on the right are appended back to the signal on the far left. This is called rotating right.
 
b <= a sll n;----shifts signal a left by n bits and assigns '0' to the new values entering from the right.
b <= a srl n;----shifts signal a right by n bits and assigns '0' to the new values entering from the left.
b <= a rol n;----shifts signal a left by n bits; the bits shifted out on the left are appended back to the signal on the far right. This is called rotating left.
b <= a ror n;----shifts signal a right by n bits; the bits shifted out on the right are appended back to the signal on the far left. This is called rotating right.

let a <= SIGNED "10101".
b <= a sll 3;-- signal a is shifted left by 3 bits and the new bits entering from the right are set to '0'. Signal b then becomes "10100".
b <= a srl 3;-- signal a is shifted right by 3 bits and the new bits entering from the left are set to '0'. Signal b then becomes "00101".
b <= a ror 3;-- signal a is rotated right by 3 bits and the bits shifted out are written back in from the left. Signal b then becomes "01101".
b <= a rol 3;-- signal a is rotated left by 3 bits and the bits shifted out are written back in from the right. Signal b then becomes "10110".
```

Resize function:
```
"RESIZE"=> Defined for inputs whose first parameter is SIGNED/UNSIGNED and whose second parameter is NATURAL (and, additionally in VHDL 2008, SIGNED/UNSIGNED), returns a SIGNED/UNSIGNED output.
Used to change the size of a value. It resizes the first parameter according to the second parameter.
If the size shrinks, the requested number of bits is taken starting from the least significant bit; if the size grows, sign extension is applied for a SIGNED input and zero extension for an UNSIGNED input.
In VHDL 2008 a SIGNED/UNSIGNED vector can also be supplied as the length parameter. When a SIGNED/UNSIGNED input is given as the second parameter, the output has the same format as that second parameter.

let a be UNSIGNED "10011".
b <= resize(a,3);--b will then take the UNSIGNED value "011".
c <= resize(a,7);--c will then take the UNSIGNED value "0010011".

The declaration below is valid for VHDL 2008.
let d be a signal declared as UNSIGNED(7 downto 0).
e <= resize(a,d);--signal e is matched to the length of signal d. e will then take the UNSIGNED value "00010011".
```

Conversion functions:
```
to_integer  => Defined for SIGNED/UNSIGNED inputs, returns a NATURAL/INTEGER output.
to_unsigned => Defined for inputs whose first parameter is NATURAL and whose second parameter is NATURAL, returns a UNSIGNED output.
to_signed 	=> Defined for inputs whose first parameter is INTEGER and whose second parameter is NATURAL, returns a SIGNED output.
```

The operations performed by the functions above and examples of their use are given below.
```
b <= to_integer(a);	-- signal a, declared as SIGNED/UNSIGNED, is converted to type integer and written to signal b, which is declared as type integer.
b <= to_unsigned(a,length);-- signal a, declared as type NATURAL, is converted into an unsigned value made up of as many bits as the "length" parameter of type natural specifies, and written to signal b.
b <= to_signed(a,length);-- signal a, declared as type INTEGER, is converted into a signed value made up of as many bits as the "length" parameter of type natural specifies, and written to signal b.
```

Logical operators:
```
"not" => Defined for SIGNED/UNSIGNED inputs, returns a SIGNED/UNSIGNED output.
"and" => Defined for SIGNED/UNSIGNED inputs, returns a SIGNED/UNSIGNED output.
"or" => Defined for SIGNED/UNSIGNED inputs, returns a SIGNED/UNSIGNED output.
"nand" => Defined for SIGNED/UNSIGNED inputs, returns a SIGNED/UNSIGNED output.
"nor" => Defined for SIGNED/UNSIGNED inputs, returns a SIGNED/UNSIGNED output.
"xor" => Defined for SIGNED/UNSIGNED inputs, returns a SIGNED/UNSIGNED output.
"xnor" => Defined for SIGNED/UNSIGNED inputs, returns a SIGNED/UNSIGNED output.
```

The operations performed by the functions above and examples of their use are given below.
```
c <= a and b; 	-- applies a logical and operation to signals a and b.
c <= a nand b;	-- applies a logical nand operation to signals a and b.
c <= a or b;	-- applies a logical or operation to signals a and b. 
c <= a nor b;	-- applies a logical nor operation to signals a and b.
c <= a xor b;	-- applies a logical xor operation to signals a and b.
c <= a xnor b;	-- applies a logical xnor operation to signals a and b.
c <= not a;		-- applies not to a and writes the result to signal c.
```

For more detailed information about the functions and operators mentioned above, **["numeric_std.vhd"](https://github.com/seckinalbamya/seckinalbamya.github.io/blob/main/content/vhdl_libraries/numeric_std.vhd)** can be examined.

## std_logic_arith package

Besides the IEEE, which develops the VHDL standards, there is also a widely used package named "std_logic_arith" developed by Synopsys. 
Where possible, the packages published by the IEEE should be preferred over these Synopsys packages, since they are continuously updated and are developed by the body that defines the VHDL standards.

If the std_logic_arith package is to be used, the numeric_std package, which is defined for the same purposes, must not be used in the same code. Otherwise different functions called by the same name are likely to produce unintended results in the design.

The functions defined by the "std_logic_arith" package are given below.
```
"abs" => Defined for SIGNED inputs, returns a SIGNED/STD_LOGIC_VECTOR output.
"-"   => Defined for SIGNED/UNSIGNED/INTEGER inputs, returns a SIGNED/UNSIGNED/STD_LOGIC_VECTOR output.
"+"   => Defined for SIGNED/UNSIGNED/INTEGER inputs, returns a SIGNED/UNSIGNED/STD_LOGIC_VECTOR output.
"*"   => Defined for SIGNED/UNSIGNED/INTEGER inputs, returns a SIGNED/UNSIGNED/STD_LOGIC_VECTOR output.
```

Comparison operators:
```
">"  => Defined for SIGNED/UNSIGNED/INTEGER inputs, returns a BOOLEAN output.
"<"  => Defined for SIGNED/UNSIGNED/INTEGER inputs, returns a BOOLEAN output.
"<=" => Defined for SIGNED/UNSIGNED/INTEGER inputs, returns a BOOLEAN output.
">=" => Defined for SIGNED/UNSIGNED/INTEGER inputs, returns a BOOLEAN output.
"="  => Defined for SIGNED/UNSIGNED/INTEGER inputs, returns a BOOLEAN output.
"/=" => Defined for SIGNED/UNSIGNED/INTEGER inputs, returns a BOOLEAN output.
```

The operations performed by the functions above and examples of their use are given below.
```
 if a > b then --evaluates to TRUE if signal a is greater than signal b.
	--
 end if;
 if a >= b then --evaluates to TRUE if signal a is greater than or equal to signal b.
	--
 end if;
 if a < b then --evaluates to TRUE if signal a is less than signal b.
	--
 end if;
 if a <= b then --evaluates to TRUE if signal a is less than or equal to signal b.
	--
 end if;
 if a = b then --evaluates to TRUE if signal a is equal to signal b.
	--
 end if;
 if a /= b then --evaluates to TRUE if signal a is not equal to signal b.
	--
 end if;
```

Conversion functions:
```
CONV_INTEGER  			=> Defined for INTEGER/SIGNED/UNSIGNED/STD_ULOGIC inputs, returns a INTEGER output.
CONV_UNSIGNED 			=> Defined for inputs whose first parameter is INTEGER/SIGNED/UNSIGNED/STD_ULOGIC and whose second parameter is INTEGER, returns a UNSIGNED output.
CONV_SIGNED				=> Defined for inputs whose first parameter is INTEGER/SIGNED/UNSIGNED/STD_ULOGIC and whose second parameter is INTEGER, returns a SIGNED output.
CONV_STD_LOGIC_VECTOR 	=> Defined for inputs whose first parameter is INTEGER and whose second parameter is NATURAL, returns a SIGNED output.
EXT 					=> Defined for inputs whose first parameter is STD_LOGIC_VECTOR and whose second parameter is INTEGER, returns a STD_LOGIC_VECTOR output.
SXT 					=> Defined for inputs whose first parameter is STD_LOGIC_VECTOR and whose second parameter is INTEGER, returns a STD_LOGIC_VECTOR output.
```

The operations performed by the functions above and examples of their use are given below.
```
b <= CONV_INTEGER(a);-- signal a, declared as INTEGER/SIGNED/UNSIGNED/STD_ULOGIC, is converted to type integer and written to signal b, which is declared as type integer.
b <= CONV_UNSIGNED(a,length);-- signal a, declared as INTEGER/SIGNED/UNSIGNED/STD_ULOGIC, is converted into an unsigned value made up of as many bits as the "length" parameter of type natural specifies, and written to signal b.
b <= CONV_SIGNED(a,length);-- signal a, declared as INTEGER/SIGNED/UNSIGNED/STD_ULOGIC, is converted into a signed value made up of as many bits as the "length" parameter of type natural specifies, and written to signal b.
b <= CONV_STD_LOGIC_VECTOR(a,length);-- signal a, declared as type INTEGER, is converted into a std_logic_vector made up of as many bits as the "length" parameter of type natural specifies, and written to signal b. 
b <= EXT(a,length);-- Used to change the size of a value. If the size set by the length parameter shrinks, the requested number of bits is taken starting from the least significant bit; if the size grows,
zero extension is applied to the additional bits.
b <= SXT(a,length);-- Used to change the size of a value. If the size set by the length parameter shrinks, the requested number of bits is taken starting from the least significant bit; if the size grows,
sign extension is applied to the additional bits.
```

For more detailed information about the functions and operators mentioned above, **["std_logic_arith.vhd"](https://github.com/seckinalbamya/seckinalbamya.github.io/blob/main/content/vhdl_libraries/std_logic_arith.vhd)** can be examined.

## std_logic_signed and std_logic_unsigned packages

The "std_logic_signed" and "std_logic_unsigned" packages developed by Synopsys, which are used to perform arithmetic on std_logic_vector values, and the functions they contain are given below.

Although both libraries provide the same functions, the std_logic_signed package interprets std_logic_vector values as two's complement signed integers, whereas the std_logic_unsigned package interprets them as unsigned integers.

Since they have not been published as a standard by the IEEE, their use is not recommended; if they are to be used, care must be taken not to declare the std_logic_signed and std_logic_unsigned packages at the same time.

```
"+"   => Defined for STD_LOGIC_VECTOR/INTEGER inputs, returns a STD_LOGIC_VECTOR output.
"-"   => Defined for STD_LOGIC_VECTOR/INTEGER inputs, returns a STD_LOGIC_VECTOR output.
"*"   => Defined for STD_LOGIC_VECTOR inputs, returns a STD_LOGIC_VECTOR output.
```

Comparison operators:
```
">"  => Defined for STD_LOGIC_VECTOR/INTEGER inputs, returns a BOOLEAN output.
"<"  => Defined for STD_LOGIC_VECTOR/INTEGER inputs, returns a BOOLEAN output.
"<=" => Defined for STD_LOGIC_VECTOR/INTEGER inputs, returns a BOOLEAN output.
">=" => Defined for STD_LOGIC_VECTOR/INTEGER inputs, returns a BOOLEAN output.
"="  => Defined for STD_LOGIC_VECTOR/INTEGER inputs, returns a BOOLEAN output.
"/=" => Defined for STD_LOGIC_VECTOR/INTEGER inputs, returns a BOOLEAN output.
```

The operations performed by the functions above and examples of their use are given below.
```
 if a > b then --evaluates to TRUE if signal a is greater than signal b.
	--
 end if;
 if a >= b then --evaluates to TRUE if signal a is greater than or equal to signal b.
	--
 end if;
 if a < b then --evaluates to TRUE if signal a is less than signal b.
	--
 end if;
 if a <= b then --evaluates to TRUE if signal a is less than or equal to signal b.
	--
 end if;
 if a = b then --evaluates to TRUE if signal a is equal to signal b.
	--
 end if;
 if a /= b then --evaluates to TRUE if signal a is not equal to signal b.
	--
 end if;
```

Shift functions:
```
"SHL" => Defined for inputs whose first parameter is STD_LOGIC_VECTOR and whose second parameter is STD_LOGIC_VECTOR, returns a STD_LOGIC_VECTOR output.
"SHR" => Defined for inputs whose first parameter is STD_LOGIC_VECTOR and whose second parameter is STD_LOGIC_VECTOR, returns a STD_LOGIC_VECTOR output.

b <= a SHL 	n;----shifts signal a left by n bits and assigns '0' to the new values entering from the right.
b <= a SHR	n;----shifts signal a right by n bits and assigns '0' to the new values entering from the left.
```

Conversion function:
```
CONV_INTEGER  			=> Defined for STD_LOGIC_VECTOR inputs, returns a INTEGER output.
```

The operation performed by the function above and an example of its use are given below.
```
b <= CONV_INTEGER(a);-- signal a, declared as STD_LOGIC_VECTOR, is converted to type integer and written to signal b, which is declared as type integer.
```

For more detailed information about the functions and operators mentioned above, **["std_logic_signed.vhd"](https://github.com/seckinalbamya/seckinalbamya.github.io/blob/main/content/vhdl_libraries/std_logic_signed.vhd)** and **["std_logic_unsigned.vhd"](https://github.com/seckinalbamya/seckinalbamya.github.io/blob/main/content/vhdl_libraries/std_logic_unsigned.vhd)** can be examined.

-- $Id: standard.vhd,v 1.1 2003/01/17 19:41:54 kumar Exp $
package STANDARD is

	-- predefined enumeration types:

	type BOOLEAN is (FALSE, TRUE);

	type BIT is ('0', '1');

	type CHARACTER is (
		NUL,	SOH,	STX,	ETX,	EOT,	ENQ,	ACK,	BEL,
		BS,	HT,	LF,	VT,	FF,	CR,	SO,	SI,
		DLE,	DC1,	DC2,	DC3,	DC4,	NAK,	SYN,	ETB,
		CAN,	EM,	SUB,	ESC,	FSP,	GSP,	RSP,	USP,

		' ',	'!',	'"',	'#',	'$',	'%',	'&',	''',
		'(',	')',	'*',	'+',	',',	'-',	'.',	'/',
		'0',	'1',	'2',	'3',	'4',	'5',	'6',	'7',
		'8',	'9',	':',	';',	'<',	'=',	'>',	'?',

		'@',	'A',	'B',	'C',	'D',	'E',	'F',	'G',
		'H',	'I',	'J',	'K',	'L',	'M',	'N',	'O',
		'P',	'Q',	'R',	'S',	'T',	'U',	'V',	'W',
		'X',	'Y',	'Z',	'[',	'\',	']',	'^',	'_',

		'`',	'a',	'b',	'c',	'd',	'e',	'f',	'g',
		'h',	'i',	'j',	'k',	'l',	'm',	'n',	'o',
		'p',	'q',	'r',	's',	't',	'u',	'v',	'w',
		'x',	'y',	'z',	'{',	'|',	'}',	'~',	DEL,

	        C128,   C129,   C130,   C131,   C132,   C133,   C134,   C135,
	        C136,   C137,   C138,   C139,   C140,   C141,   C142,   C143,
	        C144,   C145,   C146,   C147,   C148,   C149,   C150,   C151,
	        C152,   C153,   C154,   C155,   C156,   C157,   C158,   C159,

		'�',   '�',   '�',   '�',   '�',   '�',   '�',   '�',
	        '�',   '�',   '�',   '�',   '�',   '�',   '�',   '�',
	        '�',   '�',   '�',   '�',   '�',   '�',   '�',   '�',
	        '�',   '�',   '�',   '�',   '�',   '�',   '�',   '�',
	        '�',   '�',   '�',   '�',   '�',   '�',   '�',   '�',
	        '�',   '�',   '�',   '�',   '�',   '�',   '�',   '�',
	        '�',   '�',   '�',   '�',   '�',   '�',   '�',   '�',
	        '�',   '�',   '�',   '�',   '�',   '�',   '�',   '�',
	        '�',   '�',   '�',   '�',   '�',   '�',   '�',   '�',
	        '�',   '�',   '�',   '�',   '�',   '�',   '�',   '�',
	        '�',   '�',   '�',   '�',   '�',   '�',   '�',   '�',
	        '�',   '�',   '�',   '�',   '�',   '�',   '�',   '�'    );

	type SEVERITY_LEVEL is (NOTE, WARNING, ERROR, FAILURE);
     
	type FILE_OPEN_KIND is (READ_MODE, WRITE_MODE, APPEND_MODE);

	type FILE_OPEN_STATUS is (OPEN_OK, STATUS_ERROR, NAME_ERROR, MODE_ERROR);

	-- predefined numeric types:

	type INTEGER is range -2147483648 to 2147483647;

	type REAL is range -1.7014111e+308 to 1.7014111e+308;

	-- predefined type TIME:

	type TIME is range -2147483647 to 2147483647
	-- this declaration is for the convenience of the parser.  Internally
	-- the parser treats it as if the range were:
	--      range -9223372036854775807 to 9223372036854775807
	units
		fs;			-- femtosecond
		ps	= 1000 fs; 	-- picosecond
		ns	= 1000 ps; 	-- nanosecond
		us	= 1000 ns; 	-- microsecond
		ms	= 1000 us;	-- millisecond
		sec	= 1000 ms;	-- second
		min	=   60 sec;	-- minute
		hr	=   60 min;	-- hour
	end units;

	subtype DELAY_LENGTH is TIME range 0 fs to TIME'HIGH;

	-- function that returns the current simulation time:

	function NOW return DELAY_LENGTH;

	-- predefined numeric subtypes:

	subtype NATURAL is INTEGER range 0 to INTEGER'HIGH;

	subtype POSITIVE is INTEGER range 1 to INTEGER'HIGH;

	-- predefined array types:

	type STRING is array (POSITIVE range <>) of CHARACTER;

	type BIT_VECTOR is array (NATURAL range <>) of BIT;

        attribute FOREIGN: STRING;
end STANDARD;

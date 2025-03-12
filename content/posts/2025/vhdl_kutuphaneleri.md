---
title: "VHDL'de Kütüphaneler ve İçerdikleri Fonksiyonlar"
date: 12/03/2025
slug: /vhdl_kutuphaneleri/
description: VHDL'de Kütüphaneler ve İçerdikleri Fonksiyonlar
image: images/brent-cox-ydGRmobx5jA-unsplash.jpg
caption: Photo by Brentcox on Unsplash
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

VHDL kullanılarak yapılan bir tasarımda bir tanımlamaya ihtiyaç duyulmaksızın "standard" package tanımlı olarak gelmektedir. Standard package'ın
tanımladığı type çeşitleri aşağıda verilmiştir.	

```
bit      	<= '0' ve '1' mantıksal değerini alabilen type'tır.
bit_vector	<= '0' ve '1' mantıksal değeri alabilen ardışık dizilerden oluşan çok sayıda bit type'tır.
integer  	<= Tamsayılar için kullanılan type'tır. Sınırları belirtilmedikçe varsayılan olarak [-2147483648,2147483647] arasında değer alabilir.
natural  	<= Tamsayılar için kullanılan type'tır. Sınırları belirtilmedikçe varsayılan olarak [0,2147483647] arasında değer alabilir.
positive	<= Tamsayılar için kullanılan type'tır. Sınırları belirtilmedikçe varsayılan olarak [1,2147483647] arasında değer alabilir.
boolean  	<= Koşullu ifadeler için kullanılan, "false" veya "true" değeri alabilen type'tır.
real     	<= Ondalıklı sayılar için kullanılır. Simülasyon için kullanılan, gerçek donanıma sentezlenemeyen bir type'tır. Sınırları belirtilmedikçe varsayılan olarak [-1.7014111e+308,1.7014111e+308] arasında değer alabilir.
time		<= Simülasyonlarda zamanı temsil etmek için kullanılmaktadır. Simülasyon için kullanılan, gerçek donanıma sentezlenemeyen bir type'tır.
character	<= Karakterleri temsil etmek için kullanılan type'tır.
string		<= Karakter dizilerini temsil etmek için kullanılan type'tır.
```

Yukarıda bahsedilen type'lar hakkında daha detaylı bilgiye ulaşmak için **["standard.vhd"](https://github.com/antlr/grammars-v4/blob/master/vhdl/examples/standard.vhd)** incelenebilir.

## std_logic_1164 package

IEEE tarafından 1993 yılında yayınlanan bir package'tır. Dijital elektronik sinyallerin davranışını '0' ve '1' dışındaki elektriksel davranışlarını modelleyebilen type çeşitleri içermektedir. "std_logic_1164" package, std_logic/std_ulogic ve bu türlerin vektörleri için aritmetik fonksiyonlar tanımlar. İçerisinde yer alan bazı fonksiyonlar "numeric_std" kütüphanesi ile aynı işlevleri, kendi tanımlı oldukları type için yerine getirmektedir. 

Aşağıda yer alan satırlar kodun tanımlama bölümüne eklenerek kullanılabilir.
```
library IEEE;
use IEEE.std_logic_1164.all;
```

"std_logic_1164" package'ın tanımladığı type çeşitleri aşağıda verilmiştir.

```
std_ulogic			<= 'U','X''0','1','Z','W','L','H','-' değerleri alabilen type'tır.
std_ulogic_vector   <= 'U','X''0','1','Z','W','L','H','-' değerleri alabilen, çok sayısa std_ulogic'ten oluşan type'tır.
std_logic			<= Resolved std_ulogic type'tır. std_ulogic ile aynı değerleri alabilir.
std_logic_vector    <= Resolved std_ulogic type'tır. std_ulogic_vector ile aynı değerleri alabilir.
```

Eğer std_ulogic/std_ulogic_vector kullanarak aynı sinyale iki değer tanımlaması yapılırsa "multiple driver" hatası alınır.
Resolved fonksiyonu bu durumda bir hata oluşturmak yerine daha önceden tanımlanmış bir tabloya göre çıktı oluşturmaktadır.

std_ulogic/std_logic ve std_ulogic_vector/std_logic_vector type'larının alabileceği değerler aşağıda verilmiştir.

```
'U' => Herhangi bir değer atanmamış değerdir.
'X' => Kuvvetli bilinmeyen
'0' => Kuvvetli '0'
'1' => Kuvvetli '1'
'Z' => Yüksek empedans 
'W' => Zayıf bilinmeyen
'L' => Zayıf '0'     
'H' => Zayıf '1'     
'-' => Farketmez('1' ya da '0')
```

std_logic_1164 package'da tanımlanan fonksiyonlar ve destekledikleri türler aşağıda verilmiştir.

Mantıksal işlem fonksiyonları:
```
and		 => std_ulogic/std_logic/std_ulogic_vector/std_logic_vector	türünde girdiler için tanımlıdır, ('U','X','0','1') çıkış değerlerini alabilir.
nand	 => std_ulogic/std_logic/std_ulogic_vector/std_logic_vector	türünde girdiler için tanımlıdır, ('U','X','0','1') çıkış değerlerini alabilir.
or		 => std_ulogic/std_logic/std_ulogic_vector/std_logic_vector	türünde girdiler için tanımlıdır, ('U','X','0','1') çıkış değerlerini alabilir.
nor		 => std_ulogic/std_logic/std_ulogic_vector/std_logic_vector	türünde girdiler için tanımlıdır, ('U','X','0','1') çıkış değerlerini alabilir.
xor  	 => std_ulogic/std_logic/std_ulogic_vector/std_logic_vector	türünde girdiler için tanımlıdır, ('U','X','0','1') çıkış değerlerini alabilir.
xnor 	 => std_ulogic/std_logic/std_ulogic_vector/std_logic_vector	türünde girdiler için tanımlıdır, ('U','X','0','1') çıkış değerlerini alabilir.
not  	 => std_ulogic/std_logic/std_ulogic_vector/std_logic_vector	türünde girdiler için tanımlıdır, ('U','X','0','1') çıkış değerlerini alabilir.
```

Yukarıdaki fonksiyonların yaptığı işlemler ve kullanım örnekleri aşağıda verilmiştir.

```
c <= a and b; 	-- a ve b sinyallerine mantıksal and işlemi uygular.
c <= a nand b;	-- a ve b sinyallerine mantıksal nand işlemi uygular.
c <= a or b;	-- a ve b sinyallerine mantıksal or işlemi uygular. 
c <= a nor b;	-- a ve b sinyallerine mantıksal nor işlemi uygular.
c <= a xor b;	-- a ve b sinyallerine mantıksal xor işlemi uygular.
c <= a xnor b;	-- a ve b sinyallerine mantıksal xnor işlemi uygular.
c <= not a;		-- a değerine not uygulayarak c sinyalina yazar.
```

Dönüşüm fonksiyonları:
```
to_bit       		=> std_ulogic/std_logic türünde girdiler için tanımlıdır, bit türünde çıkış verir.
to_bitvector 		=> std_ulogic_vector/std_logic_vector türünde girdiler için tanımlıdır, bit_vector türünde çıkış verir.
to_stdulogic        => bit türünde girdiler için tanımlıdır, std_ulogic türünde çıkış verir.
to_stdlogicvector   => bit_vector/std_ulogic_vector türünde girdiler için tanımlıdır, std_logic_vector türünde çıkış verir.				
to_stdulogicvector  => bit_vector/std_logic_vector türünde girdiler için tanımlıdır, std_ulogic_vector türünde çıkış verir.
```

Yukarıdaki fonksiyonların yaptığı işlemler ve kullanım örnekleri aşağıda verilmiştir.
```
b <= to_bit(a);-- std_ulogic/std_logic type tanımlanan a sinyali bit type'a çevrilerek bit type olarak tanımlanan b siyanline yazılıyor.
b <= to_bitvector(a);-- std_ulogic_vector/std_logic_vector type tanımlanan a sinyali bit_vector type'a çevrilerek bit_vector type olarak tanımlanan b siyanline yazılıyor.
b <= to_stdulogic(a);-- std_ulogic/std_logic type tanımlanan a sinyali bit type'a çevrilerek bit type olarak tanımlanan b siyanline yazılıyor.
b <= to_stdlogicvector(a);-- bit_vector/std_ulogic_vector type tanımlanan a sinyali std_logic_vector type'a çevrilerek std_logic_vector type olarak tanımlanan b siyanline yazılıyor.
b <= to_stdulogicvector(a);-- bit_vector/std_logic_vector type tanımlanan a sinyali std_ulogic_vector type'a çevrilerek std_ulogic_vector type olarak tanımlanan b siyanline yazılıyor.
```

Yükselen/düşen kenar (edge) tespit fonksiyonları:
```
Sinyalin yalnızca değişiminde BOOLEAN türünde çıktı üretir. Sıklıkla senkron dizayn metodolojilerinde clock sinyaline bağlanarak kullanılır.

rising_edge  std_ulogic/std_logic türünde girdiler için tanımlıdır, boolean türünde çıkış verir.
falling_edge std_ulogic/std_logic türünde girdiler için tanımlıdır, boolean türünde çıkış verir.
```

Yukarıdaki fonksiyonların yaptığı işlemler ve kullanım örnekleri aşağıda verilmiştir.
```
rising_edge(clk);-- clk sinyalinin yükselen kenarında TRUE boolean değerini döndürür.
fallin_edge(clk);-- clk sinyalinin düşen kenarında TRUE boolean değerini döndürür.

if rising_edge(clk) then--clk sinyalinin yükselen kenarı doğruysa "end if" satırına kadar olan bölüm işlenir.
	--clk sinyalinin ilk tetiklendiği anda gerçekleşmesi istenen işlemlerin yazılacağı alan.
end if;
```
Yukarıda bahsedilen type'lar, fonksiyonlar ve operatörler hakkında daha detaylı bilgiye ulaşmak için **["std_logic_1164.vhd"](https://github.com/antlr/grammars-v4/blob/master/vhdl/examples/std_logic_1164.vhd)** incelenebilir.

## numeric_std package

IEEE tarafından oluşturulan "numeric_std" package, VHDL'de vector türü için aritmetik fonksiyonlar tanımlar. İçerisinde yer alan bazı fonksiyonlar "std_logic_1164" kütüphanesi ile aynı işlevleri, kendi tanımlı oldukları type için yerine getirmektedir. 

"numeric_std" package'ın tanımladığı fonksiyonlar aşağıda verilmiştir.
```
"abs" => SIGNED türünde girdiler için tanımlıdır, SIGNED türünde çıkış verir.
"-"   => SIGNED/UNSIGNED/NATURAL/INTEGER türünde girdiler için tanımlıdır, SIGNED/UNSIGNED türünde çıkış verir.
"+"   => SIGNED/UNSIGNED/NATURAL/INTEGER türünde girdiler için tanımlıdır, SIGNED/UNSIGNED türünde çıkış verir.
"*"   => SIGNED/UNSIGNED/NATURAL/INTEGER türünde girdiler için tanımlıdır, SIGNED/UNSIGNED türünde çıkış verir.
"/"   => SIGNED/UNSIGNED/NATURAL/INTEGER türünde girdiler için tanımlıdır, SIGNED/UNSIGNED türünde çıkış verir.
"rem" => SIGNED/UNSIGNED/NATURAL/INTEGER türünde girdiler için tanımlıdır, SIGNED/UNSIGNED türünde çıkış verir.
"mod" => SIGNED/UNSIGNED/NATURAL/INTEGER türünde girdiler için tanımlıdır, SIGNED/UNSIGNED türünde çıkış verir.
```

Kıyaslama operatörleri:
```
">"  => SIGNED/UNSIGNED/NATURAL/INTEGER türünde girdiler için tanımlıdır, BOOLEAN türünde çıkış verir.
"<"  => SIGNED/UNSIGNED/NATURAL/INTEGER türünde girdiler için tanımlıdır, BOOLEAN türünde çıkış verir.
"<=" => SIGNED/UNSIGNED/NATURAL/INTEGER türünde girdiler için tanımlıdır, BOOLEAN türünde çıkış verir.
">=" => SIGNED/UNSIGNED/NATURAL/INTEGER türünde girdiler için tanımlıdır, BOOLEAN türünde çıkış verir.
"="  => SIGNED/UNSIGNED/NATURAL/INTEGER türünde girdiler için tanımlıdır, BOOLEAN türünde çıkış verir.
"/=" => SIGNED/UNSIGNED/NATURAL/INTEGER türünde girdiler için tanımlıdır, BOOLEAN türünde çıkış verir.

 if a > b then --a sinyali b sinyalinden büyükse TRUE olarak değer alır.
	--
 end if;
 if a >= b then --a sinyali b sinyalinden büyük veya eşitse TRUE olarak değer alır.
	--
 end if;
 if a > b then --a sinyali b sinyalinden küçükse TRUE olarak değer alır.
	--
 end if;
 if a > b then --a sinyali b sinyalinden küçükse veya eşitse TRUE olarak değer alır.
	--
 end if;
 if a = b then --a sinyali b sinyaline eşitse TRUE olarak değer alır.
	--
 end if;
 if a /= b then --a sinyali b sinyaline eşit değilse TRUE olarak değer alır.
	--
 end if;
```

Shift (kaydırma) ve Rotate (çevirme) fonksiyonları
```
"SHIFT_LEFT"  => İlk parametresi SIGNED/UNSIGNED, ikinci parametresi NATURAL türünde girdiler için tanımlıdır, SIGNED/UNSIGNED türünde çıkış verir.
"SHIFT_RIGHT" => İlk parametresi SIGNED/UNSIGNED, ikinci parametresi NATURAL türünde girdiler için tanımlıdır, SIGNED/UNSIGNED türünde çıkış verir.
"ROTATE_LEFT" => İlk parametresi SIGNED/UNSIGNED, ikinci parametresi NATURAL türünde girdiler için tanımlıdır, SIGNED/UNSIGNED türünde çıkış verir.
"ROTATE_RIGHT"=> İlk parametresi SIGNED/UNSIGNED, ikinci parametresi NATURAL türünde girdiler için tanımlıdır, SIGNED/UNSIGNED türünde çıkış verir.

"sll" => İlk parametresi SIGNED/UNSIGNED, ikinci parametresi INTEGER türünde girdiler için tanımlıdır, SIGNED/UNSIGNED türünde çıkış verir.
"srl" => İlk parametresi SIGNED/UNSIGNED, ikinci parametresi INTEGER türünde girdiler için tanımlıdır, SIGNED/UNSIGNED türünde çıkış verir.
"rol" => İlk parametresi SIGNED/UNSIGNED, ikinci parametresi INTEGER türünde girdiler için tanımlıdır, SIGNED/UNSIGNED türünde çıkış verir.
"ror" => İlk parametresi SIGNED/UNSIGNED, ikinci parametresi INTEGER türünde girdiler için tanımlıdır, SIGNED/UNSIGNED türünde çıkış verir.

SHIFT_LEFT,SHIFT_RIGHT,ROTATE_LEFT ve ROTATE_RIGHT fonksiyonlarını, sll,srl,rol ve ror fonksiyonları yerine tercih edilmesi önerilir.

b <= a SHIFT_LEFT 	n;----a sinyalini n bit sola kaydırır ve sağdan gelen yeni değerlere '0' ataması yapar.
b <= a SHIFT_RIGHT	n;----a sinyalini n bit sağa kaydırır ve soldan gelen yeni değerlere '0' ataması yapar.
b <= a ROTATE_LEFT 	n;----a sinyalini n bit sola kaydırır, sola kaydılırlan bitler en sağdan sinyale geri eklenir. Sola döndürme olarak adlandırılır.
b <= a ROTATE_RIGHT n;----a sinyalini n bit sağa kaydırır, sağa kaydılırlan bitler en soldan sinyale geri eklenir. Sağa döndürme olarak adlandırılır.
 
b <= a sll n;----a sinyalini n bit sola kaydırır ve sağdan gelen yeni değerlere '0' ataması yapar.
b <= a srl n;----a sinyalini n bit sağa kaydırır ve soldan gelen yeni değerlere '0' ataması yapar.
b <= a rol n;----a sinyalini n bit sola kaydırır, sola kaydılırlan bitler en sağdan sinyale geri eklenir. Sola döndürme olarak adlandırılır.
b <= a ror n;----a sinyalini n bit sağa kaydırır, sağa kaydılırlan bitler en soldan sinyale geri eklenir. Sağa döndürme olarak adlandırılır.

a <= SIGNED "10101"olsun.
b <= a sll 3;-- a sinyali 3 bit sola kaydırılır ve sağdan gelen yeni bitlere '0' değeri yazılır. Son durumda b sinyali "10100" olur.
b <= a srl 3;-- a sinyali 3 bit sağa kaydırılır ve soldan gelen yeni bitlere '0' değeri yazılır. Son durumda b sinyali "00101" olur.
b <= a ror 3;-- a sinyali 3 bit sağa kaydırılır ve sola kaydırılan bitler sağdan kaydırılarak yazılır. Son durumda b sinyali "01101" olur.
b <= a srl 3;-- a sinyali 3 bit sağa kaydırılır ve soldan gelen yeni bitlere '0' değeri yazılır. Son durumda b sinyali "10110" olur.
```

Resize (yeniden boyutlandırma) foknsiyonu:
```
"RESIZE"=> İlk parametresi SIGNED/UNSIGNED ikinci parametresi NATURAL türünde girdiler için tanımlıdır, SIGNED/UNSIGNED türünde çıkış verir.
Boyut değiştirmek için kullanılır. Boyut küçülüyorsa en az değerli bitten itibaren istenen miktarda bit alınır, boyut büyüyor ise SIGNED giriş için işaretli (sext, sign extended), UNSIGNED giriş için 
sıfırla genişletme (zero extended) uygulanır. 

a UNSIGNED "10011" olsun.
b <= resize(a,3);--Son durumda b UNSIGNED "011" değerini alacaktır.
c UNSIGNED "10011" olsun.
d <= resize(c,7);--Son durumda d UNSIGNED "0010011" değerini alacaktır.
```

Dönüştürme fonksiyonları:
```
to_integer  => SIGNED/UNSIGNED türünde girdiler için tanımlıdır, NATURAL/INTEGER türünde çıkış verir.
to_unsigned => İlk parametresi NATURAL, ikinci parametresi NATURAL türünde girdiler için tanımlıdır, UNSIGNED türünde çıkış verir.
to_signed 	=> İlk parametresi INTEGER, ikinci parametresi NATURAL türünde girdiler için tanımlıdır, SIGNED türünde çıkış verir.
```

Yukarıdaki fonksiyonların yaptığı işlemler ve kullanım örnekleri aşağıda verilmiştir.
```
b <= to_integer(a);	-- SIGNED/UNSIGNED type tanımlanan a sinyali integer type'a çevrilerek integer type olarak tanımlanan b siyanline yazılıyor.
b <= to_unsigned(a,length);-- NATURAL type tanımlanan a sinyali bit_vector type'a çevrilerek natural type tanımlanan "lengh" parametresi miktarınca bitten oluşan unsigned type'a çevrilip b sinyaline yazılır.
b <= to_unsigned(a,length);-- INTEGER type tanımlanan a sinyali bit_vector type'a çevrilerek natural type tanımlanan "lengh" parametresi miktarınca bitten oluşan signed type'a çevrilip b sinyaline yazılır.
```

Mantıksal operatörler:
```
"not" => SIGNED/UNSIGNED türünde girdiler için tanımlıdır, SIGNED/UNSIGNED türünde çıkış verir.
"and" => SIGNED/UNSIGNED türünde girdiler için tanımlıdır, SIGNED/UNSIGNED türünde çıkış verir.
"or" => SIGNED/UNSIGNED türünde girdiler için tanımlıdır, SIGNED/UNSIGNED türünde çıkış verir.
"nand" => SIGNED/UNSIGNED türünde girdiler için tanımlıdır, SIGNED/UNSIGNED türünde çıkış verir.
"nor" => SIGNED/UNSIGNED türünde girdiler için tanımlıdır, SIGNED/UNSIGNED türünde çıkış verir.
"xor" => SIGNED/UNSIGNED türünde girdiler için tanımlıdır, SIGNED/UNSIGNED türünde çıkış verir.
"xnor" => SIGNED/UNSIGNED türünde girdiler için tanımlıdır, SIGNED/UNSIGNED türünde çıkış verir.
```

Yukarıdaki fonksiyonların yaptığı işlemler ve kullanım örnekleri aşağıda verilmiştir.
```
c <= a and b; 	-- a ve b sinyallerine mantıksal and işlemi uygular.
c <= a nand b;	-- a ve b sinyallerine mantıksal nand işlemi uygular.
c <= a or b;	-- a ve b sinyallerine mantıksal or işlemi uygular. 
c <= a nor b;	-- a ve b sinyallerine mantıksal nor işlemi uygular.
c <= a xor b;	-- a ve b sinyallerine mantıksal xor işlemi uygular.
c <= a xnor b;	-- a ve b sinyallerine mantıksal xnor işlemi uygular.
c <= not a;		-- a değerine not uygulayarak c sinyalina yazar.
```

Yukarıda bahsedilen fonksiyonlar ve operatörler hakkında daha detaylı bilgiye ulaşmak için **["numeric_std.vhd"](https://github.com/antlr/grammars-v4/blob/master/vhdl/examples/numeric_std.vhd)** incelenebilir.

## std_logic_arith package

VHDL standartlarını geliştiren IEEE dışında, Synopsys tarafından geliştirilen ve yaygın olarak kullanılan "std_logic_arith" adlı package da bulunmaktadır. 
Mümkünse IEEE'nin yayınladığı package'lar (sürekli güncellendiği, VHDL standartlarını belirleyen kurum tarafından geliştirildikleri için) Synopsys tarafından geliştirilen bu package'lara tercih edilmelidir.

Eğer std_logic_arith package kullanılacak ise, aynı amaçlar için tanımlanmış numeric_std package aynı kod yapısında kullanılmamalıdır. Aksi taktirde aynı isimle çağırılan farklı fonksiyonların tasarımda istenmeyen sonuçlar üretmesi muhtemeldir.

"std_logic_arith" package'ın tanımladığı fonksiyonlar aşağıda verilmiştir.
```
"abs" => SIGNED türünde girdiler için tanımlıdır, SIGNED/STD_LOGIC_VECTOR türünde çıkış verir.
"-"   => SIGNED/UNSIGNED/INTEGER türünde girdiler için tanımlıdır, SIGNED/UNSIGNED/STD_LOGIC_VECTOR türünde çıkış verir.
"+"   => SIGNED/UNSIGNED/INTEGER türünde girdiler için tanımlıdır, SIGNED/UNSIGNED/STD_LOGIC_VECTOR türünde çıkış verir.
"*"   => SIGNED/UNSIGNED/INTEGER türünde girdiler için tanımlıdır, SIGNED/UNSIGNED/STD_LOGIC_VECTOR türünde çıkış verir.
```

Kıyaslama operatörleri:
```
">"  => SIGNED/UNSIGNED/INTEGER türünde girdiler için tanımlıdır, BOOLEAN türünde çıkış verir.
"<"  => SIGNED/UNSIGNED/INTEGER türünde girdiler için tanımlıdır, BOOLEAN türünde çıkış verir.
"<=" => SIGNED/UNSIGNED/INTEGER türünde girdiler için tanımlıdır, BOOLEAN türünde çıkış verir.
">=" => SIGNED/UNSIGNED/INTEGER türünde girdiler için tanımlıdır, BOOLEAN türünde çıkış verir.
"="  => SIGNED/UNSIGNED/INTEGER türünde girdiler için tanımlıdır, BOOLEAN türünde çıkış verir.
"/=" => SIGNED/UNSIGNED/INTEGER türünde girdiler için tanımlıdır, BOOLEAN türünde çıkış verir.
```

Yukarıdaki fonksiyonların yaptığı işlemler ve kullanım örnekleri aşağıda verilmiştir.
```
 if a > b then --a sinyali b sinyalinden büyükse TRUE olarak değer alır.
	--
 end if;
 if a >= b then --a sinyali b sinyalinden büyük veya eşitse TRUE olarak değer alır.
	--
 end if;
 if a > b then --a sinyali b sinyalinden küçükse TRUE olarak değer alır.
	--
 end if;
 if a > b then --a sinyali b sinyalinden küçükse veya eşitse TRUE olarak değer alır.
	--
 end if;
 if a = b then --a sinyali b sinyaline eşitse TRUE olarak değer alır.
	--
 end if;
 if a /= b then --a sinyali b sinyaline eşit değilse TRUE olarak değer alır.
	--
 end if;
```

Dönüştürme fonksiyonları:
```
CONV_INTEGER  			=> INTEGER/SIGNED/UNSIGNED/STD_ULOGIC türünde girdiler için tanımlıdır, INTEGER türünde çıkış verir.
CONV_UNSIGNED 			=> İlk parametresi INTEGER/SIGNED/UNSIGNED/STD_ULOGIC, ikinci parametresi INTEGER türünde girdiler için tanımlıdır, UNSIGNED türünde çıkış verir.
CONV_SIGNED				=> İlk parametresi INTEGER/SIGNED/UNSIGNED/STD_ULOGIC, ikinci parametresi INTEGER türünde girdiler için tanımlıdır, SIGNED türünde çıkış verir.
CONV_STD_LOGIC_VECTOR 	=> İlk parametresi INTEGER, ikinci parametresi NATURAL türünde girdiler için tanımlıdır, SIGNED türünde çıkış verir.
EXT 					=> İlk parametresi STD_LOGIC_VECTOR, ikinci parametresi INTEGER türünde girdiler için tanımlıdır, STD_LOGIC_VECTOR türünde çıkış verir.
SXT 					=> İlk parametresi STD_LOGIC_VECTOR, ikinci parametresi INTEGER türünde girdiler için tanımlıdır, STD_LOGIC_VECTOR türünde çıkış verir.
```

Yukarıdaki fonksiyonların yaptığı işlemler ve kullanım örnekleri aşağıda verilmiştir.
```
b <= CONV_INTEGER(a);-- INTEGER/SIGNED/UNSIGNED/STD_ULOGIC type tanımlanan a sinyali integer type'a çevrilerek bit type olarak tanımlanan b siyanline yazılır.
b <= CONV_UNSIGNED(a,length);-- INTEGER/SIGNED/UNSIGNED/STD_ULOGIC type tanımlanan a sinyalini natural type tanımlanan "lengh" parametresi miktarınca bitten oluşan unsigned type'a çevrilip b sinyaline yazılır.
b <= CONV_SIGNED(a,length);-- INTEGER/SIGNED/UNSIGNED/STD_ULOGIC type tanımlanan a sinyalini natural type tanımlanan "lengh" parametresi miktarınca bitten oluşan signed type'a çevrilip b sinyaline yazılır.
b <= CONV_STD_LOGIC_VECTOR(a,length);-- INTEGER type tanımlanan a sinyali natural type tanımlanan "lengh" parametresi miktarınca bitten oluşan std_logic_vector type'a çevrilip b sinyaline yazılır. 
b <= EXT(a,length);-- Boyut değiştirmek için kullanılır. lenght sinyali ile belirlenen boyut küçülüyorsa en az değerli bitten itibaren istenen miktarda bit alınır, boyut büyüyor ise
fazla bitler için işaretsiz (zero extended) genişletme uygulanır.
b <= SXT(a,length);-- Boyut değiştirmek için kullanılır. lenght sinyali ile belirlenen boyut küçülüyorsa en az değerli bitten itibaren istenen miktarda bit alınır, boyut büyüyor ise
fazla bitler için işaretli (sext, sign extended) genişletme uygulanır.
```

## std_logic_signed ve std_logic_unsigned packageleri

std_logic_vector'ler üzerinde aritmetik işlem yapmak için kullanılan, Synopsys firması tarafından geliştirilen "std_logic_signed" ve "std_logic_unsigned" package'ları ve içerdikleri fonksiyonlar aşağıda verilmiştir.

Her iki kütüphane de aynı fonksiyonlara sahip olmakla birlikte std_logic_signed package, std_logic_vector'leri 2'nin tümleyeni (2's complement) işaretli integer olarak çevirirken, std_logic_unsigned package, std_logic_vector'leri işaretsiz integer olarak çevirir.

IEEE tarafından standart olarak yayınlanmadığı için kullanılması tavsiye edilmemekle birlikte kullanılmak istendiğinde aynı anda std_logic_signed ve std_logic_unsigned package'ların tanımlanmamasına dikkat edilmedilir.

```
"+"   => STD_LOGIC_VECTOR/INTEGER türünde girdiler için tanımlıdır,STD_LOGIC_VECTOR türünde çıkış verir.
"-"   => STD_LOGIC_VECTOR/INTEGER türünde girdiler için tanımlıdır,STD_LOGIC_VECTOR türünde çıkış verir.
"*"   => STD_LOGIC_VECTOR türünde girdiler için tanımlıdır, STD_LOGIC_VECTOR türünde çıkış verir.
```

Kıyaslama operatörleri:
```
">"  => STD_LOGIC_VECTOR/INTEGER türünde girdiler için tanımlıdır, BOOLEAN türünde çıkış verir.
"<"  => STD_LOGIC_VECTOR/INTEGER türünde girdiler için tanımlıdır, BOOLEAN türünde çıkış verir.
"<=" => STD_LOGIC_VECTOR/INTEGER türünde girdiler için tanımlıdır, BOOLEAN türünde çıkış verir.
">=" => STD_LOGIC_VECTOR/INTEGER türünde girdiler için tanımlıdır, BOOLEAN türünde çıkış verir.
"="  => STD_LOGIC_VECTOR/INTEGER türünde girdiler için tanımlıdır, BOOLEAN türünde çıkış verir.
"/=" => STD_LOGIC_VECTOR/INTEGER türünde girdiler için tanımlıdır, BOOLEAN türünde çıkış verir.
```

Yukarıdaki fonksiyonların yaptığı işlemler ve kullanım örnekleri aşağıda verilmiştir.
```
 if a > b then --a sinyali b sinyalinden büyükse TRUE olarak değer alır.
	--
 end if;
 if a >= b then --a sinyali b sinyalinden büyük veya eşitse TRUE olarak değer alır.
	--
 end if;
 if a > b then --a sinyali b sinyalinden küçükse TRUE olarak değer alır.
	--
 end if;
 if a > b then --a sinyali b sinyalinden küçükse veya eşitse TRUE olarak değer alır.
	--
 end if;
 if a = b then --a sinyali b sinyaline eşitse TRUE olarak değer alır.
	--
 end if;
 if a /= b then --a sinyali b sinyaline eşit değilse TRUE olarak değer alır.
	--
 end if;
```

Kaydırma fonksiyonları:
```
"SHL" => İlk parametresi STD_LOGIC_VECTOR, ikinci parametresi STD_LOGIC_VECTOR türünde girdiler için tanımlıdır, STD_LOGIC_VECTOR türünde çıkış verir.
"SHR" => İlk parametresi STD_LOGIC_VECTOR, ikinci parametresi STD_LOGIC_VECTOR türünde girdiler için tanımlıdır, STD_LOGIC_VECTOR türünde çıkış verir.

b <= a SHL 	n;----a sinyalini n bit sola kaydırır ve sağdan gelen yeni değerlere '0' ataması yapar.
b <= a SHR	n;----a sinyalini n bit sağa kaydırır ve soldan gelen yeni değerlere '0' ataması yapar.
```

Dönüştürme fonksiyonu:
```
CONV_INTEGER  			=> STD_LOGIC_VECTOR türünde girdiler için tanımlıdır, INTEGER türünde çıkış verir.
```

Yukarıdaki fonksiyonların yaptığı işlemler ve kullanım örnekleri aşağıda verilmiştir.
```
b <= CONV_INTEGER(a);-- STD_LOGIC_VECTOR type tanımlanan a sinyali integer type'a çevrilerek bit type olarak tanımlanan b siyanline yazılır.
```

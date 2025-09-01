---
title: "FPGA'de Reset Topolojileri"
date: 2025-08-31
slug: /fpga_reset_topolojileri/
description: FPGA'de Reset Topolojileri
image: images/reset_topolojileri_kapak.png
categories:
  - fpga
  - reset
tags:
  - fpga
  - reset topolojileri
  - senkron reset
  - asenkron reset
draft: false
---

**FPGA'de Reset Topolojileri**

FPGA uygulamalarında reset yapısı tasarımın güvenilirliği için son derece kritik öneme sahiptir. Reset yapıları, özellikle Uzay, Havacılık ve kritik öneme sahip sistemlerde olası hataların hızlı bir şekilde önlenmesi ve ilk çalışma durumundaki davranışlarının belirlenmesi için kritik rol oynamaktadır.

FPGA'lerde reset yapısı senkron ve asenkron reset olmak üzere iki ana yapıdadır.

Senkron reset clock sinyaline göre eşzamanlı şekilde registerlerin sıfırlamasını yapar. 
Avantajları şu şekildedir: 
- Senkron şekilde gerçekleştiği için timing ihlallerine neden olmaz. 
- Timing ihlali bakımından avantajlıdır. 
- Clock sinyalinin dalgalanmasına (glitch) karşı bağışıklıdır. 
Dezavantajları şu şekildedir:
- Clock sinyali gerektirir. Clock olmadan çalışamaz.
- Uygulanmasından sonra clock periyodu kadar gecikmeye ihtiyaç duyar.
- Kullanımı için fazladan FPGA kaynağı gerekebilir.
- FPGA içerisinde geniş fanout (yayılım) oluşturur.
 
<p align="center">
  <img src="https://vhdlverilog.com/images/reset_topolojileri/sekil_1.png" width="387"/>
  <em>Şekil 1 - Senkron reset yapısı</em>
</p>

Asenkron reset clock sinyalindan bağımsız olarak flip flopların sıfırlamasını yapar. Flip flopların reset girişi ile sağlanır.
Avantajları şu şekildedir: 
- Clock sinyali gerektirmediği için istenilen anda tetiklenebilir.
- Uygulanmasından sonra etki süresi düşüktür.
- Kullanımı için senkrona kıyasla daha az FPGA kaynağı gerekir.
Dezavantajları şu şekildedir:
- Sona ermesi anında timing ihlali oluşturma olasılığı yüksektir.
- Clock sinyalinin dalgalanmasına (glitch) karşı hassastır.

Her iki reset yapısının avantaj-dezavantajları farklıdır. Asenkron reset çoğu uygulamada ilk çalıştırma (power-on) sürecinde sıklıkla kullanılırken çalışma esnasında senkron resetin kullanılması tercih edilmektedir. 
Senkron reset sinyali geldiğinde clock sinyaline eşzamanlı şekilde sıfırlama gerçekleşir. Böylece ilgili flip flopların çıkışı stabil çalışma için gereken timing kuralları ihlal edilmeden(doğru zamanda) değiştirilebilir. Asenkron reset sinyali ise clock sinyalinden bağımsız olarak, herhangi bir zaman diliminde gerçekleşebileceğinden dolayı timing kurallarını ihlal edebilir ve bu da metastabilite durumunu oluşturarak FPGA'yı kararsız bir durum içerisine sokabilir (3). Bu durum Şekil 2’deki görsel üzerinden incelenebilir.

 <p align="center">
  <img src="https://vhdlverilog.com/images/reset_topolojileri/sekil_2.png" width="1000"/>
  <em>Şekil 2 - Asenkron resetin sebep olduğu timing ihlali</em>
</p>

Şekil 2 incelendiğinde Asenkron reset sinyali geldiğinde clock sinyalinden bağımsız olarak sıfırlama gerçekleştiği görülmektedir. Asenkron reset sinyalinin kesilmesi sonrasında ise normal çalışmasına dönen registerlar clock sinyaline bağlı olarak yeni değerler ile güncellenmiştir. Bu yeni değerlerin çıkışa doğru şekilde aktarılabilmesi için (timing ihlali gerçekleşmemesi için) çıkış değerinin değişimi öncesinde Tsetup, çıkış değerinin değişimi sonrasında ise Thold süresince beklenmesi gerekmektedir. Şeklin sol tarafındaki a durumunda bu timing kurallarına uygun şekilde bir sıfırlama gerçekleşmiştir. Reset sinyalinin bu iki süre arasında gelmesi durumunda çıkış değeri reset sinyalinin etkisiyle değiştirilir ve dolayısıyla istenen aralıkta stabil kalamaz ve timing ihlali gerçekleşir. Şeklin sağ tarafındaki b durumunda ise bu kurallara uygun şekilde sıfırlama gerçekleşmemiş, timing ihlali olmuştur.

Büyük tasarımlarda, reset sinyalinin dağıtılması esnasında oluşabilecek routing gecikmeleri de yukarıda bahsedilen sebep ile birleşerek timing ihlallerine sebep olabilir.
Asenkron reset sinyali geldiğinde herhangi bir clock sinyali beklenmeksizin sıfırlama işlemi gerçekleştirilir. Özellikle sistemin hatalı bir durum içerisinde olduğu tespit edildiğinde çıkış değerlerine hızlı müdahale edebilmek için asenkron reset yapısı kullanılmalıdır. Ayrıca ilk çalıştırma zamanı gibi clock sinyalinin olmadığı durumda tüm register ve çıkış değerlerini sıfırlamak için asenkron reset yapısının kullanılması zorunludur.

Her iki yapının avantaj, dezavantajları bulunduğundan Uzay, havacılık ve kritik uygulamalarda hibrit yaklaşım kullanılmalıdır. Bu hibrit yaklaşımda açılış için (Power-on) asenkron, normal çalışmada senkronize edilmiş reset yapısının uygulamanın kritikliğine göre Triple Mod Redundancy yapısı ile çoğaltılıp kullanılması önerilmektedir. Örnek devreler ve kullanılması önerilen yapılar aşağıda verilmiştir.

 <p align="center">
  <img src="https://vhdlverilog.com/images/reset_topolojileri/sekil_3.png" width="800"/>
  <em>Şekil 3 - Reset senkronizer devreleri</em>
</p>

Şekil 3'te verilen a ve b devreleri asenkron olarak tetiklenen, senkron olarak sonlanan sırasıyla aktif '1' ve aktif '0' senkronizer devreleridir. Çıkışlarında yer alan mantık kapısı reset sinyali tarafından clocktan bağımsız şekilde aktif hale getirilir. Mantık kapısının diğer girişinde ise clocka senkron çalışan F1 flip flopunun çıkışı yer almaktadır. F1 flip flopunun girişine asenkron reset girişi tarafından sürülen F0 flip flopu bağlanmıştır. Bu flip flop clocka senkron şekilde giriş sinyalini F1 flip flopuna iletir. F1 flip flopu da aynı şekilde mantık kapısını sürer. Reset sinyalinin kesilmesi durumunda flip flop sayısı kadar clock boyunca reset sinyali aktif tutulur ve süre tamamlandığında clock ile senkron şekilde pasif hale getirilir. Böylece reset asenkron şekilde aktifleştirilip, senkron şekilde pasifleştirilebilir. Bu yapıdaki kaskat flip floplar ile metastabilite önlenmektedir. Bu devrelerin tetiklenmesinden sonra kaskat flip floplardan dolayı flip flop sayısınca clock süresi boyunca aktif reset çıkışı vereceği unutulmamalıdır.

Şekil 3'te verilen c ve d devreleri ise sırasıyla aktif '1' ve aktif '0' reset sinyallerine göre tetiklenen, kaskat flip floplardan oluşan senkronizer devreleridir. Bu devreler gelen asenkron sinyalleri clocka göre senkron hale getirerek çıkışa aktarır. a ve b yapısındaki gibi asenkron şekilde tetikleme gerçekleşmez, sadece clocka bağlı, senkron şekilde çalışır. Bu yapıdaki kaskat flip floplar ile metastabilite önlenmektedir.

Yukarıdaki yapılardan elde edilen reset çıkışlarının tüm tasarımda kullanılması özellikle büyük tasarımlar için timing ve routing bakımından sorun oluşturmaktadır. Bu sorunlardan timingin çözümü için Şekil 4'te verilen, çıkış senkronizer devresine çok sayıda ve paralel şekilde kullanılacak flip flop devresi eklenilerek timing bakımından uyumluluk sağlanabilir.

<p align="center">
  <img src="https://vhdlverilog.com/images/reset_topolojileri/sekil_4.png" width="750"/>
  <em>Şekil 4 - Senkronizer devresini timing bakımından uyumlu hale getiren devre</em>
</p>

Şekil 4'te verilen devrede asenkron olarak set özelliği kullanıldığından tetikleme esnasında clock kaybı yaşanmaz. Tetikleme sona erdikten sonra çıkışta 1 clock gecikme oluşur. Bu yapı reset sinyalinin ulaştırılacağı modüllere yakın olacak şekilde kullanıldığında, reset sinyalini taşıyan yol kısalacağından routingten kaynaklı timing problemlerinin önüne geçilebilmektedir.
Çok sayıda clock domainine sahip bir tasarım için reset mimarisi kullanılırken tüm clock domainleri için ayrı ayrı reset yapısı kullanılmalıdır. Asenkron resetin her clock domainine kendi clock frekansına göre ayrı ayrı senkron edilmesi metastabilite oluşmaması için gereklidir.

Power on Reset yapısı:

Özellikle flash tabanlı FPGA'lerde ilk çalışma esnasında registerlerin başlangıç değerleri doğru şekilde ayarlanmamış olabilir. Bunun önüne geçmek için ilk enerji verildiği andan itibaren belirli bir süre boyunca asenkron reset uygulanarak tasarımda yer alan tüm registerların sıfırlanması ve başlangıç değerlerinin istenen şekilde ayarlanması sağlanır. Ayrıca çalışma gerilimi ve PLL(ve benzeri) clock yapılarının stabil rejime geçmesi için bir süre beklenmesi gerekmektedir.

Bunun için üreticilerin donanımsal olarak eklediği POR yapısı veya RTL seviyesinde bir tasarım ile tasarlanan POR yapısı kullanılabilir.
POR yapısının amacı sadece ilk çalıştırmaya mahsus, belirli bir süre boyunca hiçbir koşula bağlı olmaksızın reset sinyali uygulamaktır. Böylece ilk çalıştırma esnasında tüm registerlerin istenilen değerleri alacağından emin olunur. POR süresi dolduğunda çalışma normal düzenine geçer.

FPGA'e gücün ilk geldiği anda POR aktifleşir ve bu esnada clock sinyali genellikle ya yoktur ya da stabil değildir. Bundan dolayı POR asenkron bir reset çıktısı ile resetlemeyi sağlar. İstenen zaman aşımının tamamlanmasıyla birlikte clock sinyaline senkron şekilde pasife çekilir.

POR için kullanılan timer saymaya başlaması için genellikle FPGA clock IP corelarının lock sinyali kullanılır. Bu sinyal FPGA içerisindeki clock dağıtım birimi stabil bir şekilde çıktı vermeye başladığında IP core tarafından aktifleştirilir ve stabil bir clock olduğu sürece devam eder.

 <p align="center">
  <img src="https://vhdlverilog.com/images/reset_topolojileri/sekil_5.png" width="500"/>
  <em>Şekil 5 - Zamana göre POR'un pasif hale geçmesi</em>
</p>

Triple Mod Redundancy (TMR) yapısı:
Uzay veya havacılık projeleri gibi kritik uygulamalarda iç sinyallerin dış etmenlerden (SEU ve radyasyon) etkilenerek hatalı çıktılar üretmemesi için TMR yapısı kullanılabilir. Bu yapıda (TMR mimarisine göre değişmekle birlikte) TMR uygulanacak sinyal 3 tane olacak şekilde sentezlenerek istenen yapıya iletilir. Son aşamada bir kıyaslayıcı ile giriş sinyalleri kıyaslanır. Üç sinyalden en az 2 tanesinin durumu çıkış sinyali olarak belirlenir. Bu sayede üç sinyalden en az iki tanesinin değişmesi durumunda hata oluşabilir. Şekil 6'da TMR yapısının blok mimarisi verilmiştir.
 <p align="center">
  <img src="https://vhdlverilog.com/images/reset_topolojileri/sekil_6.png" width="700"/>
  <em>Şekil 6 - TMR yapısı</em>
</p>

TMR seçeneği RTL koduna eklenen bir attribute ile sağlanabilir. Ayrıca uzay uygulamaları için kullanılan Rad-hard FPGA'lerde reset yapılarında otomatik olarak kullanılır.

VHDL attribute kodu aşağıda verilmiştir:
```vhdl
	--Xilinx
	attribute TMR : string;
	attribute TMR of my_ff : signal is "TRUE";
	--Microchip
	attribute tmr : string;
	attribute tmr of my_ff : signal is "ENABLED";
```
Verilog attribute kodu aşağıda verilmiştir:
```verilog
	--Xilinx
	(* TMR = "TRUE" *) reg my_ff;
	(* TMR = "TRUE" *) wire my_reset;
	--Microchip
	(* tmr = "ENABLED" *) reg my_ff;
	(* tmr = "ENABLED" *) wire rst_n;
```

Glitch filtrelenmesi:
Hassas uygulamalarda asenkron resetin dezavantajlarından olan glitch duyarlılığının azaltılması için glitch filtre yapısının kullanılması tavsiye edilmektedir. Glitch filtresi reset girişinin çok kısa süre boyunca dalgalanmadan kaynaklı aktif hale gelmesini engeller. Bu sayede özellikle kritik tasarımlarda asenkron reset sinyaline gürültü ve çevresel etkenlere karşı bağışıklık kazandırır.
 <p align="center">
  <img src="https://vhdlverilog.com/images/reset_topolojileri/sekil_7.png" width="1236"/>
  <em>Şekil 7 - Glitch filtresi</em>
</p>

Şekil 7'de verilen reset glitch filtresindeki giriş sinyalinin kendisi ve giriş sinyalinin bir miktar geciktirilmiş hali or(veya aktif ‘0’ için and) kapısına uygulanmaktadır. Giriş sinyalinin geciktirilmesi üreticilerin sağlamış olduğu donanımsal makrolar ile veya basit logicler ile gecikme oluşturularak yapılabilmektedir. Mantık kapısına hem glitchli hem de henüz glitchin ulaşmadığı sinyal girilerek etkilenmeyen çıktı elde edilmiş, sonrasında elde edilen bu filtrelenmiş sinyal senkronizer devresine girilerek clock sinyaline senkron hale getirilmiştir. Sol üstte yer alan glitchten etkilenmiş rst_n, geciktirilmiş drst_n ve filtrelenmiş frst_n sinyalinin zamana göre değişimleri incelendiğinde filtre yapısının çalışması anlaşılabilir.

Sonuç olarak senkron ve asenkron reset yapılarının her ikisi de kendilerine has avantaj ve dezavantajlara sahip farklı yapılardır. Her iki yapının da birlikte kullanılmasıyla tasarımın güvenilirliği ve her iki yapının da avantajlı yanları ortak şekilde tasarıma entegre edilmesi özellikle uzay ve havacılık gibi kritik uygulamalarda önem arz etmektedir.

Bu yazı hazırlanırken [VLSIVerify - DFF with synchronous reset](https://vlsiverify.com/verilog/verilog-codes/dff-with-synchronous-reset/),[ Embedded - Asynchronous reset synchronization and distribution challenges and solutions](https://www.embedded.com/asynchronous-reset-synchronization-and-distribution-challenges-and-solutions), [Asynchronous & Synchronous Reset
Design Techniques - Part Deux](http://www.sunburst-design.com/papers/CummingsSNUG2003Boston_Resets.pdf) ve [Xilinx - UG949](https://docs.amd.com/r/en-US/ug949-vivado-design-methodology) kaynaklarından faydalanılmıştır.

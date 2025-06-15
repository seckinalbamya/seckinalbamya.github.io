---
title: "FPGA'de Statik Timing Analizi"
date: 2025-06-15
slug: /fpgade_statik_timing_analizi/
description: FPGA'de Statik Timing Analizi
image: images/statik_timing_analiz_pp.png
categories:
  - fpga
tags:
  - fpga
  - timing analizi
  - setup time
  - hold time
  - slack
draft: false
---

**FPGA'de Statik Timing Analizi:** 

&nbsp;&nbsp;&nbsp;&nbsp;Bir FPGA tasarımının güvenli ve hatasız çalışması için bazı tasarım gereksinimlerine uyulmalıdır. Bu tasarım gerekliliklerinin en önemlilerinden bir tanesi timing (zaman) analizidir.

&nbsp;&nbsp;&nbsp;&nbsp;FPGA içerisindeki register'dan register'a, FPGA içerisindeki bir register'dan harici bir donanıma giden veya harici bir donanımdan FPGA içerisindeki bir register'a gelen sinyallerin belirli zaman dilimleri içerisinde ulaşması gerekmektedir. Constraint dosyası ile tanımlanan çalışma frekansı ve üzerinde çalışılacak FPGA modelinin sabit parametrelerine göre analiz edilip tasarımın kararlı çalışıp çalışmayacağının belirlenmesine timing (zaman) analizi denir.

&nbsp;&nbsp;&nbsp;&nbsp;Timing analizi, tasarımın kararlı çalışmasını garantiye almak için önemli bir analizdir. Timing gereksinimlerini karşılamayan bir sistemde sinyaller kaynaktan hedef flip floplara doğru zamanda aktarılmayabilir ve beklenmedik davranışlar görülebilir.

&nbsp;&nbsp;&nbsp;&nbsp;Bu yazının içeriğine başlamadan önce görseller ve metinlerde kullanılan kısaltmalar ve açıklamaları aşağıda verilmiştir.
	
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Tclk**: Clock kaynağından flip flop'un clock girişine kadar olan yolda harcanan süredir. Tasarıma göre değişir.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**tco** (clock to output) veya **tcq** (clock to q): Flip flop'a gelen clock sinyalinin yükselen kenarından Q çıkışına kadar geçen süredir. Üretim teknolojisiyle alakalı, sabit bir parametredir.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Tdata**: Kaynak flip flop'un Q çıkışından hedef flip flop'un D girişine kadar verinin iletilmesinde geçen süredir. Tasarıma göre değişir.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Jitter**: Sinyalin özellikle değişim anlarında yaşanan dalgalanma durumudur.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Skew**: İletimden kaynaklı oluşan zaman gecikmesidir.

<p align="center">
  <img src="https://github.com/seckinalbamya/seckinalbamya.github.io/blob/main/content/timing_analyses_images/kisaltmalar.png?raw=true" alt="Kullanılan kısaltmaların zaman çizgisi üzerinde gösterimi" width="500"/>
</p>

<p align="center"><em>Şekil 1: Kullanılan kısaltmaların zaman çizgisi üzerinde gösterimi</em></p>

&nbsp;&nbsp;&nbsp;&nbsp;Timing analizi, FPGA içerisinde bulunan flip flop'lara uygulanan sinyal girişinin (D girişi), clock girişine göre, izin verilen zaman aralığında değişip değişmediğini inceler. Setup ve hold time gereksinimleri olmak üzere iki farkı zaman dilimi için analiz uygulanır.
	
**1. Setup time analizi:**
	
&nbsp;&nbsp;&nbsp;&nbsp;Flip flop, kendisine uygulanan sinyal girişini örneklemek için clock sinyalinin yükselen kenarını (rising edge) kullanır. Bu yükselen kenar anındaki D girişini örnekleyerek Q çıkışına aktarır.
	
&nbsp;&nbsp;&nbsp;&nbsp;Gerçek hayattaki bir flip flop'ta yükselen kenar anında yapılacak örneklemenin sağlıklı bir şekilde yapılabilmesi için sinyalin değişmeden bir süre sabit kalması gerekmektedir. Bu süreye setup time süresi (**t<sub>setup</sub>**) denir. Üretim teknolojisiyle alakalı, sabit bir parametredir. Clock'un yükselen kenarının hemen öncesinde yer alan bu süre içerisinde sinyal değişime uğrarsa flip flop çıkışı metastabil duruma geçerek kararsız bir hal alır. Bu kararsız durum flip flop'un çıkışının 0 veya 1 arasında değiştiği ancak belirli bir süre beklendiği taktirde çözülerek çıkışın sabit bir değer aldığı durumdur.
	
&nbsp;&nbsp;&nbsp;&nbsp;İzin verilen maksimum veri yolu gecikmesi (setup time için) = **T<sub>required\_setup</sub>** = **t<sub>co</sub>** + **T<sub>data</sub>** + **t<sub>setup</sub>** (flip flop'un gerektirdiği clock öncesi bekleme süresi) + diğer etmenler (jitter, skew vs.)  
	
&nbsp;&nbsp;&nbsp;&nbsp;**T<sub>required\_setup</sub>** ≤ **T<sub>clk</sub>** olmalıdır.

&nbsp;&nbsp;&nbsp;&nbsp;Başka bir ifadeyle eşitsizlikteki ifadeler yer değiştirildiğinde şu şekilde de ifade edilebilir:
	
&nbsp;&nbsp;&nbsp;&nbsp;(**t<sub>co</sub>** + **T<sub>data</sub>** + **t<sub>setup</sub>**) ≤ **T<sub>clk</sub>**
	
&nbsp;&nbsp;&nbsp;&nbsp;Burada dikkat edilmesi gereken nokta, clock frekansı arttığında **T<sub>required\_setup</sub>** azalmaktadır. Diğer bir ifadeyle tasarlanan veri yolu uzunluğu arttıkça clock frekansı azalmaktadır.
	
**2. Hold time analizi:**

&nbsp;&nbsp;&nbsp;&nbsp;Flip flop'un sinyal girişinin clock sinyalinin yükselen kenar anındaki örneklemeden sonra bir süre sabit kalması gerekmektedir. Bu süreye hold time süresi (**t<sub>hold</sub>**) denir. Üretim teknolojisiyle alakalı, sabit bir parametredir. Flip flop'un D girişindeki sinyalin clock'un yükselen kenarının hemen öncesinde yer alan bu süre içerisinde değişime uğraması durumunda flip flop çıkışı metastabil duruma geçerek kararsız bir hal alır.
	
&nbsp;&nbsp;&nbsp;&nbsp;İzin verilen minimum veri yolu gecikmesi (hold time için) = **T<sub>required\_hold</sub>** = **t<sub>hold</sub>** (flip flopun gerektirdiği clock sonrası bekleme süresi) + diğer etmenler (jitter, skew vs.)  
	
&nbsp;&nbsp;&nbsp;&nbsp;Diğer bir ifadeyle, verinin kaynak flip-flop’tan oluşturulup hedef flip-flop’a iletilmesinde geçen süre, minimum hold time süresinden (ve sistem belirsizliklerinden) daha uzun veya eşit olmalıdır:
	
&nbsp;&nbsp;&nbsp;&nbsp;(**t<sub>co</sub>** + **T<sub>data</sub>**) ≥ **T<sub>required\_hold</sub>**
	
&nbsp;&nbsp;&nbsp;&nbsp;Burada dikkat edilmesi gereken nokta, clock frekansının **T<sub>required\_hold</sub>**'a herhangi bir etkisinin olmadığıdır çünkü aynı clock kenarında yapılan örnekleme ile ilgili bir parametredir.

&nbsp;&nbsp;&nbsp;&nbsp;Setup ve hold time analizi hesaplamasının nasıl yapıldığı konusundan önce setup ve hold time gereksinimlerini karşılayıp karşılamadığı bakımından çeşitli örnekler aşağıda incelenmiştir.

&nbsp;&nbsp;&nbsp;&nbsp;Setup time bakımından incelenen ve hatasız çalışan bir örnek aşağıdaki görsel üzerinde gösterilmiştir.

<p align="center">
  <img src="https://github.com/seckinalbamya/seckinalbamya.github.io/blob/main/content/timing_analyses_images/setup_basarili.PNG?raw=true" alt="Kullanılan kısaltmaların zaman çizgisi üzerinde gösterimi" width="710"/>
</p>

<p align="center"><em>Şekil 2: Setup time bakımından hatasız çalışan bir örnek</em></p>

&nbsp;&nbsp;&nbsp;&nbsp;Görseldeki zaman çizelgesindeki sinyaller incelendiğinde Register 1'den çıkan REG1.Q sinyali REG2.D girişine geldiğinde bir sonraki örneklemeye **T<sub>setup</sub>**'tan daha uzun zaman kalmaktadır. Dolayısıyla setup time bakımından herhangi bir ihlal bulunmamaktadır.

&nbsp;&nbsp;&nbsp;&nbsp;Setup time bakımından incelenen ve setup time ihlalı olan bir örnek aşağıdaki görsel üzerinde gösterilmiştir.

<p align="center">
  <img src="https://github.com/seckinalbamya/seckinalbamya.github.io/blob/main/content/timing_analyses_images/setup_basarisiz.PNG?raw=true" alt="Kullanılan kısaltmaların zaman çizgisi üzerinde gösterimi" width="727"/>
</p>

<p align="center"><em>Şekil 3: Setup time ihlali olan bir örnek</em></p>

&nbsp;&nbsp;&nbsp;&nbsp;Görseldeki zaman çizelgesindeki sinyaller incelendiğinde Register 1'den çıkan REG1.Q sinyali REG2.D girişine geldiğinde bir sonraki örneklemeye **T<sub>setup</sub>**'tan daha kısa zaman kalmaktadır. Dolayısıyla örnekleme öncesinde gereken sinyal stabilliği sağlanamamış, setup time bakımından ihlal gerçekleşmiştir.

&nbsp;&nbsp;&nbsp;&nbsp;Hold time bakımından incelenen ve hatasız çalışan bir örnek aşağıdaki görsel üzerinde gösterilmiştir.

<p align="center">
  <img src="https://github.com/seckinalbamya/seckinalbamya.github.io/blob/main/content/timing_analyses_images/hold_basarili.PNG?raw=true" alt="Hold time bakımından hatasız çalışan bir örnek" width="710"/>
</p>

<p align="center"><em>Şekil 4: Hold time bakımından hatasız çalışan bir örnek</em></p>

&nbsp;&nbsp;&nbsp;&nbsp;Görseldeki zaman çizelgesindeki sinyaller incelendiğinde Register 1'den çıkan REG1.Q sinyali REG2.D girişine gelip bir sonraki clock yükselen kenarıyla birlikte örneklendiğinde, **t<sub>hold</sub>**'tan daha uzun bir süre boyunca sabit kalmaktadır. Dolayısıyla hold time bakımından herhangi bir ihlal bulunmamaktadır.

&nbsp;&nbsp;&nbsp;&nbsp;Hold time bakımından incelenen ve hold time ihlali olan bir örnek aşağıdaki görsel üzerinde gösterilmiştir.

<p align="center">
  <img src="https://github.com/seckinalbamya/seckinalbamya.github.io/blob/main/content/timing_analyses_images/hold_basarisiz.PNG?raw=true" alt="Hold time ihlali olan bir örnek" width="710"/>
</p>

<p align="center"><em>Şekil 5: Hold time ihlali olan bir örnek</em></p>


&nbsp;&nbsp;&nbsp;&nbsp;Görseldeki zaman çizelgesindeki sinyaller incelendiğinde Register 1'den çıkan REG1.Q sinyali REG2.D girişine gelip bir sonraki clock yükselen kenarıyla birlikte örneklendiğinde, **t<sub>hold</sub>**'tan daha kısa bir süre boyunca sabit kalmaktadır. Dolayısıyla örnekleme sonrasında gereken sinyal stabilliği sağlanamamış, hold time bakımından ihlal gerçekleşmiştir.

&nbsp;&nbsp;&nbsp;&nbsp;Setup ve Hold time analizi yapılırken analiz araçları her bir veri yolu için slack(boşluk miktarı) hesabı yapar. Bu slack hesaplarında kullanılan parametreler ve hesaplanışları aşağıda verilmiştir.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Setup Slack**: Gereken veri aktarım süresi (setup time için) - Verinin varış süresi  ===> Verinin varış süresi ≤ **T<sub>required\_setup</sub>** olmalıdır.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Hold Slack**: Verinin varış süresi - Gereken veri aktarım süresi (hold time için)	 ===> Verinin varış süresi ≥ **T<sub>required\_hold</sub>** olmalıdır.

&nbsp;&nbsp;&nbsp;&nbsp;Setup ve hold slack değerleri pozitif olduğunda tasarım timing gereksinimlerini karşılamakta, aksi halde tasarımda timing ihlali bulunmaktadır.

&nbsp;&nbsp;&nbsp;&nbsp;Pozitif setup ve hold slack değerlerinde tasarımın kararlı çalışması garanti altına alınırken negatif slack değerlerinde sistemde metastability ve kararsız durumlar gözlenebilir. Bu durum flip flop'ların çıktılarının kararsız olmasına, kararsız flip flop'lardan örnekleme yapan başka flip flop'ların yanlış değerleri örneklemesine ve sistemin çökmesine kadar ilerleyen bir hataya yol açabilir. İyi bir tasarımda bu hatalara karşı analizleri dikkate almak önem arz eder.

Bu yazıdaki içerik ve görseller için YouTube'da paylaşım yapan Altera kanalının [Understanding Timing Analysis in FPGAs](https://www.youtube.com/watch?v=6D-w8mOttnE) videosundan faydalanılmıştır.

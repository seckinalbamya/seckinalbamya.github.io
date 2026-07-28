---
title: "AXI-S Slave Arayüzü Tasarımı"
date: 2026-07-29
slug: /axis_slave_interface/
description: AXI-S Slave Arayüzü Tasarımı
image: images/axis_slave_kapak.png
categories:
  - fpga
  - arayuz
tags:
  - fpga
  - axi-s
  - axi stream
  - hdmi
  - vga
draft: false
---

RTL tasarımlarında geliştirilen modül veya tasarımın standart bir arayüz ile geliştirilmesi tasarımcıya önemli bir kolaylık sağlamaktadır. Yapılan tasarımın projelere kolaylıkla entegre edilebilmesi, başkaları tarafından geliştirilen tasarımlar ile uyumluluk açısından ortak bir yapıya sahip olması avantajları bulunmaktadır. 

ARM firmasının standardını tasarladığı, yüksek miktarda ve tek yönlü veri akışı gereken sistemlerde kullanılan AXI4-Stream (AXI-S), HDMI veya VGA gibi görüntü aktarma standartlarında sıklıkla kullanılmaktadır.

Oldukça basit yapıda olan AXI-S, gönderen ve alıcı tarafın hazır olduklarını birbirlerine ilettikleri birer bitlik durum sinyallerinden, verinin senkronizasyonunu sağlamak için kullanılan bir bitlik sinyalden, verinin kendisini taşıyan çok bitlik bir hattan ve görevi kullanıcı tarafından tanımlanabilen bir bitlik sinyalden oluşmaktadır.

AXI-S sinyallerinden temel olarak kullanılanları yakından incelenecek olursa;

- ACLK: Clock sinyalidir. Tüm işlemler bu sinyalin yükselen kenarında gerçekleştirilir.
- ARESETN: Asenkron reset sinyalidir. Aktif '0' olarak uygulanır. ACLK'a senkron şekilde serbest bırakılmalıdır.
- TDATA: Verinin aktarıldığı arayüzdür. Master için çıkış, slave için giriş sinyalidir. Herhangi bir bit sınırlaması yoktur.
- TVALID: TDATA verisinin geçerli olduğunu belirten arayüzdür. Master için çıkış, slave için giriş sinyalidir.
- TREADY: Slave cihazın veriyi alabileceğini belirttiği arayüzdür. Master için giriş, slave için çıkış sinyalidir.
- TUSER: Kullanıcı tarafından belirlenen bir fonksiyon için kullanılabilen bir arayüzdür. Master için çıkış, slave için giriş sinyalidir
- TLAST: Son verinin alındığını belirten arayüzdür. Master için çıkış, slave için giriş sinyalidir

Bu arayüzler dışında spesifikasyonda yer alan TSTRB, TKEEP, TID ve TDEST sinyallerinin işleyişlerine [<u>buradan</u>](https://support.arm.com/documentation/ihi0051/b/) göz atabilirsiniz.

AXI-S, TREADY ve TVALID sinyallerinin ikisinin de '1' olması durumunda herhangi bir ek el sıkışma veya adres haberleşmesi gerekmeden doğrudan veri aktarmaya başlayan bir protokoldür. Şekil 1'de AXI-S protokolünün arayüz sinyalleri üzerinden çalışma prensibi incelenebilir.

<p align="center">
  <img src="https://vhdlverilog.com/images/axis_slave/sekil_1.png" width="1580"/>
  <em>Şekil 1 - AXI-S protokolünün çalışma prensibi</em>
</p>

Ek olarak Kilitlenmeyi engellemek için protokol kuralları gereği TVALID sinyali, TREADY sinyalinin '1' olmasını bekleyemez. Bununla

Bu yazı içeriğinde HDMI ve VGA gibi görüntü aktarım uygulamarında doğrudan kullanılabilecek AXI-S Slave arayüzü tasarımı yapılmıştır.

HDMI ve VGA arayüzlerinde kaynak tarafından üretilen görüntüler ile gönderimin yapıldığı arayüz arasındaki veri senkronizasyonu kritiktir. Farklı clock domaininde çalışan kaynak ve görüntü arayüzü arasındaki senkronizasyon bufferler ile sağlanır. Üretilen veri miktarı >= gönderilen veri miktarı ve kaynak clock frekansı <= arayüz clock frekansı koşulları sağlandığı taktirde clock domaini çevrimi yapılacak bir adet FIFO ile herhangi bir kesinti olmaksızın veri aktarımı sağlanabilir.
İki clock girişi destekleyen bir FIFO üzerinden sağlanan bu akışta FIFO'nun clock domain crossing özelliği kullanılmaktadır. Ayrıca AXI-S protokolüne uygun olarak FIFO'nun doluluk/boşluk durumuna göre TREADY sinyali üretilmektedir. Sistemin gecikmesini minimumda tutmak amacıyla, okuma işlemine başlamak için FIFO'da tam bir satırın birikmesi beklenmez. Kaynak frekansı (ACLK) hedef frekanstan (PIXEL_CLK) yüksek olduğu için FIFO'nun ekran modülünü kesintisiz beslemesi öngörülür.

Xilinx ve çoğu diğer IP Core geliştirici video amaçlı AXI-S uygulamalarında TUSER sinyalini kare başlangıcı sinyali (Start of Frame, SoF) olarak kullanmaktadır. Bu uygulamada da TUSER sinyali SoF sinyali amacıyla kullanılmıştır. Ekrandaki görüntünün ilk satırının ilk pixel verisinde SoF sinyali '1' yapılmaktadır.

Benzer doğrultuda TLAST sinyali satır sonu sinyali (End of Line, EoL) olarak kullanılmaktadır. Aktarılan satırın son pixel verisinde EoL sinyali '1' yapılmaktadır.

HDMI standardında RGB kanallarının her birisinin 8 bit olarak aktarılması gerekmektedir. Bu uygulamada TDATA sinyali sırasıyla Kırmızı(R), Yeşil(G) ve Mavi(B) kanallarının birleştirilmesiyle oluşan 24 bitlik sinyal formatındadır. Bu renk verisi FIFO'ya yazılırken toplamda 26 bit olacak şekilde TUSER(SoF) ve TLAST(EoL) sinyalleriyle birleştirilerek yazılır. TUSER(SoF) ve TLAST(EoL) bitleri sırasıyla 25 ve 24. bit olacak şekilde yerleştirilmektedir. Bu sayede FIFO'dan veriyi çeken hedef modül kendi senkronizasyonunu sağlayabilmektedir.

FIFO, çıkışta veriyi her zaman hazırda tutan First Word Fall Through (FWFT) olarak ayarlanarak kullanılmıştır. Bu sayede AXI-S protokolünün gerektirdiği üzere TREADY ve TVALID sinyalleri '1' olduklarında doğrudan veri akışı başlayabilmekte, herhangi bir clock gecikmesi bulunmamaktadır. FIFO'nun durum sinyalleri kullanılarak dolu değilken gelen verinin kabul edilebileceğini belirten TREADY'nin '1' olması sağlanmış, aynı şekilde dolu değilken geçerli veri geldiğinde (TVALID = '1') verinin FIFO'ya yazılması sağlanmıştır.

SoF sinyali hazır olarak bulunan FIFO veri çıkışından concurrent olarak modül dışarısına aktarılmıştır. Bunun sebebi, görüntü senkronizasyon sinyallerini üreten modülden yeni bir karenin başladığını, verinin register'a yazılmasını beklemeden anında yakalaması gerekliliğidir.

Son olarak HDMI veya VGA'nın senkronizasyon sinyallerini üreten modülden gelen enable girişi ile modul aktifken FIFO'dan çıkan veri arayüz modülünün çalışma frekansı ile bir register üzerinden dışarıya aktarılmıştır.

Vivado 2024.1 ile FIFO Generator 13.2 (Rev. 10) kullanılarak oluşturulan FWFT FIFO'nun konfigürasyon ayarları şekil 2'de verilmiştir.

<p align="center">
  <img src="https://vhdlverilog.com/images/axis_slave/sekil_2.png" width="3560"/>
  <em>Şekil 2 - FWFT FIFO konfigürasyon ayarları</em>
</p>

VHDL ile yazılan ve özel tasarlanmış HDMI IP Core'unde kullanılan AXI-S slave arayüz kodu aşağıda verilmiştir.
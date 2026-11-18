-- ============================================================
-- PIZZA_ANALIZ.SQL
-- Soru: Bir pizzacinin yillik cirosu ve siparis sayisi ne kadar,
--       hangi gun ve saatlerde yogunluk var?
--
-- Kullanilan tablolar:
--   orders        (order_id, date, time)
--   order_details (order_details_id, order_id, pizza_id, quantity)
--   pizzas        (pizza_id, pizza_type_id, size, price)
--
-- Once pizza_kurulum.sql calistirilmis ve pizza_db veritabani
-- doldurulmus olmali. Bu dosyayi calistirmadan once:
--   USE pizza_db;
-- ============================================================

USE pizza_db;


-- ------------------------------------------------------------
-- SORGU 1: TOPLAM CIRO
-- ------------------------------------------------------------
-- Ciro = her siparis satirindaki (adet * fiyat) degerlerinin toplami.
-- order_details tablosunda fiyat yok, sadece pizza_id var; fiyat
-- pizzas tablosunda. Bu yuzden iki tabloyu pizza_id uzerinden
-- JOIN ile birlestirip, her satirin (quantity * price) degerini
-- SUM() ile topluyoruz.
SELECT
    SUM(od.quantity * p.price) AS toplam_ciro
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id;


-- ------------------------------------------------------------
-- SORGU 2: TOPLAM SIPARIS SAYISI
-- ------------------------------------------------------------
-- Her siparis (order_id) icinde birden fazla pizza satiri olabilir
-- (orn. bir siparişte 3 farkli pizza). Bu yuzden order_details
-- tablosundaki satir sayisini saymak yanlis olur; "kac farkli
-- siparis var" sorusuna cevap vermek icin COUNT(DISTINCT order_id)
-- kullaniyoruz, boylece her siparis sadece 1 kez sayilir.
SELECT
    COUNT(DISTINCT order_id) AS toplam_siparis_sayisi
FROM orders;


-- ------------------------------------------------------------
-- SORGU 3: SIPARIS BASINA ORTALAMA TUTAR
-- ------------------------------------------------------------
-- Ortalama tutar = toplam ciro / toplam siparis sayisi.
-- Burada iki JOIN'li tablodan ciroyu, orders tablosundan siparis
-- sayisini aliyoruz; ayni SELECT icinde iki farkli hesabi
-- bolerek tek bir sonuc satiri elde ediyoruz.
SELECT
    SUM(od.quantity * p.price) / COUNT(DISTINCT od.order_id)
        AS ortalama_siparis_tutari
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id;


-- ------------------------------------------------------------
-- SORGU 3b (BONUS): UC METRIGI TEK SATIRDA GETIR
-- ------------------------------------------------------------
-- Tableau'da 3 ozet kutucuk (KPI) hazirlarken tek bir CSV/sorgu
-- yeterli olsun diye toplam ciro, toplam siparis ve ortalama
-- tutari aynı satirda hesapliyoruz.
SELECT
    SUM(od.quantity * p.price) AS toplam_ciro,
    COUNT(DISTINCT od.order_id) AS toplam_siparis_sayisi,
    SUM(od.quantity * p.price) / COUNT(DISTINCT od.order_id)
        AS ortalama_siparis_tutari
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id;


-- ------------------------------------------------------------
-- SORGU 4: GUN x SAAT YOGUNLUGU
-- ------------------------------------------------------------
-- Hangi gun ve saatte kac siparis geldigini bulmak icin:
--   DAYNAME(date) -> tarihten gunun adini cikarir (orn. "Friday")
--   HOUR(time)    -> saatten sadece saat kismini cikarir (orn. 13)
-- Ayni gun+saat kombinasyonuna dusen siparisleri bir grup sayarak
-- saymak icin GROUP BY DAYNAME(date), HOUR(time) kullaniyoruz.
-- COUNT(DISTINCT order_id) kullaniyoruz ki ayni siparisin birden
-- fazla pizza satiri varsa tekrar tekrar sayilmasin.
-- DAYOFWEEK(date) sadece siralama icin eklendi (1=Pazar...7=Cumartesi
-- degil, MySQL'de 1=Pazar, 2=Pazartesi... Boylece Pazartesi'den
-- Pazar'a dogru siralanir); ekranda gorunmesi gerekmiyor ama
-- ORDER BY icin GROUP BY'a eklenmesi gerekiyor.
SELECT
    DAYNAME(o.`date`)      AS gun,
    DAYOFWEEK(o.`date`)    AS gun_sira_no,
    HOUR(o.`time`)         AS saat,
    COUNT(DISTINCT o.order_id) AS siparis_sayisi
FROM orders o
GROUP BY DAYNAME(o.`date`), DAYOFWEEK(o.`date`), HOUR(o.`time`)
ORDER BY gun_sira_no, saat;

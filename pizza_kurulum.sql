-- ============================================================
-- PIZZA_KURULUM.SQL
-- Amac: pizza_db veritabanini olusturmak, tablolari tanimlamak
--       ve data/ klasorundeki CSV dosyalarini bu tablolara yuklemek.
-- Nasil calistirilir (PowerShell, bu dosyanin bulundugu klasorden):
--   cd "pizza-sql-tableau" klasorune gir
--   & "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p --local-infile=1 < pizza_kurulum.sql
-- Not: --local-infile=1 bayragi, LOAD DATA LOCAL INFILE komutunun
--      calismasi icin gereklidir (kendi bilgisayarindaki dosyayi okur).
-- ============================================================

-- 1) Veritabanini olustur (varsa dokunma) ve kullanima al
CREATE DATABASE IF NOT EXISTS pizza_db;
USE pizza_db;

-- local_infile ayarini bu oturum icin acik hale getiriyoruz.
-- (Sunucu tarafinda da acik olmasi gerekir; mysql'i --local-infile=1 ile
--  baslattigimiz icin bu genelde otomatik calisir.)
SET GLOBAL local_infile = 1;

-- Onceki denemeden kalan tablolar varsa temiz baslamak icin kaldir
DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS pizzas;

-- 2) orders tablosu: her siparisin tarihi ve saati
-- date  -> DATE tipinde: sadece gun/ay/yil tutar (saat bilgisi yok)
-- time  -> TIME tipinde: sadece saat/dakika/saniye tutar
-- Bu ayrim, ileride DAYNAME() ve HOUR() gibi fonksiyonlarla
-- "hangi gun / hangi saat" analizini kolaylastirir.
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    `date` DATE NOT NULL,
    `time` TIME NOT NULL
);

-- 3) pizzas tablosu: her pizzanin boyutu ve fiyati
-- pizza_type_id burada sadece referans olarak tutulur;
-- pizza_types tablosu bu projede kullanilmiyor (gorev tanimina gore).
CREATE TABLE pizzas (
    pizza_id VARCHAR(30) PRIMARY KEY,
    pizza_type_id VARCHAR(30) NOT NULL,
    size VARCHAR(5) NOT NULL,
    price DECIMAL(6,2) NOT NULL
);

-- 4) order_details tablosu: bir siparis icinde kac adet hangi pizza var
-- order_id  -> orders tablosuna, pizza_id -> pizzas tablosuna baglanir (FK)
-- Boylece "ciro" hesabi icin quantity * price JOIN ile carpilabilir.
CREATE TABLE order_details (
    order_details_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    pizza_id VARCHAR(30) NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (pizza_id) REFERENCES pizzas(pizza_id)
);

-- 5) CSV dosyalarini tablolara yukle
-- FIELDS TERMINATED BY ','  -> sutunlar virgulle ayrilmis (CSV)
-- IGNORE 1 ROWS             -> CSV'nin ilk satiri baslik (header), o yuklenmez
-- LOAD DATA LOCAL INFILE, pizzas tablosunu orders/order_details'tan once
-- yukluyoruz cunku order_details icindeki FOREIGN KEY, pizzas tablosunun
-- once var olmasini gerektirir.
LOAD DATA LOCAL INFILE 'data/pizzas.csv'
INTO TABLE pizzas
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(pizza_id, pizza_type_id, size, price);

LOAD DATA LOCAL INFILE 'data/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, `date`, `time`);

LOAD DATA LOCAL INFILE 'data/order_details.csv'
INTO TABLE order_details
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_details_id, order_id, pizza_id, quantity);

-- 6) Kontrol: her tabloda kac satir var?
-- Beklenen: orders ~21.350 | order_details ~48.620 | pizzas 96
SELECT 'orders' AS tablo, COUNT(*) AS satir_sayisi FROM orders
UNION ALL
SELECT 'order_details', COUNT(*) FROM order_details
UNION ALL
SELECT 'pizzas', COUNT(*) FROM pizzas;

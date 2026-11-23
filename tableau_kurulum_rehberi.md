# Tableau Public Kurulum Rehberi — Pizza Satış Analizi

Bu rehber, elindeki iki CSV dosyasını (`exports/ozet_metrikler.csv` ve
`exports/gun_saat_yogunluk.csv`) kullanarak tek sayfalık bir dashboard
kurmanı adım adım anlatır. Tableau'yu kendi bilgisayarında açıp tıklaya
tıklaya ilerleyeceksin.

## 0) Hazırlık

- Tableau Public Desktop'ı indir (ücretsiz): tableau.com/products/public/download
- Kurulumu tamamla ve uygulamayı aç.
- Not: Tableau Public'e **yükleme (yayınlama)** adımında kendi hesabınla
  giriş yapman gerekecek — o noktada sana haber vereceğim, giriş
  bilgilerini ben girmeyeceğim.

## 1) Veriyi bağla

1. Tableau Public'i aç → sol üstte **"Connect"** panelinde **"Text file"** seç.
2. `exports/gun_saat_yogunluk.csv` dosyasını seç. (Bu, ısı tablosu ve
   çubuk grafik için kullanacağımız ana veri.)
3. Açılan ekranda sütun tiplerini kontrol et:
   - `gun` → metin (string)
   - `gun_sira_no` → sayı (tamsayı)
   - `saat` → sayı (tamsayı)
   - `siparis_sayisi` → sayı (tamsayı)
4. Sol altta **"Sheet 1"** sekmesine tıkla, çalışma alanına geç.
5. İkinci veri kaynağını eklemek için üstteki menüden **Data → New Data Source**
   seç ve `exports/ozet_metrikler.csv` dosyasını bağla. (Bu, 3 özet
   kutucuk için kullanılacak.)

## 2) Sheet 1 — Gün × Saat Isı Tablosu (Highlight Table)

1. Veri kaynağı olarak `gun_saat_yogunluk` seçili olsun.
2. Sol taraftaki **Dimensions** altından `gun` alanını sürükleyip
   **Rows** (Satırlar) alanına bırak.
3. `saat` alanını (Measures/Dimensions altında görünür, sayısal) sürükleyip
   **Columns** (Sütunlar) alanına bırak. Eğer sütun olarak "sayı" (yeşil
   top) görünüyorsa, üzerine sağ tık → **Convert to Discrete** yap (mavi
   top olmalı, yoksa ısı tablosu ızgarası oluşmaz).
4. `siparis_sayisi` alanını **Color** (Renk) kutusuna sürükle (Marks kartı
   üzerinde).
5. Marks kartının üstündeki açılır menüden **"Square"** (kare) seç —
   bu, görünümü klasik bir ısı tablosuna çevirir.
6. Günlerin doğru sırada (Pazartesi→Pazar) görünmesi için: `gun`
   alanına sağ tık → **Sort** → `gun_sira_no` alanına göre sırala
   (ya da Rows'a önce `gun_sira_no`'yu discrete olarak ekleyip `gun`
   ile birlikte kullan, sonra `gun_sira_no` pill'ini gizle).
7. Bu sheet'in adını `Gün x Saat Yoğunluk` olarak değiştir (sekme
   üzerine çift tık).

## 3) Sheet 2 — Saate Göre Sipariş Sayısı (Çubuk Grafik)

1. Yeni bir sheet aç (alttaki **+** ikonuna tıkla).
2. Aynı veri kaynağını (`gun_saat_yogunluk`) kullan.
3. `saat` alanını **Columns**'a, `siparis_sayisi`'ni **Rows**'a sürükle.
4. Marks kartından **"Bar"** (çubuk) seçili olduğundan emin ol.
5. Üstte **Analytics** sekmesinden "Totals" ya da basitçe grafiğin
   kendisi zaten saat bazında toplamı gösterecek (gün ayrımı yok çünkü
   `gun` alanını bu sheet'e eklemedik).
6. Sheet adını `Saatlik Sipariş Sayısı` yap.

## 4) Sheet 3 — 3 Özet Kutucuk (KPI)

1. Yeni bir sheet aç, veri kaynağı olarak `ozet_metrikler` seç.
2. `toplam_ciro` alanını **Text** (Marks kartındaki metin kutusu) içine
   sürükle → büyük bir sayı olarak görünecek.
3. Format için sayı üzerine sağ tık → **Format** → Number → Currency
   (Custom) seçip `$` işareti ekle, 2 ondalık basamak bırak.
4. Yazı boyutunu büyütmek için Marks kartı → **Text** → font boyutunu
   24-32pt yap.
5. Bu işlemi `toplam_siparis_sayisi` ve `ortalama_siparis_tutari` için
   ayrı ayrı iki sheet daha açarak tekrarla (toplam 3 küçük KPI sheet'i).
6. Her birinin adını değiştir: `KPI - Ciro`, `KPI - Siparis Sayisi`,
   `KPI - Ortalama Tutar`.

## 5) Dashboard'u birleştir

1. Alttan **"New Dashboard"** sekmesine tıkla.
2. Sağ panelden sheet'leri sürükleyip yerleştir:
   - Üst satıra 3 KPI sheet'ini yan yana koy (küçük kutular).
   - Altına solda `Gün x Saat Yoğunluk` ısı tablosu, sağda ya da
     altında `Saatlik Sipariş Sayısı` çubuk grafiği.
3. Üstte bir **Text** objesi ekleyip başlık yaz — bulgularına göre
   gerçek bir cümle, örnek:
   **"En yoğun saat 12:00–13:00, en yoğun gün Cuma"**
4. Dashboard adını `Pizza Satış Analizi` yap (üst sekmeye çift tık).

## 6) Tableau Public'e yükleme (senin gireceğin kısım)

1. Üst menüden **File → Save to Tableau Public As...** seç.
2. Açılan pencerede Tableau Public hesabınla **giriş yap** (bunu sen
   yapacaksın).
3. Dashboard'a bir isim ver (örn. "Pizza Satış Analizi") ve kaydet.
4. Kaydetme bitince tarayıcıda otomatik açılan sayfadaki linki kopyala —
   bu link README.md'deki "Dashboard linki" kısmına eklenecek.
5. Hazır olunca bana haber ver, linki README'ye ben ekleyeyim.

## 7) Ekran görüntüsü al

1. Dashboard tam göründüğü haliyle ekran görüntüsü al (Windows: `Win + Shift + S`).
2. Kaydettiğin görüntüyü `pizza-sql-tableau/dashboard/dashboard.png` olarak kaydet
   (klasör zaten hazır, sadece dosyayı içine koy).

---

### Sorun giderme (yaygın hatalar)

- **Isı tablosunda kareler görünmüyor, sadece sayı listesi var** →
  Marks kartındaki açılır menüden "Square" seçili olduğundan emin ol.
- **Günler alfabetik sıralanıyor (Friday en başta)** → `gun_sira_no`
  alanına göre sıralama yapmayı unutmuş olabilirsin (Adım 2.6).
- **"Saat" alanı sürekli bir çizgi/eksen gibi davranıyor, ayrı sütunlar
  oluşmuyor** → `saat` alanını sağ tık → **Convert to Discrete** yap.

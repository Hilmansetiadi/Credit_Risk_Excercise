# 📊 End-to-End Credit Risk Analytics Dashboard

## 📌 Project Overview
Proyek ini membangun solusi analitik risiko kredit komprehensif dari hulu ke hilir (*end-to-end*). Proses dimulai dari optimasi penyimpanan dan pembersihan data mentah (dataset finansial berukuran besar) menggunakan **MySQL Workbench**, hingga visualisasi metrik risiko operasional secara dinamis menggunakan **Power BI Desktop**. Dasbor ini dirancang untuk membantu Manajemen Risiko (*Risk Management*) mengevaluasi kesehatan portofolio kredit, mendeteksi kantong risiko, dan mengoptimalkan strategi suku bunga.

---

## 🛠️ Tech Stack & Skills Demonstrated
* **Database Management:** MySQL Workbench (ETL, Data Cleaning, SQL Views, Optimization)
* **Data Visualization:** Power BI Desktop (Interactive Dashboarding, UI/UX Design)
* **Analytical Expressions:** DAX - Data Analysis Expressions (Advanced Measures & Calculations)
* **Analytical Framework:** Data-Driven Storytelling & Credit Risk Framework

---

## 🗄️ Database Architecture & Data Preparation (MySQL)
Untuk menangani volume data yang besar secara efisien, proses *data ingestion* dilakukan menggunakan perintah `LOAD DATA LOCAL INFILE` guna menghindari isu *timeout* koneksi. 

Transformasi data dilakukan pada layer database menggunakan **SQL View** untuk menjaga performa komputasi Power BI. Logika bisnis utama yang diterapkan meliputi:
1.  **Pembersihan Data:** Mengisolasi nilai anomali dan menangani nilai kosong (*missing values*).
2.  **Pembuatan Target Variable (`is_default`):** Mengklasifikasikan nasabah gagal bayar berdasarkan status pinjaman (`Charged Off`, `Default`) menggunakan pernyataan `CASE WHEN`.

---

## 📈 Dashboard Architecture (Power BI)

### Page 1: Executive Risk Monitoring
![Dashboard Page 1](assets/dashboard_page1.png) *(Ganti dengan gambar screenshot dasbormu)*

Halaman utama berfokus pada visualisasi metrik makro portofolio menggunakan formula **DAX** kustom:
* **Total Loan Applications:** `COUNT(id)` -> Mengukur volume aplikasi.
* **Total Funded Amount:** `SUM(funded_amnt)` -> Menghitung total eksposur modal tersalurkan.
* **Good Loan Rate:** Mengukur persentase portofolio kredit yang berstatus sehat (`Fully Paid`, `Current`, `Issued`).
* **Default Rate (NPL):** Menghitung proporsi nasabah macet terhadap total portofolio.
* **Bad Loan Amount:** Mengukur nilai kapital riil yang terancam gagal bayar.

---

## 🔎 Key Business Insights (Laporan Eksekutif)

### 1. Kesehatan Portofolio Makro
Perusahaan telah menyalurkan dana sebesar **$169.26M** dari **14K aplikasi**. Rasio kredit lancar (*Good Loan Rate*) tercatat di angka **84.64%**, namun modal yang tertahan pada kategori macet (*Bad Loan Amount*) telah menyentuh **$27.25M** dengan akumulasi *Default Rate* makro sebesar **14.95%**. 

### 2. Validasi Sistem Scoring Risiko (Grade Analysis)
Realisasi data membuktikan klasifikasi risiko internal bekerja secara akurat. Nasabah **Grade A** memiliki tingkat gagal bayar terendah sebesar **6.97%**, sedangkan nasabah **Grade G** mencatatkan risiko tertinggi sebesar **37.74%**. Lonjakan risiko kritis (>20%) dimulai sejak nasabah masuk ke **Grade E (26.00%)**.

### 3. Konsentrasi Risiko Tujuan Pinjaman
Setengah dari total portofolio pinjaman perusahaan didominasi oleh satu tujuan tunggal, yaitu **Debt Consolidation (50.16%)**. Konsentrasi yang terlalu tinggi pada segmen nasabah pelarian utang ini menjadi pendorong utama tingginya angka gagal bayar makro.

### 4. Ambang Batas Suku Bunga (Interest Rate Border)
Berdasarkan analisis grafik tren, tingkat kegagalan bayar relatif stabil dan terkendali pada suku bunga di bawah 15%. Namun, terdapat volatilitas dan lonjakan risiko ekstrem yang tidak kompensatif ketika instrumen suku bunga dipatok **di atas 20%**.

---

## 💡 Strategic Recommendations (Aksi Operasional)
1.  **Credit Tightening:** Terapkan pembatasan kuota persetujuan (*approval limit*) yang ketat atau naikkan batas kriteria minimum pendapatan bagi pemohon yang masuk dalam klasifikasi risiko **Grade E, F, dan G**.
2.  **Product Diversification:** Kurangi risiko konsentrasi pada *Debt Consolidation* (50.16%) dengan mengalihkan fokus operasional dan pemasaran ke produk pinjaman yang lebih aman atau produktif (seperti *Home Improvement* atau *Major Purchase*).
3.  **Interest Cap Evaluation:** Evaluasi atau hentikan kebijakan penetapan suku bunga di atas 20%. Tingginya risiko gagal bayar di segmen tersebut terbukti menguras profitabilitas margin yang dihasilkan.

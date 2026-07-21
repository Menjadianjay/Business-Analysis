# Business & Product Case Studies Team

> Business and product case studies that uncover actionable insights from multiple business perspectives to support strategic product decisions.

## Tentang Project Ini

Tim ini fokus membedah studi kasus bisnis dan produk nyata (atau hipotetis) dari berbagai sudut pandang — strategi, produk, operasional, finansial, dan pengguna — untuk menghasilkan insight yang bisa langsung dipakai dalam pengambilan keputusan produk.

Output akhir dari setiap case study idealnya bukan sekadar analisis akademis, tapi rekomendasi yang actionable: "apa yang sebaiknya dilakukan tim produk berdasarkan temuan ini?"

---

## Tujuan

- Melatih kemampuan berpikir strategis lintas fungsi (bisnis, produk, data, UX).
- Membangun repository studi kasus yang bisa jadi referensi tim internal.
- Menghasilkan rekomendasi konkret yang bisa diuji atau diterapkan.
- Mengasah kemampuan storytelling data dan presentasi insight ke stakeholder.

---

## Langkah-Langkah Membangun Project Ini

### 1. Definisikan Ruang Lingkup & Tujuan Tim
- Tentukan fokus: apakah case study bersifat industri umum, spesifik startup, atau internal perusahaan sendiri?
- Tetapkan target audiens dari hasil case study (misalnya: tim produk, calon investor, portofolio pribadi, komunitas belajar).
- Buat pernyataan misi singkat tim (bisa pakai deskripsi yang sudah kamu tulis sebagai starting point).

### 2. Susun Struktur Tim
- **Case Lead** — menentukan topik, koordinasi timeline.
- **Business Analyst** — analisis model bisnis, revenue, market positioning.
- **Product Analyst** — analisis fitur, UX, product-market fit.
- **Data/Research Support** — mengumpulkan data pendukung, riset sekunder.
- **Writer/Editor** — menyusun narasi akhir agar mudah dibaca.

> Untuk tim kecil, satu orang bisa merangkap beberapa peran.

### 3. Buat Kerangka Kerja (Framework) Analisis
Tetapkan framework standar agar setiap case study konsisten, misalnya kombinasi dari:
- **Business Model Canvas** — untuk memahami model bisnis secara menyeluruh.
- **SWOT / Porter's Five Forces** — untuk analisis kompetitif dan strategis.
- **Jobs to be Done (JTBD)** — untuk memahami motivasi pengguna.
- **RICE / ICE Scoring** — untuk memprioritaskan rekomendasi.
- **North Star Metric & AARRR (Pirate Metrics)** — untuk sudut pandang growth/produk.

Dokumentasikan framework ini di file terpisah (`/framework.md`) agar semua anggota tim pakai standar yang sama.

### 4. Pilih & Validasi Topik Case Study
- Buat daftar kandidat perusahaan/produk yang menarik untuk dibedah.
- Prioritaskan berdasarkan: ketersediaan data publik, relevansi industri, tingkat kompleksitas.
- Validasi dengan tim: apakah topik ini cukup kaya untuk dianalisis dari banyak perspektif?

### 5. Kumpulkan Data & Riset
- Sumber: laporan tahunan, artikel berita, wawancara (jika memungkinkan), data publik (app store reviews, social listening, dsb).
- Catat semua sumber untuk menjaga kredibilitas dan menghindari klaim yang tidak terverifikasi.
- Simpan riset mentah di folder `/research/{nama-case}/`.

### 6. Lakukan Analisis Multi-Perspektif
Setiap case study sebaiknya dianalisis minimal dari 3 sudut pandang, misalnya:
- **Perspektif Bisnis**: model revenue, unit economics, positioning pasar.
- **Perspektif Produk**: fitur utama, user flow, diferensiasi.
- **Perspektif Pengguna**: pain point, motivasi, hambatan adopsi.
- **Perspektif Kompetitif**: bagaimana posisi terhadap pesaing.

### 7. Rumuskan Insight & Rekomendasi
- Insight harus spesifik dan didukung data, bukan opini umum.
- Setiap insight idealnya diikuti rekomendasi aksi yang jelas: *"Karena X, tim produk sebaiknya melakukan Y untuk mencapai Z."*
- Gunakan prioritization framework (RICE/ICE) untuk mengurutkan rekomendasi mana yang paling berdampak.

### 8. Dokumentasikan dalam Format Standar
Buat template case study, misalnya:
```
1. Ringkasan Eksekutif
2. Latar Belakang Perusahaan/Produk
3. Masalah/Tantangan yang Dibahas
4. Analisis (per perspektif)
5. Temuan Kunci (Key Insights)
6. Rekomendasi Strategis
7. Referensi/Sumber Data
```
Simpan template ini di `/templates/case-study-template.md`.

### 9. Review & Diskusi Tim
- Lakukan sesi review internal sebelum publikasi — cek validitas argumen, bukan hanya kerapian tulisan.
- Undang perspektif "devil's advocate" untuk menguji ketahanan rekomendasi.

### 10. Publikasikan & Kumpulkan Feedback
- Publikasikan case study (blog internal, Notion, Medium, atau repo ini).
- Minta feedback dari luar tim untuk menguji apakah insight benar-benar actionable.
- Update case study jika ada data baru yang relevan.

### 11. Bangun Ritme & Kadensa Tim
- Tentukan target output (misalnya 1 case study per 2 minggu).
- Retrospektif berkala: apa yang bisa diperbaiki dari proses analisis atau kolaborasi tim.

---

## Struktur Folder yang Disarankan

```
/case-studies-team
├── README.md
├── framework.md
├── templates/
│   └── case-study-template.md
├── research/
│   └── {nama-case}/
├── case-studies/
│   └── {nama-case}.md
└── retrospectives/
    └── {tanggal}.md
```

---

## Prinsip Kerja Tim

- **Data-driven, bukan asumsi** — setiap klaim harus bisa ditelusuri ke sumber.
- **Actionable over academic** — insight tanpa rekomendasi aksi dianggap belum selesai.
- **Multi-perspektif wajib** — hindari analisis satu sudut pandang saja.
- **Iteratif** — case study bisa direvisi ketika ada data atau perspektif baru.

---

## Langkah Selanjutnya

- [ ] Finalisasi anggota tim dan pembagian peran
- [ ] Buat `framework.md` dan `case-study-template.md`
- [ ] Pilih 1 case study pertama sebagai pilot
- [ ] Jadwalkan sesi kickoff tim

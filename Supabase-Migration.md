# Migrasi Data ke Supabase

Lanjutan dari [Data-Integration-Docker.md](Data-Integration-Docker.md). Kalau
dataset di `retailspg` (Docker) sudah lengkap dan mau dipakai secara online /
dishare ke tim lewat Supabase, ini caranya.

> **Prasyarat**: data sudah ter-load ke container `retailspg` (lihat
> [Data-Integration-Docker.md](Data-Integration-Docker.md)), atau minimal
> file `data/schema.sql` dan CSV di `data/` sudah ada.

## Daftar Isi

1. [Konsep singkat](#1-konsep-singkat)
2. [Buat project Supabase & ambil credential](#2-buat-project-supabase--ambil-credential)
3. [Test koneksi](#3-test-koneksi)
4. [Pindahkan data](#4-pindahkan-data)
5. [Verifikasi](#5-verifikasi)
6. [Hal-hal yang perlu diperhatikan](#6-hal-hal-yang-perlu-diperhatikan)

---

## 1. Konsep singkat

Supabase itu Postgres juga — mereka hosting instance PostgreSQL di cloud,
ditambah fitur lain (Auth, Storage, Studio UI) di atasnya. Jadi "connect
Docker ke Supabase" sebenarnya bukan fitur Docker — cukup **ambil connection
string dari Supabase, lalu pakai tool Postgres biasa untuk pindahin data**
dari container ke database itu. Docker cuma sumber datanya, bukan bagian
dari proses koneksi.

## 2. Buat project Supabase & ambil credential

1. Daftar di [supabase.com](https://supabase.com) → **New Project**.
2. Pilih region, lalu set **database password** — catat baik-baik, Supabase
   tidak menampilkannya lagi setelah ini.
3. Buka **Project Settings → Database**. Ada dua mode koneksi:

   | Mode | Port | Dipakai untuk |
   |---|---|---|
   | **Direct connection** | `5432` | Migrasi schema, load data bulk — ini yang dipakai di tutorial ini |
   | **Connection pooler (pgbouncer)** | `6543` | Dipakai aplikasi saat runtime (banyak koneksi pendek) |

   Connection string-nya bentuknya:
   ```
   postgresql://postgres:[PASSWORD]@db.<project-ref>.supabase.co:5432/postgres
   ```

## 3. Test koneksi

```bash
psql "postgresql://postgres:[PASSWORD]@db.<project-ref>.supabase.co:5432/postgres"
```

Kalau berhasil connect, koneksi ke Supabase sudah beres — tidak perlu setup
VPN/firewall untuk project personal.

## 4. Pindahkan data

Dua cara, pilih salah satu:

### Opsi A — Replay schema.sql + CSV (disarankan untuk kasus ini)

`\copy` di `psql` jalan di sisi **client**, jadi bisa baca CSV langsung dari
disk kita sendiri — tidak perlu `docker cp` lagi, cukup arahkan ke connection
string Supabase:

```bash
psql "postgresql://postgres:[PASSWORD]@db.<ref>.supabase.co:5432/postgres" -f data/schema.sql

psql "postgresql://postgres:[PASSWORD]@db.<ref>.supabase.co:5432/postgres" \
  -c "\copy dim_date FROM 'data/dim_date.csv' WITH (FORMAT csv, HEADER true)"
# ulangi untuk dim_product, dim_customer, dim_store, lalu fact_sales paling akhir
```

Urutan tabel sama seperti di [Data-Integration-Docker.md § 4](Data-Integration-Docker.md#4-load-csv-ke-tabel)
— dimensi dulu, `fact_sales` terakhir (foreign key).

### Opsi B — Dump dari container, restore ke Supabase

Dipakai kalau state container `retailspg` sudah beda dari CSV asli (misal
sudah ada perubahan manual) dan yang mau dipindah adalah state itu:

```bash
docker exec retailspg pg_dump -U postgres --no-owner --no-privileges postgres > dump.sql
psql "postgresql://postgres:[PASSWORD]@db.<ref>.supabase.co:5432/postgres" -f dump.sql
```

`--no-owner --no-privileges` penting — role `postgres` di container dan di
Supabase adalah role yang berbeda secara internal, tanpa flag ini restore
bisa gagal saat mencoba `ALTER OWNER` ke role yang tidak ada di Supabase.

## 5. Verifikasi

Query count yang sama seperti di
[Data-Integration-Docker.md § 5](Data-Integration-Docker.md#5-verifikasi),
tinggal arahkan ke connection string Supabase:

```bash
psql "postgresql://postgres:[PASSWORD]@db.<ref>.supabase.co:5432/postgres" -c "
  SELECT 'dim_date', count(*) FROM dim_date
  UNION ALL SELECT 'dim_product', count(*) FROM dim_product
  UNION ALL SELECT 'dim_customer', count(*) FROM dim_customer
  UNION ALL SELECT 'dim_store', count(*) FROM dim_store
  UNION ALL SELECT 'fact_sales', count(*) FROM fact_sales;"
```

Atau lihat langsung di **Supabase Studio → Table Editor**. Angka yang
diharapkan sama seperti tabel di
[Data-Integration-Docker.md § 5](Data-Integration-Docker.md#5-verifikasi)
(730 / 400 / 2.000 / 40 / 60.000).

## 6. Hal-hal yang perlu diperhatikan

- **Jangan commit password/connection string Supabase ke git.** Simpan di
  `.env` dan masukkan ke `.gitignore`. Kalau perlu, buat `.env.example`
  dengan value kosong supaya tim tahu variabel apa saja yang dibutuhkan.
- Setelah ini, `retailspg` (Docker) dan Supabase jadi **dua database
  terpisah** — load data ke Supabase tidak otomatis sync balik ke
  `retailspg`, begitu juga sebaliknya. Tentukan mana yang jadi source of
  truth untuk CSV ke depannya.
- Project Supabase free-tier auto-pause kalau tidak ada aktivitas ~1 minggu —
  koneksi pertama setelah pause butuh beberapa detik ekstra untuk "bangun".

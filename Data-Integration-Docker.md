# Load CSV ke PostgreSQL (Docker Volume)

Lanjutan dari [Docker.md](Docker.md). Tutorial ini load dataset
[`data/`](data/README.md) (CSV) ke dalam container `retailspg`, supaya bisa
langsung dipakai latihan query SQL.

> **Prasyarat**: container `retailspg` sudah jalan (lihat
> [Docker.md § 2](Docker.md#2-jalankan-postgresql-di-container)). Cek dengan
> `docker ps` — harus muncul container bernama `retailspg`.

## Daftar Isi

1. [Konsep singkat](#1-konsep-singkat)
2. [Buat tabel (schema)](#2-buat-tabel-schema)
3. [Copy CSV ke dalam container](#3-copy-csv-ke-dalam-container)
4. [Load CSV ke tabel](#4-load-csv-ke-tabel)
5. [Verifikasi](#5-verifikasi)
6. [Load ulang dari awal](#6-load-ulang-dari-awal)

---

## 1. Konsep singkat

`psql` yang jalan **di dalam container** tidak bisa lihat file di komputer
kita (host) secara langsung. Jadi alurnya dua langkah:

1. **`docker cp`** — copy file dari host ke dalam filesystem container.
2. **`COPY` / `\copy`** — command PostgreSQL yang baca file itu dan masukkan
   isinya ke tabel.

Soal "tersimpan di volume" — itu otomatis. Volume `retailspg-data` di-mount
ke `/var/lib/postgresql/data`, yaitu path tempat PostgreSQL fisik menyimpan
semua tabel. Begitu data masuk lewat `COPY`, otomatis sudah ada di volume —
tidak ada langkah terpisah untuk "save ke volume".

## 2. Buat tabel (schema)

Tabel harus sudah ada dulu sebelum `COPY`, dengan kolom yang cocok sama CSV.
Schema-nya sudah disiapkan di [`data/schema.sql`](data/schema.sql) — 4 tabel
dimensi + 1 fact table, mengikuti model di
[`data/README.md`](data/README.md#the-model).

```bash
# copy file schema ke dalam container
docker cp data/schema.sql retailspg:/schema.sql

# jalankan untuk bikin semua tabel
docker exec retailspg psql -U postgres -f /schema.sql
```

## 3. Copy CSV ke dalam container

```bash
docker cp data/dim_date.csv     retailspg:/dim_date.csv
docker cp data/dim_product.csv  retailspg:/dim_product.csv
docker cp data/dim_customer.csv retailspg:/dim_customer.csv
docker cp data/dim_store.csv    retailspg:/dim_store.csv
docker cp data/fact_sales.csv   retailspg:/fact_sales.csv
```

## 4. Load CSV ke tabel

disclamer : jika pada saat copy muncul error duplicate key maka coba refresh table sql karena error tersebut muncul karena tabel sudah ada di database.
Urutan **penting**: tabel dimensi dulu, `fact_sales` paling akhir — karena
`fact_sales` punya foreign key ke keempat dimensi (baris sale tidak bisa
nunjuk ke customer/product/store/date yang belum ada).

```bash
docker exec retailspg psql -U postgres -c "\copy dim_date     FROM '/dim_date.csv'     WITH (FORMAT csv, HEADER true)"
docker exec retailspg psql -U postgres -c "\copy dim_product  FROM '/dim_product.csv'  WITH (FORMAT csv, HEADER true)"
docker exec retailspg psql -U postgres -c "\copy dim_customer FROM '/dim_customer.csv' WITH (FORMAT csv, HEADER true)"
docker exec retailspg psql -U postgres -c "\copy dim_store    FROM '/dim_store.csv'    WITH (FORMAT csv, HEADER true)"
docker exec retailspg psql -U postgres -c "\copy fact_sales   FROM '/fact_sales.csv'   WITH (FORMAT csv, HEADER true)"
```

Penjelasan singkat:
- `\copy` — command sisi client `psql` (perhatikan `\` di depan) untuk baca
  file lalu kirim ke server.
- `WITH (FORMAT csv, HEADER true)` — format file CSV, dan `HEADER true`
  supaya baris pertama (nama kolom) di-skip, bukan ikut dimasukkan sebagai data.

## 5. Verifikasi

```bash
docker exec retailspg psql -U postgres -c "
  SELECT 'dim_date', count(*) FROM dim_date
  UNION ALL SELECT 'dim_product', count(*) FROM dim_product
  UNION ALL SELECT 'dim_customer', count(*) FROM dim_customer
  UNION ALL SELECT 'dim_store', count(*) FROM dim_store
  UNION ALL SELECT 'fact_sales', count(*) FROM fact_sales;"
```

Angka yang diharapkan (sesuai [`data/README.md`](data/README.md)):

| Tabel | Jumlah baris |
|---|---|
| `dim_date` | 730 |
| `dim_product` | 400 |
| `dim_customer` | 2,000 |
| `dim_store` | 40 |
| `fact_sales` | 60,000 |

Kalau angkanya cocok, data sudah lengkap dan konsisten (integritas foreign
key-nya sudah diverifikasi di [`data/INTEGRITY.txt`](data/INTEGRITY.txt)).

## 6. Load ulang dari awal

`COPY` akan gagal kalau tabel sudah ada isinya (bentrok primary key). Untuk
load ulang dari kosong:

```bash
docker exec retailspg psql -U postgres -c "
  TRUNCATE fact_sales, dim_date, dim_product, dim_customer, dim_store CASCADE;"
```

Lalu ulangi step 4. Atau, kalau mau benar-benar dari nol (volume ikut
kehapus), lihat
[Docker.md § 5](Docker.md#5-command-docker-sehari-hari) untuk `docker rm -f`
lalu bikin ulang container-nya.

---

Mau data ini online / bisa diakses tim tanpa jalanin Docker masing-masing?
Lanjut ke [Supabase-Migration.md](Supabase-Migration.md).

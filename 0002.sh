#!/bin/bash
./iatrader/scripts/corrections/0001.sh
# Definir la ruta del directorio de archivos JSON
json_dir="/home/rgodim/iatrader/data/news/crypto/raw"

# Definir los detalles de conexión a la base de datos PostgreSQL
db_host="localhost"
db_port="5432"
db_name="news"
db_user="news"
db_password="F48YN9NAVTL1GUG6WB2LM8NEM"

# Crear la tabla "crypto" en la base de datos si no existe
PGPASSWORD="$db_password" psql -h "$db_host" -p "$db_port" -U "$db_user" -d "$db_name" -c "CREATE TABLE IF NOT EXISTS crypto (fecha DATE, pagina INTEGER, PRIMARY KEY (fecha, pagina));"

# Iterar sobre todos los archivos JSON en el directorio y agregarlos a la base de datos
for file in "$json_dir"/*.json; do
    fecha=$(echo "$file" | grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2}")
    pagina=$(echo "$file" | grep -oE "page-[0-9]+\.json" | sed 's/page-//;s/\.json//')
    PGPASSWORD="$db_password" psql -h "$db_host" -p "$db_port" -U "$db_user" -d "$db_name" -c "INSERT INTO crypto (fecha, pagina) VALUES ('$fecha', '$pagina') ON CONFLICT DO NOTHING;"
done
exit
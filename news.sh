#!/bin/bash
cd
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

# Definir la fecha inicial y final del intervalo
start_date="2021-05-12"
end_date=$(date -d "yesterday" +%F)

# Iterar sobre todas las fechas dentro del intervalo
while [ "$start_date" != "$end_date" ]; do
  # Iterar sobre las 10 páginas de newsverifier para la fecha actual
  for i in {1..10}; do
    # Verificar si los datos para esta fecha y página ya fueron descargados
    existencia=$(PGPASSWORD="$db_password" psql -h "$db_host" -p "$db_port" -U "$db_user" -d "$db_name" -t -c "SELECT COUNT(*) FROM crypto WHERE fecha='$start_date' AND pagina=$i;")

    # Si los datos ya fueron descargados, pasar a la siguiente página
    if [ "$existencia" -gt 0 ]; then
      echo "Datos para $start_date página $i ya descargados. Saltando..."
      continue
    fi

    # Obtener los datos de las newsverifier para la página actual
    query="https://api.newscatcherapi.com/v2/search?q=Crypto&from=$start_date&page=$i&page_size=100"
    headers="x-api-key: CTQjvu2OgArFtA_J14bmwxX6xOLFZJgjq_d9dF10eYU"
    curl -XGET "$query" -H "$headers" > "$json_dir/$start_date-page-$i.json"
    echo "Noticias para $start_date página $i descargadas correctamente."

    # Insertar los datos en la base de datos
    PGPASSWORD="$db_password" psql -h "$db_host" -p "$db_port" -U "$db_user" -d "$db_name" -c "INSERT INTO crypto (fecha, pagina) VALUES ('$start_date', $i);"
  done
sleep 10
  # Avanzar a la siguiente fecha
  start_date=$(date -d "$start_date + 1 day" +%F)
done

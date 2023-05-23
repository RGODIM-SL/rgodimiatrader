#!/bin/bash
cd
# Nombre del archivo CSV
filename="crypto.csv"

# Ruta completa del archivo CSV
filepath="/home/rgodim/iatrader/data/fear/$filename"

# Verificar si el archivo CSV existe
if [ -f $filepath ]; then
    # Obtener la última fecha en el archivo CSV
    last_date=$(tail -n 1 $filepath | cut -d ',' -f 1)
    # Obtener la fecha actual en formato YYYY-MM-DD
    date=$(date +'%Y-%m-%d')
    # Verificar si la fecha actual ya está en el archivo CSV
    if [ "$last_date" = "$date" ]; then
        echo "El archivo CSV ya está actualizado para la fecha de hoy."
        exit 0
    fi
fi

# Obtener los datos de la API del Fear and Greed Index
data=$(curl -s https://api.alternative.me/fng/)

# Extraer el valor del Fear and Greed Index y su clasificación
value=$(echo $data | jq -r '.data[0].value')
classification=$(echo $data | jq -r '.data[0].value_classification')

# Obtener la fecha actual en formato YYYY-MM-DD
date=$(date +'%Y-%m-%d')

# Escribir los datos en un archivo CSV
echo "$date,$value,$classification" >> $filepath

echo "Los datos del Fear and Greed Index han sido guardados en $filepath."

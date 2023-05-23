#!/bin/bash
cd
# Configuración de la API de CoinMarketCap
url="https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest"
symbol="BTC"
api_key="364ce6b5-347f-4702-82a6-4ed585c2401e" # Reemplaza esto con tu API Key de CoinMarketCap

# Configuración del archivo CSV
csv_header="Fecha,Precio"
csv_path="/home/rgodim/iatrader/data/live/BTC/$(date +%d-%m-%Y).csv"
echo "$csv_header" > "$csv_path"

# Bucle principal
while true; do
    # Obtener los datos de la API
    response=$(curl -s "$url?symbol=$symbol" -H "Accepts: application/json" -H "X-CMC_PRO_API_KEY: $api_key")
    precio=$(echo "$response" | jq -r '.data.BTC.quote.USD.price')
    fecha=$(date +%Y-%m-%d\ %H:%M:%S)
    
    # Imprimir el precio en la consola
    echo "$fecha,$precio"
    
    # Agregar el precio al archivo CSV
    echo "$fecha,$precio" >> "$csv_path"
    
    # Esperar 5 minutos antes de obtener el siguiente precio
    sleep 300
    
    # Si es un nuevo día, guardar los precios en un nuevo archivo CSV
    if [[ "$csv_path" != "/home/rgodim/iatrader/data/live/BTC/$(date +%d-%m-%Y).csv" ]]; then
        csv_path="/home/rgodim/iatrader/data/live/BTC/$(date +%d-%m-%Y).csv"
        echo "$csv_header" > "$csv_path"
    fi
done

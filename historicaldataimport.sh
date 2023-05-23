#!/bin/bash
cd
# Configuración de la API
API_KEY="TV1B05MBZJFXL435"
SYMBOL="BTCUSD"
OUTPUT_FILE="/home/rgodim/iatrader/data/historical/crypto/BTC.csv"

# Obtener los datos históricos de Alpha Vantage
JSON_DATA=$(curl -s "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=$SYMBOL&outputsize=full&apikey=$API_KEY")

# Extraer datos JSON relevantes usando jq y convertir a CSV
echo "$JSON_DATA" | jq -r '.["Time Series (Daily)"] | to_entries | map([.key, .value."1. open", .value."2. high", .value."3. low", .value."4. close", .value."5. adjusted close", .value."6. volume"] | join(",")) | join("\n")' | tr -d '\\' > "$OUTPUT_FILE"

# Comprobar si el archivo existe y tiene contenido
if [[ -s $OUTPUT_FILE ]]; then
  echo "Datos guardados correctamente en $OUTPUT_FILE"
else
  echo "Hubo un error al guardar los datos"
fi

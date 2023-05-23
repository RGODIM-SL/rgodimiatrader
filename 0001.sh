#!/bin/bash

# Cambia al directorio donde se encuentran los archivos JSON
cd /home/rgodim/iatrader/data/news/crypto/raw/

# Encuentra todos los archivos JSON de menos de 1KB y los elimina
find . -name "*.json" -size -2k -delete

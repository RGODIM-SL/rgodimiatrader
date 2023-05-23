#!/bin/bash

# API variables
API_URL='https://api.livecoinwatch.com/overview/history'
API_KEY='b6eb01a4-8586-460a-aeaf-a8612ef66616'
CURRENCY='USD'
START_DATE=1606232700000 # In milliseconds
END_DATE=$(date +%s)000 # In milliseconds

# CSV variables
CSV_FOLDER='/home/rgodim/iatrader/data/marketcap/crypto'
CSV_FILE="$CSV_FOLDER/BTC.csv"
CSV_HEADER='date,cap,volume,liquidity,btcDominance'

# Create CSV folder if it doesn't exist
mkdir -p $CSV_FOLDER

# Check if CSV file exists and create it if it doesn't
if [[ ! -f $CSV_FILE ]]; then
  echo $CSV_HEADER >> $CSV_FILE
fi

# Loop through each day between the start and end date
while [ $START_DATE -le $END_DATE ]; do

  # Get data from API for the current day
  response=$(curl -s -X POST $API_URL \
    -H "content-type: application/json" \
    -H "x-api-key: $API_KEY" \
    -d "{\"currency\":\"$CURRENCY\",\"start\":$START_DATE,\"end\":$START_DATE}")

  # Parse data for the current day
  date=$(date -d @$((START_DATE/1000)) +%Y-%m-%d)
  cap=$(echo $response | grep -oP '(?<=\"cap\":)[^,]*' | sed 's/}]//g')
  volume=$(echo $response | grep -oP '(?<=\"volume\":)[^,]*' | sed 's/}]//g')
  liquidity=$(echo $response | grep -oP '(?<=\"liquidity\":)[^,]*' | sed 's/}]//g')
  btc_dominance=$(echo $response | grep -oP '(?<=\"btcDominance\":)[^,]*' | sed 's/}]//g')

  # Append data for the current day to CSV file
  echo "$date,$cap,$volume,$liquidity,$btc_dominance" >> $CSV_FILE

  # Move to next day
  START_DATE=$((START_DATE+86400000))
done

# Sort data by date in ascending order
sort -t',' -k1 $CSV_FILE -o $CSV_FILE

# Print success message
echo "Data saved to $CSV_FILE sorted by date in ascending order"

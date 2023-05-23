#!/bin/bash
input_dir="/home/rrmgodinho/iatrader/data/news/json"
output_dir="/home/rrmgodinho/iatrader/data/news/csv"

for json_file in "$input_dir"/*.json; do
    filename=$(basename "$json_file" .json)
    output_subdir="$output_dir/$filename"
    mkdir -p "$output_subdir"

    jq -c '.articles[]' "$json_file" | while IFS= read -r article; do
        csv_file="$output_subdir/$(uuidgen).csv"

        title=$(jq -r '.title // empty' <<< "$article" | sed 's/"/""/g')
        author=$(jq -r '.author // empty' <<< "$article" | sed 's/"/""/g')
        published_date=$(jq -r '.published_date // empty' <<< "$article" | sed 's/"/""/g')
        published_date_precision=$(jq -r '.published_date_precision // empty' <<< "$article" | sed 's/"/""/g')
        link=$(jq -r '.link // empty' <<< "$article" | sed 's/"/""/g')
        clean_url=$(jq -r '.clean_url // empty' <<< "$article" | sed 's/"/""/g')
        excerpt=$(jq -r '.excerpt // empty' <<< "$article" | sed 's/"/""/g')
        summary=$(jq -r '.summary // empty' <<< "$article" | sed 's/"/""/g')
        rights=$(jq -r '.rights // empty' <<< "$article" | sed 's/"/""/g')
        rank=$(jq -r '.rank // empty' <<< "$article")
        topic=$(jq -r '.topic // empty' <<< "$article" | sed 's/"/""/g')
        country=$(jq -r '.country // empty' <<< "$article" | sed 's/"/""/g')
        language=$(jq -r '.language // empty' <<< "$article" | sed 's/"/""/g')
        authors=$(jq -r '.authors[] // empty' <<< "$article" | sed 's/"/""/g' | paste -sd "," -)
        media=$(jq -r '.media // empty' <<< "$article" | sed 's/"/""/g')
       is_opinion=$(jq -r '.is_opinion // empty' <<< "$article")
if [[ "$is_opinion" == "false" ]]; then
    is_opinion=true
else
    is_opinion=false
fi

twitter_account=$(jq -r '.twitter_account // empty' <<< "$article")
_score=$(jq -r '._score // empty' <<< "$article")

        echo "title,author,published_date,published_date_precision,link,clean_url,excerpt,summary,rights,rank,topic,country,language,authors,media,is_opinion,twitter_account,_score" > "$csv_file"
        echo "\"$title\",\"$author\",\"$published_date\",\"$published_date_precision\",\"$link\",\"$clean_url\",\"$excerpt\",\"$summary\",\"$rights\",$rank,\"$topic\",\"$country\",\"$language\",\"$authors\",\"$media\",$is_opinion,\"$twitter_account\",$_score,\"" >> "$csv_file"
echo "El artículo ha sido procesado y se ha creado el archivo CSV correspondiente: $csv_file"
done
echo "El archivo JSON $json_file ha sido procesado y se han creado los archivos CSV correspondientes."
done

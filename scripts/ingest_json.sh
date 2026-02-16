#!/usr/bin/bash

# Usage:
# ./ingest_json.sh input.json database.db table_name
# for example 
# ./ingest_json.sh instagram.json breaches.db instagram_2025 

set -e

JSON_FILE="$1"
DB_FILE="$2"
TABLE_NAME=$(echo "$3" | tr -cd 'a-zA-Z0-9_')

if [[ -z "$JSON_FILE" || -z "$DB_FILE" || -z "$TABLE_NAME" ]]; then
  echo "Usage: $0 input.json database.db table_name"
  exit 1
fi

if [[ ! -f "$JSON_FILE" ]]; then
  echo "Error: JSON file not found: $JSON_FILE"
  exit 1
fi

echo "Ingesting $JSON_FILE into $DB_FILE (table: $TABLE_NAME)..."

duckdb "$DB_FILE" <<EOF
CREATE TABLE IF NOT EXISTS $TABLE_NAME AS
SELECT *
FROM read_json_auto('$JSON_FILE'
);
EOF

echo "Done."

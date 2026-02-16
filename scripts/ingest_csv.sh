#!/usr/bin/bash

# Usage:
# ./ingest_csv.sh input.csv database.db table_name
# for example 
# ./ingest_csv apollo.csv breaches.db apollo_2018 

set -e

CSV_FILE="$1"
DB_FILE="$2"
TABLE_NAME=$(echo "$3" | tr -cd 'a-zA-Z0-9_')

if [[ -z "$CSV_FILE" || -z "$DB_FILE" || -z "$TABLE_NAME" ]]; then
  echo "Usage: $0 input.csv database.db table_name"
  exit 1
fi

if [[ ! -f "$CSV_FILE" ]]; then
  echo "Error: CSV file not found: $CSV_FILE"
  exit 1
fi

echo "Ingesting $CSV_FILE into $DB_FILE (table: $TABLE_NAME)..."

duckdb "$DB_FILE" <<EOF
CREATE TABLE IF NOT EXISTS $TABLE_NAME AS
SELECT *
FROM read_csv_auto('$CSV_FILE',
    header=true,
    ignore_errors=true,
    sample_size=-1
);
EOF

echo "Done."

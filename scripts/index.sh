#!/usr/bin/bash
#Simple indexing script for initial and re-indexing purposes
#Example usage: ./index.sh database.duckdb column_name_to_index

set -e

DB="$1"
COLUMN="$2"

if [[ -z "$DB" || -z "$COLUMN" ]]; then
    echo "Usage: $0 database.duckdb column_name"
    exit 1
fi

if [[ ! -f "$DB" ]]; then
    echo "Error: Database not found: $DB"
    exit 1
fi

echo "[*] Creating indexes for column '$COLUMN' in $DB"
echo

# Get tables that contain the specified column
TABLES=$(duckdb "$DB" -csv -noheader <<EOF
SELECT DISTINCT table_name
FROM information_schema.columns
WHERE lower(column_name) = lower('$COLUMN');
EOF
)

if [[ -z "$TABLES" ]]; then
    echo "[!] No tables found with column '$COLUMN'"
    exit 0
fi

# Loop through tables
while IFS= read -r TABLE; do
    [[ -z "$TABLE" ]] && continue

    # Sanitize for index name safety
    SAFE_TABLE=$(echo "$TABLE" | tr -c 'a-zA-Z0-9_' '_')
    SAFE_COLUMN=$(echo "$COLUMN" | tr -c 'a-zA-Z0-9_' '_')

    INDEX_NAME="idx_${SAFE_TABLE}_${SAFE_COLUMN}"

    echo "----------------------------------------"
    echo "[*] Table: $TABLE"
    echo "[*] Creating index: $INDEX_NAME"
    echo "----------------------------------------"

    duckdb "$DB" <<EOF
CREATE INDEX IF NOT EXISTS $INDEX_NAME
ON "$TABLE"($COLUMN);
EOF

done <<< "$TABLES"

echo
echo "[*] Done."

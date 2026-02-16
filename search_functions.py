import duckdb
import settings
duckdb_bases = settings.DUCKDB_FILES
async def search_by_term(term, value):

    value = value.strip().lower()
    term = term.strip().lower()
    results = []
    for file in duckdb_bases:
        conn = duckdb.connect(file, read_only=True)

        tables = conn.execute(f"""
            SELECT DISTINCT table_name
            FROM information_schema.columns
            WHERE lower(column_name) = ?
            """,(term,)
        ).fetchall()

        for (table,) in tables:

            try:
                rows = conn.execute(
                    f"""
                    SELECT *
                    FROM "{table}"
                    WHERE {term} = ?
                    LIMIT {settings.RESULTS_LIMIT}
                    """,
                 (value,)
                ).fetchall()

                if rows:

                    cols = [c[1] for c in conn.execute(
                        f'PRAGMA table_info("{table}")'
                    ).fetchall()]

                    formatted = [
                        dict(zip(cols, row))
                        for row in rows
                    ]

                    results.append({
                        "table": table,
                        "rows": formatted
                    })

            except Exception as e:
                print(f"Error querying {table}: {e}")

        conn.close()
    return results
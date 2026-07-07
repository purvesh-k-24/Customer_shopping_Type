import psycopg

try:
    conn = psycopg.connect(
        host="localhost",
        port=5432,
        dbname="postgres",
        user="postgres",
        password="purvesh@24"  # Replace with your PostgreSQL password
    )

    print("✅ Connected to PostgreSQL successfully!")

    cur = conn.cursor()
    cur.execute("SELECT version();")

    version = cur.fetchone()
    print(version[0])

    cur.close()
    conn.close()

except Exception as e:
    print("❌ Connection failed:")
    print(e)
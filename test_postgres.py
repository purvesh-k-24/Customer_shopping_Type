import psycopg

try:
    conn = psycopg.connect(
        host="localhost",
        port=5432,
        dbname="postgres",
        user="postgres",
        password="purvesh@24"
    )

    print("Connected!")

except Exception as e:
    print(e)
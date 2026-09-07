-- Star schema for the retail dataset (data/*.csv)

CREATE TABLE IF NOT EXISTS dim_date (
    date_key     INTEGER PRIMARY KEY,
    full_date    TIMESTAMP NOT NULL,
    day_of_week  TEXT,
    month_name   TEXT,
    quarter      TEXT,
    is_weekend   BOOLEAN
);

CREATE TABLE IF NOT EXISTS dim_product (
    product_key  INTEGER PRIMARY KEY,
    product_name TEXT,
    category     TEXT,
    subcategory  TEXT,
    unit_cost    NUMERIC(10,2),
    list_price   NUMERIC(10,2)
);

CREATE TABLE IF NOT EXISTS dim_customer (
    customer_key  INTEGER PRIMARY KEY,
    customer_name TEXT,
    email         TEXT,
    city          TEXT,
    country       TEXT,
    segment       TEXT
);

CREATE TABLE IF NOT EXISTS dim_store (
    store_key   INTEGER PRIMARY KEY,
    store_name  TEXT,
    region      TEXT,
    store_type  TEXT
);

CREATE TABLE IF NOT EXISTS fact_sales (
    sale_id       INTEGER PRIMARY KEY,
    date_key      INTEGER REFERENCES dim_date(date_key),
    product_key   INTEGER REFERENCES dim_product(product_key),
    customer_key  INTEGER REFERENCES dim_customer(customer_key),
    store_key     INTEGER REFERENCES dim_store(store_key),
    sold_at       TIMESTAMP,
    quantity      INTEGER,
    unit_price    NUMERIC(10,2),
    discount_pct  NUMERIC(5,2),
    revenue       NUMERIC(12,2),
    category      TEXT
);

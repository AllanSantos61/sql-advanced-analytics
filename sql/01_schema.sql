-- PostgreSQL 15+ | Modelo estrela de vendas sintéticas
CREATE SCHEMA IF NOT EXISTS analytics;
CREATE TABLE IF NOT EXISTS analytics.dim_customer (
 customer_id INTEGER PRIMARY KEY, customer_name TEXT NOT NULL, segment TEXT NOT NULL,
 signup_date DATE NOT NULL
);
CREATE TABLE IF NOT EXISTS analytics.dim_product (
 product_id INTEGER PRIMARY KEY, product_name TEXT NOT NULL, category TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS analytics.dim_date (
 date_id DATE PRIMARY KEY, year_number INTEGER NOT NULL, month_number INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS analytics.fact_order (
 order_id INTEGER PRIMARY KEY, customer_id INTEGER NOT NULL REFERENCES analytics.dim_customer(customer_id),
 product_id INTEGER NOT NULL REFERENCES analytics.dim_product(product_id),
 order_date DATE NOT NULL REFERENCES analytics.dim_date(date_id),
 quantity INTEGER NOT NULL CHECK(quantity>0),
 unit_price NUMERIC(12,2) NOT NULL CHECK(unit_price>=0),
 unit_cost NUMERIC(12,2) NOT NULL CHECK(unit_cost>=0),
 status TEXT NOT NULL CHECK(status IN ('completed','cancelled'))
);
CREATE INDEX IF NOT EXISTS idx_fact_order_date ON analytics.fact_order(order_date);
CREATE INDEX IF NOT EXISTS idx_fact_order_customer_date ON analytics.fact_order(customer_id,order_date);
CREATE INDEX IF NOT EXISTS idx_fact_order_product ON analytics.fact_order(product_id);

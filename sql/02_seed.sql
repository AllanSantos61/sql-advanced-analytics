-- Seed determinístico: 120 clientes, 12 produtos, 1200 pedidos.
INSERT INTO analytics.dim_customer(customer_id,customer_name,segment,signup_date)
SELECT i,'Cliente '||lpad(i::text,3,'0'),
 CASE WHEN i%3=0 THEN 'Enterprise' WHEN i%3=1 THEN 'SMB' ELSE 'Mid-market' END,
 DATE '2023-01-01'+(i*5) FROM generate_series(1,120) i
ON CONFLICT (customer_id) DO NOTHING;
INSERT INTO analytics.dim_product(product_id,product_name,category)
SELECT i,'Produto '||lpad(i::text,2,'0'),
 CASE WHEN i%3=0 THEN 'Software' WHEN i%3=1 THEN 'Serviços' ELSE 'Treinamento' END
FROM generate_series(1,12) i ON CONFLICT(product_id) DO NOTHING;
INSERT INTO analytics.dim_date(date_id,year_number,month_number)
SELECT d::date,EXTRACT(YEAR FROM d)::int,EXTRACT(MONTH FROM d)::int
FROM generate_series(DATE '2024-01-01',DATE '2026-12-31',INTERVAL '1 day') d
ON CONFLICT(date_id) DO NOTHING;
INSERT INTO analytics.fact_order(order_id,customer_id,product_id,order_date,quantity,unit_price,unit_cost,status)
SELECT i,1+(i*37)%120,1+(i*7)%12,DATE '2024-01-01'+((i*29)%1096),
 1+i%5,(100+(i*13)%900)::numeric,(35+(i*5)%160)::numeric,
 CASE WHEN i%13=0 THEN 'cancelled' ELSE 'completed' END
FROM generate_series(1,1200) i ON CONFLICT(order_id) DO NOTHING;

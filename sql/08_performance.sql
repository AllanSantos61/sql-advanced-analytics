-- Executar com EXPLAIN ANALYZE para inspecionar planejamento e execução.
-- Com apenas 1200 linhas, sequential scan pode ser a melhor escolha; índice não garante ganho.
EXPLAIN (ANALYZE,BUFFERS)
SELECT customer_id,COUNT(*) AS orders,SUM(quantity*unit_price) AS revenue
FROM analytics.fact_order
WHERE status='completed' AND order_date>=DATE '2026-01-01' AND order_date<DATE '2027-01-01'
GROUP BY customer_id ORDER BY revenue DESC LIMIT 10;

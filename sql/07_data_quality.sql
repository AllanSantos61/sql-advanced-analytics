-- Consultas de auditoria: devem retornar zero linhas em uma base íntegra.
SELECT order_id FROM analytics.fact_order GROUP BY order_id HAVING COUNT(*)>1;
SELECT order_id FROM analytics.fact_order
WHERE quantity<=0 OR unit_price<0 OR unit_cost<0 OR status NOT IN ('completed','cancelled');
SELECT f.order_id FROM analytics.fact_order f LEFT JOIN analytics.dim_customer c USING(customer_id)
WHERE c.customer_id IS NULL;

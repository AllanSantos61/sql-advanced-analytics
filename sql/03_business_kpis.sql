-- Pedidos cancelados são excluídos da receita reconhecida.
WITH monthly AS (
 SELECT date_trunc('month',order_date)::date AS month,
 SUM(quantity*unit_price) AS revenue,
 SUM(quantity*(unit_price-unit_cost)) AS gross_profit,
 COUNT(*) AS orders
 FROM analytics.fact_order WHERE status='completed'
 GROUP BY 1
)
SELECT month,revenue,gross_profit,orders,
 ROUND(revenue/NULLIF(orders,0),2) AS avg_ticket,
 ROUND(100*gross_profit/NULLIF(revenue,0),2) AS gross_margin_pct,
 LAG(revenue) OVER(ORDER BY month) AS previous_month_revenue,
 ROUND(100*(revenue/LAG(revenue) OVER(ORDER BY month)-1),2) AS mom_growth_pct,
 SUM(revenue) OVER(PARTITION BY EXTRACT(YEAR FROM month) ORDER BY month) AS ytd_revenue
FROM monthly ORDER BY month;

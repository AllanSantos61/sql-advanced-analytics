-- RFM: snapshot fixo após o fim do período sintético, sem data atual variável.
WITH customer_metrics AS (
 SELECT c.customer_id,c.customer_name,
 (DATE '2027-01-01'-MAX(f.order_date))::int AS recency_days,
 COUNT(f.order_id) AS frequency,
 COALESCE(SUM(f.quantity*f.unit_price),0) AS monetary
 FROM analytics.dim_customer c
 LEFT JOIN analytics.fact_order f ON c.customer_id=f.customer_id AND f.status='completed'
 GROUP BY 1,2
), scores AS (
 SELECT *,NTILE(5) OVER(ORDER BY recency_days DESC NULLS FIRST) AS r_score,
 NTILE(5) OVER(ORDER BY frequency ASC) AS f_score,
 NTILE(5) OVER(ORDER BY monetary ASC) AS m_score
 FROM customer_metrics
)
SELECT *,CASE WHEN r_score>=4 AND f_score>=4 AND m_score>=4 THEN 'Campeões'
 WHEN r_score<=2 AND f_score>=4 THEN 'Em risco'
 WHEN r_score>=4 AND f_score<=2 THEN 'Novos/ocasionais'
 ELSE 'Regulares' END AS rfm_segment
FROM scores ORDER BY monetary DESC;

-- Coortes por primeira compra concluída e retenção mensal.
WITH completed AS (
 SELECT customer_id,date_trunc('month',order_date)::date AS activity_month
 FROM analytics.fact_order WHERE status='completed'
), first_purchase AS (
 SELECT customer_id,MIN(activity_month) AS cohort_month FROM completed GROUP BY 1
), activity AS (
 SELECT DISTINCT f.cohort_month,c.customer_id,
 (EXTRACT(YEAR FROM age(c.activity_month,f.cohort_month))*12+
  EXTRACT(MONTH FROM age(c.activity_month,f.cohort_month)))::int AS month_number
 FROM completed c JOIN first_purchase f USING(customer_id)
), sizes AS (
 SELECT cohort_month,COUNT(*) AS cohort_size FROM first_purchase GROUP BY 1
)
SELECT a.cohort_month,a.month_number,s.cohort_size,COUNT(*) AS active_customers,
 ROUND(100.0*COUNT(*)/NULLIF(s.cohort_size,0),2) AS retention_pct
FROM activity a JOIN sizes s USING(cohort_month)
GROUP BY 1,2,3 ORDER BY 1,2;

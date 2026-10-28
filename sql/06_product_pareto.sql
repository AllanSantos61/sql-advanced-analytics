-- Concentração ABC/Pareto com window functions.
WITH product_revenue AS (
 SELECT p.product_id,p.product_name,p.category,
 COALESCE(SUM(f.quantity*f.unit_price) FILTER(WHERE f.status='completed'),0) AS revenue
 FROM analytics.dim_product p LEFT JOIN analytics.fact_order f USING(product_id)
 GROUP BY 1,2,3
), ranked AS (
 SELECT *,SUM(revenue) OVER(ORDER BY revenue DESC,product_id) AS cumulative_revenue,
 SUM(revenue) OVER() AS total_revenue,
 DENSE_RANK() OVER(ORDER BY revenue DESC) AS revenue_rank FROM product_revenue
)
SELECT *,ROUND(100*revenue/NULLIF(total_revenue,0),2) AS share_pct,
 ROUND(100*cumulative_revenue/NULLIF(total_revenue,0),2) AS cumulative_share_pct,
 CASE WHEN 100*(cumulative_revenue-revenue)/NULLIF(total_revenue,0)<80 THEN 'A'
 WHEN 100*(cumulative_revenue-revenue)/NULLIF(total_revenue,0)<95 THEN 'B'
 ELSE 'C' END AS abc_class
FROM ranked ORDER BY revenue DESC,product_id;

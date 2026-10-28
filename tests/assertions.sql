DO $$
DECLARE bad INTEGER;
BEGIN
 SELECT COUNT(*) INTO bad FROM analytics.fact_order;
 IF bad<>1200 THEN RAISE EXCEPTION 'Expected 1200 orders, got %',bad; END IF;
 SELECT COUNT(*) INTO bad FROM analytics.fact_order WHERE status='cancelled';
 IF bad<>92 THEN RAISE EXCEPTION 'Expected 92 cancellations, got %',bad; END IF;
 SELECT COUNT(*) INTO bad FROM analytics.fact_order f
 LEFT JOIN analytics.dim_customer c USING(customer_id) WHERE c.customer_id IS NULL;
 IF bad<>0 THEN RAISE EXCEPTION 'Orphan customer references: %',bad; END IF;
 SELECT COUNT(*) INTO bad FROM analytics.fact_order WHERE quantity<=0 OR unit_price<0 OR unit_cost<0;
 IF bad<>0 THEN RAISE EXCEPTION 'Invalid financial rows: %',bad; END IF;
 RAISE NOTICE 'All SQL assertions passed';
END $$;

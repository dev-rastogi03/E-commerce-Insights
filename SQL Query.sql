  create database ecommerce
  use ecommerce

  ---Total Revenue---
  SELECT 
    ROUND(SUM(payment_value), 2) AS total_revenue
FROM order_payments;

---Total Orders---
SELECT 
    COUNT(DISTINCT order_id) AS total_orders
FROM orders;

---Monthly Revenue Trend---
SELECT 
    FORMAT(order_purchase_timestamp, 'yyyy-MM') AS month,
    ROUND(SUM(op.payment_value), 2) AS revenue
FROM orders o
JOIN order_payments op 
ON o.order_id = op.order_id
GROUP BY FORMAT(order_purchase_timestamp, 'yyyy-MM')
ORDER BY month;

--Top 10 Customers--
SELECT TOP 10
    c.customer_unique_id,
    ROUND(SUM(op.payment_value), 2) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_payments op ON o.order_id = op.order_id
GROUP BY c.customer_unique_id
ORDER BY total_spent DESC;

--Top 10 Products Category--
SELECT TOP 10
    p.product_category_name,
    COUNT(oi.order_id) AS total_orders
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_orders DESC

---New vs Repeat Customers---
SELECT 
    CASE 
        WHEN order_count = 1 THEN 'New'
        ELSE 'Repeat'
    END AS customer_type,
    COUNT(*) AS total_customers
FROM (
    SELECT 
        customer_unique_id,
        COUNT(order_id) AS order_count
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY customer_unique_id
) t
GROUP BY 
    CASE 
        WHEN order_count = 1 THEN 'New'
        ELSE 'Repeat'
    END


---Insights---
--Total Revenue=16008872.12
--Total Orders=99441
--new customer=93099
--repeat customer=2997
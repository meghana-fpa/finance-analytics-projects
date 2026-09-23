WITH customer_metrics AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.customer_segment,
        COUNT(DISTINCT o.order_id) AS completed_orders,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY
        c.customer_id,
        c.customer_name,
        c.customer_segment
)

SELECT
    customer_name,
    customer_segment,
    completed_orders,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(
        total_revenue / completed_orders,
        2
    ) AS average_order_value
FROM customer_metrics
WHERE completed_orders > 1
  AND total_revenue >= 10000
ORDER BY total_revenue DESC;
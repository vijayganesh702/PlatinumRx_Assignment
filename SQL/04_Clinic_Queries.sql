------------1st QUESTION------------ 
SELECT 
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE strftime('%Y', datetime) = '2021'
GROUP BY sales_channel
ORDER BY total_revenue DESC;
---------------2nd QUESTION----------

SELECT 
    c.uid,
    c.name,
    SUM(cs.amount) AS total_spent
FROM clinic_sales cs
JOIN customer c 
    ON cs.uid = c.uid
WHERE strftime('%Y', cs.datetime) = '2021'
GROUP BY c.uid, c.name
ORDER BY total_spent DESC
LIMIT 10;
-------------3rd QUESTION -------------
WITH revenue AS (
    SELECT 
        strftime('%m', datetime) AS month,
        SUM(amount) AS total_revenue
    FROM clinic_sales
    WHERE strftime('%Y', datetime) = '2021'
    GROUP BY strftime('%m', datetime)
),
expense AS (
    SELECT 
        strftime('%m', datetime) AS month,
        SUM(amount) AS total_expense
    FROM expenses
    WHERE strftime('%Y', datetime) = '2021'
    GROUP BY strftime('%m', datetime)
)
SELECT 
    r.month,
    r.total_revenue,
    COALESCE(e.total_expense, 0) AS total_expense,
    (r.total_revenue - COALESCE(e.total_expense, 0)) AS profit,
    CASE 
        WHEN (r.total_revenue - COALESCE(e.total_expense, 0)) > 0 
            THEN 'Profitable'
        ELSE 'Not-Profitable'
    END AS status
FROM revenue r
LEFT JOIN expense e 
    ON r.month = e.month
ORDER BY r.month;
------------------------4th QUESTION ---------------------
WITH clinic_profit AS (
    SELECT 
        cl.city,
        cl.cid,
        cl.clinic_name,
        SUM(cs.amount) - SUM(e.amount) AS profit
    FROM clinics cl
    JOIN clinic_sales cs 
        ON cl.cid = cs.cid
    LEFT JOIN expenses e 
        ON cl.cid = e.cid
        AND strftime('%Y-%m', e.datetime) = '2021-09'
    WHERE strftime('%Y-%m', cs.datetime) = '2021-09'
    GROUP BY cl.city, cl.cid, cl.clinic_name
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY city ORDER BY profit DESC) AS rnk
    FROM clinic_profit
)
SELECT 
    city,
    cid,
    clinic_name,
    profit
FROM ranked
WHERE rnk = 1
ORDER BY city;

-----------------------5th Question-----------------------
WITH clinic_profit AS (
    SELECT 
        cl.state,
        cl.cid,
        cl.clinic_name,
        SUM(cs.amount) - SUM(e.amount) AS profit
    FROM clinics cl
    JOIN clinic_sales cs 
        ON cl.cid = cs.cid
    LEFT JOIN expenses e 
        ON cl.cid = e.cid
        AND strftime('%Y-%m', e.datetime) = '2021-09'
    WHERE strftime('%Y-%m', cs.datetime) = '2021-09'
    GROUP BY cl.state, cl.cid, cl.clinic_name
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY state ORDER BY profit ASC) AS rnk
    FROM clinic_profit
)
SELECT 
    state,
    cid,
    clinic_name,
    profit
FROM ranked
WHERE rnk = 2
ORDER BY state;

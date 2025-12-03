---------------1---------------------
select bookings.user_id,bookings.room_no from bookings  
inner join (select user_id,max(booking_date) as latest_booked from bookings 
            group by user_id) lb
on bookings.user_id=lb.user_id 
and lb.latest_booked= bookings.booking_date;

----------2--------------------------------------------------------- 

select bookings.booking_id,sum(items.item_rate*booking_commercials.item_quantity) as total_billing_amount 
from bookings inner join booking_commercials on bookings.booking_id = booking_commercials.booking_id 
inner join items on items.item_id =booking_commercials.item_id 
where bookings.booking_date>='2021-11-01' and bookings.booking_date<'2021-12-01' group by bookings.booking_id


------------------------------3--------------------------------------------------

SELECT 
    booking_commercials.bill_id,
    SUM(items.item_rate * booking_commercials.item_quantity) AS bill_amount 
FROM booking_commercials 
INNER JOIN items 
    ON booking_commercials.item_id = items.item_id 
WHERE booking_commercials.bill_date >= '2021-09-01' 
  AND booking_commercials.bill_date <  '2021-10-01' 
GROUP BY booking_commercials.bill_id 
HAVING bill_amount > 1000;


---------4------------------------------------------------------------------
WITH item_month AS (
    SELECT
        bc.bill_date AS order_month,
        bc.item_id,
        i.item_name,
        SUM(bc.item_quantity) AS total_quantity
    FROM booking_commercials bc
    JOIN items i 
        ON bc.item_id = i.item_id
    WHERE bc.bill_date >= '2021-01-01'
      AND bc.bill_date <  '2022-01-01'
    GROUP BY order_month, bc.item_id, i.item_name
),
month_limits AS (
    SELECT 
        order_month,
        MAX(total_quantity) AS max_qty,
        MIN(total_quantity) AS min_qty,
        COUNT(*) AS item_count
    FROM item_month
    GROUP BY order_month
)
SELECT 
    im.order_month,
    im.item_id,
    im.item_name,
    im.total_quantity,
    CASE
        WHEN im.total_quantity = ml.max_qty AND ml.item_count = 1 THEN 'BOTH MOST & LEAST'
        WHEN im.total_quantity = ml.max_qty THEN 'MOST ORDERED'
        WHEN im.total_quantity = ml.min_qty THEN 'LEAST ORDERED'
    END AS order_type
FROM item_month im
JOIN month_limits ml
    ON im.order_month = ml.order_month
WHERE im.total_quantity = ml.max_qty
   OR im.total_quantity = ml.min_qty
ORDER BY im.order_month, order_type;
------------5-------------------------------------------------------------- 

WITH bill_totals AS (
    SELECT 
        bc.bill_id,
        b.user_id,
        bc.bill_date AS bill_month,
        SUM(i.item_rate * bc.item_quantity) AS total_bill
    FROM booking_commercials bc
    JOIN items i 
        ON bc.item_id = i.item_id
    JOIN bookings b 
        ON bc.booking_id = b.booking_id
    WHERE bc.bill_date >= '2021-01-01'
      AND bc.bill_date <  '2022-01-01'
    GROUP BY bc.bill_id, b.user_id, bill_month
),
ranked_bills AS (
    SELECT *,
           RANK() OVER (
               PARTITION BY bill_month 
               ORDER BY total_bill DESC
           ) AS rnk
    FROM bill_totals
)
SELECT 
    u.user_id,
    u.name,
    rb.bill_month,
    rb.total_bill AS second_highest_bill
FROM ranked_bills rb
JOIN users u 
    ON rb.user_id = u.user_id
WHERE rb.rnk = 2
ORDER BY rb.bill_month;

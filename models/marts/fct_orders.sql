with orders as (
select * from {{ ref('stg_jaffle_shop__orders') }}
),
payments as (
select * from {{ ref('stg_stripe__payments') }}
--where status = 'success'
),
order_payments as (
    select
        order_id,
        sum (case when payment_status = 'success' then payment_amount end) as amount
    from payments
    group by 1
)

select
    orders.order_id,
    orders.customer_id,
    orders.order_date,
    coalesce (order_payments.amount, 0) as amount
from orders
left join order_payments
on orders.order_id = order_payments.order_id;
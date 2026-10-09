with customers as (
select * from {{ ref('stg_jaffle_shop__customers') }}
),

orders as (
select * from {{ ref('stg_jaffle_shop__orders') }}
),

customer_orders as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders
    from orders
    group by 1
)

select
    cu.customer_id,
    cu.first_name,
    cu.last_name,
    co.first_order_date,
    co.most_recent_order_date,
    coalesce(co.number_of_orders, 0) as number_of_orders
from customers as cu
left join customer_orders as co
on cu.customer_id = co.customer_id
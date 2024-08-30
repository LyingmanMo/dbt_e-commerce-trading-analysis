with orders as (select * from {{ ref("stg_jaffle_shop__orders") }})

select
    -- generate customer_id+order_id as primary key
    {{
        dbt_utils.generate_surrogate_key(
            ['customer_id', 'order_id']
        )
    }} as id, 
    customer_id, 
    order_date, 
    count(*) order_quantity

from orders
group by 1, 2, 3

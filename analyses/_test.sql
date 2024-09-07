with orders as (select * from analytics.dbt_xliu.stg_jaffle_shop__orders)

select
    -- generate customer_id+order_id as primary key
    md5(cast(coalesce(cast( as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast( as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as id,

    customer_id,
    order_date,
    count(*)

from orders
group by 1, 2, 3
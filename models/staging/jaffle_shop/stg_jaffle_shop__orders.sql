with 
source as (
    select * from {{ source('jaffle_shop', 'customers') }}
),

transformed as (
    select 
        id as order_id,
        user_id as customer_id,
        order_date,
        status
    from source
)

select * from transformed
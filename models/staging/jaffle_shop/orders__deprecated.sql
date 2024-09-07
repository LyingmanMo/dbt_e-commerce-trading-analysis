
with orders as  (

    select * from {{ ref('stg_jaffle_shop__orders' )}}

),

final as (

    select
    
        orders.order_id,
        case
            when orders.customer_id = 1
            then orders.customer_id +1000
            else orders.customer_id 
        end as customer_id,
        orders.order_date

    from orders
)

select * from final
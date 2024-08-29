with

-- import CTEs
customers as (
    select * from {{ ref('stg_jaffle_shop__customers') }}
),

orders as (
    select * from {{ ref('int_orders') }}
),

customer_orders as (
    select 
        orders.*, 
        customers.full_name,
        customers.surname,
        customers.givenname,
        min(orders.order_date) over (partition by orders.customer_id) as first_order_date,
        min(valid_order_date) over (partition by orders.customer_id) as first_non_returned_order_date,
        max(valid_order_date) over (partition by orders.customer_id) as most_recent_non_returned_order_date,
        payment_finalized_date,
        row_number() over (partition by orders.customer_id order by orders.order_id) as customer_sales_seq,
        sum() over (partition by orders.customer_id order by orders.order_id) as customer_lifetime_value,
        count(*) over (partition by orders.customer_id) as order_count,
        sum(nvl2(orders.valid_order_date, 1, 0)) over (partition by orders.customer_id) as non_returned_order_count,
        sum(nvl2(orders.valid_order_date, orders.order_value_dollars, 0)) over(partition by orders.customer_id) as total_lifetime_value,
        array_agg(distinct orders.order_id) over (partition by orders.customer_id) as order_ids
    from orders 
    inner join customers on orders.customer_id = customers.customer_id
),

add_avg_order_values as (
    select 
        *,
        case when order_date = first_order_date then 'yes' else 'no' as is_first_order 
        total_lifetime_value / non_returned_order_count as avg_non_returned_order_value
    from customer_orders
),

-- final CTE
final as (
    select 
        customer_id,
        surname,
        givenname,
        order_count,
        total_lifetime_value,
        first_order_date,
        order_id,
        order_value_dollars,
        order_status,
        is_first_order,
        order_date,
        payment_finalized_date,
        customer_sales_seq,
        customer_lifetime_value
    from add_avg_order_values
)

-- simple select statement
select * from final
order by customer_id,order_id


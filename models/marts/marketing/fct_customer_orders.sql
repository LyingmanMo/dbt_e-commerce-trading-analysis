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

        -- first purchase day
        min(orders.order_date) over (partition by orders.customer_id) as first_order_date,

        min(valid_order_date) over (partition by orders.customer_id) as first_non_returned_order_date,

        max(valid_order_date) over (partition by orders.customer_id) as most_recent_non_returned_order_date,

        -- customer sales sequence
        row_number() over (partition by orders.customer_id order by orders.order_id) as customer_sales_seq,

        -- customer accumulative lifetime value
        sum(order_value_dollars) over (partition by orders.customer_id order by orders.order_id) as customer_lifetime_value,

        count(*) over (partition by orders.customer_id) as order_count,

        sum(nvl2(orders.valid_order_date, 1, 0)) over (partition by orders.customer_id) as non_returned_order_count,

        -- customer total lifetime value
        sum(nvl2(orders.valid_order_date, orders.order_value_dollars, 0)) over(partition by orders.customer_id) as total_lifetime_value,

        array_agg(distinct orders.order_id) over (partition by orders.customer_id) as order_ids

    from orders 
    inner join customers on orders.customer_id = customers.customer_id
),

add_avg_order_values as (
    select 
        *,

        -- new vs returning customer
        case when order_date = first_order_date then 'yes' else 'no' end as is_new_customer,

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
        is_new_customer,
        order_date,
        payment_finalized_date,
        customer_sales_seq,
        customer_lifetime_value
    from add_avg_order_values
)

-- simple select statement
select * from final
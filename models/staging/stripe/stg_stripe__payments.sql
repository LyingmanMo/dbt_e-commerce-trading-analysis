with 

source as (
    select * from {{ source('stripe', 'payment') }}
),

transformed as (
    select 
        id as payment_id, 
        orderid as order_id, 
        paymentmethod as payment_method, 
        status as payment_status, 

        -- amount is stored in cents, convert it to dollars
        {{ cents_to_dollars('amount', 4) }} as payment_amount,

        created as created_id
    from source
)

select * from transformed
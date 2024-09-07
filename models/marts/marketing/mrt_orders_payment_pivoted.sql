{%- set payment_methods = ['bank_transfer', 'coupon', 'credit_card', 'gift_card'] -%}

with payments as (
    select * from {{ ref('stg_stripe__payments') }}
),

pivoted as (
    select
        order_id,

        {%- for item in payment_methods %}
        sum (case when payment_method = '{{item}}' then payment_amount else 0 end) as {{item}}amount

        {%- if not loop.last -%}
            ,
        {%- endif -%}
            
        {%- endfor %} 

from payments
where payment_status = 'success'
group by 1
order by 1
)

select * from pivoted
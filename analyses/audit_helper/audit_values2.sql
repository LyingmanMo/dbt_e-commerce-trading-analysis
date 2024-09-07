{% set old_etl_relation=ref('orders__deprecated') %}

-- this is your newly built dbt model 
{% set dbt_relation=ref('stg_jaffle_shop__orders') %}

{{ audit_helper.compare_relations(
    a_relation=old_etl_relation,
    b_relation=dbt_relation,
    primary_key="order_id"
) }}
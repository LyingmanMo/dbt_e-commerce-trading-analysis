
{% set old_relation = ref('customer_orders2') -%}

{% set dbt_relation = ref('fct_customer_orders') %}

{{ audit_helper.compare_relation_columns(
    a_relation=old_relation,
    b_relation=dbt_relation
) }}

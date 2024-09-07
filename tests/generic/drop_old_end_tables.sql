{% macro drop_old_temp_tables(older_than_days) %}
  {% set drop_sql %}
    SELECT CONCAT('DROP TABLE ', table_schema, '.', table_name)
    FROM information_schema.tables
    WHERE table_name LIKE 'temp_%'
    AND created < dateadd('day', -{{ older_than_days }}, current_date);
  {% endset %}
  
  {{ return(drop_sql) }}
{% endmacro %}

{# 
example: dbt run-operation drop_old_temp_tables --args '{"older_than_days": 30}'
#}
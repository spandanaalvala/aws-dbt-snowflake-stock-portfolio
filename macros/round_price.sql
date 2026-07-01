{% macro round_price(column_name) %}

ROUND({{ column_name }},2)

{% endmacro %}
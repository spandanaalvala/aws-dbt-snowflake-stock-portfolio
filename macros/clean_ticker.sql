{% macro clean_ticker(column_name) %}

UPPER(TRIM({{ column_name }}))

{% endmacro %}
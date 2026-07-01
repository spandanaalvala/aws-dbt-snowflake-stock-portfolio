{{ config(
    materialized='view'
) }}

SELECT
    *,
    CURRENT_TIMESTAMP() AS CREATED_AT
FROM {{ source('staging', 'PORTFOLIO') }}
{{ config(
    materialized='incremental',
    schema='SILVER',
    unique_key=['DATE','TICKER'],
    incremental_strategy='merge'
) }}

SELECT
    *,
    CURRENT_TIMESTAMP() AS CREATED_AT
FROM {{ source('staging', 'NASDAQ') }}

{% if is_incremental() %}

WHERE DATE >
(
    SELECT COALESCE(MAX(DATE), '1900-01-01')
    FROM {{ this }}
)

{% endif %}
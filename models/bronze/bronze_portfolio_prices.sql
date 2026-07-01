{{ config(
    materialized='incremental',
    unique_key=['DATE','TICKER']
) }}

SELECT
    *,
    CURRENT_TIMESTAMP() AS CREATED_AT
FROM {{ source('staging', 'PORTFOLIO_PRICES') }}

{% if is_incremental() %}

WHERE DATE >
(
    SELECT COALESCE(MAX(DATE), '1900-01-01')
    FROM {{ this }}
)

{% endif %}
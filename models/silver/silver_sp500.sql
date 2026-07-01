{{ config(
    materialized='incremental',
    schema='SILVER',
    unique_key=['DATE','TICKER'],
    incremental_strategy='merge'
) }}

SELECT

    {{ generate_surrogate_key(['DATE','TICKER']) }} AS TRADE_SK,

    DATE,

    {{ clean_ticker('TICKER') }} AS TICKER,

    OPEN_PRICE,
    HIGH_PRICE,
    LOW_PRICE,
    CLOSE_PRICE,
    ADJUSTED_PRICE,
    RETURNS,
    VOLUME,

    {{ audit_columns() }}

FROM {{ ref('bronze_sp500') }}

WHERE
    DATE IS NOT NULL
    AND TICKER IS NOT NULL
    AND OPEN_PRICE IS NOT NULL
    AND CLOSE_PRICE IS NOT NULL

{% if is_incremental() %}

AND DATE >
(
    SELECT COALESCE(MAX(DATE), '1900-01-01')
    FROM {{ this }}
)

{% endif %}
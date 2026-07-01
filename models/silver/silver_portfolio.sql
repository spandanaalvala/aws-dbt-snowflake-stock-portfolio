{{ config(
    materialized='table',
    schema='SILVER'
) }}

SELECT

    {{ generate_surrogate_key(['TICKER']) }} AS PORTFOLIO_SK,

    {{ clean_ticker('TICKER') }} AS TICKER,

    QUANTITY,

    SECTOR,

    CLOSE_PRICE,

    WEIGHT,

    {{ audit_columns() }}

FROM {{ ref('bronze_portfolio') }}

WHERE
    TICKER IS NOT NULL
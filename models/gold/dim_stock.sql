{{ config(
    materialized='table',
    schema='GOLD'
) }}

SELECT DISTINCT

    {{ generate_surrogate_key(['TICKER']) }} AS STOCK_SK,

    TICKER,

    SECTOR,

    CREATED_AT,

    UPDATED_AT

FROM {{ ref('silver_portfolio') }}

WHERE
    TICKER IS NOT NULL
{{ config(
    materialized='table',
    schema='GOLD'
) }}

SELECT DISTINCT

    {{ generate_surrogate_key(['TICKER']) }} AS PORTFOLIO_SK,

    TICKER,

    SECTOR,

    QUANTITY,

    WEIGHT,

    CASE
        WHEN WEIGHT >= 0.10 THEN 'CORE HOLDING'
        WHEN WEIGHT >= 0.05 THEN 'GROWTH HOLDING'
        ELSE 'SATELLITE HOLDING'
    END AS INVESTMENT_CATEGORY,

    CREATED_AT,

    UPDATED_AT

FROM {{ ref('silver_portfolio') }}

WHERE
    TICKER IS NOT NULL
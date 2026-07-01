{{ config(
    materialized='incremental',
    schema='GOLD',
    unique_key=['DATE','MARKET_SK'],
    incremental_strategy='merge'
) }}

WITH market_data AS (

    SELECT
        DATE,
        TICKER,
        OPEN_PRICE,
        HIGH_PRICE,
        LOW_PRICE,
        CLOSE_PRICE,
        ADJUSTED_PRICE,
        RETURNS,
        VOLUME,
        'DOW_JONES' AS MARKET_NAME
    FROM {{ ref('silver_dow_jones') }}

    UNION ALL

    SELECT
        DATE,
        TICKER,
        OPEN_PRICE,
        HIGH_PRICE,
        LOW_PRICE,
        CLOSE_PRICE,
        ADJUSTED_PRICE,
        RETURNS,
        VOLUME,
        'NASDAQ' AS MARKET_NAME
    FROM {{ ref('silver_nasdaq') }}

    UNION ALL

    SELECT
        DATE,
        TICKER,
        OPEN_PRICE,
        HIGH_PRICE,
        LOW_PRICE,
        CLOSE_PRICE,
        ADJUSTED_PRICE,
        RETURNS,
        VOLUME,
        'SP500' AS MARKET_NAME
    FROM {{ ref('silver_sp500') }}

)

SELECT

    d.DATE_SK,

    m.MARKET_SK,

    md.DATE,

    md.MARKET_NAME,

    md.TICKER,

    md.OPEN_PRICE,

    md.HIGH_PRICE,

    md.LOW_PRICE,

    md.CLOSE_PRICE,

    md.ADJUSTED_PRICE,

    md.RETURNS,

    md.VOLUME,

    (md.CLOSE_PRICE - md.OPEN_PRICE) AS DAILY_PRICE_CHANGE,

    ROUND(
        ((md.CLOSE_PRICE - md.OPEN_PRICE)
        / NULLIF(md.OPEN_PRICE,0))*100,
        2
    ) AS DAILY_RETURN_PERCENT,

    (md.HIGH_PRICE - md.LOW_PRICE) AS DAILY_VOLATILITY,

    CASE
        WHEN md.CLOSE_PRICE > md.OPEN_PRICE THEN 'UP'
        WHEN md.CLOSE_PRICE < md.OPEN_PRICE THEN 'DOWN'
        ELSE 'NO CHANGE'
    END AS MARKET_DIRECTION,

    CURRENT_TIMESTAMP() AS CREATED_AT,

    CURRENT_TIMESTAMP() AS UPDATED_AT

FROM market_data md

LEFT JOIN {{ ref('dim_date') }} d
ON md.DATE = d.DATE

LEFT JOIN {{ ref('dim_market_index') }} m
ON md.MARKET_NAME = m.MARKET_NAME

{% if is_incremental() %}

WHERE md.DATE >
(
    SELECT COALESCE(MAX(DATE),'1900-01-01')
    FROM {{ this }}
)

{% endif %}
{{ config(
    materialized='incremental',
    schema='GOLD',
    unique_key=['DATE','TICKER'],
    incremental_strategy='merge'
) }}

SELECT

    ------------------------------------------------------------------
    -- Dimension Keys
    ------------------------------------------------------------------

    d.DATE_SK,

    s.STOCK_SK,

    p.PORTFOLIO_SK,

    ------------------------------------------------------------------
    -- Business Keys
    ------------------------------------------------------------------

    pp.DATE,

    pp.TICKER,

    ------------------------------------------------------------------
    -- Price Measures
    ------------------------------------------------------------------

    pp.OPEN_PRICE,

    pp.HIGH_PRICE,

    pp.LOW_PRICE,

    pp.CLOSE_PRICE,

    pp.ADJUSTED_PRICE,

    pp.RETURNS,

    pp.VOLUME,

    ------------------------------------------------------------------
    -- Business Metrics
    ------------------------------------------------------------------

    (pp.CLOSE_PRICE - pp.OPEN_PRICE) AS DAILY_PRICE_CHANGE,

    ROUND(
        ((pp.CLOSE_PRICE - pp.OPEN_PRICE)
        / NULLIF(pp.OPEN_PRICE,0))*100,
        2
    ) AS DAILY_RETURN_PERCENT,

    (pp.HIGH_PRICE - pp.LOW_PRICE) AS DAILY_VOLATILITY,

    CASE
        WHEN pp.CLOSE_PRICE > pp.OPEN_PRICE THEN 'UP'
        WHEN pp.CLOSE_PRICE < pp.OPEN_PRICE THEN 'DOWN'
        ELSE 'NO CHANGE'
    END AS MARKET_DIRECTION,

    ------------------------------------------------------------------
    -- Audit Columns
    ------------------------------------------------------------------

    CURRENT_TIMESTAMP() AS CREATED_AT,

    CURRENT_TIMESTAMP() AS UPDATED_AT

FROM {{ ref('silver_portfolio_prices') }} pp

LEFT JOIN {{ ref('dim_date') }} d
ON pp.DATE = d.DATE

LEFT JOIN {{ ref('dim_stock') }} s
ON pp.TICKER = s.TICKER

LEFT JOIN {{ ref('dim_portfolio') }} p
ON pp.TICKER = p.TICKER

WHERE
    pp.DATE IS NOT NULL
    AND pp.TICKER IS NOT NULL

{% if is_incremental() %}

AND pp.DATE >
(
    SELECT COALESCE(MAX(DATE),'1900-01-01')
    FROM {{ this }}
)

{% endif %}
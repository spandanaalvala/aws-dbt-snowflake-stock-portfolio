{{ config(
    materialized='table',
    schema='GOLD'
) }}

WITH latest_prices AS (

    SELECT *

    FROM {{ ref('fact_portfolio_prices') }}

    QUALIFY ROW_NUMBER() OVER
    (
        PARTITION BY TICKER
        ORDER BY DATE DESC
    ) = 1

)

SELECT

    p.PORTFOLIO_SK,

    s.STOCK_SK,

    lp.DATE_SK,

    p.TICKER,

    p.SECTOR,

    p.QUANTITY,

    p.WEIGHT,

    lp.CLOSE_PRICE,

    lp.DAILY_PRICE_CHANGE,

    lp.DAILY_RETURN_PERCENT,

    lp.DAILY_VOLATILITY,

    lp.MARKET_DIRECTION,

    ROUND(p.QUANTITY * lp.CLOSE_PRICE,2) AS MARKET_VALUE,

    CURRENT_TIMESTAMP() AS CREATED_AT

FROM {{ ref('dim_portfolio') }} p

JOIN {{ ref('dim_stock') }} s
ON p.TICKER = s.TICKER

JOIN latest_prices lp
ON p.TICKER = lp.TICKER
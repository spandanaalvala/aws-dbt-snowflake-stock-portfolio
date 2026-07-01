SELECT *
FROM {{ ref('fact_portfolio_prices') }}

WHERE CLOSE_PRICE < LOW_PRICE
   OR CLOSE_PRICE > HIGH_PRICE
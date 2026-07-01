SELECT *
FROM {{ ref('fact_portfolio_prices') }}

WHERE OPEN_PRICE < LOW_PRICE
   OR OPEN_PRICE > HIGH_PRICE
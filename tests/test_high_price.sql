SELECT *
FROM {{ ref('fact_portfolio_prices') }}

WHERE HIGH_PRICE < LOW_PRICE
SELECT *
FROM {{ ref('fact_portfolio_prices') }}

WHERE VOLUME < 0
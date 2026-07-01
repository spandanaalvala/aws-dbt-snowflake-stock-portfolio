SELECT
    TICKER,
    COUNT(*)
FROM {{ ref('dim_stock') }}
GROUP BY TICKER
HAVING COUNT(*) > 1
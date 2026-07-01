SELECT *
FROM {{ ref('dim_portfolio') }}

WHERE WEIGHT < 0
   OR WEIGHT > 100
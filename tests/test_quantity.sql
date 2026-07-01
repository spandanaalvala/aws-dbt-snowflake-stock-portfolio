SELECT *
FROM {{ ref('dim_portfolio') }}

WHERE QUANTITY <= 0
{{ config(
    materialized='table',
    schema='GOLD'
) }}

SELECT
    1 AS MARKET_SK,
    'DOW_JONES' AS MARKET_NAME

UNION ALL

SELECT
    2,
    'NASDAQ'

UNION ALL

SELECT
    3,
    'SP500'
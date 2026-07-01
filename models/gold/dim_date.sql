{{ config(
    materialized='table',
    schema='GOLD'
) }}

SELECT DISTINCT

    TO_NUMBER(TO_CHAR(DATE,'YYYYMMDD')) AS DATE_SK,

    DATE,

    YEAR(DATE)        AS YEAR,

    QUARTER(DATE)     AS QUARTER,

    MONTH(DATE)       AS MONTH,

    MONTHNAME(DATE)   AS MONTH_NAME,

    DAY(DATE)         AS DAY,

    DAYNAME(DATE)     AS DAY_NAME,

    WEEK(DATE)        AS WEEK_NUMBER,

    CASE
        WHEN DAYOFWEEK(DATE) IN (1,7)
        THEN TRUE
        ELSE FALSE
    END AS IS_WEEKEND,

    CURRENT_TIMESTAMP() AS CREATED_AT

FROM {{ ref('silver_dow_jones') }}

ORDER BY DATE
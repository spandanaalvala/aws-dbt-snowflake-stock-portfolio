{% snapshot portfolio_snapshot %}

{{
    config(

        target_database='STOCKPORTFOLIO',

        target_schema='SNAPSHOTS',

        unique_key='TICKER',

        strategy='check',

        check_cols=[
            'QUANTITY',
            'WEIGHT',
            'SECTOR'
        ]
    )
}}

SELECT *

FROM {{ ref('dim_portfolio') }}

{% endsnapshot %}
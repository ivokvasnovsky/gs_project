{%-
    set amt_columns = [
        'initial_discount_amt',
        'last_review_revenue_amt',
        'current_discount_amt',
        'next_discount_amt',
        'revenue_progress_amt',
        'revenue_gap_to_next_lvl'
    ]
-%}

with dd_reports as (
    select * from {{ ref('int_dd_reports_progress') }}
),

exchange_rates_eur as (
    select * from {{ ref('stg_common_dims__exchange_rate') }}
    where to_currency = 'EUR'
),

joined as (
    select
        dd_reports.*,
        {{ convert_to_eur(amt_columns, rate_col='rates.ber_exchange_rate') }},
        current_timestamp() as inserted_ts,
        'dbt_' || '{{ invocation_id }}' as inserted_by
    from dd_reports
    left join exchange_rates_eur as rates
        on
            dd_reports.currency_date = rates.valid_from
            and dd_reports.currency_cd = rates.from_currency
)

select * from joined

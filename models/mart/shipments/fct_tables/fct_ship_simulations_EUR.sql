{{ config(
    materialized = 'incremental',
    unique_key = ['revenue_no','system_source_code'],
    incremental_strategy='merge',
    on_schema_change='append_new_columns',
    transient = false
) }}

{%-
    set amt_columns = [
        'shp_chrg_price_gross_amt',
        'shp_chrg_price_adj_amt',
        'shp_chrg_price_net_amt',
        'shp_chrg_base_amt',
        'weight_charge',
        'extra_charge',
        'total_charge'
    ]
-%}

with int_joined as (
    select * from {{ ref('int_ship_sims_joined') }}
),

ber_exchange_rates as (
    select
        valid_from,
        from_currency,
        ber_exchange_rate
    from {{ ref('stg_common_dims__exchange_rate') }}
    where to_currency = 'EUR'
),

converted as (
    select
        int_joined.*,
        {{ convert_to_eur(amt_columns, rate_col='rates.ber_exchange_rate') }},
        current_timestamp() as inserted_ts,
        'dbt_' || '{{ invocation_id }}' as inserted_by
    from int_joined
    left join ber_exchange_rates as rates
        on
            int_joined.valid_from = rates.valid_from
            and int_joined.local_currency_code = rates.from_currency
)

select * from converted

{% if is_incremental() %}

    where invoice_date >= (select max(invoice_date) from {{ this }})  -- noqa: RF02

{% endif %}

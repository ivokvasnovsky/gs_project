{{ config(materialized  = 'ephemeral') }}

with dd_progress as (
    select * from {{ ref('dd_progress_snapshot') }}
),

casted as (
    select
        cast(ctry_cd as varchar(2)) as ctry_cd,
        cast(cpa_key as varchar(255)) as cpa_id,
        cast(discount_key as varchar(255)) as discount_key,
        cast(payer_country as varchar(255)) as payer_ctry_cd,
        cast(discount_pid as varchar(255)) as discount_pid,
        cast(measurement_period as int) as measurement_period,
        cast(coalesce(discounting_period, 0) as number(18, 3))
            as discounting_period,
        cast(discounted_products_group as varchar(255)) as discounted_products_grp,
        cast(threshold_type as varchar(255)) as threshold_type,
        cast(coalesce(ramp_up_period, 0) as number(18, 3)) as ramp_up_period,
        cast(currency_code as varchar(255)) as currency_cd,
        cast(coalesce(initial_discount_amount, 0) as number(18, 3))
            as initial_discount_amt,
        cast(coalesce(initial_discount_percent, 0) as number(18, 3))
            as initial_discount_pct,
        cast(coalesce(initial_discount_period, 0) as number(18, 3))
            as initial_discount_period,
        cast(discount_tiers_and_values as varchar(10000))
            as discount_tiers_and_values,
        cast(coalesce(last_review_shipment_count, 0) as number(18, 3))
            as last_review_shipment_cnt,
        cast(coalesce(last_review_revenue_count, 0) as number(18, 3))
            as last_review_revenue_amt,
        cast(coalesce(current_discount_amount, 0) as number(18, 3))
            as current_discount_amt,
        cast(coalesce(current_discount_percent, 0) as number(18, 3))
            as current_discount_pct,
        cast(coalesce(next_discount_amount, 0) as number(18, 3))
            as next_discount_amt,
        cast(coalesce(next_discount_percent, 0) as number(18, 3))
            as next_discount_pct,
        cast(coalesce(next_measurement_months, 0) as number(18, 3))
            as next_measurement_months,
        cast(coalesce(shipment_progress_count, 0) as number(18, 3))
            as shipment_progress_cnt,
        cast(coalesce(revenue_progress_count, 0) as number(18, 3))
            as revenue_progress_amt,
        cast(coalesce(shipment_gap_to_current_level, 0) as number(18, 3))
            as shipment_gap_to_current_lvl,
        cast(coalesce(revenue_gap_to_current_level, 0) as number(18, 3))
            as revenue_gap_to_current_lvl,
        cast(coalesce(shipment_gap_to_next_level, 0) as number(18, 3))
            as shipment_gap_to_next_lvl,
        cast(coalesce(revenue_gap_to_next_level, 0) as number(18, 3))
            as revenue_gap_to_next_lvl,
        cast(exported_to_file as varchar(255)) as exported_to_file,
        valid_from_ts,
        valid_to_ts,
        cast(file_nm as varchar(255)) as file_nm,
        to_timestamp(report_dtm, 'DD.MM.YYYY HH24:MI:SS') as report_ts,
        to_date(ramp_up_end_date, 'DD.MM.YYYY') as ramp_up_end_dt,
        to_date(last_review_date, 'DD.MM.YYYY') as last_review_dt,
        date_trunc('MONTH', last_review_dt) as currency_date,
        to_date(next_review_due_date, 'DD.MM.YYYY') as next_review_due_dt,
        to_date(next_measurement_start_date, 'DD.MM.YYYY')
            as next_measurement_start_dt,
        to_timestamp(
            regexp_substr(file_nm, '_[A-Z]{2}_([0-9]+)\\.CSV', 1, 1, 'ei', 1),
            'DDMMYYYYHH24MISS'
        )
            as file_create_ts,
        regexp_substr(file_nm, '[^/]+$') as filename
    from dd_progress
)

select * from casted

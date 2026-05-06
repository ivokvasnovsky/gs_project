{{ config(materialized = 'ephemeral') }}

with source as (
    select * from {{ source('dd_reports','dd_progress') }}
    {% if target.name == 'dev' %}
        where REGEXP_SUBSTR(file_nm, '\\d{8}') = '31052025'    
    {% endif %}
),

dedup as (

    select
        *,
        regexp_substr(file_nm, '_([A-Z]{2})_', 1, 1, 'e') as ctry_cd
    from source
    qualify
        row_number()
            over (
                partition by
                    ctry_cd, payer_country, cpa_key, discounted_products_group
                order by report_dtm desc nulls last
            )
        = 1

)

select * from dedup

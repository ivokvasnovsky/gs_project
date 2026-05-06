with source as (
    select * from {{ source('idw','shipments') }}
    {% if target.name == 'dev' %}
        where invoice_date <= '2026-01-01'  
    {% endif %}
),

dedup as (
    select * from source

    qualify
        row_number()
            over (
                partition by
                    system_source_code, valid_from, revenue_no, shp_rec_key
                order by invoice_date desc
            )
        = 1
)

select * from dedup

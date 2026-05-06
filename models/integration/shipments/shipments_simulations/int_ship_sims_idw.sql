{{ config(materialized = 'ephemeral') }}

with ship as (
    select *
    from {{ ref('stg_idw__shipments') }}
),

idw_rd as (
    select
        system_source_code,
        valid_from,
        revenue_no,
        shp_rec_key
    from {{ ref('stg_idw__revenue_details') }}
    where extra_charge_type = 'F'
),

joined as (
    select ship.*
    from ship
    left join
        idw_rd
        on
            ship.system_source_code = idw_rd.system_source_code
            and ship.valid_from = idw_rd.valid_from
            and ship.revenue_no = idw_rd.revenue_no
            and ship.shp_rec_key = idw_rd.shp_rec_key
)

select * from joined

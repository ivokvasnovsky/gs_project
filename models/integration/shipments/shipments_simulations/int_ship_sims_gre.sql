with ship as (
    select * from {{ ref('stg_gre__shipments') }}
),

lnkg as (
    select * from {{ ref('stg_gre__linkage') }}
),

joined as (
    select
        lnkg.valid_from,
        lnkg.system_source_code,
        lnkg.gre_uniq_id,
        lnkg.revenue_no,
        ship.awb_no,
        ship.sim_type,
        ship.shp_chrg_price_gross_amt,
        ship.shp_chrg_price_adj_amt,
        ship.shp_chrg_price_net_amt,
        ship.shp_chrg_base_amt
    from lnkg
    inner join
        ship
        on
            lnkg.ctry_cd = ship.ctry_cd
            and lnkg.gre_uniq_id = ship.gre_uniq_id
            and lnkg.qual_no = ship.qual_no
)

select * from joined

with idw_ship as (
    select * from {{ ref('int_ship_sims_idw') }}
),

gre_ship as (
    select * from {{ ref('int_ship_sims_gre') }}
),

joined as (
    select
        idw_ship.*,
        gre_ship.sim_type,
        gre_ship.shp_chrg_price_gross_amt,
        gre_ship.shp_chrg_price_adj_amt,
        gre_ship.shp_chrg_price_net_amt,
        gre_ship.shp_chrg_base_amt
    from idw_ship
    inner join
        gre_ship
        on
            idw_ship.valid_from = gre_ship.valid_from
            and idw_ship.system_source_code = gre_ship.system_source_code
            and idw_ship.revenue_no = gre_ship.revenue_no
)

select * from joined

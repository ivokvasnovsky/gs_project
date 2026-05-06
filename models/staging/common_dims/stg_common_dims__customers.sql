with source as (
    select * from {{ source('common_dims','customers') }}
)

select
    syst_src_cd,
    cpa_name,
    left(syst_src_cd, 2) as ctry_cd,
    ctry_cd || cast(cpa_id as varchar(20)) as cpa_id
from source

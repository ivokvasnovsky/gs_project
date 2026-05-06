with source as (
    select * from {{ ref('stg_common_dims__geo_ref') }}
)

select * from source

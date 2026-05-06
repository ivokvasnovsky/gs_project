with source as (
    select * from {{ source('common_dims','geo_ref') }}
)

select * from source

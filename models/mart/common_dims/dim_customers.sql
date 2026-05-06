with source as (
    select * from {{ ref('stg_common_dims__customers') }}
)

select * from source

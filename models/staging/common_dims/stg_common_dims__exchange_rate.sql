with source as (
    select * from {{ source('common_dims','exchange_rate') }}
)

select * from source

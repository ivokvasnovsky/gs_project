with source as (
    select * from {{ source('idw','revenue_details') }}
)

select * from source

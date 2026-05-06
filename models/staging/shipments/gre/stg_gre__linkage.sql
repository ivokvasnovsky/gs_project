with source as (
    select * from {{ source('gre','gre_linkage') }}
)

select * from source

with source as (
    select * from {{ source('gre','shipments') }}
),

dedup as (
    select * from source
    qualify
        row_number()
            over (
                partition by gre_uniq_id, ctry_cd
                order by file_ts desc nulls last
            )
        = 1
)

select * from dedup

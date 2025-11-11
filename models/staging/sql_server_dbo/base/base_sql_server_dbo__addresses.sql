with
    src_addresses as (select * from {{ source("SQL_SERVER_DBO", "ADDRESSES") }}),

    renamed_casted as (
        select
            address_id,
            zipcode,
            country,
            state,
            address,
            _fivetran_synced as date_load
        from src_addresses
    )

select *
from renamed_casted
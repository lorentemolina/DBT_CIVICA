with
    src_addresses as (select zipcode, country, state from {{ ref("base_sql_server_dbo__addresses") }}),

    renamed_casted as (
        select
            address_id,
            MD5(CONCAT(zipcode,country,state)) AS countries_id,
            address,
            _fivetran_synced as date_load
        from src_addresses
    )

select *
from renamed_casted
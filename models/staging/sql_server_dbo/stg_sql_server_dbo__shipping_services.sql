with
    src_orders as (select shipping_service from {{ ref("base_sql_server_dbo__orders") }}),

    renamed_casted as (
        select
            DISTINCT MD5(shipping_service) AS shipping_service_id,
            shipping_service,
            _fivetran_synced as date_load
        from src_orders
    ),

    no_shipping_service AS (
        SELECT 
            MD5('No_shipping_service') AS promo_id
            , 'No_shipping_service' AS promo_name
            , CONVERT_TIMEZONE('UTC', CURRENT_DATE()) AS date_load_utc
    )

SELECT * FROM renamed_casted
UNION ALL
SELECT * FROM no_shipping_service
    
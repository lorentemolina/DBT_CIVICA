WITH
    src_orders as (select * from {{ ref("base_sql_server_dbo__orders") }}),

renamed AS (

    SELECT
        order_id,
        MD5(shipping_service) AS shipping_service_id,
        shipping_cost AS dollars_shipping_cost,
        address_id,
        created_at,
        MD5(LOWER(REPLACE(REPLACE(promo_id, ' ', '_'), '-', '_'))) AS promo_id,
        estimated_delivery_at,
        order_cost AS dollars_order_cost,
        user_id,
        order_total AS dollars_order_total,
        CONVERT_TIMEZONE('UTC', delivered_at) AS delivered_at,
        tracking_id,
        status,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load
    FROM src_orders

)

SELECT * FROM renamed
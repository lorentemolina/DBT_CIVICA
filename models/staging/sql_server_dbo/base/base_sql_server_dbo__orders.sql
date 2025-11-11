{{ config(
    materialized='incremental',
    unique_key = '_row'
    ) 
    }}

WITH src_orders AS (

    SELECT * FROM {{ source('SQL_SERVER_DBO', 'ORDERS') }}

),

{% if is_incremental() %}
    WHERE _fivetran_synced > (SELECT MAX(_fivetran_synced) FROM {{ this }} )
{% endif %}

renamed AS (

    SELECT
        order_id,
        COALESCE(shipping_service,'No_shipping_service') AS shipping_service,
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
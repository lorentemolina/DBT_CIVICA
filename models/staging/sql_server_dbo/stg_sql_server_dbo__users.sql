{{
  config(
    materialized='view'
  )
}}

WITH src_products AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'PRODUCTS') }}
    ),

renamed_casted AS (
    SELECT
        product_id
        , price AS unit_price_usd
        , name AS product_name
        , inventory
        , _fivetran_synced AS date_load
    FROM src_products
    )

SELECT * FROM renamed_casted
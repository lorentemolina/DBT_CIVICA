WITH src_promos AS (
    SELECT * 
    FROM {{ source('SQL_SERVER_DBO', 'PROMOS') }}
    ),

renamed_casted AS (
    SELECT
        MD5(LOWER(REPLACE(REPLACE(promo_id, ' ', ''), '-', ''))) AS promo_id
        , LOWER(REPLACE(REPLACE(promo_id, ' ', ''), '-', '')) AS promo_name
        , discount AS discount_usd
        , CASE
            WHEN status='inactive' THEN FALSE
            ELSE TRUE
        END AS is_active
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load_utc
    FROM src_promos
    ),

no_promo AS (
    SELECT 
        MD5('No-promo') AS promo_id
        , 'No-promo' AS promo_name
        , 0 AS discount_usd
        , FALSE AS status
        , CONVERT_TIMEZONE('UTC', CURRENT_DATE()) AS date_load_utc
)

SELECT * FROM renamed_casted
UNION ALL
SELECT * FROM no_promo
    
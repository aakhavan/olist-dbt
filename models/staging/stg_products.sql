select
    NULLIF(product_id, '') as product_id,
    NULLIF(product_category_name, '') as product_category_name,
    CAST(NULLIF(product_name_lenght, '') AS integer) as product_name_lenght,
    CAST(NULLIF(product_description_lenght, '') AS integer) as product_description_lenght,
    CAST(NULLIF(product_photos_qty, '') AS integer) as product_photos_qty,
    CAST(NULLIF(product_weight_g, '') AS integer) as product_weight_g,
    CAST(NULLIF(product_length_cm, '') AS integer) as product_length_cm,
    CAST(NULLIF(product_height_cm, '') AS integer) as product_height_cm,
    CAST(NULLIF(product_width_cm, '') AS integer) as product_width_cm
from {{ source('raw', 'olist_products_dataset') }}

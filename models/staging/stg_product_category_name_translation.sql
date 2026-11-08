select
    NULLIF(product_category_name, '') as product_category_name,
    NULLIF(product_category_name_english, '') as product_category_name_english
from {{ source('raw', 'product_category_name_translation') }}

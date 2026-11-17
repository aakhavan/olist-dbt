select
    geolocation_zip_code_prefix as geolocation_zip_code_prefix,
    geolocation_lat as geolocation_lat,
    geolocation_lng as geolocation_lng,
    geolocation_city as geolocation_city,
    geolocation_state as geolocation_state
from {{ source('raw', 'olist_geolocation_dataset') }}

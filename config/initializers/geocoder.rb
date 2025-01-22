# config/initializers/geocoder.rb
Geocoder.configure(
  # [...]
  timeout: 5, # seconds
  lookup: :mapbox, # Defaults to :nominatim, which is less reliable but free
  api_key: ENV['MAPBOX_API_KEY'],
  units: :km, # Defaults to miles (:mi)
  cache_prefix: 'geocoder:'      # Cache key prefix
  # [...]
)

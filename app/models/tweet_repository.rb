class TweetRepository
  include Elasticsearch::Persistence::Repository

  def initialize(options={})
    index  options[:index] || [Rails.application.engine_name, Rails.env].join('_')
    client Elasticsearch::Client.new url: 'http://localhost:9200', log: true
  end

  klass Tweet

  settings number_of_shards: 1 do
    mapping do
      indexes :id, type: 'string'
      indexes :id_str, type: 'string'
      indexes :created_at, type: 'date'
      indexes :text, type: 'string'
      indexes :geo, type: 'nested', properties: {
        coordinates:  { type: 'geo_point', geohash: true, geohash_prefix: true, geohash_precision: 10 }
      }
    end
  end

  def search_by_location(lon, lat, radius)
    search(query: {
      nested: {
        path: "geo",
        query: {
          bool: {
            must: {
              match_all: {}
            },
            filter: {
              geohash_cell: {
                "geo.coordinates": {
                  lon: lon,
                  lat: lat
                },
                precision: radius
              }
            }
          }
        }
      }
    },
    sort: {
      created_at: { order: "desc"}
    },
    size: 250
  )
  end
end
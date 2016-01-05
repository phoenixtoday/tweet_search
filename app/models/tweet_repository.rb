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
      indexes :text, type: 'string', analyzer: 'snowball'
      indexes :geo, type: 'object', properties: {
        coordinates:  { type: 'geo_point', geohash: true, geohash_prefix: true, geohash_precision: 10 }
      }
    end
  end

  def search_by_location(lon, lat, radius, hashtag=nil)
    query = hashtag ? { term: { text: hashtag }} : { match_all: {}}

    search(
      query: {
        filtered: {
          query: query,
          filter: {
            bool: {
              must: {
                geohash_cell: {
                  "geo.coordinates": {
                    lon: lon,
                    lat: lat
                  },
                  precision: radius,
                  neighbors: true
                }
              },
              _cache: true
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
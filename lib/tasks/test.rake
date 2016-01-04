namespace :spec do
  namespace :db do
    desc 'prepare some tests data'
    task :seeds => :environment do
      raise 'Need to set RAILS_ENV=test' unless Rails.env == 'test'

      repository = TweetRepository.new
      repository.create_index! force: true

      tweet = Tweet.new(
        "id_str": 'simple_139_50',
        "created_at": "Thu Dec 24 00:00:00 +0000 2015",
        "text": 'hello twitter',
        "geo": {
          "type": 'Point',
          "coordinates": [
            139,
            50
          ]
        },
        "entities": {
          "hashtags": ["twitter"]
        }
      )


      repository.save tweet

      tweet = Tweet.new(
        "id_str": 'simple_120_50',
        "created_at": "Thu Dec 24 00:00:00 +0000 2015",
        "text": 'hello twitter',
        "geo": {
          "type": 'Point',
          "coordinates": [
            120,
            50
          ]
        },
        "entities": {
          "hashtags": ["twitter"]
        }
      )

      repository.save tweet

      tweet = Tweet.new(
        "id_str": 'simple_139_50_jan_3_2016',
        "created_at": "Sun Jan 3 00:00:00 +0000 2016",
        "text": 'hello twitter',
        "geo": {
          "type": 'Point',
          "coordinates": [
            139,
            50
          ]
        },
        "entities": {
          "hashtags": ["twitter"]
        }
      )

      repository.save tweet

      tweet = Tweet.new(
        "id_str": 'simple_139_50_with_hashtag_banjo',
        "created_at": "Thu Dec 24 00:00:00 +0000 2015",
        "text": 'hello twitter, #banjo',
        "geo": {
          "type": 'Point',
          "coordinates": [
            139,
            50
          ]
        },
        "entities": {
          "hashtags": ["twitter"]
        }
      )

      repository.save tweet
    end
  end
end
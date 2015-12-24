namespace :tweets do
  desc 'insert some tweets'
  task :insert => :environment do
    twitter_app_config = nil
    File.open("#{Rails.root}/config/twitter_app.yml", 'r') do |file|
      twitter_app_config = YAML.load(file)[Rails.env]
    end

    TweetStream.configure do |config|
      config.consumer_key       = twitter_app_config['consumer_key']
      config.consumer_secret    = twitter_app_config['consumer_secret']
      config.oauth_token        = twitter_app_config['oauth_token']
      config.oauth_token_secret = twitter_app_config['oauth_token_secret']
      config.auth_method        = :oauth
    end

    repository = TweetRepository.new
    repository.create_index! force: true

    TweetStream::Client.new.sample do |status|
      attributes = status.to_hash.select{|k,v| %w{id_str created_at text geo entities}.include?(k.to_s)}
      repository.save(Tweet.new(attributes))
    end
  end
end

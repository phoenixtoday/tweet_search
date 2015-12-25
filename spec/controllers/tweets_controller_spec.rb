require 'rails_helper'

RSpec.describe TweetsController, :type => :controller do
  let(:repo) { TweetRepository.new }

  before do
    # repo.create_index! force: true
  end

  it "GET index should be able to return correct response" do
    tweet_one = Tweet.new(
      "id_str": '679936067110334468',
      "created_at": "Thu Dec 24 05:55:23 +0000 2015",
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
    repo.save(tweet_one)

    tweet_two = Tweet.new(
      "id_str": '679936067110334469',
      "created_at": "Thu Dec 24 05:55:23 +0000 2015",
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
    repo.save(tweet_two)

    get :index, { lat: 50, lon: 120, radius: 3 }

    expect(assigns(:tweets).collect(&:to_hash)[0][:id_str]).to eq [tweet_two].collect(&:to_hash)[0][:id_str]
  end
end
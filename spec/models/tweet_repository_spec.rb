require 'rails_helper'

RSpec.describe TweetRepository, :type => :model do
  before do
    # subject.create_index! force: true
  end

  it "should be able save tweet into elastic search" do
    tweet = Tweet.new(
      "id_str": '679936067110334468',
      "created_at": "Thu Dec 24 05:55:23 +0000 2015",
      "text": 'hello twitter',
      "geo": {
        "type": 'Point',
        "coordinates": [
          50,
          139
        ]
      },
      "entities": {
        "hashtags": ["twitter"]
      }
    )
    tweet.reverse_coordinates_for_twitter!

    expect(subject.save(tweet)).to be
  end

  it "should be able use geo hash cell query to find tweets in a location" do
    tweet_one = Tweet.new(
      "id_str": '679936067110334468',
      "created_at": "Thu Dec 24 05:55:23 +0000 2015",
      "text": 'hello twitter',
      "geo": {
        "type": 'Point',
        "coordinates": [
          50,
          139
        ]
      },
      "entities": {
        "hashtags": ["twitter"]
      }
    )
    tweet_two = Tweet.new(
      "id_str": '679936067110334469',
      "created_at": "Thu Dec 24 05:55:23 +0000 2015",
      "text": 'hello twitter',
      "geo": {
        "type": 'Point',
        "coordinates": [
          50,
          120
        ]
      },
      "entities": {
        "hashtags": ["twitter"]
      }
    )

    tweet_one.reverse_coordinates_for_twitter!
    subject.save(tweet_one)

    tweet_two.reverse_coordinates_for_twitter!
    subject.save(tweet_two)

    result = subject.search_by_location(139, 50, 3).to_a
    target_tweet = result.first
    expect(result.size).to be > 0
    expect(result.all?{ |tweet| tweet.to_hash[:id_str] != '679936067110334469'}).to be true
  end

  it "should be able to sort tweets by created_at" do
    tweet_one = Tweet.new(
      "id_str": '679936067110334467',
      "created_at": "Thu Dec 23 05:55:23 +0000 2015",
      "text": 'hello twitter',
      "geo": {
        "type": 'Point',
        "coordinates": [
          50,
          139
        ]
      },
      "entities": {
        "hashtags": ["twitter"]
      }
    )
    tweet_two = Tweet.new(
      "id_str": '679936067110334465',
      "created_at": "Thu Dec 25 05:55:23 +0000 2015",
      "text": 'hello twitter',
      "geo": {
        "type": 'Point',
        "coordinates": [
          50,
          139
        ]
      },
      "entities": {
        "hashtags": ["twitter"]
      }
    )

    tweet_one.reverse_coordinates_for_twitter!
    subject.save(tweet_one)

    tweet_two.reverse_coordinates_for_twitter!
    subject.save(tweet_two)

    result = subject.search_by_location(139, 50, 3).to_a
    expect(result.first.to_hash[:id_str]).to eq '679936067110334465'
  end

  it "should be able to filter text on top of geo point" do
    tweet_one = Tweet.new(
      "id_str": '679936067110334461',
      "created_at": "Thu Dec 21 05:55:23 +0000 2015",
      "text": 'hello twitter',
      "geo": {
        "type": 'Point',
        "coordinates": [
          50,
          139
        ]
      },
      "entities": {
        "hashtags": ["twitter"]
      }
    )
    tweet_two = Tweet.new(
      "id_str": '679936067110334462',
      "created_at": "Thu Dec 22 05:55:23 +0000 2015",
      "text": 'hello twitter, #banjo',
      "geo": {
        "type": 'Point',
        "coordinates": [
          50,
          139
        ]
      },
      "entities": {
        "hashtags": ["twitter"]
      }
    )

    tweet_one.reverse_coordinates_for_twitter!
    subject.save(tweet_one)

    tweet_two.reverse_coordinates_for_twitter!
    subject.save(tweet_two)

    result = subject.search_by_location(139, 50, 3, 'banjo').to_a
    expect(result.first.to_hash[:id_str]).to eq '679936067110334462'
  end
end
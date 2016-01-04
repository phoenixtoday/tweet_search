require 'rails_helper'

RSpec.describe TweetRepository, :type => :model do

  it "should be able save tweet into elastic search" do
    tweet = Tweet.new(
      "id_str": 'some_new_one',
      "created_at": "Thu Dec 24 00:00:00 +0000 2015",
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
    expect(subject.count()).to be > 1
    result = subject.search_by_location(139, 50, 3).to_a
    target_tweet = result.first
    expect(result.size).to be >= 1
    expect(result.collect { |tweet| tweet.to_hash[:id_str] }).to include 'simple_139_50'
    expect(result.all?{ |tweet| tweet.to_hash[:id_str] != 'simple_120_50'}).to be true
  end

  it "should be able to sort tweets by created_at" do
    result = subject.search_by_location(139, 50, 3).to_a
    expect(result.first.to_hash[:id_str]).to eq 'simple_139_50_jan_3_2016'
  end

  it "should be able to filter text on top of geo point" do
    result = subject.search_by_location(139, 50, 3, 'banjo').to_a
    expect(result.size).to eq 1
    expect(result.first.to_hash[:id_str]).to eq 'simple_139_50_with_hashtag_banjo'
  end
end
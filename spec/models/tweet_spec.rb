require 'rails_helper'

RSpec.describe Tweet, :type => :model do

  it "should convert string to datetime" do
    tweet = Tweet.new(
      "id_str": '679936067110334468',
      "created_at": "Thu Dec 24 05:55:23 +0000 2015",
      "text": 'hello twitter',
      "geo": {
        "coordinates": [
          50,
          50
        ]
      },
      "entities": {
        "hashtags": ["twitter"]
      }
    )
    expect(tweet.to_hash[:created_at]).to be_a DateTime
  end

  it "should reverse order of twitter geo coordinates. come on! twiiter, why would you do that!" do
    tweet = Tweet.new(
      "id_str": '679936067110334468',
      "created_at": "Thu Dec 24 05:55:23 +0000 2015",
      "text": 'hello twitter',
      "geo": {
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

    expect(tweet.to_hash[:geo][:coordinates][0]).to eq 139
    expect(tweet.to_hash[:geo][:coordinates][1]).to eq 50
  end
end
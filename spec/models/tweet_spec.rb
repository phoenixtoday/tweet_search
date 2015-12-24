require 'rails_helper'

RSpec.describe Tweet, :type => :model do
  it "should convert string to datetime" do
    tweet = Tweet.new(
      "id_str": '679936067110334468',
      "created_at": "Thu Dec 24 05:55:23 +0000 2015",
      "text": 'hello twitter',
      "coordinates": [
        50,
        50
      ],
      "entities": {
        "hashtags": ["twitter"]
      }
    )
    expect(tweet.to_hash[:created_at]).to be_a DateTime
  end
end
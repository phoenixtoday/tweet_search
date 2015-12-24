require 'rails_helper'

RSpec.describe TweetRepository, :type => :model do

  before do
    subject.create_index! force: true
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
          50
        ]
      },
      "entities": {
        "hashtags": ["twitter"]
      }
    )
    expect(subject.save(tweet)).to be
  end
end
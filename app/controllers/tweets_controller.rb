class TweetsController < ApplicationController

  def index
    repo = TweetRepository.new
    lon = params[:lon] || 122.2361
    lat = params[:lat] || 37.4828
    radius = params[:radius] || 3
    hashtag = params[:hashtag]
    lon = lon.to_f
    lat = lat.to_f
    radius = radius.to_i
    @tweets = repo.search_by_location(lon, lat, radius, hashtag).to_a
    render :index
  end

end
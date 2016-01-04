require 'rails_helper'

RSpec.describe TweetsController, :type => :controller do
  let(:repo) { TweetRepository.new }

  it "GET index should be able to return correct response" do
    get :index, { lat: 50, lon: 120, radius: 3 }
    expect(assigns(:tweets).collect(&:to_hash)[0][:id_str]).to eq 'simple_120_50'
  end
end
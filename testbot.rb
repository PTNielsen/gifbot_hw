require 'pry'
require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use!
require 'rack/test'
require './gifbot_api'
require './gifbot'

ENV["TEST"] = ENV["RACK_ENV"] = "test"

require './db/setup'
require './lib/all'

require './server'

 

class GifBotTest < MiniTest::Test
	include Rack::Test::Methods

  def setup
    Gif.delete_all
    User.delete_all
  end
  
	def app
		Gifty
	end

  def test_users_can_add_gifs

  	post "/add", 
  	 link:  "http://giphy.com/gifs/adventure-time-cartoons-confetti-9sVS967nejlqU",
  	 username: "username"


    assert_equal 200, last_response.status

    assert_equal 1, Gif.count

    assert_equal "http://giphy.com/gifs/adventure-time-cartoons-confetti-9sVS967nejlqU", Gif.last.url

    # gif = Gif.find_by_id

    # assert gif 
    # assert_equal gif.id.to_s, last_response.body
  end

  # # def test_view_all_gifs
  # # end

  # def test_users_can_tag_gifs

    # get "/tag"
    # id: 
    # tag_name: 


  # def test_users_can_view_a_gif
  # end
end


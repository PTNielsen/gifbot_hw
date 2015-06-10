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
  	link:  "http://giphy.com/gifs/dance-adventure-time-jake-ALCI3eTii7qOk",
  	username: "username"


    assert_equal 200, last_response.status

    # gif = Gif.find_by_id

    # assert gif 
    # assert_equal gif.id.to_s, last_response.body
  end

  # # def test_view_all_gifs
  # # end

  # def test_users_can_tag_gifs
  # end

  # def test_users_can_view_a_gif
  # end
end



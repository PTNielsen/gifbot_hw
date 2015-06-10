require 'pry'
require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use!
require 'rack/test'

ENV["TEST"] = ENV["RACK_ENV"] = "test"

require './db/setup'
require './lib/all'

require './server'

 

class GifBot < MiniTest::Test
	include Rack::Test::Methods

	def app
		GifBot
	end

  def test_users_can_add_gifs

  	post "/add", 
  	link:  "url",
  	username: "username"

    assert_equal 200, last_response.status

    gif = Gif.find_by_gif 

    assert gif 
    assert_equal gif.id.to_s, last_response.body
  end

  # # def test_view_all_gifs
  # # end

  # def test_users_can_tag_gifs
  # end

  # def test_users_can_view_a_gif
  # end
end



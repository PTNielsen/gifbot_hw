require 'pry'
require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use!
require 'rack/test'
require './gifbot'
require './gifbot_api'
require './db/setup'
require './lib/all'
require './server'

ENV["TEST"] = ENV["RACK_ENV"] = "test"

class GifBotTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    MyServer
  end

  def setup
    Gif.delete_all
    User.delete_all
  end

  def test_users_can_add_gifs

     post "/add",
  	  link:  "https://www.google.com/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=0CAcQjRxqFQoTCPLx67eDhsYCFY0vjAodszILeA&url=http%3A%2F%2Fwww.reddit.com%2Fr%2Fgifs%2Fcomments%2F2crra1%2Fcool_gif%2F&ei=Q6Z4VbLEHI3fsASz5azABw&bvm=bv.95277229,d.cWc&psig=AFQjCNHIp3Cj51-G4a12zUNK2nSn-YXxcg&ust=1434056640830492",
  	  username: "Patrick"
     assert_equal 200, last_response.status

     # gif = Gif.find_by_id(1)

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
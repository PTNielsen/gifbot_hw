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
    u = User.create! name: "username"

    post "/add", 
  	 link:  "http://giphy.com/gifs/adventure-time-cartoons-confetti-9sVS967nejlqU",
  	 username: "username"

    gif = Gif.find_by_creator_id u.id

    assert_equal 200, last_response.status
    assert_equal 1, Gif.count
    assert_equal "http://giphy.com/gifs/adventure-time-cartoons-confetti-9sVS967nejlqU", Gif.last.url
    assert gif
    assert_equal gif.id.to_s, last_response.body
  end

  def test_view_all_gifs
    u = User.create! name: "username"
    Gif.create! url: "https://www.google.com/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=0CAcQjRxqFQoTCMTDo4ChiMYCFUZnjAodMf8BCA&url=http%3A%2F%2Fwww.smosh.com%2Fsmosh-pit%2Fphotos%2F15-hilarious-pokemon-gifs-x-y&ei=s9F5VYSeHcbOsQSx_odA&bvm=bv.95277229,d.cWc&psig=AFQjCNHZrdJ-R180AQgGLD-K3G9rW9oRtw&ust=1434133236936238", creator_id: u.id, seen_count: 0
    Gif.create! url: "https://www.google.com/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=0CAcQjRxqFQoTCJvwwYWiiMYCFUMrrAodCEAAnw&url=http%3A%2F%2Fwww.gifbin.com%2F987281&ei=ytJ5VZvjNsPWsAWIgIH4CQ&bvm=bv.95277229,d.cWc&psig=AFQjCNHZrdJ-R180AQgGLD-K3G9rW9oRtw&ust=1434133236936238", creator_id: u.id, seen_count: 0
    Gif.create! url: "https://www.google.com/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=0CAcQjRxqFQoTCIepwtuhiMYCFbAvjAodr3IJPw&url=http%3A%2F%2Fgingerspiceandallthingsnice.com%2F2015%2F01%2F27%2Fdance-like-nobodys-watching-house-of-cards-on-an-ipad-during-your-dance-recital%2F&ei=ctJ5VYeoMrDfsASv5aX4Aw&bvm=bv.95277229,d.cWc&psig=AFQjCNHaeJAZPNgHkrOw4eeTF0wHgg4SIg&ust=1434133483329159", creator_id: u.id, seen_count: 0
  
    get "/view_all_gifs"

    assert_equal 200, last_response.status
    assert_equal 3, Gif.all.count
    assert_equal "https://www.google.com/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=0CAcQjRxqFQoTCIepwtuhiMYCFbAvjAodr3IJPw&url=http%3A%2F%2Fgingerspiceandallthingsnice.com%2F2015%2F01%2F27%2Fdance-like-nobodys-watching-house-of-cards-on-an-ipad-during-your-dance-recital%2F&ei=ctJ5VYeoMrDfsASv5aX4Aw&bvm=bv.95277229,d.cWc&psig=AFQjCNHaeJAZPNgHkrOw4eeTF0wHgg4SIg&ust=1434133483329159", Gif.third.url
  end

  def test_users_can_tag_gifs
    u = User.create! name: "username"
    g = Gif.create! url: "https://www.google.com/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=0CAcQjRxqFQoTCK-6zeetiMYCFURsrQodjkAATA&url=http%3A%2F%2Fgiphy.com%2Fsearch%2Frick-astley&ei=Id95Ve-lGMTYtQWOgYHgBA&bvm=bv.95277229,d.b2w&psig=AFQjCNHlGzpaJOCK9fy3tV9Pe7Nq5Fy3yg&ust=1434136730270158", creator_id: u.id, seen_count: 0
    t = Tag.create! name: "Rick Astley"

    post "/tag_gif", id: g.id, tag_name: t.name
    
    tagged_gif = GifTag.find_by(gif_id: g.id)

    assert_equal 200, last_response.status
    assert tagged_gif
  end

  # def test_users_can_view_tagged_gifs
  #   u = User.create! name: "username"
  #   g = Gif.create! url: "https://www.google.com/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=0CAcQjRxqFQoTCK-6zeetiMYCFURsrQodjkAATA&url=http%3A%2F%2Fgiphy.com%2Fsearch%2Frick-astley&ei=Id95Ve-lGMTYtQWOgYHgBA&bvm=bv.95277229,d.b2w&psig=AFQjCNHlGzpaJOCK9fy3tV9Pe7Nq5Fy3yg&ust=1434136730270158", creator_id: u.id, seen_count: 0
  #   i = Gif.create! url: "http://giphy.com/gifs/batman-shocked-what-11LPqjefhW3ACk", creator_id: u.id, seen_count: 0
  #   t = Tag.create! name: "Rick Astley"

  #   post "/tag_gif", id: t.id, tag_name: t.name

  #   get "/tagged_gif", tag_name: t.name

  #   tagged_gif = GifTag.find_by(gif_id: g.id)

  #   assert_equal 200, last_response.status
  #   binding.pry
  #   assert_equal g.id, tagged_gif.gif_id
  # end

  def test_users_can_view_random_gifs
    u = User.create! name: "username"
    g = Gif.create! url: "http://giphy.com/gifs/kitten-pixel-pikachu-2s9zkB4NawQlq", creator_id: u.id, seen_count: 0
    i = Gif.create! url: "http://giphy.com/gifs/batman-shocked-what-11LPqjefhW3ACk", creator_id: u.id, seen_count: 0
    f = Gif.create! url: "http://giphy.com/gifs/kanye-west-interview-hip-hop-9cmVjltMzhPUY", creator_id: u.id, seen_count: 0
    s = Gif.create! url: "http://giphy.com/gifs/archer-reactiongifs-mrw-AckmGL4e1i7M4", creator_id: u.id, seen_count: 0

    get "/get_gif"
    random_gif = JSON.parse last_response.body

    assert_equal 200, last_response.status
    assert_equal 1, random_gif["seen_count"]
  end

  def test_track_seen_count_properly
    u = User.create! name: "username"
    g = Gif.create! url: "http://giphy.com/gifs/kitten-pixel-pikachu-2s9zkB4NawQlq", creator_id: u.id, seen_count: 0

    5.times do get "/get_gif"
    end
    random_gif = JSON.parse last_response.body

    assert_equal 200, last_response.status
    assert_equal 5, random_gif["seen_count"]
  end

  def test_user_input_must_be_complete
    post "/add", 
      link:  "http://giphy.com/gifs/adventure-time-cartoons-confetti-9sVS967nejlqU"

    assert_equal 400, last_response.status
    assert_equal 0, Gif.count
  end

end
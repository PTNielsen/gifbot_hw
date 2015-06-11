require 'sinatra/base'
require 'pry'

class Gifty < Sinatra::Base

  enable :logging

  set :bind, "0.0.0.0"

  post "/add" do 
    gifty = GifBot.new
    gif = gifty.add_gif params[:link], params[:username]
    gif.id.to_s
  end

  get "/view_gifs" do
    gifty = GifBot.new
    gif = gifty.all_gifs
    gif.to_json
  end

  post "/tag_gif" do
    gifty = GifBot.new
    gif = gifty.tag_gif
  
  end  

end


if $PROGRAM_NAME == __FILE__
MyServer.run!
end
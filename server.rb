require 'sinatra/base'
require 'pry'

class Gifty < Sinatra::Base

  enable :logging

  set :bind, "0.0.0.0"

  post "/add" do 
      if params[:link] && params[:username]  
        gifty = GifBot.new
        gif = gifty.add_gif params[:link], params[:username]
        gif.id.to_json
      else
        400
      end
  end

  get "/view_all_gifs" do
    gifty = GifBot.new
    gif = gifty.all_gifs
    gif.to_json
  end

  post "/tag_gif" do
    gifty = GifBot.new
    gif = gifty.tag_gif params[:id], params[:tag_name]
    gif.to_json
  end

  get "/view_random_gif" do
    gifty = GifBot.new
    random_gif = gifty.all_gifs.sample
    random_gif.has_been_seen!
    random_gif.to_json
  end

end

if $PROGRAM_NAME == __FILE__
MyServer.run!
end
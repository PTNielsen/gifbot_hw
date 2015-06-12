require 'sinatra/base'
require "./gifbot"
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

  get "/get_gif" do
    gifty = GifBot.new
    random_gif = gifty.all_gifs.sample
    random_gif.has_been_seen!
    random_gif.to_json
  end

  # get "/tagged_gif" do
  #   gifty = GifBot.new
  #   tagged_gif = gifty.view_tagged_gif params[:tag_name]
  #   tagged_gif.has_been_seen!
  #   tagged_gif.to_json
  # end

end

if $PROGRAM_NAME == __FILE__
Gifty.run!
end
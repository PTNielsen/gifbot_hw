require 'sinatra/base'
require 'pry'

class Gifty < Sinatra::Base

  enable :logging

  set :bind, "0.0.0.0"

  post "/add" do
    gifty = Gifbot.new
    gif = gifty.add_gif params[:link], params[:username]
    gif.id.to_s
  end

end

if $PROGRAM == __FILE__
  MyServer.run!
end
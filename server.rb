require 'sinatra/base'
require 'pry'

class MyServer < Sinatra::Base

  enable :logging

  set :bind, "0.0.0.0"

  post 

end
require 'sinatra'
require 'sinatra/reloader'

get '/:name' do |n|
  #"hello #{n}
  @name = n
  @title = "main index"
  erb :index
end
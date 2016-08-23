require 'sinatra'
require 'sinatra/reloader'
require 'active_record'

set :public, File.dirname(__FILE__) + '/public'

ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3",
  "database" => "./bbs.db"
)

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

class Comment < ActiveRecord::Base
end

get '/' do
  @comments = Comment.order("id desc").all
  erb :dbindex
end

post '/new' do
  Comment.create({:body => params[:body]})
  redirect '/'
end

post '/delete' do
  Comment.find(params[:id]).destroy
end

post '/upload' do
	if params[:file]

    save_path = "./public/images/#{params[:file][:filename]}"

		File.open(save_path, 'wb') do |f|
			p params[:file][:tempfile]
			f.write params[:file][:tempfile].read
			@mes = "アップロード成功"
		end
	else
		@mes = "アップロード失敗"
	end
	erb :upload
	redirect 'images'
end

get '/images' do
	images_name = Dir.glob("public/images/*")
	@images_path = []

	images_name.each do |image|
		@images_path << image.gsub("public/", "./")
	end
	erb :images
end
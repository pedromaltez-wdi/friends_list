require 'sinatra'
require 'securerandom'
require 'pg'


# ==============
# Standard Pages
# ==============

get '/' do
	erb :home_page
end

get '/friends' do
	sql = "SELECT * FROM friends_table" 
	conn = PG.connect(:dbname =>'friends_list', :host => 'localhost')
	@friends = conn.exec(sql)
	conn.close

	erb :friends
end

get '/new_friend' do
	erb :new_friend
end

post '/new_friend' do
	@first_name = params[:first_name]
	@last_name = params[:last_name]
	@age = params[:age]
	@sex = params[:sex]
	@image_url = params[:image_url]
	@twitter_url = params[:twitter_url]
	@github_url = params[:github_url]
	@facebook_url = params[:facebook_url]
	@uuid = SecureRandom.uuid

	sql = "INSERT INTO friends_table (first_name, last_name, age, sex, image_url, twitter_url, github_url, facebook_url, uuid) values ('#{@first_name}', '#{@last_name}', '#{@age}', '#{@sex}', '#{@image_url}', '#{@twitter_url}', '#{@github_url}', '#{@facebook_url}', '#{@uuid}')"

	conn = PG.connect(:dbname =>'friends_list', :host => 'localhost')
	conn.exec(sql)
	conn.close

	redirect '/friends'
end

get '/friend/:uuid' do

	sql = "SELECT * FROM friends_table WHERE uuid = '#{params[:uuid]}'" 
	conn = PG.connect(:dbname =>'friends_list', :host => 'localhost')
	@profile_details = conn.exec(sql)

	erb :profile

end


get '/friend/:uuid/delete' do
	sql = "DELETE FROM friends_table WHERE uuid = '#{params[:uuid]}'"
	conn = PG.connect(:dbname =>'friends_list', :host => 'localhost')
	@friends = conn.exec(sql)
	conn.close
	redirect '/friends'
end




require 'sinatra'
require 'slim'
require 'sass'
require './song'

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end


configure do
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

# basic route handler displays a view called login.
get '/login' do
  slim :login
end


get('/styles.css'){ scss :styles }

get '/' do
  @title = "This is my Home Page"
  slim :home
end

get '/about' do
  @title = "All About This Website"
  slim :about
end

get '/contact' do
  @title = "This is my Contact Page"
  slim :contact
end

not_found do
	slim :not_found
end


configure do
  enable :sessions
end

get '/set/:name' do
  session[:name] = params[:name]
end

get '/get/hello' do
  "Hello #{session[:name]}"
end


post '/login' do
  if params[:username] == settings.username && params[:password] == settings. password
  	session[:admin] = true
  	redirect to('/songs')
  else
  	slim :login
  end
end


# this route handler will destroy the session and redirect user to login page.
get '/logout' do
  session.clear
  redirect to('/login')
end





require 'sinatra'

require 'slim'

require 'sass'

require 'data_mapper'
require 'sinatra/flash'

require './song' #Moving this statement to another location causes errors

require 'pony'

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

configure do
  enable :sessions
end

before do
  set_title
end




helpers do
  def css(*stylesheets)
    stylesheets.map do |stylesheet|
      "<link href=\"/#{stylesheet}.css\" media=\"screen, projection\"rel=\"stylesheet\" />"
    end.join
  end 
end
  def current?(path='/')
    (request.path==path || request.path==path+'/') ? "current" : nil
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

get '/set/:name' do
  session[:name] = params[:name]
end

get '/get/hello' do
  "Hello #{session[:name]}"
end


post '/login' do
  if params[:username] == settings.username && params[:password] == settings.password
  	session[:admin] = true
  	redirect to('/songs')
  else
  	slim :login
  end
end


post '/contact' do
  send_message
  flash[:notice] = "Thank you for your message. We'll be in touch soon."
  redirect to('/')
end


def send_message
    Pony.mail(
      :from => params[:name] + "<" + params[:email] + ">",
      :to => 'delaine.lawrence35@gmail.com',
      :subject => params[:name] + "has contacted you",
      :body => params[:message],
      #:port => '587',
      :via => :smtp,
      :via_options => {
        :address          => 'smtp.gmail.com',
        :port             => '587',
        :enable_starttls_auto => true,
        :user_name        => 'delaine.lawrence35@gmail.com',
        :password         => 'letrell01.',
        :authentication   => :plain,
        :domain           => 'localhost.localdomain'
      })
      redirect '/success'
  end


# this route handler will destroy the session and redirect user to login page.
get '/logout' do
  session.clear
  redirect to('/login')
end

def set_title
  @title ||= "Songs By Sinatra"
end



 






require 'sinatra'
require_relative 'config/application'
require 'pry'

helpers do
  def current_user
    if @current_user.nil? && session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
      session[:user_id] = nil unless @current_user
    end
    @current_user
  end
end

get '/' do
  redirect '/meetups'
end

get '/auth/github/callback' do
  user = User.find_or_create_from_omniauth(env['omniauth.auth'])
  session[:user_id] = user.id
  session[:name] = user.username
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/meetups' do
  @meetups = Meetup.all
  erb :'meetups/index'
end

get '/meetups/new' do

  @errors = []

  erb :'meetups/new'
end

post '/meetups/new' do

  @name = params[:name]
  @description = params[:description]
  @location = params[:location]
  @creator = session[:user_id]

  @meetup = Meetup.create(meetup_name: @name, description: @description, location: @location)
  Event.create(user_id: @creator, meetup: @meetup, creator: true)

    @errors = ""

    if session[:user_id].nil?
      @errors += "user must be signed in to make a new meetup\n"

      erb :'meetups/new'
    else

      if @meetup.valid?
        @meetup.save
      else
        @meetup.errors.messages.each do |field, msg|
          @errors += "#{field.to_s}: "
          msg.each_with_index do |s, index|
            @errors += "#{s},"
            if (index + 1) < msg.size
              @errors += ","
            end
          end
          @errors += "\n"
        end
      end

      if !@errors.empty?
        erb :'meetups/new'
      else
        session[:success_message] = "Event created!"
        redirect "/meetups/#{@meetup.id}"
      end
    end
end

get '/meetups/:id' do

  @success = session[:success_message]
  @join = session[:join_message]
  @join_error = session[:join_error]
  session[:join_message] = nil
  session[:success_message] = nil
  session[:join_error] = nil


  @meetup = Meetup.find(params[:id])

  @attendees = @meetup.users

  @creator = Event.where(creator: true).find_by(meetup: @meetup).user

  erb :'meetups/show'
end

post '/meetups/:id' do

  if session[:user_id].nil?
    session[:join_error] = "user must be signed in to make a new meetup\n"
    redirect "/meetups/#{params[:id]}"
  else
    Event.create(user_id: session[:user_id], meetup_id: params[:id])
    session[:join_message] = "You've joined the meetup!"

    redirect "/meetups/#{params[:id]}"
  end
end

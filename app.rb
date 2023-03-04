require "sinatra"
require "sinatra/json"
require "sinatra/reloader"
require "json"
require "open-uri"
require "rest-client"
require "date"
require "pry"

# Gcal gems
require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"
require "sinatra/cross_origin"

configure do
  enable :cross_origin
end

before do
  response.headers["Access-Control-Allow-Origin"] = "*"
end

CALENDAR_ID = "b59a228f41a5dc7128742a7b073e0cd48a5ab52eaf5f7922e7139435b0ad27ca@group.calendar.google.com"
TIME_ZONE = "Asia/Tokyo"

# Gcal API post
OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
APPLICATION_NAME = "OCR test".freeze
CREDENTIALS_PATH = "credentials.json".freeze
# The file token.yaml stores the user's access and refresh tokens, and is
# created automatically when the authorization flow completes for the first
# time.
TOKEN_PATH = "token.yaml".freeze
SCOPE = "https://www.googleapis.com/auth/calendar"
##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization. If authorization is required,
# the user's default browser will be launched to approve the request.
#
# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials

options "*" do
  response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
  response.headers["Access-Control-Allow-Origin"] = "*"
  200
end

get "/" do
  service = initialize_gcal
  @events = fetch_existing_events(service)

  erb :index
end

get "/send_today" do
  num = rand(1..1000)

  event = { 
    id: rand.to_s[2..11],
    group: "test group#{num}",
    name: "test#{num}",
    venue: "test venue#{num}",
    date: DateTime.now.to_s,
    url: "www",
    description: "test description" 
  }
  
  service = initialize_gcal
  post_to_gcalendar(event, service)
  @events = fetch_existing_events(service)

  erb :index
end

def authorize
  client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
  token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
  authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
  user_id = "default"
  credentials = authorizer.get_credentials user_id
  if credentials.nil?
    url = authorizer.get_authorization_url base_url: OOB_URI
    puts "Open the following URL in the browser and enter the " \
        'resulting code after authorization:\n' + url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: OOB_URI,
    )
  end
  credentials
end

def initialize_gcal
  # Initialize the API
  service = Google::Apis::CalendarV3::CalendarService.new
  service.client_options.application_name = APPLICATION_NAME
  service.authorization = authorize
  service
end

def fetch_existing_events(service)
  response = service.list_events(CALENDAR_ID)
  puts "No upcoming events found" if response.items.empty?
  response.items
end

def post_to_gcalendar(event, service)
  # Create new events
  puts "Event to be created:"
  p event
  gcal_event = Google::Apis::CalendarV3::Event.new(
    summary: event[:name],
    location: event[:location],
    description: event[:description],
    html_link: event[:url],
    start: {
      date_time: event[:date], # should be like 2020-03-25T17:04:00-07:00
      time_zone: TIME_ZONE,
    },
    end: {
      date_time: event[:date],
      time_zone: TIME_ZONE,
    },
  )
  begin
    result = service.insert_event(CALENDAR_ID, gcal_event)
    puts "Event created: #{result.html_link}"
  rescue
    puts "Event already exists"
  end
end

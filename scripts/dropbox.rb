# Generate a file with the JSON of every screenshots with thumbnails in Dropbox
# account. Usage: `ruby scripts/dropbox.rb`

require 'dropbox_sdk'
require 'json'

APP_KEY = ''
APP_SECRET = ''

ACCESS_TYPE = :dropbox

ACCESS_TOKEN_KEY = ''
ACCESS_TOKEN_SECRET = ''

class JSONScreenies
  # Create a new DropboxSession.
  def initialize
    if APP_KEY.empty? or APP_SECRET.empty?
      puts 'APP_KEY or APP_SECRET is not set.'
      exit
    end

    @session = DropboxSession.new(APP_KEY, APP_SECRET)
  end

  # Set the access token for the current session and create a new DropboxClient
  # instance.
  def login
    if ACCESS_TOKEN_KEY.empty? or ACCESS_TOKEN_SECRET.empty?
      puts 'ACCESS_TOKEN_KEY or ACCESS_TOKEN_SECRET is not set.'
      exit
    end

    # Set access token.
    @session.set_access_token(ACCESS_TOKEN_KEY, ACCESS_TOKEN_SECRET)

    # Create new client instance.
    @client = DropboxClient.new(@session, ACCESS_TYPE)
  end

  # Generate the JSON file.
  def generate_json_file
    login

    # Retrieve the current user's account information in order to get the uid.
    uid = @client.account_info['uid']

    # Retrieve the files on the /Public/screenies directory and generate the
    # Array. Format of Array is:
    # [
    #   { 'image' => '...', 'thumbnail' => '...' }
    # ]
    json = []

    # Retrieve the thumbnails so we can search if a thumbnail exists for the
    # current file.
    thumbs = @client.search('/Public/screenies/thumbs', '.png')

    @client.search('/Public/screenies', '.png').each do |image|
      filename = File.basename(image['path'], '.png')

      thumbs.each do |thumb|
        if thumb['path'] == "/Public/screenies/thumbs/#{filename}-thumb.png"
          image_url = "https://dl.dropbox.com/u/#{uid}/screenies/#{filename}.png"
          thumbnail_url = "https://dl.dropbox.com/u/#{uid}/screenies/thumbs/#{filename}-thumb.png"

          json << { 'image' => image_url, 'thumbnail' => thumbnail_url }
          break
        end
      end
    end

    # Write the JSON output to screenies.json.
    File.open('screenies.json', 'w') do |file|
      file.write(JSON.pretty_generate(json))
    end
  end
end

command = JSONScreenies.new
command.generate_json_file

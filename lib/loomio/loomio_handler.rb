require 'httparty'

class LoomioHandler
  include HTTParty
  @@base_uri = ENV['LOOMIO_BASE_URL'].nil? ? 'https://talk.theborderland.se/' : ENV['LOOMIO_BASE_URL']
  @@sessions_uri = 'api/v1/sessions'
  @@comments_uri = 'api/v1/comments'
  @@threads_uri = 'api/v1/discussions'
  @@group_id = ENV['LOOMIO_GROUP_ID']

  # login using username and password and set cookies
  # for all the other requests within LoomioHandler
  def initialize(username=ENV['LOOMIO_USER'], password=ENV['LOOMIO_PASSWORD'])
    if !username || !password || !ENV['LOOMIO_GROUP_ID']
      raise ArgumentError, "LOOMIO_USER, LOOMIO_PASSWORD, LOOMIO_GROUP_ID environment variables must be set"
    end

    user = {user:{email:username,password:password}}
    security_response = self.class.post(@@base_uri + @@sessions_uri, body: user)
    puts(security_response.value) # raises error if the request failed

    # parse and set security cookies based on the post call
    @security_cookies = self.parse_set_cookie(security_response.headers['set-cookie'])
    self.class.default_cookies.add_cookies(@security_cookies)

    # set headers used for all requests
    @headers = {
      'Content-Type': 'application/json'
    }
  end

  # create a thread (discussion) in loomio
  def new_thread(name, description='')
    response = self.class.post(
      @@base_uri + @@threads_uri, 
      body: {"discussion":{"title":name,"description":description,"group_id":@@group_id,"private":false,"forked_event_ids":[],"document_ids":[]}}.to_json,
      headers: @headers
    )
    puts(response.value) # raises error if the request failed
    return response
  end

  # post a comment to loomio based on discussion_id
  def new_comment(name, discussion_id)
    response = self.class.post(
      @@base_uri + @@comments_uri,
      body: {"comment":{"body":name,"discussion_id":discussion_id,"document_ids":[]}}.to_json,
      headers: @headers
    )
    return response
  end

  # parse cookies coming from a set-cookies header of a response
  def parse_set_cookie(all_cookies_string)
    cookies = Hash.new
  
    # if all_cookies_string.present?
    # single cookies are devided with comma
    all_cookies_string.split(',').each {
      # @type [String] cookie_string
        |single_cookie_string|
      # parts of single cookie are seperated by semicolon; first part is key and value of this cookie
      # @type [String]
      cookie_part_string  = single_cookie_string.strip.split(';')[0]
      # remove whitespaces at beginning and end in place and split at '='
      # @type [Array]
      cookie_part         = cookie_part_string.strip.split('=')
      # @type [String]
      key                 = cookie_part[0]
      # @type [String]
      value               = cookie_part[1]

      # add cookie to Hash
      cookies[key] = value
    }
  
    cookies
  end
end

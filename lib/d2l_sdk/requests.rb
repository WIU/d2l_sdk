require_relative 'auth'
require 'net/http'
require 'uri'
require 'mime/types'
require 'json'

########################
# QUERIES/RESPONSE:#####
########################
@debug = false
# performs a get request on a particular path of the host.
# To do this, a uniform resource identifier string is created using the path and
# specifying that this is a get request. Then, the RestClient get method is
# used to retrieve the data and parse it as a JSON. Then, the parsed response is
# returned. Otherwise, nothing is returned and the response code is printed
#
# returns: JSON parsed response.
def _get(path, isD2l = true)
    uri_string = path
    uri_string = create_authenticated_uri(path, 'GET') if isD2l == true
    ap uri_string if @debug
    RestClient.get(uri_string) do |response, _request, _result|
      begin
        #ap _request
        case response.code
        when 200
            # ap JSON.parse(response) # Here is the JSON fmt'd response printed
            JSON.parse(response)
        else
            display_response_code(response.code)
            ap JSON.parse(response.body) if @debug
        end
      rescue => e
        display_response_code(response.code)
        ap JSON.parse(response.body) if @debug
        raise
      end
    end
end

def _get_raw(path, isD2l = true)
  uri_string = path
  uri_string = create_authenticated_uri(path, 'GET') if isD2l == true
  RestClient.get(uri_string) do |response, _request, _result|
    begin
      case response.code
      when 200
          # ap JSON.parse(response) # Here is the JSON fmt'd response printed
          response
      else
          display_response_code(response.code)
          ap response.body
      end
    rescue => e
      display_response_code(response.code)
      ap response.body
      raise
    end
  end
end



# performs a post request using the path and the payload arguments. First, an
# authenticated uri is created to reference a particular resource. Then, the
# post method is executed using the payload and specifying that it is formatted
# as JSON.
def _post(path, payload, isD2l = true)
    auth_uri = path
    auth_uri = create_authenticated_uri(path, 'POST') if isD2l == true
    RestClient.post(auth_uri, payload.to_json, content_type: :json) do |response|
      case response.code
      when 200
        return nil if response == ""
        JSON.parse(response)
        ap JSON.parse(response.body)
      else
        display_response_code(response.code)
        ap JSON.parse(response.body) if $debug
      end
    end
end

# performs a put request using the path and the payload arguments. After first
# creating an authenticated uri, the put request is performed using the
# authenticated uri, the payload argument, and specifying that the payload is
# formatted in JSON.
def _put(path, payload, isD2l = true)
    auth_uri = path
    auth_uri = create_authenticated_uri(path, 'PUT') if isD2l == true
    # Perform the put action, updating the data; Provide feedback to client.
    RestClient.put(auth_uri, payload.to_json, content_type: :json) do |response|
      case response.code
      when 200
        return nil if response == ""
        JSON.parse(response)
        #ap JSON.parse(response.body)
      else
        display_response_code(response.code)
        ap JSON.parse(response.body) if $debug
      end
    end
end

# Performs a delete request by creating an authenticated uri and using the
# RestClient delete method and specifying the content_type as being JSON.
def _delete(path, isD2l = true, headers = {})
    headers[:content_type] = :json
    auth_uri = path
    auth_uri = create_authenticated_uri(path, 'DELETE') if isD2l == true
    RestClient.delete(auth_uri, headers)
end

# NOTE: multipart code examples referrenced from danielwestendorf--
# FTC 1867 and FTC 2388 implementations are based upon the following url:
# => "https://coderwall.com/p/c-mu-a/http-posts-in-ruby"
# The code has obviously been modified for usage with basic D2L POST/PUT api methods
# in compliance with FTC 1867 & FTC 2388 HTTP file upload and according to examples
# shown on: "http://docs.valence.desire2learn.com/basic/fileupload.html"

# Upload a file to the learning repository.
def _learning_repository_upload(path, file, method)
    # name = the content name,
    # e.g. "Resource", "profileImage", "name", "description", "file", "targetUsers"
    # file = the File's name in the directory.
    # method = POST or PUT
    # json = the json appended to the end of the request body
    auth_uri = path
    auth_uri = create_authenticated_uri(path, method)
    uri = URI.parse(auth_uri)

    boundary = "xxBOUNDARYxx"
    header = {"Content-Type" => "multipart/form-data; boundary=#{boundary}"}
    # setup the post body
    post_body = []
    post_body << "--#{boundary}\n"
    post_body << "Content-Disposition: form-data; name = \"Resource\"; filename=\"#{File.basename(file)}\"\r\n"
    post_body << "Content-Type: application/zip\r\n\r\n"
    post_body << File.read(file)
    post_body << "\r\n\r\n--#{boundary}--\r\n"

    # Create the HTTP objects
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = post_body.join

    # Send the request
    response = http.request(request)
    JSON.parse(response)
end

# Upload a file to the learning repository.
def _course_package_upload(path, file, method)
    # name = the content name,
    # e.g. "Resource", "profileImage", "name", "description", "file", "targetUsers"
    # file = the File's name in the directory.
    # method = POST or PUT
    # json = the json appended to the end of the request body
    auth_uri = path
    auth_uri = create_authenticated_uri(path, method)
    uri = URI.parse(auth_uri)

    boundary = "xxBOUNDARYxx"
    header = {"Content-Type" => "multipart/form-data; boundary=#{boundary}"}
    # setup the post body
    post_body = []
    post_body << "--#{boundary}\n"
    post_body << "Content-Disposition: form-data; name = \"Resource\"; filename=\"#{File.basename(file)}\"\r\n"
    post_body << "Content-Type: #{MIME::Types.type_for(file)}\r\n\r\n"
    post_body << File.read(file)
    post_body << "\r\n\r\n--#{boundary}--\r\n"

    # Create the HTTP objects
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = post_body.join

    # Send the request
    response = http.request(request)
    JSON.parse(response)
end

# REVIEW: image upload process
def _image_upload(path, file, method)
  # name = the content name,
  # e.g. "Resource", "profileImage", "name", "description", "file", "targetUsers"
  # file = the File's name in the directory.
  # method = POST or PUT
  # json = the json appended to the end of the request body
  auth_uri = path
  auth_uri = create_authenticated_uri(path, method)
  uri = URI.parse(auth_uri)

  boundary = "xxBOUNDARYxx"
  header = {"Content-Type" => "multipart/form-data; boundary=#{boundary}"}
  # setup the post body
  post_body = []
  post_body << "--#{boundary}\n"
  post_body << "Content-Disposition: form-data; name = \"profileImage\"; filename=\"#{File.basename(file)}\"\r\n"
  post_body << "Content-Type: image/png\r\n\r\n"
  post_body << File.read(file)
  post_body << "\r\n\r\n--#{boundary}--\r\n"

  # Create the HTTP objects
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri, header)
  request.body = post_body.join

  # Send the request
  response = http.request(request)
  JSON.parse(response)
end

def _ePortfolio_upload(path, file, method, description)
  # name = the content name,
  # e.g. "Resource", "profileImage", "name", "description", "file", "targetUsers"
  # filename = the File's name in the directory.
  # method = POST or PUT
  # json = the json appended to the end of the request body
  auth_uri = path
  auth_uri = create_authenticated_uri(path, method)
  uri = URI.parse(auth_uri)

  boundary = "xxBOUNDARYxx"
  header = {"Content-Type" => "multipart/form-data; boundary=#{boundary}"}
  # setup the post body
  post_body = []
  post_body << "--#{boundary}\r\n"
  post_body << "Content-Type: text/plain\r\n"
  post_body << "Content-Disposition: form-data; name = \"name\"\r\n\r\n"
  post_body << "#{File.basename(file)}\r\n"

  post_body << "--#{boundary}\r\n"
  post_body << "Content-Type: text/plain\r\n"
  post_body << "Content-Disposition: form-data; name = \"description\"\r\n\r\n"
  post_body << "#{description}\r\n"

  post_body << "--#{boundary}\r\n"
  post_body << "Content-Type: text/plain\r\n"
  post_body << "Content-Disposition: form-data; name = \"file\"; filename=\"#{File.basename(file)}\"\r\n\r\n"
  post_body << File.read(file)
  post_body << "\r\n\r\n--#{boundary}--\r\n"

  # Create the HTTP objects
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri, header)
  request.body = post_body.join

  # Send the request
  response = http.request(request)
  JSON.parse(response)
end

def _course_content_upload(path, json, file, method)
  # name = the content name,
  # e.g. "Resource", "profileImage", "name", "description", "file", "targetUsers"
  # filename = the File's name in the directory.
  # method = POST or PUT
  # json = the json appended to the end of the request body
  auth_uri = path
  auth_uri = create_authenticated_uri(path, method)
  uri = URI.parse(auth_uri)

  boundary = "xxBOUNDARYxx"
  header = {"Content-Type" => "multipart/mixed; boundary=#{boundary}"}
  # setup the post body
  post_body = []
  post_body << "--#{boundary}\r\n"
  post_body << "Content-Type: application/json\r\n\r\n"

  post_body << json.to_json
  post_body << "\r\n"

  post_body << "--#{boundary}\r\n"
  post_body << "Content-Disposition: form-data; name = \"\"; filename=\"#{File.basename(file)}\"\r\n\r\n"
  post_body << "Content-Type: text/plain\r\n"
  post_body << File.read(file)
  post_body << "\r\n\r\n--#{boundary}--\r\n"

  # Create the HTTP objects
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri, header)
  request.body = post_body.join

  # Send the request
  response = http.request(request)
  JSON.parse(response)
end

def _dropbox_upload(path, json, file, method)
  # name = the content name,
  # e.g. "Resource", "profileImage", "name", "description", "file", "targetUsers"
  # filename = the File's name in the directory.
  # method = POST or PUT
  # json = the json appended to the end of the request body
  auth_uri = path
  auth_uri = create_authenticated_uri(path, method)
  uri = URI.parse(auth_uri)

  boundary = "xxBOUNDARYxx"
  header = {"Content-Type" => "multipart/mixed; boundary=#{boundary}"}
  # setup the post body
  post_body = []
  post_body << "--#{boundary}\r\n"
  post_body << "Content-Type: application/json\r\n\r\n"

  post_body << json.to_json # e.g. {"Text" => "Here you go", "Html" => null}
  post_body << "\r\n"
  post_body << "--#{boundary}\r\n"
  post_body << "Content-Disposition: form-data; name = \"\"; filename=\"#{File.basename(file)}\"\r\n"
  post_body << "Content-Type: #{MIME::Types.type_for(file)}\r\n\r\n"

  post_body << File.read(file)
  post_body << "\r\n\r\n--#{boundary}--\r\n"

  # Create the HTTP objects
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri, header)
  request.body = post_body.join

  # Send the request
  response = http.request(request)
  JSON.parse(response)
end

# function to upload 1+ files to a news event.
# e.g. uploading 2 attachments to a news event (a text file; a png)
def _news_upload(path, json, files, method)
  # name = the content name,
  # e.g. "Resource", "profileImage", "name", "description", "file", "targetUsers"
  # files = array of filenames
  # method = POST or PUT
  # json = the json appended to the end of the request body
  auth_uri = path
  auth_uri = create_authenticated_uri(path, method)
  uri = URI.parse(auth_uri)

  boundary = "xxBOUNDARYxx"
  header = {"Content-Type" => "multipart/mixed; boundary=#{boundary}"}
  # setup the post body
  post_body = []
  post_body << "--#{boundary}\r\n"
  post_body << "Content-Type: application/json\r\n\r\n"

  post_body << json.to_json # e.g. {"Text" => "Here you go", "Html" => null}

  file_iteration = 0
  files.each do |file|
    post_body << "\r\n--#{boundary}\r\n"
    post_body << "Content-Disposition: form-data; name = \"file #{file_iteration}\"; filename=\"#{File.basename(file)}\"\r\n"
    post_body << "Content-Type: text/plain\r\n\r\n"
    post_body << File.read(file)
    file_iteration += 1
  end
  post_body << "\r\n\r\n--#{boundary}--\r\n"

  # Create the HTTP objects
  http = Net::HTTP.new(uri.host, uri.port)
  http.set_debug_output($stdout)
  http.use_ssl = true
  request = Net::HTTP::Post.new(uri.request_uri, header)
  request.body = post_body.join
  puts request.body
  # Send the request
  response = http.request(request)
  response.body
end

# bridge function ~~~
def _upload_post_data(path, json, files, method)
  _news_upload(path, json, files, method)
end



# based upon the specific code that is returned from the http method, this
# displays the response, in the case that it is an error within the request
# or the server. This is simply informative and assists in describing the
# lacking response information from the valence api. In the case of a Bad
# Request, it is likely that it cannot be further specified without looking
# back at the d2l_api documentation or looking at the documentation on
# the docs.valence.desire2learn.com website.
def display_response_code(code)
    case code
    when 400
        puts '[!] 400: Bad Request'
    when 401
        puts '[!] 401: Unauthorized'

    when 403
        print '[!] Error Code Forbidden 403: accessing the page or resource '\
              'you were trying to reach is absolutely forbidden for some reason.'
    when 404
        puts '[!] 404: Not Found'
    when 405
        puts '[!] 405: Method Not Allowed'
    when 406
        puts 'Unacceptable Type'\
    	    'Unable to provide content type matching the client\'s Accept header.'
    when 412
        puts '[!] 412: Precondition failed\n'\
          'Unsupported or invalid parameters, or missing required parameters.'
    when 415
        puts '[!] 415: Unsupported Media Type'\
          'A PUT or POST payload cannot be accepted.'
    when 423
        puts '[!] 423'
    when 500
        puts '[!] 500: General Service Error\n'\
          'Empty response body. The service has encountered an unexpected'\
            'state and cannot continue to handle your action request.'
    when 504
        puts '[!] 504: Service Error'
    end
end

##################
### Versions #####
##################
def get_all_products_supported_versions
  path = "/d2l/api/versions/"
  _get(path)
  # returns array of product codes in a JSON block
end

# Retrieve the collection of versions supported by a specific product component
def get_product_supported_versions(product_code)
  path = "/d2l/api/#{product_code}/versions/"
  _get(path)
end

def get_latest_product_version(product_code)
  begin
    get_product_supported_versions(product_code)["SupportedVersions"][-1]
  rescue SocketError => e
    puts "\n[!] Error likely caused by an incorrect 'd2l_config.json' hostname value: #{e}"
    exit
  rescue NoMethodError => e
    puts "\n[!] Error likely caused by incorrect 'd2l_config.json' api or user values: #{e}"
    exit
  end
end

# retrieve all supported versions for all product components
def get_versions
  path = "/d2l/api/versions/"
  _get(path)
  # returns: SupportedVersion JSON block
end

#determine if a specific product component supports a particular API version
def check_if_product_supports_api_version(product_code, version)
  path = "/d2l/api/#{product_code}/versions/#{version}"
  _get(path)
end

def check_supported_version_request_validity(supported_version_request)
    schema = {
      'type' => 'array',
      'items' =>
        {
            'type' => "object",
            "properties" =>
            {
              "Productcode" => {'type'=>"string"},
              "Version" => {'type'=>"string"}
            }
        }
    }
    JSON::Validator.validate!(schema, supported_version_request, validate_schema: true)
end

# determine versions supported by the back-end Brightspace API
# requires: JSON SupportedVersionRequest data block
def check_product_versions(supported_version_request)
  payload =
  [
    {
      "ProductCode" => "9.9",
      "Version" => "9.9"
    }
  ].merge!(supported_version_request)
  # requires: JSON SupportedVersionRequest data block
  check_supported_version_request_validity(payload)
  path = "/d2l/api/versions/check"
  _post(path, payload)
  # returns: BulkSupportedVersionResponse JSON block
end

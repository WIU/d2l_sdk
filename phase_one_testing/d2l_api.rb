
require 'rubygems'
require 'awesome_print' # awesome_print gem
require 'base64'
require 'json'
require 'restclient' # rest-client gem
require 'openssl'
require 'open-uri'
require 'launchy'
require 'colorize'
require_relative 'D2L_Config'

# Global variables initialized through require_relative 'D2L_Config'

def create_authenticated_uri(path, http_method)
    parsed_url = URI.parse(path.downcase)
    uri_scheme = 'https'
    query_string = get_query_string(parsed_url.path, http_method)
    uri = uri_scheme + '://' + $hostname + parsed_url.path + query_string
    uri << '&' + parsed_url.query if parsed_url.query
    uri
end

def build_authenticated_uri_query_string(signature, timestamp)
    "?x_a=#{$app_id}"\
    "&x_b=#{$user_id}"\
    "&x_c=#{get_base64_hash_string($app_key, signature)}"\
    "&x_d=#{get_base64_hash_string($user_key, signature)}"\
    "&x_t=#{timestamp}"
end

def authenticate_uri(path, http_method)
    get_query_string(path, http_method)
end

def format_signature(path, http_method, timestamp)
    http_method.upcase + '&' + path.encode('UTF-8') + '&' + timestamp.to_s
end

def get_base64_hash_string(key, signature)
    hash = OpenSSL::HMAC.digest('sha256', key, signature)
    Base64.urlsafe_encode64(hash).delete('=')
end

def get_query_string(path, http_method)
    timestamp = Time.now.to_i
    signature = format_signature(path, http_method, timestamp)
    build_authenticated_uri_query_string(signature, timestamp)
end

# Creates the user (identified by userId)
def create_user_data(userData)
    payload = { 'OrgDefinedId' => '', # String
                'FirstName' => 'TestUser', # String
                'MiddleName' => 'Test', # String
                'LastName' => 'Test', # String
                'ExternalEmail' => nil, # String (nil or well-formed email addr)
                'UserName' => 'test12345a', # String
                'RoleId' => 110, # number
                'IsActive' => false, # bool
                'SendCreationEmail' => false, # bool
              }.merge!(userData)
    ap payload
    test_uri = create_authenticated_uri('/d2l/api/lp/1.4/users/', 'POST')
    RestClient.post(test_uri, payload.to_json, { content_type: :json })
    puts '[+] User creation completed successfully'.green
end

# Updates the user's data (identified by userId)
def update_user_data(userId, newData)
    payload = {
      'OrgDefinedId' => '',
      'FirstName' => '',
      'MiddleName' => '',
      'LastName' => '',
      'ExternalEmail' => nil, # Predefines user data, in the case that
      'UserName' => '',       # there is are variables left out in the JSON
      'Activation' => {
        'IsActive' => false
      }
    }.merge!(newData)
    path = '/d2l/api/lp/1.4/users/' + userId.to_s
    test_uri = create_authenticated_uri(path, 'PUT')
    RestClient.put(test_uri, payload.to_json, { content_type: :json })
    puts '[+] User data updated successfully'.green
end

def get_query(uri_string)
    RestClient.get(uri_string) do |response, request, result, &block|
        begin
            case response.code
            when 200
                puts '[+] The request has succeeded.'.green
                puts JSON.parse(response).class
                puts "\n[-] awesome_print Formatted JSON parsed response: "
                ap JSON.parse(response)
            else
                handle_response(response.code)
                response.return!(request, result, &block)
                puts '[!] Get query failed, see above response code'.red
            end
        rescue
            ap response.code
        end
    end
end

def handle_response(code)
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
        raise SomeCustomExceptionIfYouWant
    when 500
        puts '[!] 500: General Service Error\n'\
          'Empty response body. The service has encountered an unexpected'\
            'state and cannot continue to handle your action request.'
    when 504
        puts '[!] 504: Service Error'
    end
end

# example paths
# -----------------
# path = '/d2l/api/lp/1.4/users/'
# path = '/d2l/api/lp/1.4/enrollments/users/47892/orgUnits/'
# path = '/d2l/api/versions/'

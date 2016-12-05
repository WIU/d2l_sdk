
require 'rubygems'
require 'awesome_print' # awesome_print gem
require 'base64'
require 'json'
require 'restclient' # rest-client gem
require 'openssl'
require 'open-uri'
require 'launchy'
require 'colorize'

# vars
$hostname = 'wiutest.desire2learn.com' # set hostname to the test server
puts '[+] Host set to: '.yellow + $hostname
# User ID = api-user
# User PW = see keepass
$user_id = 'rV5wdZwBbnT4prgaLlqx05'
$user_key = 'xVee4KJhixBCQphf-3Wuf9'

# #OG app ID and key
$app_id = 'ysuBVIqmRDaJpnVEOb8Ylg'
$app_key = 't3Rro3P91i_U1let5vd8Wg'

# #Zero permissions account app
# $app_id = 'KG3-PlRdIghGK_mc4M0QAg'
# $app_key = '0VX8ZBNh5_Qip3SmNL57eA'

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

def _post(url, payload, headers)
    RestClient.post(url, payload.to_json, headers)
end
=begin
{ 'OrgDefinedId' => '12345678',
            'FirstName' => 'test',
            'MiddleName' => 'test1',
            'LastName' => 'test12',
            'ExternalEmail' => 'None',
            'UserName' => 'test12345a',
            'RoleId' => 105,
            'IsActive' => false,
            'SendCreationEmail' => false
          }
=end
# CREATE
def create_sample_user_data
    http_method = 'POST'
    puts '[-] Testing ' + http_method + ' through create_sample_user_data'
    path = '/d2l/api/lp/1.4/users/'
    payload = { 'OrgDefinedId' => '', # String
                'FirstName' => 'TestUser', # String
                'MiddleName' => 'Test', # String
                'LastName' => 'Test', # String
                'ExternalEmail' => nil, # String (nil or well-formed email addr)
                'UserName' => 'test12345a', # String
                'RoleId' => 110, # number
                'IsActive' => false, # bool
                'SendCreationEmail' => false, # bool
              }

    ap payload
    puts '[-] Path used: ' + path
    headers = { content_type: :json }
    # POST /d2l/api/lp/1.4/users/
    test_uri = create_authenticated_uri(path, http_method)
    RestClient.post(test_uri, payload.to_json, headers)
    puts '[+] sample user data completed successfully'.green
end

def update_sample_user_data(_userId, _newData)
    http_method = 'PUT'
    puts '[-] Testing ' + http_method + ' through update_sample_user_data'
    path = '/d2l/api/lp/1.4/users/' + '47906' #'JtVGn4cUKz' # to_s
    payload = {
        'OrgDefinedId' => '',
        'FirstName' => 'API',
        'MiddleName' => 'changedName',
        'LastName' => 'User',
        'ExternalEmail' => 'help@wiu.edu',
        'UserName' => 'api-user',
        'Activation' => {
            'IsActive' => true
        }
    }
    print 'user JSON = '
    ap payload
    headers = { content_type: :json }
    # POST /d2l/api/lp/1.4/users/
    test_uri = create_authenticated_uri(path, http_method)
    puts '[-] Path used: ' + path
    RestClient.put(test_uri, payload.to_json, headers)
    puts '[+] sample user data updated successfully'.green
    # argument newData is used to update data of the sample users
    # will need to get the userId of the sample first
end

def get_query(uri_string)
    RestClient.get(uri_string) do |response, request, result, &block|
        begin
            case response.code
            when 200
                puts '[+] The request has succeeded.'.green
                print '[-] Class utilized: '
                puts JSON.parse(response).class
                # puts "\n[+] Unformatted JSON parsed response: "
                # puts JSON.parse(response)
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

# Test1
def testRolesViewing
    puts '[-] Test1: Checking if Current User can check existing roles'.cyan
    path = '/d2l/api/lp/1.4/roles/'
    http_method = 'GET'
    test_uri = create_authenticated_uri(path, http_method)
    puts '[-] Authenticated URI Created For: ' + path
    # General Brightspace API response behaviors
    get_query(test_uri)
    puts "[+] Test1 Succeeded\n".green
rescue
    puts '[!] Test1 failed'.red
end

# Test 2
def testWhoAmI
    puts "[-] Test2: Getting Current User's WhoAmI".cyan
    path = '/d2l/api/lp/1.4/users/whoami'
    http_method = 'GET'
    test_uri = create_authenticated_uri(path, http_method)
    puts '[-] Authenticated URI Created: ' + path
    # General Brightspace API response behaviors
    get_query(test_uri)
    puts "[+] Test2 Succeeded\n".green
rescue
    puts '[!] Test2 failed'.red
end

# TEST 3
def testCreateUser
    puts '[-] Test3: testing create sample user data function'.cyan
    create_sample_user_data # ERROR 403 Forbidden (lack of access/back-end)
    puts "[+] Test3 Succeeded\n".green
rescue => error
    ap error
    puts "[!] Test3 failed\n".red
    # ap error.backtrace
end

# Test 4
def testUpdateUser
    puts '[-] Test4: testing update sample user data function'.cyan
    update_sample_user_data(1, 1) # TCP failed?
    puts "[+] Test4 Succeeded\n".green
rescue => error
    ap error
    ap error.backtrace
    puts "[!] Test4 failed\n".red
end

# Test 5
def testWhoAnotherUserIs(id)
    puts "[-] Test5: Getting Current User's Ability to view other user profiles".cyan
    path = '/d2l/api/lp/1.4/users/' + id # '/d2l/api/lp/1.4/users/whoami'
    http_method = 'GET'
    test_uri = create_authenticated_uri(path, http_method)
    puts '[-] Authenticated URI Created: ' + path
    # General Brightspace API response behaviors
    get_query(test_uri)
    puts "[+] Test5 Succeeded\n".green
rescue
    puts '[!] Test5 failed'.red
end

def testSearchByUserName(username)
  puts "[-] Test6: Using brightspace search functionality using UserName".cyan
  path = '/d2l/api/lp/1.4/users/' + "?UserName=" + username
  http_method = 'GET'
  test_uri = create_authenticated_uri(path, http_method)
  puts '[-] Authenticated URI Created: ' + path
  # General Brightspace API response behaviors
  get_query(test_uri)
  puts "[+] Test6 Succeeded\n".green
rescue
  puts '[!] Test6 failed'.red
end


#testRolesViewing
#testWhoAmI
#testCreateUser
#testUpdateUser
#testWhoAnotherUserIs('47906')
testSearchByUserName("test12345a")

# ap response.return!(request, result, &block)
# hash = OpenSSL::HMAC.digest('sha256', "#{$user_id}&#{$user_key}", $app_key)
# x_c = Base64.urlsafe_encode64(hash).delete('=')
# puts '[+] Hash:  ' + x_c
# $timestamp = Time.now.to_i # current hour
# $timestamp = 1406652368

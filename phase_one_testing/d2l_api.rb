
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
require 'set'

# Global variables initialized through require_relative 'D2L_Config'
def prompt(*args)
    print(*args)
    gets.chomp.downcase
end

def create_authenticated_uri(path, http_method)
    parsed_url = URI.parse(path.downcase)
    uri_scheme = 'https'
    query_string = _get_string(parsed_url.path, http_method)
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

def format_signature(path, http_method, timestamp)
    http_method.upcase + '&' + path.encode('UTF-8') + '&' + timestamp.to_s
end

def get_base64_hash_string(key, signature)
    hash = OpenSSL::HMAC.digest('sha256', key, signature)
    Base64.urlsafe_encode64(hash).delete('=')
end

def _get_string(path, http_method)
    timestamp = Time.now.to_i
    signature = format_signature(path, http_method, timestamp)
    build_authenticated_uri_query_string(signature, timestamp)
end

########################
# QUERIES/RESPONSE:#####
########################
def _get(path)
    uri_string = create_authenticated_uri(path, "GET")
    RestClient.get(uri_string) do |response, _request, _result|
        case response.code
        when 200
            puts '[+] The request has succeeded.'.green # Query == Ok!
            # puts "\n[-] awesome_print Formatted JSON parsed response: "
            # ap JSON.parse(response) # Here is the JSON fmt'd response printed
            JSON.parse(response)
        else
            handle_response(response.code) # display informaiton on the err code
            # response.return!(request, result, &block)
            # response.return!
            puts '[!] Get query failed, see above response code'.red
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

########################
# COURSES:##############
########################
# Creates the course offering
def create_course_data(course_data)
    # ForceLocale- course override the user’s locale preference
    # Path- root path to use for this course offering’s course content
    #       if your back-end service has path enforcement set on for
    #       new org units, leave this property as an empty string
    # Define a valid, empty payload and merge! with the user_data. Print it.
    payload = { 'Name' => '', # String
                'Code' => 'off_SEMESTERCODE_STARNUM', # String
                'Path' => '', # String
                'CourseTemplateId' => 99_989, # number: D2L_ID
                'SemesterId' => nil, # number: D2L_ID  | nil
                'StartDate' => nil, # String: UTCDateTime | nil
                'EndDate' => nil, # String: UTCDateTime | nil
                'LocaleId' => nil, # number: D2L_ID | nil
                'ForceLocale' => false, # bool
                'ShowAddressBook' => false # bool
              }.merge!(course_data)
    ap payload
    # Define a path referencing the courses path
    path = "/d2l/api/lp/#{$version}/courses/"
    #ap path
    auth_uri = create_authenticated_uri(path, 'POST')
    # Perform the Post action, creating the course; provide feedback to client.
    RestClient.post(auth_uri, payload.to_json, content_type: :json)
    puts '[+] Course creation completed successfully'.green
end

def get_org_unit_children(org_unit)
    path = "/d2l/api/lp/#{$version}/orgstructure/" + org_unit + '/children/'
    _get(path)
end

def get_org_department_classes(org_unit)
    path = "/d2l/api/lp/#{$version}/orgstructure/" + org_unit + '/descendants/?=ouTypeId=3'
    _get(path)
end

def get_courses_by_name(org_unit_name)
    class_not_found = true
    puts '[+] Searching for courses using search string: '.yellow + org_unit_name
    courses_results = []
    path = "/d2l/api/lp/#{$version}/orgstructure/6606/descendants/?outTypeId=3"
    results = _get(path)
    results.each do |x|
        if x['Name'].downcase.include? org_unit_name.downcase
            class_not_found = false
            courses_results.push(x)
        end
    end
    if class_not_found
        puts '[-] No courses could be found based upon the search string.'.yellow
    end
    courses_results
end

# Update the course based upon the first argument
# Utilize the second argument and perform a PUT action to replace the old data
def update_course_data(course_id, new_data)
    # Define a valid, empty payload and merge! with the new data.
    payload = { 'Name' => '', # String
                'Code' => 'off_SEMESTERCODE_STARNUM', # String
                'StartDate' => nil, # String: UTCDateTime | nil
                'EndDate' => nil, # String: UTCDateTime | nil
                'IsActive' => false # bool
              }.merge!(new_data)
    ap payload
    # Define a path referencing the courses path
    path = "/d2l/api/lp/#{$version}/courses/" + course_id.to_s
    ap path
    auth_uri = create_authenticated_uri(path, 'PUT')
    # Perform the put action, updating the data; Provide feedback to client.
    RestClient.put(auth_uri, payload.to_json, content_type: :json)
    puts '[+] Course creation completed successfully'.green
    # Define a path referencing the course data using the course_id
    # Perform the put action that replaces the old data
    # Provide feedback that the update was successful
end

# Deletes a course based, referencing it via its org_unit_id
def delete_course_data(org_unit_id)
    path = "/d2l/api/lp/#{$version}/courses/" + org_unit_id.to_s # setup user path
    auth_uri = create_authenticated_uri(path, 'DELETE')
    RestClient.delete(auth_uri, content_type: :json)
    puts '[+] Course data deleted successfully'.green
end

########################
# COURSE TEMPLATES:#####
########################

#/d2l/api/lp/(version)/coursetemplates/ [POST]
def create_course_template(new_course_template)
  # ForceLocale- course override the user’s locale preference
  # Path- root path to use for this course offering’s course content
  #       if your back-end service has path enforcement set on for
  #       new org units, leave this property as an empty string
  # Define a valid, empty payload and merge! with the user_data. Print it.
  payload = { 'Name' => '', # String
              'Code' => 'off_SEMESTERCODE_STARNUM', # String
              'Path' => '', # String
              'ParentOrgUnitIds' => [99_989], # number: D2L_ID
            }.merge!(course_data)
  ap payload
  # Define a path referencing the courses path
  path = "/d2l/api/lp/#{$version}/coursetemplates/"
  #ap path
  auth_uri = create_authenticated_uri(path, 'POST')
  # Perform the Post action, creating the course; provide feedback to client.
  RestClient.post(auth_uri, payload.to_json, content_type: :json)
  puts '[+] Course template creation completed successfully'.green
end
#/d2l/api/lp/(version)/coursetemplates/(orgUnitId) [GET]
def get_course_template(org_unit_id)
  path = "/d2l/api/lp/#{$version}/coursetemplates/" + org_unit_id
  _get(path)
end

#/d2l/api/lp/(version)/coursetemplates/schema [GET]
def get_course_templates_schema
  path = "/d2l/api/lp/#{$version}/coursetemplates/schema"
  _get(path)
end

#/d2l/api/lp/(version)/coursetemplates/(orgUnitId) [PUT]
def update_course_template(org_unit_id, course_template_update)
  # Define a valid, empty payload and merge! with the new data.
  payload = { 'Name' => '', # String
              'Code' => 'off_SEMESTERCODE_STARNUM', # String
            }.merge!(new_data)
  ap payload
  # Define a path referencing the courses path
  path = "/d2l/api/lp/#{$version}/coursestemplates/" + org_unit_id.to_s
  auth_uri = create_authenticated_uri(path, 'PUT')
  # Perform the put action, updating the data; Provide feedback to client.
  RestClient.put(auth_uri, payload.to_json, content_type: :json)
  puts '[+] Course creation completed successfully'.green
end

#/d2l/api/lp/(version)/coursetemplates/(orgUnitId) [DELETE]
def delete_course_template(org_unit_id)
  path = "/d2l/api/lp/#{$version}/coursetemplates/" + org_unit_id.to_s
  auth_uri = create_authenticated_uri(path, 'DELETE')
  RestClient.delete(auth_uri, content_type: :json)
  puts '[+] Course template data deleted successfully'.green
end







########################
# SEMESTER:#############
########################
def create_semester_data(semester_data)
    # Define a valid, empty payload and merge! with the semester_data. Print it.
    payload = { 'Type' => 5, # String
                'Name' => 'Winter 2013 Semester', # String
                'Code' => 'YEAR01', # String #YearNUM where NUM{sp:01,su:06,fl:08}
                'Parents' => [6606], # String
              }.merge!(semester_data)
    ap payload
    # Define a path referencing the course data using the course_id
    auth_uri = create_authenticated_uri("/d2l/api/lp/#{$version}/orgstructure/", 'POST')
    # Perform the Post action, creating the user; provide feedback to client.
    RestClient.post(auth_uri, payload.to_json, content_type: :json)
    puts '[+] Semester creation completed successfully'.green
end

def update_semester_data(org_unit_id, semester_data)
    # Define a valid, empty payload and merge! with the semester_data. Print it.
    payload = { # Can only update NAME, CODE, and PATH variables
        'Identifier' => org_unit_id.to_s, # String: D2LID // DO NOT CHANGE
        'Name' => 'Winter 2013 Semester', # String
        # String #YearNUM where NUM{sp:01,su:06,fl:08}  | nil
        'Code' => 'REQUIRED',
        # String: /content/enforced/IDENTIFIER-CODE/
        'Path' => '/content/enforced/23452-YEAR01/',
        'Type' => { # DO NOT CHANGE THESE
            'Id' => 5, # <number:D2LID>
            'Code' => 'Semester', # <string>
            'Name' => 'Semester', # <string>
        } # String #YearNUM where NUM{sp:01,su:06,fl:08}
    }.merge!(semester_data)
    # print out the projected new data
    puts '[-] New Semester Data:'.yellow
    ap payload
    # Define a path referencing the course data using the course_id
    path = "/d2l/api/lp/#{$version}/orgstructure/" + org_unit_id.to_s
    puts '[-] Attempting put request (updating orgunit)...'
    auth_uri = create_authenticated_uri(path, 'PUT')
    # Perform the Post action, creating the user; provide feedback to client.
    RestClient.put(auth_uri, payload.to_json, content_type: :json)
    puts '[+] Semester update completed successfully'.green
end

def recycle_semester_data(org_unit_id)
    # Define a path referencing the user data using the user_id
    puts '[!] Attempting to recycle Semester data referenced by id: ' + org_unit_id.to_s
    path = "/d2l/api/lp/#{$version}/orgstructure/recyclebin/" + org_unit_id.to_s + '/recycle' # setup user path
    auth_uri = create_authenticated_uri(path, 'POST')
    # Perform the post action - sending the orgunit to recycling-bin;
    # Provide feedback to client.
    RestClient.post(auth_uri, content_type: :json)
    puts '[+] Semester data recycled successfully'.green
end

########################
# USERS:#################
########################
# Creates the user (identified by userId)
def create_user_data(user_data)
    # Define a valid, empty payload and merge! with the user_data. Print it.
    payload = { 'OrgDefinedId' => '', # String
                'FirstName' => 'TestUser', # String
                'MiddleName' => 'Test', # String
                'LastName' => 'Test', # String
                'ExternalEmail' => nil, # String (nil or well-formed email addr)
                'UserName' => 'test12345a', # String
                'RoleId' => 110, # number
                'IsActive' => false, # bool
                'SendCreationEmail' => false, # bool
              }.merge!(user_data)
    ap payload
    # Define a path referencing the course data using the course_id
    auth_uri = create_authenticated_uri("/d2l/api/lp/#{$version}/users/", 'POST')
    # Perform the Post action, creating the user; provide feedback to client.
    RestClient.post(auth_uri, payload.to_json, content_type: :json)
    puts '[+] User creation completed successfully'.green
end

def get_whoami
  path = "/d2l/api/lp/#{$version}/users/whoami"
  _get(path)
end
# Updates the user's data (identified by userId)
def update_user_data(user_id, new_data)
    # Define a valid, empty payload and merge! with the user_data. Print it.
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
    }.merge!(new_data)
    # Define a path referencing the user data using the user_id
    path = "/d2l/api/lp/#{$version}/users/" + user_id.to_s
    auth_uri = create_authenticated_uri(path, 'PUT')
    # Perform the put action, updating the data; Provide feedback to client.
    RestClient.put(auth_uri, payload.to_json, content_type: :json)
    puts '[+] User data updated successfully'.green
end

def delete_user_data(userId)
    # Define a path referencing the user data using the user_id
    path = "/d2l/api/lp/#{$version}/users/" + userId.to_s # setup user path
    auth_uri = create_authenticated_uri(path, 'DELETE')
    # Perform the delete action - deleting the data; Provide feedback to client.
    RestClient.delete(auth_uri, content_type: :json)
    puts '[+] User data deleted successfully'.green
end

########################
# Org Units:############
########################
def get_org_unit_descendants(org_unit_id)
  path = "/d2l/api/lp/#{$version}/orgstructure/" + org_unit_id.to_s + '/descendants/'
  _get(path)
  #return json of org_unit descendants
end

def get_org_unit_parents(org_unit_id)
  path = "/d2l/api/lp/#{$version}/orgstructure/" + org_unit_id.to_s + '/parents/'
  _get(path)
  #return json of org_unit parents
end

def get_org_unit_children(org_unit_id)
  path = "/d2l/api/lp/#{$version}/orgstructure/" + org_unit_id.to_s + '/children/'
  _get(path)
  #return json of org_unit children
end

def get_org_unit_properties(org_unit_id)
  path = "/d2l/api/lp/#{$version}/orgstructure/" + org_unit_id.to_s
  _get(path)
  #return json of org_unit properties
end

def create_custom_orgunit
  #POST /d2l/api/lp/(version)/orgstructure/
end

def update_course_orgunit
  #PUT /d2l/api/lp/(version)/orgstructure/(orgUnitId)
end

def get_organization_info
  path = "/d2l/api/lp/#{$version}/organization/info"
  _get(path)
end

def get_outype(outype_id)
  path = '/d2l/api/lp/#{$version}/outypes/' + outype_id
  _get(path)
end

def get_all_outypes
  path = '/d2l/api/lp/#{$version}/outypes/'
  _get(path)
end


=begin
def retrieve_all_users()
    puts ''.cyan
    path = "/d2l/api/lp/#{$version}/users/"
    response = _get(create_authenticated_uri(path, 'GET'))
    i = 1
    while response!=404 && i < 61 do
      path = "/d2l/api/lp/#{$version}/users/?bookmark=" + response["PagingInfo"]["Bookmark"]
      new_response = _get(create_authenticated_uri(path, 'GET'))
      response.merge(new_response)
      i=i+1
      print i.to_s + "\n"
      print response["PagingInfo"]["Bookmark"] = new_response["PagingInfo"]["Bookmark"]
    end
    ap response["Items"]
    response["Items"]
end

def search_users_by_username(username)
    results = []
    File.open("test_log.txt", 'w') do |s|
      all_users = retrieve_all_users
      #ap all_users.count
      matching_names = all_users.select{|user| user["UserName"].downcase.include?(username.downcase)}
      #ap matching_names.count
      matching_names.each do |user|
          ap user
          #x = ap user
          #s.puts x
      end
    end
end
=end
#def search_users(search_string)
#  path = "/d2l/api/lp/#{$version}/users/?userName=test"
#  response = _get(create_authenticated_uri(path, 'GET'))
#  ap response
#end
# example paths
# -----------------
# path = "/d2l/api/lp/#{$version}/users/"
# path = "/d2l/api/lp/#{$version}/enrollments/users/47892/orgUnits/"
# path = "/d2l/api/versions/"

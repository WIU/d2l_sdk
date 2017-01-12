require_relative 'requests'
require 'thread'
require 'json-schema'

########################
# USERS:################
########################

# Checks whether the created user data conforms to the valence api for the
# user data JSON object. If it does conform, then nothing happens and it
# simply returns true. If it does not conform, then the JSON validator raises
# an exception.
def check_user_data_validity(user_data)
    schema = {
        'type' => 'object',
        'required' => %w(OrgDefinedId FirstName MiddleName
                         LastName ExternalEmail UserName
                         RoleId IsActive SendCreationEmail),
        'properties' => {
            'OrgDefinedId' => { 'type' => 'string' },
            'FirstName' => { 'type' => 'string' },
            'MiddleName' => { 'type' => 'string' },
            'LastName' => { 'type' => 'string' },
            'ExternalEmail' => { 'type' => %w(string null) },
            'UserName' => { 'type' => 'string' },
            'RoleId' => { 'type' => 'integer' },
            'IsActive' => { 'type' => 'boolean' },
            'SendCreationEmail' => { 'type' => 'boolean' }
        }
    }
    JSON::Validator.validate!(schema, user_data, validate_schema: true)
end

# Creates the user using user_data as an argument.
# A Hash is merged with the user_data. The data types for each Hash key is
# specified below. For the ExternalEmail, there must be either nil for the value
# or a WELL FORMED email address. The username must be unique, meaning no other
# user has that name. All of the rest can remain the same, assuming roleId 110
# exists in your system.
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
    # requires: UserData JSON block
    # Define a path referencing the course data using the course_id
    check_user_data_validity(payload)
    path = "/d2l/api/lp/#{$lp_ver}/users/"
    _post(path, payload)
    puts '[+] User creation completed successfully'.green
    # returns a UserData JSON block for the newly created user
end

# Retrieves the whoami of the user authenticated through the config file.
# returns: JSON whoami response
def get_whoami
    path = "/d2l/api/lp/#{$lp_ver}/users/whoami"
    _get(path)
    # returns a WhoAmIUser JSON block for the current user context
end

# Simple get users function that assists in retrieving users by particular
# paramerters. These parameters are then appended to the query string if
# they are defined by the user.
#
# Returns: JSON of all users matching the parameters given.
def get_users(org_defined_id = '', username = '', bookmark = '')
    path = "/d2l/api/lp/#{$lp_ver}/users/"
    path += "?orgDefinedId=#{org_defined_id}" if org_defined_id != ''
    path += "?userName=#{username}" if username != ''
    path += "?bookmark=#{bookmark}" if bookmark != ''
    _get(path)
    # If- username is defined, this RETURNS a single UserData JSON block
    # else if- org_defined_id is defined, this returns a UserData JSON array
    # else- if neither is defined, this RETURNS a paged result set of users after
    # the bookmark
end

# Retrieves a user based upon an explicitly defined username.
# Returns: JSON response of this user.
def get_user_by_username(username)
    get_users('', username)
end

# Helper function that retrieves the first 100 users after the specified
# bookmark.
#
# Returns: JSON array of user objects.
def get_users_by_bookmark(bookmark = '')
    get_users('', '', bookmark)
    # Returns: JSON array of user objects.
end

# Uses a min and max to create a range.
# returns: range obj
def create_range(min, max)
    (min..max)
    # returns: range obj
end

# Checks whether a username already exists
# returns: true if the the user exists already
def does_user_exist(username)
    if !get_user_by_username(username.to_s).nil?
        return true
    else
        return false
    end
end

# Initiates a multithreaded search to streamline the search of a user based upon
# a part of their search str. This calls +get_user_by_string+, which is actually
# using a bookmarked search. This brings the search time down from 15+ minutes
# to only ~10-13 seconds, depending upon the computer. This can be sped up MUCH
# more by using a computer with more cores. Anyways, based upon the number of
# threads used, iterations are performed, specifying certain ranges for each
# thread to search by using +get_user_by_string+. Upon all of the threads
# joining, the thread_results are returned (as they are all the matching names)
#
# returns: Array::param_values_with_string_included
# example--- multithreaded_user_search("UserName", "api", 17)
# example 2--- multithreaded_user_search("UserName", /pap/, 17, true)
def multithreaded_user_search(parameter, search_string, num_of_threads, regex = false)
    # Assumed: there is only up to 60,000 users.
    # Start from 1, go up to max number of users for this search...
    max_users = 60_000
    range_min = 1
    # range max = the upper limit for the search for a thread
    range_max = max_users / num_of_threads + 1
    threads = []
    thread_results = []
    # ap "creating #{num_of_threads} threads..."
    # from 0 up until max number of threads..
    (0...num_of_threads - 1).each do |iteration|
        # setup range limits for the specific thread
        min = range_min + range_max * iteration
        max = range_max + (range_max - 1) * iteration
        range = create_range(min, max)
        # push thread to threads arr and start thread search of specified range.
        threads[iteration] = Thread.new do
            _get_user_by_string(parameter, search_string, range, regex).each do |match|
                thread_results.push(match)
            end
        end
    end
    # Join all of the threads
    threads.each(&:join)
    puts "returning search results for #{parameter}::#{search_string}"
    # Return an array of users that exist with the search_string in the param.
    thread_results
end

# get_user_by_string uses arguments search_string and range. To use these,
# a range is created, an array of matching names is initialized, and then
# the entire range is iterated to check for names that have the search_string
# in them. Upon reaching a page that has an empty items JSON array, the search
# ends. This is due to the fact that pages with zero items will not have any
# more users past them. The array of matching names is then returned.
#
# returns: array::matching_names
def _get_user_by_string(parameter, search_string, range, regex = false)
    # puts "searching from #{range.min.to_s} to #{range.max.to_s}"
    i = range.min
    matching_names = []
    # Average difference between each paged bookmarks beginnings is 109.6
    while i.to_i < range.max
        # path = "/d2l/api/lp/#{$lp_ver}/users/?bookmark=" + i.to_s
        response = get_users_by_bookmark(i.to_s)
        if response['PagingInfo']['HasMoreItems'] == false
            # ap 'response returned zero items, last page possible for this thread..'
            return matching_names
        end
        response['Items'].each do |user|
            if regex && !user[parameter].nil?
                matching_names.push(user) if (user[parameter] =~ search_string) != nil
            elsif !user[parameter].nil?
                matching_names.push(user) if user[parameter].include? search_string
            end
        end
        i = response['PagingInfo']['Bookmark']
    end
    matching_names
end

# Retrieves a user based upon an explicitly pre-defined user_id. This is also
# known as the Identifier of this user object. Upon retrieving the user, it
# is then returned.
#
# returns: JSON user object.
def get_user_by_user_id(user_id)
    # Retrieve data for a particular user
    path = "/d2l/api/lp/#{$lp_ver}/users/#{user_id}"
    _get(path)
    # returns a UserData JSON block
end

# Checks whether the updated user data conforms to the valence api for the
# user data JSON object. If it does conform, then nothing happens and it
# simply returns true. If it does not conform, then the JSON validator raises
# an exception.
def check_updated_user_data_validity(user_data)
    schema = {
        'type' => 'object',
        'required' => %w(OrgDefinedId FirstName MiddleName
                         LastName ExternalEmail UserName
                         Activation),
        'properties' => {
            'OrgDefinedId' => { 'type' => 'string' },
            'FirstName' => { 'type' => 'string' },
            'MiddleName' => { 'type' => 'string' },
            'LastName' => { 'type' => 'string' },
            'ExternalEmail' => { 'type' => %w(string null) },
            'UserName' => { 'type' => 'string' },
            'Activation' => {
                'required' => ['IsActive'],
                'properties' => {
                    'IsActive' => {
                        'type' => 'boolean'
                    }
                }
            }
        }
    }
    JSON::Validator.validate!(schema, user_data, validate_schema: true)
end

# Updates the user's data (identified by user_id)
# By merging input, named new_data, with a payload, the user_data is guarenteed
# to at least be formatted correctly. The data, itself, depends upon the api
# user. Once this is merged, a put http method is utilized to update the user
# data.
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
    # Requires: UpdateUserData JSON block
    check_updated_user_data_validity(payload)
    # Define a path referencing the user data using the user_id
    path = "/d2l/api/lp/#{$lp_ver}/users/" + user_id.to_s
    _put(path, payload)
    puts '[+] User data updated successfully'.green
    # Returns a UserData JSON block of the updated user's data
end

# Deletes the user's data (identified by user_id). By forming a path that is
# correctly referencing this user's data, a delete http method is executed and
# effectively deleted the user that is referenced.
def delete_user_data(user_id)
    # Define a path referencing the user data using the user_id
    path = "/d2l/api/lp/#{$lp_ver}/users/#{user_id}" # setup user path
    _delete(path)
    puts '[+] User data deleted successfully'.green
end

def get_enrolled_roles_in_org_unit(org_unit_id)
  # this only lists ones viewable by the CALLING user
  # also, only includes roles that are enrolled in the org unit
  path = "/d2l/api/#{$lp_ver}/#{org_unit_id}/roles/"
  _get(path)
end

# retrieve personal profile info for the current user context
def get_current_user_profile
  path = "/d2l/api/lp/#{$lp_ver}/profile/myProfile"
  _get(path)
  # Returns UserProfile JSON data block
end

# retrieve personal profile info of the specified user
def get_user_profile(user_id)
  path = "/d2l/api/lp/#{$lp_ver}/profile/user/#{user_id}"
  _get(path)
  # Returns UserProfile JSON data block
end

def get_profile_image(profile_id, size = 0)
  path = "/d2l/api/lp/#{$lp_ver}/profile/#{profile_id}/image"
  path += "?size=#{size}" if size != 0
  _get(path)
end

def get_current_user_profile_image(size = 0)
  path = "/d2l/api/lp/#{$lp_ver}/profile/myProfile/image"
  path += "?size=#{size}" if size != 0
  _get(path)
end

def get_user_profile_image(user_id)
  path = "/d2l/api/lp/#{$lp_ver}/profile/user/#{user_id}"
  path += "?size=#{size}" if size != 0
  _get(path)
end
#####Notifications
def get_all_notification_carrier_channels
  path = "/d2l/api/lp/#{$lp_ver}/notifications/instant/carriers/"
  _get(path)
end

def get_all_subscriptions_by_carrier(carrier_id)
  path = "/d2l/api/lp/#{$lp_ver}/notifications/instant/carriers/#{carrier_id}/subscriptions/"
  _get(path)
end

def subscribe_to_carrier_notification(carrier_id, message_type_id)
  path = "/d2l/api/lp/#{$lp_ver}/notifications/instant/carriers/#{carrier_id}/subscriptions/#{message_type_id}"
  _put(path,{})
end

#####LOCALES
=begin
# retrieve the locale account settings for a particular user.
def get_locale_account_settings(user_id)
  path = "/d2l/api/lp/#{$lp_ver}/accountSettings/#{user_id}/locale/"
  _get(path)
  # returns Locale JSON block
end

# optional parameter 'bookmark' for querying with a paging offset
# Retrieve the collection of all known locales.
def get_all_locales(bookmark = '')
  path = "/d2l/api/lp/#{$lp_ver}/locales/"
  _get(path)
  # returns paged result set containing Locale data blocks
end

# Retrieve the properties for a particular locale.
def get_locale_properties(locale_id)
  path = "/d2l/api/lp/#{$lp_ver}/locales/#{locale_id}"
  _get(path)
  # returns Locale JSON block
end

def is_valid_locale_id(locale_id)


end

# Update the current user's locale account settings
def update_current_user_locale_account_settings(update_locale)
  payload = {"LocaleId" => 0}.merge!(update_locale)
  path = "/d2l/api/lp/#{$lp_ver}/accountSettings/mysettings/locale/"
  # requires UpdateSettings JSON data block
  _put(path, payload)
end

def update_user_locale_account_settings(user_id)
  payload = {"LocaleId" => 0}.merge!(update_locale)
  path = "/d2l/api/lp/#{$lp_ver}/accountSettings/#{user_id}/locale/"
  # requires UpdateSettings JSON data block
  _put(path, payload)
end


######IMS/LIS role configuration
# retrieve list of known LIS roles
def get_lis_roles(lisUrn = "")
  path = "/d2l/api/lp/#{$lp_ver}/imsconfig/roles/"
  path += "#{lisUrn}" if lisUrn != ""
  _get(path)
  # returns array of LIS role data blocks
end

# retrieve mappings between user roles and LIS roles
def get_user_role_lis_mappings(lisUrn = "", d2lid = 0)
  path = "/d2l/api/lp/#{$lp_ver}/imsconfig/map/roles/"
  path += "#{lisUrn}" if lisUrn != ""
  path += "#{d2lid}" if d2lid != 0
  _get(path)
  # returns JSON array of LIS role mapping data blocks
end

# retrieve mapping between a user role and a LIS role
def get_user_role_lis_mappings(role_id, d2lid = 0)
  path = "/d2l/api/lp/#{$lp_ver}/imsconfig/map/roles/#{role_id}"
  path += "#{d2lid}" if d2lid != 0
  _get(path)
  # returns JSON array of LIS role mapping data blocks
end
=end

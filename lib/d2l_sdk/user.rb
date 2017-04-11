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
            'MiddleName' => { 'type' => %w(string null) },
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
# RETURNS: JSON whoami response
def get_whoami
    path = "/d2l/api/lp/#{$lp_ver}/users/whoami"
    _get(path)
    # RETURNS: a WhoAmIUser JSON block for the current user context
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
# RETURNS: JSON user object.
def get_user_by_user_id(user_id)
    # Retrieve data for a particular user
    path = "/d2l/api/lp/#{$lp_ver}/users/#{user_id}"
    _get(path)
    # RETURNS: a UserData JSON block
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
            'OrgDefinedId' => { 'type' => %w(string null) },
            'FirstName' => { 'type' => 'string' },
            'MiddleName' => { 'type' => %w(string null)  },
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
    #puts '[+] User data updated successfully'.green
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

########################
# ACTIVATION:###########
########################
# REVIEW: Retrieve a particular user’s activation settings.
# RETURNS: a UserActivationData JSON block with the user’s current activation status.
def get_user_activation_settings(user_id)
  path = "/d2l/api/lp/#{$lp_ver}/users/#{user_id}/activation"
  _get(path)
  # RETURNS: a UserActivationData JSON block with the user’s current activation status.
end

# REVIEW: Update a particular user’s activation settings.
# RETURNS: ?
def update_user_activation_settings(user_id, is_active)
  # PUT /d2l/api/lp/(version)/users/(userId)/activation
  if is_active != true && is_active != false
    raise ArgumentError, 'is_active is not a boolean'
  else
    path = "/d2l/api/lp/#{$lp_ver}/users/#{user_id}/activation"
    payload =
    {
      "IsActive" => is_active
    }
    _put(path, payload)
    # RETURNS: ?
  end
end

########################
# INTEGRATIONS:#########
########################

# NOTE: UNSTABLE!
# TODO: UNSTABLE!--Link a user to a Google Apps user account.
# RETURNS: ?
def link_user_google_apps_account(google_apps_linking_item)
  # POST /d2l/api/gae/(version)/linkuser
end


########################
# NOTIFICATIONS:########
########################

# REVIEW: Delete the subscription for messages of a particular type,
#       delivered by a particular carrier.
def delete_subscription(carrier_id, message_type_id)
  path = "/d2l/api/lp/#{$lp_ver}/notifications/instant/carriers/#{carrier_id}/subscriptions/#{message_type_id}"
  _delete(path)
end

# Retrieve all the carrier channels for delivering notification messages.
# RETURNS: a JSON array of CarrierOutput data blocks.
def get_all_notification_carrier_channels
  path = "/d2l/api/lp/#{$lp_ver}/notifications/instant/carriers/"
  _get(path)
end

# Retrieve all the current subscriptions for notification messages.
# RETURNS: a JSON array of SubscriptionOutput data blocks.
def get_all_subscriptions_by_carrier(carrier_id)
  path = "/d2l/api/lp/#{$lp_ver}/notifications/instant/carriers/#{carrier_id}/subscriptions/"
  _get(path)
end

# Subscribe to notification messages of a particular type, delivered by a particular carrier.
def subscribe_to_carrier_notification(carrier_id, message_type_id)
  path = "/d2l/api/lp/#{$lp_ver}/notifications/instant/carriers/#{carrier_id}/subscriptions/#{message_type_id}"
  _put(path, {})
end

########################
# PASSWORDS:############
########################

# REVIEW: Clear a particular user’s password.
def delete_user_password(user_id)
  path = "/d2l/api/lp/#{$lp_ver}/users/#{user_id}/password"
  _delete(path)
end

# REVIEW: Reset a particular user’s password.
# INPUT: nil (no payload necessary)
# NOTE: Prompts the service to send a password-reset email to the provided user.
def reset_user_password(user_id)
  path = "/d2l/api/lp/#{$lp_ver}/users/#{user_id}/password"
  _post(path, {})
end

# REVIEW: Update a particular user’s password.
# NOTE: 400 errors are implicitly invalid password
def update_user_password(user_id, user_password_data)
  if user_password_data.is_a? String
    path = "/d2l/api/lp/#{$lp_ver}/users/#{user_id}/password"
    payload = {"Password" => user_password_data}
    _put(path, payload)
  else
    raise ArgumentError, "Argument 'user_password_data' is not a String"
  end
end



########################
# ROLES:################
########################

# retrieve list of all known user roles
def get_all_user_roles
  path = "/d2l/api/lp/#{$lp_ver}/roles/"
  _get(path)
  # RETURNS: a JSON array of Role data blocks
end

# Retrieve a particular user role
def get_user_role(role_id)
  path = "/d2l/api/lp/#{$lp_ver}/roles/#{role_id}"
  _get(path)
  # returns a Role JSON data block
end

# Retrieve a list of all the enrolled user roles the calling user can view
# in an org unit
def get_enrolled_roles_in_org_unit(org_unit_id)
  # this only lists ones viewable by the CALLING user
  # also, only includes roles that are enrolled in the org unit
  path = "/d2l/api/#{$lp_ver}/#{org_unit_id}/roles/"
  _get(path)
  # returns JSON array of Role data blocks
end

# TODO: --UNSTABLE -- Create a new role copied from an existing role.
# INPUT: deep_copy_role_id = d2lID; role_copy_data = User.role_copy_data
# RETURN: a Role JSON data block representing the newly-created copy of the role.
def create_new_role_from_existing_role(deep_copy_role_id, role_copy_data)
  # POST /d2l/api/lp/(version)/roles/
end


########################
# PROFILES:#############
########################

# REVIEW: Remove the current user’s profile image.
def remove_current_user_profile_image
  path = "/d2l/api/lp/#{$lp_ver}/profile/myProfile/image"
  _delete(path)
end

# REVIEW: Remove the profile image from a particular personal profile, by Profile ID.
def remove_profile_image_by_profile_id(profile_id)
  path = "/d2l/api/lp/#{$lp_ver}/profile/#{profile_id}/image"
  _delete(path)
end

# REVIEW: Remove the profile image from a particular personal profile, by User ID.
def remove_profile_image_by_user_id(user_id)
  path = "/d2l/api/lp/#{$lp_ver}/profile/user/#{user_id}/image"
  _delete(path)
end

# retrieve personal profile info for the current user context
# Returns: UserProfile JSON data block
def get_current_user_profile
  path = "/d2l/api/lp/#{$lp_ver}/profile/myProfile"
  _get(path)
  # Returns: UserProfile JSON data block
end

# Retrieve the current user’s profile image.
# INPUT: size (integer) determines the thumbnail size
# RETURNS: This action returns a file stream containing the current user’s
#          profile image. Note that the back-end service may return a
#          profile image larger than your provided size.
def get_current_user_profile_image(size = 0)
  path = "/d2l/api/lp/#{$lp_ver}/profile/myProfile/image"
  path += "?size=#{size}" if size != 0
  _get(path)
  # RETURNS: This action returns a file stream containing the current user’s
  #          profile image. Note that the back-end service may return a
  #          profile image larger than your provided size.
end

# retrieve a particular personal profile, by Profile ID
def get_user_profile_by_profile_id(profile_id)
  path = "/d2l/api/lp/#{$lp_ver}/profile/#{profile_id}"
  _get(path)
  # Returns UserProfile JSON data block
end

# Retrieve a particular profile image, by Profile ID.
# RETURNS: This action returns a file stream containing the current user’s
#          profile image. Note that the back-end service may return a
#          profile image larger than your provided size.
def get_profile_image(profile_id, size = 0)
  path = "/d2l/api/lp/#{$lp_ver}/profile/#{profile_id}/image"
  path += "?size=#{size}" if size != 0
  _get(path)
  # RETURNS: This action returns a file stream containing the current user’s
  #          profile image. Note that the back-end service may return a
  #          profile image larger than your provided size.
end

# Retrieve a particular personal profile, by User ID.
def get_user_profile_by_user_id(user_id)
  path = "/d2l/api/lp/#{$lp_ver}/profile/user/#{user_id}"
  _get(path)
  # Returns UserProfile JSON data block
end


# Retrieve a particular profile image, by User ID.
# RETURNS: This action returns a file stream containing the current user’s
#          profile image. Note that the back-end service may return a
#          profile image larger than your provided size.
def get_user_profile_image(user_id)
  path = "/d2l/api/lp/#{$lp_ver}/profile/user/#{user_id}"
  path += "?size=#{size}" if size != 0
  _get(path)
  # RETURNS: This action returns a file stream containing the current user’s
  #          profile image. Note that the back-end service may return a
  #          profile image larger than your provided size.
end

# TODO: Update the personal profile image for the current user context.
# INPUT: Provide an uploaded image file using the simple file upload process;
#        the content-disposition part header for the file part should have the
#        name profileImage
#        http://docs.valence.desire2learn.com/basic/fileupload.html#simple-uploads
# RETURNS: ?
def update_current_user_profile_image()
  # POST /d2l/api/lp/(version)/profile/myProfile/image
  # RETURNS: ?
end

# TODO: Update the profile image for the identified personal profile, by Profile ID.
# INPUT: Provide an uploaded image file using the simple file upload process;
#        the content-disposition part header for the file part should have the
#        name profileImage
#        http://docs.valence.desire2learn.com/basic/fileupload.html#simple-uploads
# RETURNS: ?
def update_profile_image_by_profile_id
  # POST /d2l/api/lp/(version)/profile/(profileId)/image
  # RETURNS: ?
end

# TODO: Update the profile image for the identified personal profile, by User ID.
# INPUT: Provide an uploaded image file using the simple file upload process;
#        the content-disposition part header for the file part should have the
#        name profileImage
#        http://docs.valence.desire2learn.com/basic/fileupload.html#simple-uploads
# RETURNS: ?
def update_profile_image_by_user_id
  # POST /d2l/api/lp/(version)/profile/user/(userId)/image
  # RETURNS: ?
end

# TODO: Update the personal profile data for the current user context.
# NOTE: block's data will replace all user profile data
# RETURNS: a UserProfile JSON data block for the updated current user profile.
def update_current_user_profile_data(user_profile_data)
  # PUT /d2l/api/lp/(version)/profile/myProfile
end

# TODO: Update a particular personal profile, by Profile ID.
# NOTE: block's data will replace all user profile data
# RETURNS: a UserProfile JSON data block for the updated personal profile.
def update_profile_by_profile_id(profile_id, user_profile_data)
  # PUT /d2l/api/lp/(version)/profile/(profileId)
    # NOTE: Example of User.UserProfile JSON Data Block
    #    {  "Nickname": <string>,
    #       "Birthday": {
    #           "Month": <number>,
    #           "Day": <number>
    #       },
    #       "HomeTown": <string>,
    #       "Email": <string>,
    #       "HomePage": <string>,
    #       "HomePhone": <string>,
    #       "BusinessPhone": <string>,
    #       "MobilePhone": <string>,
    #       "FaxNumber": <string>,
    #       "Address1": <string>,
    #       "Address2": <string>,
    #       "City": <string>,
    #       "Province": <string>,
    #       "PostalCode": <string>,
    #       "Country": <string>,
    #       "Company": <string>,
    #       "JobTitle": <string>,
    #       "HighSchool": <string>,
    #       "University": <string>,
    #       "Hobbies": <string>,
    #       "FavMusic": <string>,
    #       "FavTVShows": <string>,
    #       "FavMovies": <string>,
    #       "FavBooks": <string>,
    #       "FavQuotations": <string>,
    #       "FavWebSites": <string>,
    #       "FutureGoals": <string>,
    #       "FavMemory": <string>,
    #       "SocialMediaUrls": [ // Array of SocialMediaUrl blocks
    #           {
    #                 "Name": <string>,
    #                 "Url": <string:URL>
    #           },
    #           { <composite:SocialMediaUrl> }, ...
    #       ]
    #    }
    # NOTE: The back-end service also expects a file names "profileImage"
  # RETURNS: a UserProfile JSON data block for the updated personal profile.
end

#####################################
# IMS/LIS role configuration:########
#####################################

# NOTE: UNSTABLE
# REVIEW: retrieve list of known LIS roles
def get_lis_roles(lis_urn = "")
  path = "/d2l/api/lp/#{$lp_ver}/imsconfig/roles/"
  path += "#{lis_urn}" if lis_urn != ""
  _get(path)
  # returns array of LIS role data blocks
end

# NOTE: UNSTABLE
# REVIEW: retrieve mappings between user roles and LIS roles
def get_user_role_lis_mappings_by_urn(lis_urn = "", d2lid = 0)
  path = "/d2l/api/lp/#{$lp_ver}/imsconfig/map/roles/"
  path += "#{lis_urn}" if lis_urn != ""
  path += "#{d2lid}" if d2lid != 0
  _get(path)
  # returns JSON array of LIS role mapping data blocks
end

# NOTE: UNSTABLE
# REVIEW: retrieve mapping between a user role and a LIS role
def get_user_role_lis_mappings_by_role(role_id, d2lid = 0)
  path = "/d2l/api/lp/#{$lp_ver}/imsconfig/map/roles/#{role_id}"
  path += "#{d2lid}" if d2lid != 0
  _get(path)
  # returns JSON array of LIS role mapping data blocks
end

# NOTE: UNSTABLE
# TODO: --UNSTABLE-- Map a user role to a set of LIS Roles.
# input: Mappings = String array
def map_user_role_to_lis_roles(role_id, mappings)
  # PUT /d2l/api/lp/(version)/imsconfig/map/roles/(roleId)
end


########################
# SETTINGS:#############
########################
# NOTE: As the settings page only has 4 functions, these functions are simply
# appended to this, the most relevant file.

# REVIEW: Retrieve the current user’s locale account settings.
def get_current_user_locale_settings
  path = "/d2l/api/lp/#{$lp_ver}/accountSettings/mySettings/locale/"
  _get(path)
  # RETURNS: a Locale JSON block
end

# REVIEW: retrieve the locale account settings for a particular user.
def get_locale_account_settings(user_id)
  path = "/d2l/api/lp/#{$lp_ver}/accountSettings/#{user_id}/locale/"
  _get(path)
  # returns Locale JSON block
end



# Add schema check for update_locale conforming to the D2L update_locale
# JSON data block of form: { "LocaleId" : <D2LID>}.
def valid_locale_id?(locale_id)
  # check if its an integer OR if its a string comprised of only numbers.
  locale_id.is_a?(Numeric) || locale_id.is_a?(String) && !!locale_id.match(/^(\d)+$/)
end

# REVIEW: Update the current user’s locale account settings.
# update_locale = { "LocaleId" : <D2LID>}
def update_current_user_locale_account_settings(locale_id)
  unless valid_locale_id?(locale_id)
    raise ArgumentError, "Variable 'update_locale' is not a "
  end
  payload = {'LocaleId' => locale_id}
  path = "/d2l/api/lp/#{$lp_ver}/accountSettings/mysettings/locale/"
  
  # requires UpdateSettings JSON data block
  # update_locale = { "LocaleId" : <D2LID>}
  _put(path, payload)
end

# REVIEW: Update the locale account settings for a particular user.
# update_locale = { "LocaleId" : <D2LID>}
def update_user_locale_account_settings(user_id, locale_id)
  unless valid_locale_id?(locale_id)
    raise ArgumentError, "Variable 'update_locale' is not a "
  end
  payload = {'LocaleId' => locale_id}
  path = "/d2l/api/lp/#{$lp_ver}/accountSettings/#{user_id}/locale/"
  # requires UpdateSettings JSON data block
  # update_locale = { "LocaleId" : <D2LID>}
  _put(path, payload)
end

########################
# LOCALE:###############
########################
# NOTE: As the locale page only has only 2 functions, these functions are simply
# appended to this, the most relevant file.

# NOTE: UNSTABLE
# optional parameter 'bookmark' for querying with a paging offset
# Retrieve the collection of all known locales.
def get_all_locales(bookmark = '')
  path = "/d2l/api/lp/#{$lp_ver}/locales/"
  path += "?bookmark=#{bookmark}" if bookmark != ''
  _get(path)
  # returns paged result set containing Locale data blocks
end

# NOTE: UNSTABLE
# Retrieve the properties for a particular locale.
def get_locale_properties(locale_id)
  path = "/d2l/api/lp/#{$lp_ver}/locales/#{locale_id}"
  _get(path)
  # returns Locale JSON block
end

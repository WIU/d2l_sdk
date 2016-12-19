require_relative 'requests'
require 'thread'

########################
# USERS:################
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
    #ap payload
    # Define a path referencing the course data using the course_id
    path = "/d2l/api/lp/#{$version}/users/"
    _post(path, payload)
    puts '[+] User creation completed successfully'.green
end

def get_whoami
    path = "/d2l/api/lp/#{$version}/users/whoami"
    _get(path)
end

def get_user_by_username(username)
    path = "/d2l/api/lp/#{$version}/users/?userName=#{username}"
    _get(path)
end

def create_range(min, max)
    (min..max)
end

def does_user_exist(username)
    if get_user_by_username(username) != nil
      return true
    else
      return false
    end
end

def multithreaded_user_search(username_string, num_of_threads)
    # Assumed: there is only up to 50,000 users.
    # Start from 1, go up to max number of users for this search...
    max_users = 60_000
    range_min = 1
    # range max = the upper limit for the search for a thread
    range_max = max_users / num_of_threads + 1
    threads = []
    thread_results = []
    #ap "creating #{num_of_threads} threads..."
    # from 0 up until max number of threads..
    (0...num_of_threads - 1).each do |iteration|
        # setup range limits for the specific thread
        min = range_min + range_max * iteration
        max = range_max + (range_max - 1) * iteration
        range = create_range(min, max)
        # push thread to threads arr and start thread search of specified range.
        threads[iteration] = Thread.new do
            get_user_by_string(username_string, range).each do |match|
                #ap match
                thread_results.push(match)
            end
            #puts "thread #{iteration} ended"

        end
    end
    # Join all of the threads
    threads.each(&:join)
    puts "returning search results for #{username_string}"
    # Return an array of users that exist with the username_string in the username
    thread_results
end

def get_user_by_string(username_string, range)
    # puts "searching from #{range.min.to_s} to #{range.max.to_s}"
    i = range.min
    matching_names = []
    # Average difference between each paged bookmarks beginnings is 109.6
    while i.to_i < range.max
        path = "/d2l/api/lp/#{$version}/users/?bookmark=" + i.to_s
        response = _get(path)
        if response['Items'] == []
            #ap 'response returned zero items, last page possible for this thread..'
            return matching_names
        end
        response['Items'].each do |user|
            matching_names.push(user) if user['UserName'].include? username_string
        end
        i = response['PagingInfo']['Bookmark']
    end
    matching_names
end

def get_user_by_user_id(user_id)
    path = "/d2l/api/lp/#{$version}/users/" + user_id.to_s
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
    _put(path, payload)
    puts '[+] User data updated successfully'.green
end

def delete_user_data(userId)
    # Define a path referencing the user data using the user_id
    path = "/d2l/api/lp/#{$version}/users/" + userId.to_s # setup user path
    _delete(path)
    puts '[+] User data deleted successfully'.green
end

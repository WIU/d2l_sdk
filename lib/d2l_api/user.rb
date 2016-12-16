require_relative "requests"
require "thread"

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
    ap payload
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

def multithreaded_user_search(username_string)
  max_users = 50000
  range_min = 1
  num_of_threads = 50
  range_max = max_users / num_of_threads + 1
  threads = []
  thread_results = []
  ap "creating #{num_of_threads.to_s} threads..."
  (0...num_of_threads - 1).each do |iteration|
    min = range_min + range_max * iteration
    max = range_max + (range_max - 1) * iteration
    range = create_range(min,max)
    threads[iteration] = Thread.new{
      #puts "Starting thread: " + iteration.to_s
      get_user_by_string(username_string, range).each do |match|
        #ap match
        thread_results.push(match)
        #ap thread_results
      end
      #puts "Thread #{iteration.to_s} has completed."
    }
  end
  puts "joining threads..."
  threads.each {|i| i.join}
  puts "returning search results for #{username}"
  thread_results
end
# Theory: multitask/multithread by running multiple searches simultaneously...
# only 50,000 users, so create 10 that search 5,000
# pseudocode:
# for range [1,10]
#Thread.new {search 1-5000} (add 5000 to min and max range, repeat)

#FIX PATHING
# Fix Range usage
def get_user_by_string(username_string, range)
  #puts "searching from #{range.min.to_s} to #{range.max.to_s}"
  i = range.min
  matching_names = []
  #Average difference between each paged bookmarks beginnings is 109.6
  while i.to_i < range.max do
    path = "/d2l/api/lp/#{$version}/users/?bookmark=" + i.to_s
    response = _get(path)
    if response == 404
      ap "response returned a 404, last page possible for this thread.."
      return
    end
    response["Items"].each do |user|
      if user["UserName"].include? username_string
        matching_names.push(user)
        #ap user
        #puts "Found a matching user!!!"
        #ap user
      end
    end
    i = response["PagingInfo"]["Bookmark"]
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

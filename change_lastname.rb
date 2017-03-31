require 'd2l_sdk'

# Setup vars for username and last name
# retrieved via rundeck args passed to this script.
@username = ARGV[0]
@new_lastname = ARGV[1]
@debug = false

# Check that the user exists.
# If the username doesn't exist, then raise.
# Why: You can't change a user's profile that you can't reference.
if !does_user_exist(@username)
        raise ArgumentError, "ARGV[0], '#{@username}', is not a username that exists."
end

# Already asserted that the user exists. Retrieve Hash of the user's profile.
user_profile = get_user_by_username(@username)

# debug code
puts "Old User Data: \n" if @debug
ap user_profile if @debug

# Change the previous d2l user data and create a new json-formatted
# payload. The payload is merged! with a skeleton payload, but it as
# each parameter is defined, this will not affect its usage.
old_lastname = user_profile["LastName"]
user_profile["LastName"] = @new_lastname # update the user's lastname
user_profile["UserName"].sub! old_lastname, @new_lastname # update the user's username
unless user_profile["ExternalEmail"].nil?
  user_profile["ExternalEmail"].sub! old_lastname, @new_lastname # update the user's email
end

# Check if there already is a user created with the +new username+
if does_user_exist(user_profile["UserName"])
        raise RuntimeError, "A user already exists with the new username, '#{user_profile["UserName"]}'."
end

# Pull in data only necessary for user_data in +update+ form.
new_user_data =
{
        'OrgDefinedId' => user_profile["OrgDefinedId"],
        'FirstName' => user_profile["FirstName"],
        'MiddleName' => user_profile["MiddleName"],
        'LastName' => user_profile["LastName"], # Changed previously
        'ExternalEmail' => user_profile["ExternalEmail"],
        'UserName' => user_profile["UserName"],
        'Activation' =>
        {
            'IsActive' => user_profile["Activation"]["IsActive"]
        }
}

# Debug code
puts "New User Data: \n" if @debug
ap new_user_data if @debug

# Finally update the user's UserData
update_user_data(user_profile["UserId"], new_user_data)

# Check if the user was properly created.
if !does_user_exist(user_profile["UserName"])
        raise "The user's last name was unsuccessfully updated."
else
        puts "The username was successfully updated to: '#{user_profile["UserName"]}'."
end

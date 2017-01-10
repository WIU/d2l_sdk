require_relative '../../lib/d2l_api'
require 'test/unit'

class TestUserCreation < Test::Unit::TestCase
    def setup

    end
    def teardown
        # delete created user from test_user_creation
        delete_user_data(get_user_by_username('test-ruby-user123')['UserId'])
    end

    def test_user_creation
        new_data = { 'OrgDefinedId' => 'ruby-test', # String
                     'FirstName' => 'test_user', # String
                     'MiddleName' => 'nil', # String
                     'LastName' => 'test_last_name', # String
                     'ExternalEmail' => 'test-ruby-user@wiu.edu', # String (nil or well-formed email addr)
                     'UserName' => 'test-ruby-user123', # String
                     'RoleId' => 110, # number
                     'IsActive' => true, # bool
                     'SendCreationEmail' => false, # bool
        }
        puts "Checking whether user #{new_data['UserName']} exists"
        if does_user_exist(new_data['UserName'])
            puts 'This user already exists. Please change your current new_data'.red
        else
            create_user_data(new_data)
        end
        assert_equal(true, does_user_exist(new_data['UserName']), 'User created unsuccessfully')
    end
end

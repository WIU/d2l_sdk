require_relative 'lib/d2l_api'
require 'test/unit'

class TestUserDeletion < Test::Unit::TestCase
    # indepentently create a user.
    def setup
        # Create user for delete test
        create_user_data('OrgDefinedId' => 'ruby-test', # String
                         'FirstName' => 'test_user', # String
                         'MiddleName' => 'nil', # String
                         'LastName' => 'test_last_name', # String
                         'ExternalEmail' => nil, # String (nil or well-formed email addr)
                         'UserName' => 'test-ruby-user12356', # String
                         'RoleId' => 110, # number
                         'IsActive' => true, # bool
                         'SendCreationEmail' => false, # bool
                        )
    end

    def teardown
    end



    # Independently create and delete a user
    def test_user_delete
        # Get the user info
        user = get_user_by_username('test-ruby-user12356')
        # Check to see if the returned user was the correct one.
        # Doubles to check whether the returned data exists in a proper form
        assert_equal('test-ruby-user12356', user['UserName'])
        # Delete the user based upon the returned user's id
        ap delete_user_data(user['UserId'])
        # assert if referencing this user, again, causes an error.
        user = get_user_by_username('test-ruby-user12356')
        assert_raise { delete_user_data(user['UserId']) }
    end
end

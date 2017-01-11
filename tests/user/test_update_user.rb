require_relative '../../lib/d2l_sdk'
require 'test/unit'

class TestUserUpdate < Test::Unit::TestCase
    # independently create a user.
    def setup
        # Create user for update test
        create_user_data('OrgDefinedId' => 'ruby-test', # String
                         'FirstName' => 'test_user', # String
                         'MiddleName' => 'nil', # String
                         'LastName' => 'test_last_name', # String
                         'ExternalEmail' => nil, # String (nil or well-formed email addr)
                         'UserName' => 'test-ruby-user1234', # String
                         'RoleId' => 110, # number
                         'IsActive' => true, # bool
                         'SendCreationEmail' => false, # bool
                        )
    end

    def teardown
        # delete created user from setup for test_user_update
        delete_user_data(get_user_by_username('test-ruby-user1234')['UserId'])
    end

    # Independently update an already created user
    def test_user_update
        new_data = {
            'OrgDefinedId' => 'ruby-test',
            'FirstName' => 'Test-User',
            'MiddleName' => 'changed',
            'LastName' => 'Test',
            'ExternalEmail' => nil, # Predefines user data, in the case that
            'UserName' => 'test-ruby-user1234', # there is are variables left out in the JSON
            'Activation' => {
                'IsActive' => true
            }
        }
        user_id = get_user_by_username(new_data['UserName'])['UserId']
        update_user_data(user_id, new_data)
    end
end

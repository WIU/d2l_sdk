require_relative '../lib/d2l_api'
require 'test/unit'
require_relative 'user/test_create_user'
#require_relative 'test_read_user'
require_relative 'user/test_update_user'
require_relative 'user/test_delete_user'

class TestUserCRUD < Test::Unit::TestCase
    # indepentently create a user.
    def setup
    end

    def teardown
    end

    def test_whoami
        assert_equal('api-user', get_whoami['UniqueName'], 'whoami test failed')
    end

    def test_get_user_by_username
        assert_equal('api-user', get_user_by_username('api-user')['UserName'], 'username api-user does not exist')
    end

    def test_get_user_by_string_in_username
        assert_not_nil(multithreaded_user_search("UserName",'api-user', 17), 'multithreaded search for api-user failed')
    end

end

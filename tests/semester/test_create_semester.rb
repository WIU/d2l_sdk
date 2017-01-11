require_relative '../../lib/d2l_sdk'
require 'test/unit'

class TestSemesterCreation < Test::Unit::TestCase
    # independently create a user.
    def setup
        # Create user for update test
    end

    def teardown
        recycle_semester_by_name('Winter 2055 Semester')
    end

    # Independently update an already created user
    def test_create_semester
        response = create_semester_data(
            'Name' => 'Winter 2055 Semester', # String
            'Code' => '205501', # String #YearNUM where NUM{sp:01,
        ) # su:06,fl:08}
        # user_id = get_user_by_username(new_data['UserName'])['UserId']
        # update_user_data(user_id, new_data)
        semester_code = get_semester_by_name('Winter 2055 Semester')[0]['Code']
        assert_equal('205501', semester_code)
    end
end

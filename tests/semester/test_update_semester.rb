require_relative '../../lib/d2l_sdk'
require 'test/unit'

class TestSemesterUpdate < Test::Unit::TestCase
    # independently create a user.
    def setup
      response = create_semester_data(
          'Name' => 'Winter 2098 Semester', # String
          'Code' => '201901', # String #YearNUM where NUM{sp:01,
      )
    end

    def teardown
        recycle_semester_by_name('Winter 2065 Semester')
    end

    # Independently update an already created user
    def test_update_semester
        sample = get_semester_by_name('Winter 2098 Semester')[0]
        response = update_semester_data(sample["Identifier"],
            {'Name' => 'Winter 2065 Semester', # String
            'Code' => '206501', # String #YearNUM where NUM{sp:01,
            'Path' => create_semester_formatted_path(sample["Identifier"], "206501")}
        ) # su:06,fl:08}
        # user_id = get_user_by_username(new_data['UserName'])['UserId']
        # update_user_data(user_id, new_data)
        semester_code = get_semester_by_name('Winter 2065 Semester')[0]['Code']
        assert_equal('206501', semester_code)
    end
end

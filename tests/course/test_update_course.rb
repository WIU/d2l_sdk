require_relative '../../lib/d2l_api'
require 'test/unit'

class TestCourseUpdate < Test::Unit::TestCase
    # independently create a course.
    def setup
        # Create course for update test
        create_course_data(
            'Name' => 'Webdev_test_course1', # String
            'Code' => 'off_209801_123456', # String
            'Path' => '', # String
            'CourseTemplateId' => 23_429, # number: D2L_ID
            'SemesterId' => nil, # number: D2L_ID  | nil
            'StartDate' => Time.parse(DateTime.now.to_s).utc.iso8601, # Time.now.utc.to_s, # String: UTCDateTime | nil
            'EndDate' => (Time.parse(DateTime.now.to_s) + (2 * 7 * 24 * 60 * 60)).utc.iso8601, # (Time.now + (2*7*24*60*60)).utc.to_s, # String: UTCDateTime | nil
            'LocaleId' => 1, # number: D2L_ID | nil
            'ForceLocale' => false, # bool
            'ShowAddressBook' => false # bool
        )
    end

    def teardown
        # recycle_semester_by_name('Winter 2055 Semester')
        get_courses_by_name('Webdev_test').each do |match|
            delete_course_by_id(match['Identifier'])
        end
    end

    # Independently update an already created user
    def test_update_course
        # ap get_all_course_templates
        sample_course = get_courses_by_name('Webdev_test_course1')
        payload = { 'Name' => 'Webdev_test_course2', # String
                    'Code' => 'off_209801_123456', # String
                    'StartDate' => Time.parse(DateTime.now.to_s).utc.iso8601, # String: UTCDateTime | nil
                    'EndDate' => (Time.parse(DateTime.now.to_s) + (2 * 7 * 24 * 60 * 60)).utc.iso8601, # (Time.now + (2*7*24*60*60)).utc.to_s, # String: UTCDateTime | nil
                    'IsActive' => false # bool
                  }
        update_course_data(sample_course[0]["Identifier"].to_s, payload)
        updated_name = get_courses_by_name('Webdev_test_course2')[0]["Name"]
        assert_equal("Webdev_test_course2", updated_name)
    end
end

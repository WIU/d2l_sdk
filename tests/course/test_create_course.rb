require_relative '../../lib/d2l_api'
require 'test/unit'

class TestCourseCreation < Test::Unit::TestCase
    # independently create a user.
    def setup
        # Create user for update test
    end

    def teardown
        #recycle_semester_by_name('Winter 2055 Semester')
        get_courses_by_name("Webdev_test").each do |match|
            delete_course_by_id(match["Identifier"])
        end
    end

    # Independently update an already created user
    def test_create_course
        #ap get_all_course_templates
        response = create_course_data(
                    'Name' => 'Webdev_test_course', # String
                    'Code' => 'off_209801_123456', # String
                    'Path' => '', # String
                    'CourseTemplateId' => 23429, # number: D2L_ID
                    'SemesterId' => nil, # number: D2L_ID  | nil
                    'StartDate' => Time.parse(DateTime.now.to_s).utc.iso8601,#Time.now.utc.to_s, # String: UTCDateTime | nil
                    'EndDate' => (Time.parse(DateTime.now.to_s) + (2*7*24*60*60)).utc.iso8601,#(Time.now + (2*7*24*60*60)).utc.to_s, # String: UTCDateTime | nil
                    'LocaleId' => 1, # number: D2L_ID | nil
                    'ForceLocale' => false, # bool
                    'ShowAddressBook' => false # bool
        )
        course_code = get_courses_by_name('Webdev_test')[0]["Code"]
        assert_equal('off_209801_123456', course_code)
    end
=begin
    Forum: (Why semester cannot be assigned)
    It sounds a lot like your production instance
    doesn't display (or require) an associated Semester
    for a created course, and for that reason, using the
    API to create a course requires you to pass in null
    for a SemesterID
=end
end

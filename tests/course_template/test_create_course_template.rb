require_relative '../../lib/d2l_sdk'
require 'test/unit'

class TestCourseTemplateCreation < Test::Unit::TestCase
    # independently create a user.
    def setup
        # Create user for update test
    end

    def teardown
        get_course_template_by_name("Webdev_test").each do |template|
            delete_course_template(template["Identifier"])
        end
    end

    # Independently update an already created user
    def test_create_course_template
        response = create_course_template(
                    'Name' => 'Webdev_test_course', # String
                    'Code' => 'off_209801_1234567', # String
                    'Path' => '', # String
                    'ParentOrgUnitIds' => [6812] # number:D2LID
        )
        temp_code = get_course_template_by_name('Webdev_test_course')[0]["Code"]
        assert_equal('off_209801_1234567', temp_code)
    end
=begin
    Forum: (Why semester cannot be assigned)
    It sounds a lot like your production instance
    doesn't display (or require) an associated Semester
    for a created course, and for that reason, using the
    sdk to create a course requires you to pass in null
    for a SemesterID
=end
end

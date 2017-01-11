require_relative '../../lib/d2l_sdk'
require 'test/unit'

class TestCourseTemplateUpdate < Test::Unit::TestCase
    # independently create a user.
    def setup
      create_course_template(
                  'Name' => 'Webdev_test_course6', # String
                  'Code' => 'off_209801_1234567', # String
                  'Path' => '', # String
                  'ParentOrgUnitIds' => [6812] # number:D2LID
      )    end

    def teardown
        delete_all_course_templates_with_name("Webdev_test_course7")
    end

    # Independently update an already created user
    def test_update_course_template
        course_template = get_course_template_by_name("Webdev_test_course6")[0]
        response = update_course_template(course_template["Identifier"],
                    {
                    'Name' => 'Webdev_test_course7', # String
                    'Code' => 'off_209801_1234567', # String
                    }
        )
        temp_code = get_course_template_by_name('Webdev_test_course7')[0]["Code"]
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

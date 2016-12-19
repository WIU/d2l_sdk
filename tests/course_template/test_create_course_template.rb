require_relative '../../lib/d2l_api'
require 'test/unit'

class TestCourseTemplateCreation < Test::Unit::TestCase
    # independently create a user.
    def setup
        # Create user for update test
    end

    def teardown
        #recycle_semester_by_name('Winter 2055 Semester')
        ap  get_courses_by_name("Webdev_test")
        get_courses_by_name("Webdev_test").each do |match|
            delete_course_by_id(match["Identifier"])
        end
    end

    # Independently update an already created user
    def test_create_course_template
        #ap get_all_course_templates
        response = create_course_template(
                    'Name' => 'Webdev_test_course', # String
                    'Code' => 'off_209801_1234567', # String
                    'Path' => '', # String
                    'ParentOrgUnitIds' => [6812] # number:D2LID
        )
        course_code = get_course_template_by_name('Webdev_test_course')[0]["Code"]
        assert_equal('off_209801_1234567', course_code)
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

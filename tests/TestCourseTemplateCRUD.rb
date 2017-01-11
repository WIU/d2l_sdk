require_relative '../lib/d2l_sdk'
require 'test/unit'
require_relative 'course_template/test_create_course_template'
require_relative 'course_template/test_update_course_template'
#require_relative 'course/test_delete_course'

class TestCourseTemplateCRUD < Test::Unit::TestCase
    # indepentently create a user.
    def setup
    end

    def teardown
    end

end

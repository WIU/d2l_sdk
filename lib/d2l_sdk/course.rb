require_relative 'requests'
require 'json-schema'

########################
# ACTIONS:##############
########################

# Deletes a course based, referencing it via its org_unit_id
# This reference is created through a formatted path appended with the id.
# Then, a delete http method is executed using this path, deleting the course.
def delete_course_by_id(org_unit_id)
    path = "/d2l/api/lp/#{$lp_ver}/courses/#{org_unit_id}" # setup user path
    #ap path
    _delete(path)
    puts '[+] Course data deleted successfully'.green
end

# retrieve the list of parent org unit type constraints for course offerings
def get_parent_outypes_courses_schema_constraints
  path = "/d2l/api/lp/#{$lp_ver}/courses/schema"
  _get(path)
  # returns a JSON array of SchemaElement blocks
end

# Performs a get request to retrieve a particular course using the org_unit_id
# of this particular course. If the course does not exist, as specified by the
# org_unit_id, the response is typically a 404 error.
#
# returns: JSON object of the course
def get_course_by_id(org_unit_id)
    path = "/d2l/api/lp/#{$lp_ver}/courses/#{org_unit_id}"
    _get(path)
    # returns: JSON object of the course
end


def get_course_image(org_unit_id, width = 0, height = 0)
  path = "/d2l/api/lp/#{lp_ver}/courses/#{org_unit_id}/image"
  if width > 0 && height > 0
    path += "?width=#{width}"
    path += "&height=#{height}"
  end
  _get(path)
end

# Checks whether the created course data conforms to the valence api for the
# course data JSON object. If it does conform, then nothing happens and it
# simply returns true. If it does not conform, then the JSON validator raises
# an exception.
def check_course_data_validity(course_data)
    schema = {
        'type' => 'object',
        'required' => %w(Name Code CourseTemplateId SemesterId
                         StartDate EndDate LocaleId ForceLocale
                         ShowAddressBook),
        'properties' => {
            'Name' => { 'type' => 'string' },
            'Code' => { 'type' => 'string' },
            'CourseTemplateId' => { 'type' => 'integer' },
            'SemesterId' => { 'type' => %w(integer null) },
            'StartDate' => { 'type' => %w(string null) },
            'EndDate' => { 'type' => %w(string null) },
            'LocaleId' => { 'type' => %w(integer null) },
            'ForceLocale' => { 'type' => 'boolean' },
            'ShowAddressBook' => { 'type' => 'boolean' }
        }
    }
    JSON::Validator.validate!(schema, course_data, validate_schema: true)
end


# Creates the course based upon a merged result of the argument course_data
# and a preformatted payload. This is then passed as a new payload in the
# +_post+ method in order to create the defined course.
# Required: "Name", "Code"
# Creates the course offering
def create_course_data(course_data)
    # ForceLocale- course override the user’s locale preference
    # Path- root path to use for this course offering’s course content
    #       if your back-end service has path enforcement set on for
    #       new org units, leave this property as an empty string
    # Define a valid, empty payload and merge! with the user_data. Print it.
    # can be an issue if more than one course template associated with
    # a course and the last course template parent to a course cannot be deleted
    payload = { 'Name' => '', # String
                'Code' => 'off_SEMESTERCODE_STARNUM', # String
                'Path' => '', # String
                'CourseTemplateId' => 99_989, # number: D2L_ID
                'SemesterId' => nil, # number: D2L_ID  | nil
                'StartDate' => nil, # String: UTCDateTime | nil
                'EndDate' => nil, # String: UTCDateTime | nil
                'LocaleId' => nil, # number: D2L_ID | nil
                'ForceLocale' => false, # bool
                'ShowAddressBook' => false # bool
              }.merge!(course_data)
    check_course_data_validity(payload)
    # ap payload
    # requires: CreateCourseOffering JSON block
    path = "/d2l/api/lp/#{$lp_ver}/courses/"
    _post(path, payload)
    #puts '[+] Course creation completed successfully'.green
end

# Checks whether the updated course data conforms to the valence api for the
# update data JSON object. If it does conform, then nothing happens and it
# simply returns true. If it does not conform, then the JSON validator raises
# an exception.
def check_updated_course_data_validity(course_data)
    schema = {
        'type' => 'object',
        'required' => %w(Name Code StartDate EndDate IsActive),
        'properties' => {
            'Name' => { 'type' => 'string' },
            'Code' => { 'type' => 'string' },
            'StartDate' => { 'type' => ['string', "null"] },
            'EndDate' => { 'type' => ['string', "null"] },
            'IsActive' => { 'type' => "boolean" },
        }
    }
    JSON::Validator.validate!(schema, course_data, validate_schema: true)
end

# Update the course based upon the first argument. This course object is first
# referenced via the first argument and its data formatted via merging it with
# a predefined payload. Then, a PUT http method is executed using the new
# payload.
# Utilize the second argument and perform a PUT action to replace the old data
def update_course_data(course_id, new_data)
    # Define a valid, empty payload and merge! with the new data.
    payload = { 'Name' => '', # String
                'Code' => 'off_SEMESTERCODE_STARNUM', # String
                'StartDate' => nil, # String: UTCDateTime | nil
                'EndDate' => nil, # String: UTCDateTime | nil
                'IsActive' => false # bool
              }.merge!(new_data)
    check_updated_course_data_validity(payload)
    # ap payload
    # Define a path referencing the courses path
    path = "/d2l/api/lp/#{$lp_ver}/courses/" + course_id.to_s
    _put(path, payload)
    # requires: CourseOfferingInfo JSON block
    puts '[+] Course update completed successfully'.green
    # Define a path referencing the course data using the course_id
    # Perform the put action that replaces the old data
    # Provide feedback that the update was successful
end

# REVIEW: Update the course image for a course offering.
def update_course_image(org_unit_id, image_file)
  path = "/d2l/api/lp/#{$lp_ver}/courses/#{org_unit_id}/image"
  # TODO: (SCHEMA) Make sure file isnt > 2MB
  # TODO: (SCHEMA) Make sure its a native web browser image fmt (e.g. JPEG, GIF, or PNG)
  _image_upload(path, image_file, "PUT")
  # PUT /d2l/api/lp/(version)/courses/(orgUnitId)/image
end

########################
# COURSE TEMPLATES:#####
########################
# NOTE: Course template related functions are now in 'course_template.rb'

########################
# COPYING COURSES:######
########################

def get_copy_job_request_status(org_unit_id, job_token)
    path = "/d2l/api/le/#{le_ver}/import/#{org_unit_id}/copy/#{job_token}"
    _get(path)
    # returns GetCopyJobResponse JSON block
    # GetImportJobResponse:
    # {"JobToken" => <string:COPYJOBSTATUS_T>,
    #  "TargetOrgUnitID" => <number:D2LID>,
    #  "Status" => <string:IMPORTJOBTSTATUS_T>}
    # States of getImport: UPLOADING, PROCESSING, PROCESSED, IMPORTING,
    #                      IMPORTFAILED, COMPLETED
end

def check_create_copy_job_request_validity(create_copy_job_request)
    schema = {
        'type' => 'object',
        'required' => %w(SourceOrgUnitId Components CallbackUrl),
        'properties' => {
            'SourceOrgUnitId' => { 'type' => 'integer' },
            'Components' => {
                'type' => ['array', "null"],
                'items' =>
                  {
                      'type' => "string"
                  }
            },
            'CallbackUrl' => { 'type' => ['string', 'null'] }
        }
    }
    JSON::Validator.validate!(schema, create_copy_job_request, validate_schema: true)
end

# simple schema check to assure the course component is an actual course component
# returns: boolean
def is_course_component(key)
  valid_components = %w(AttendanceRegisters Glossary News Checklists
                        Grades QuestionLibrary Competencies GradesSettings
                        Quizzes Content Groups ReleaseConditions CourseFiles
                        Homepages Rubrics Discussions IntelligentAgents
                        Schedule DisplaySettings Links SelfAssessments
                        Dropbox LtiLink Surveys Faq LtiTP ToolNames Forms
                        Navbars Widgets)
  valid_components.include?(key)
  # returns whether the key is actually a course component
end

def create_new_copy_job_request(org_unit_id, create_copy_job_request)
  payload =
  {
    'SourceOrgUnitId' => 0, # int
    'Components' => nil, # [Str,...] || nil
    'CallbackUrl' => nil # str | nil
  }.merge!(create_copy_job_request)
  # Check that the payload conforms to the JSON Schema of CreateCopyJobRequest
  check_create_copy_job_request_validity(payload)
  # Check each one of the components to see if they are valid Component types
  payload["Components"].each do |component|
    # If one of the components is not valid, cancel the CopyJobRequest operation
    if(!is_course_component(key))
      puts "'#{component}' specified is not a valid Copy Job Request component"
      puts "Please retry with a valid course component such as 'Dropbox' or 'Grades'"
      break
    end
  end
  path = "/d2l/api/le/#{$le_ver}/import/#{org_unit_id}/copy/"
  _post(path, payload)
  # Returns CreateCopyJobResponse JSON block
end

# NOTE: UNSTABLE!!!!
# TODO: --UNSTABLE-- Retrieve the list of logs for course copy jobs.
# Query Params:
# --OPTIONAL--
# -bookmark : string
# -page_size : number
# -source_org_unit_id : number
# -destination_org_unit_id : number
# -start_date : UTCDateTime
# -end_date : UTCDateTime
# RETURNS: An object list page containing the resulting CopyCourseLogMessage data blocks
def get_copy_jobs_logs(bookmark = '', page_size = 0, source_org_unit_id = 0,
                       destination_org_unit_id = 0, start_date = '', end_date = '')
  # GET /d2l/api/le/(version)/ccb/logs
end

########################
# IMPORTING COURSES:####
########################

def get_course_import_job_request_status(org_unit_id, job_token)
  path = "/d2l/api/le/#{le_ver}/import/#{org_unit_id}/imports/#{job_token}"
  _get(path)
  # returns GetImportJobResponse JSON block
  # example:
  # {"JobToken" => <string:COPYJOBSTATUS_T>}
  # States: PENDING, PROCESSING, COMPLETE, FAILED, CANCELLED
end

def get_course_import_job_request_logs(org_unit_id, job_token, bookmark = '')
  path = "/d2l/api/le/#{le_ver}/import/#{org_unit_id}/imports/#{job_token}/logs"
  path += "?bookmark=#{bookmark}" if bookmark != ''
  _get(path)
  # returns PAGED RESULT of ImportCourseLog JSON blocks following bookmark param
end

# REVIEW: Create a new course import job request.
# INPUT: simple file upload process -- using "course package" as the uploaded file
def create_course_import_request(org_unit_id, callback_url = '', file)
    path = "/d2l/le/#{le_ver}/import/#{org_unit_id}/imports/"
    path += "?callbackUrl=#{callback_url}" if callback_url != ''
    # TODO: (SCHEMA) Find out WTH a 'course package' entails as far as standards.
    _course_package_upload(path, file, "POST")
    # RETURNS: Parsed CreateImportJobResponse JSON block.
end

################################################################################
################################################################################


###########################
# ADDITIONAL FUNCTIONS:####
###########################


# In order to retrieve an entire department's class list, this method uses a
# predefined org_unit identifier. This identifier is then appended to a path
# and all classes withiin the department are returned as JSON objects in an arr.
#
# returns: JSON array of classes.
def get_org_department_classes(org_unit_id)
    path = "/d2l/api/lp/#{$lp_ver}/orgstructure/#{org_unit_id}"
    _get(path)
    # returns: JSON array of classes.
end



def get_all_courses
    path = "/d2l/api/lp/#{$lp_ver}/orgstructure/6606/descendants/?ouTypeId=3"
    _get(path)
end

# much slower means of getting courses if less than 100 courses
def get_courses_by_code(org_unit_code)
  all_courses = get_all_courses
  courses = []
  all_courses.each do |course|
    courses.push(course) if course["Code"].downcase.include? "#{org_unit_code}".downcase
  end
  courses
end
# Retrieves all courses that have a particular string (org_unit_name) within
# their names. This is done by first defining that none are found yet and then
# searching through all course  for ones that do have a particular string within
# their name, the matches are pushed into the previously empty array of matches.
# This array is subsequently returned; if none were found, a message is returned
#
# returns: JSON array of matching course  data objects
def get_courses_by_name(org_unit_name)
    get_courses_by_property_by_string('Name', org_unit_name)
end

# Retrieves all matching courses that are found using a property and a search
# string. First, it is considered that the class is not found. Then, all courses
# are retrieved and stored as a JSON array in the varaible +results+. After this
# each of the +results+ is iterated, downcased, and checked for their matching
# of the particular search string. If there is a match, they are pushed to
# an array called +courses_results+. This is returned at the end of this op.
#
# returns: array of JSON course objects (that match the search string/property)
def get_courses_by_property_by_string(property, search_string)
    puts "[+] Searching for courses using search string: #{search_string}".yellow +
         + " -- And property: #{property}"
    courses_results = []
    results = get_all_courses
    results.each do |x|
        if x[property].downcase.include? search_string.downcase
            courses_results.push(x)
        end
    end
    courses_results
    # returns array of all matching courses in JSON format.
end

# Retrieves all courses that have the specified prop match a regular expression.
# This is done by iterating through all courses and returning an array of all
# that match a regular expression.
#
# returns: array of JSON course objects (with property that matches regex)
def get_courses_by_property_by_regex(property, regex)
    puts "[+] Searching for courses using regex: #{regex}".yellow +
         + " -- And property: #{property}"
    courses_results = []
    results = get_all_courses
    results.each do |x|
        courses_results.push(x) if (x[property] =~ regex) != nil
    end
    courses_results
    # returns array of all matching courses in JSON format.
end

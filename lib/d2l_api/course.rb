require_relative 'requests'
########################
# COURSES:##############
########################

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
    #ap payload
    path = "/d2l/api/lp/#{$version}/courses/"
    _post(path, payload)
    puts '[+] Course creation completed successfully'.green
end

# In order to retrieve an entire department's class list, this method uses a
# predefined org_unit identifier. This identifier is then appended to a path
# and all classes withiin the department are returned as JSON objects in an arr.
#
# returns: JSON array of classes.
def get_org_department_classes(org_unit)
    path = "/d2l/api/lp/#{$version}/orgstructure/" + org_unit
    _get(path)
end

# Retrieves all courses that have a particular string (org_unit_name) within
# their names. This is done by first defining that none are found yet and then
# searching through all course  for ones that do have a particular string within
# their name, the matches are pushed into the previously empty array of matches.
# This array is subsequently returned; if none were found, a message is returned
#
# returns: JSON array of matching course  data objects
def get_courses_by_name(org_unit_name)
    class_not_found = true
    puts '[+] Searching for courses using search string: '.yellow + org_unit_name
    courses_results = []
    path = "/d2l/api/lp/#{$version}/orgstructure/6606/descendants/?ouTypeId=3"
    results = _get(path)
    results.each do |x|
        if x['Name'].downcase.include? org_unit_name.downcase
            class_not_found = false
            courses_results.push(x)
        end
    end
    if class_not_found
        puts '[-] No courses could be found based upon the search string.'.yellow
    end
    courses_results
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
    #ap payload
    # Define a path referencing the courses path
    path = "/d2l/api/lp/#{$version}/courses/" + course_id.to_s
    _put(path, payload)
    puts '[+] Course update completed successfully'.green
    # Define a path referencing the course data using the course_id
    # Perform the put action that replaces the old data
    # Provide feedback that the update was successful
end

# Deletes a course based, referencing it via its org_unit_id
# This reference is created through a formatted path appended with the id.
# Then, a delete http method is executed using this path, deleting the course.
def delete_course_by_id(org_unit_id)
    path = "/d2l/api/lp/#{$version}/courses/#{org_unit_id}" # setup user path
    ap path
    _delete(path)
    puts '[+] Course data deleted successfully'.green
end

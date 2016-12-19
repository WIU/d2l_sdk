require_relative 'requests'
########################
# COURSES:##############
########################
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

def get_org_department_classes(org_unit)
    path = "/d2l/api/lp/#{$version}/orgstructure/" + org_unit
    _get(path)
end

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
# Update the course based upon the first argument
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
def delete_course_by_id(org_unit_id)
    path = "/d2l/api/lp/#{$version}/courses/#{org_unit_id}" # setup user path
    ap path
    _delete(path)
    puts '[+] Course data deleted successfully'.green
end

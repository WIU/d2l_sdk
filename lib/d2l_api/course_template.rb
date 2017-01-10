require_relative 'requests'
require 'json-schema'
########################
# COURSE TEMPLATES:#####
########################

# Checks if the created course template data conforms to the valence api for the
# course template JSON object. If it does conform, then nothing happens and it
# simply returns true. If it does not conform, then the JSON validator raises
# an exception.
def check_course_template_data_validity(course_template_data)
    schema = {
        'type' => 'object',
        'required' => %w(Name Code Path ParentOrgUnitIds),
        'properties' => {
            'Name' => { 'type' => 'string' },
            'Code' => { 'type' => 'string' },
            'Path' => { 'type' => 'string' },
            'ParentOrgUnitIds' => { 'type' => 'array',
                                    'items' => { 'type' => 'integer', 'minItems' => 1 }
                         }
        }
    }
    JSON::Validator.validate!(schema, course_template_data, validate_schema: true)
end

# This method creates a course template using a merged payload between a
# pre-formatted payload and the argument "course_template_data". Upon this merge
# the path is defined for the POST http method that is then executed to create
# the course_template object.
# Required: "Name", "Code"
# /d2l/api/lp/(version)/coursetemplates/ [POST]
def create_course_template(course_template_data)
    # ForceLocale- course override the user’s locale preference
    # Path- root path to use for this course offering’s course content
    #       if your back-end service has path enforcement set on for
    #       new org units, leave this property as an empty string
    # Define a valid, empty payload and merge! with the user_data. Print it.
    payload = { 'Name' => '', # String
                'Code' => 'off_SEMESTERCODE_STARNUM', # String
                'Path' => '', # String
                'ParentOrgUnitIds' => [99_989], # number: D2L_ID
              }.merge!(course_template_data)
    check_course_template_data_validity(payload)
    puts 'Creating Course Template:'
    ap payload
    # Define a path referencing the courses path
    # requires: CreateCourseTemplate JSON block
    path = "/d2l/api/lp/#{$version}/coursetemplates/"
    _post(path, payload)
    puts '[+] Course template creation completed successfully'.green
    # returns: CourseTemplate JSON block containing the new data.
end

# Retrieves a course template based upon an explicitly defined course template
# org_unit_id or Identifier. This is done by using the identifier as a component
# of the path, and then performing a GET http method that is then returned.
#
# returns: JSON course template data
# /d2l/api/lp/(version)/coursetemplates/(orgUnitId) [GET]
def get_course_template(org_unit_id)
    path = "/d2l/api/lp/#{$version}/coursetemplates/#{org_unit_id}"
    _get(path)
end

# Instead of explicitly retrieving a single course template, this method uses
# the routing table to retrieve all of the organizations descendants with the
# outTypeId of 2. What this means is that it is literally retrieving any and all
# course templates that have an ancestor of the organization...which should be
# all of them.
#
# returns: JSON array of course template data objects
def get_all_course_templates
    path = "/d2l/api/lp/#{$version}/orgstructure/6606/descendants/?ouTypeId=2"
    _get(path)
end

# This method retrieves all course templates that have a specific string, as
# specified by org_unit_name, within their names. This is done by first defining
# that none are found yet and initializing an empty array. Then, by searching
# through all course templates for ones that do have a particular string within
# their name, the matches are pushed into the previously empty array of matches.
# This array is subsequently returned; if none were found, a message is returned
#
# returns: JSON array of matching course template data objects
def get_course_template_by_name(org_unit_name)
    course_template_not_found = true
    course_template_results = []
    puts "[+] Searching for templates using search string: \'#{org_unit_name}\'".yellow
    results = get_all_course_templates
    results.each do |x|
        if x['Name'].downcase.include? org_unit_name.downcase
            course_template_not_found = false
            course_template_results.push(x)
        end
    end
    if course_template_not_found
        puts '[-] No templates could be found based upon the search string.'.yellow
    end
    course_template_results
end

# Moreso a helper method, but this really just returns the schema of the
# course templates. This is predefined in the routing table, and retrieved via
# a GET http method.
#
# returns: JSON of course templates schema
# /d2l/api/lp/(version)/coursetemplates/schema [GET]
def get_course_templates_schema
    path = "/d2l/api/lp/#{$version}/coursetemplates/schema"
    _get(path)
    # This action returns a JSON array of SchemaElement blocks.
end

# Checks if the updated course template data conforms to the valence api for the
# course template JSON object. If it does conform, then nothing happens and it
# simply returns true. If it does not conform, then the JSON validator raises
# an exception.
def check_course_template_updated_data_validity(course_template_data)
    schema = {
        'type' => 'object',
        'required' => %w(Name Code),
        'properties' => {
            'Name' => { 'type' => 'string' },
            'Code' => { 'type' => 'string' }
        }
    }
    JSON::Validator.validate!(schema, course_template_data, validate_schema: true)
end

# This is the primary method utilized to update course templates. As only the
# Name and the Code can be changed in an update, they are pre-defined to
# conform to the required update data. The update is then performed via a
# PUT http method that is executed using a path referencing the course template.
# /d2l/api/lp/(version)/coursetemplates/(orgUnitId) [PUT]
def update_course_template(org_unit_id, new_data)
    # Define a valid, empty payload and merge! with the new data.
    payload = { 'Name' => '', # String
                'Code' => 'off_SEMESTERCODE_STARNUM', # String
              }.merge!(new_data)
    puts "Updating course template #{org_unit_id}"
    check_course_template_updated_data_validity(payload)
    # ap payload
    # requires: CourseTemplateInfo JSON block
    # Define a path referencing the courses path
    path = "/d2l/api/lp/#{$version}/coursetemplates/" + org_unit_id.to_s
    _put(path, payload)
    puts '[+] Course template update completed successfully'.green
end

# Simply, a course template can be deleted by refencing it using its Identifier
# as an argument for this method. The argument is then used to refernce the obj
# by a path and then the path is passed in for a delete http method.
# /d2l/api/lp/(version)/coursetemplates/(orgUnitId) [DELETE]
def delete_course_template(org_unit_id)
    path = "/d2l/api/lp/#{$version}/coursetemplates/#{org_unit_id}"
    _delete(path)
    puts '[+] Course template data deleted successfully'.green
end

# As a more streamlined approach to deleting many course templates conforming to
# a particular naming style, this function performs deletions based on a string.
# Using the name argument, +get_course_template_by_name+ is called in order to
# retrieve all matching templates. They are then deleted by referencing each
# of their Identifiers as arguments for +delete_course_template+.
def delete_all_course_templates_with_name(name)
    puts "[!] Deleting all course templates with the name: #{name}"
    get_course_template_by_name(name).each do |course_template|
        puts '[!] Deleting the following course:'.red
        ap course_template
        delete_course_template(course_template['Identifier'])
    end
end

# TO DO:
def delete_course_templates_by_regex(regex)
end

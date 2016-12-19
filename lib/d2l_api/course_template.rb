require_relative 'requests'
########################
# COURSE TEMPLATES:#####
########################
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
    puts "Creating Course Template:"
    ap payload
    # Define a path referencing the courses path
    path = "/d2l/api/lp/#{$version}/coursetemplates/"
    _post(path, payload)
    puts '[+] Course template creation completed successfully'.green
end

# /d2l/api/lp/(version)/coursetemplates/(orgUnitId) [GET]
def get_course_template(org_unit_id)
    path = "/d2l/api/lp/#{$version}/coursetemplates/" + org_unit_id.to_s
    _get(path)
end

def get_all_course_templates
  path = "/d2l/api/lp/#{$version}/orgstructure/6606/descendants/?ouTypeId=2"
  _get(path)
end

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

# /d2l/api/lp/(version)/coursetemplates/schema [GET]
def get_course_templates_schema
    path = "/d2l/api/lp/#{$version}/coursetemplates/schema"
    _get(path)
end

# /d2l/api/lp/(version)/coursetemplates/(orgUnitId) [PUT]
def update_course_template(org_unit_id, new_data)
    # Define a valid, empty payload and merge! with the new data.
    payload = { 'Name' => '', # String
                'Code' => 'off_SEMESTERCODE_STARNUM', # String
              }.merge!(new_data)
    puts "Updating course template #{org_unit_id}"
    ap payload
    # Define a path referencing the courses path
    path = "/d2l/api/lp/#{$version}/coursetemplates/" + org_unit_id.to_s
    _put(path, payload)
    puts '[+] Course template update completed successfully'.green
end

# /d2l/api/lp/(version)/coursetemplates/(orgUnitId) [DELETE]
def delete_course_template(org_unit_id)
    path = "/d2l/api/lp/#{$version}/coursetemplates/" + org_unit_id.to_s
    _delete(path)
    puts '[+] Course template data deleted successfully'.green
end

def delete_all_course_templates_with_name(name)
  puts "[!] Deleting all course templates with the name: #{name}"
  get_course_template_by_name(name).each do |course_template|
    puts "[!] Deleting the following course:".red
    ap course_template
    delete_course_template(course_template["Identifier"])
  end
end

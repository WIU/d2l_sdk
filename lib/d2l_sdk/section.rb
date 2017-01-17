require_relative 'requests'
require 'json-schema'
require_relative "org_unit"
########################
# SECTIONS:#############
########################

# Delete a section from a provided org unit.
def delete_section(org_unit_id, section_id)
  path = "/d2l/api/lp/#{$lp_ver}/#{org_unit_id}/sections/#{section_id}"
  _delete(path)
end

##########
# WesternOnline Specific GET Section ID by Code
##########
def create_semester_code(star_num, course_date)
    "sec_#{course_date}_#{star_num}"
end

def get_section_by_section_code(code)
  _get("/d2l/api/lp/1.4/orgstructure/?orgUnitCode=#{code}")["Items"][0]
end

def get_section_id_by_section_code(code)
  get_section_by_section_code(code)["Identifier"]
end

def get_section_data_by_code(code)
    sect_id = get_section_by_section_code(code)["Identifier"]
    parent_id = get_org_unit_parents(sect_id)[0]["Identifier"]
    get_section_data(parent_id, sect_id)
end
=begin
def get_section_by_offering_code(code)
  section_data = 0
  parent_course = nil
  courses = get_courses_by_code(code)
  if courses.size > 1 # If the course code matches two codes..should be CL then
    courses.each do |course| # iterate through each course...should be < 3
      if course["Code"].include? "cl_off"
        parent_course = course
      end
    end
    # ELSE IF no course with "cl_off" found: Not properly cross listed
    if parent_course == nil
      puts "More than two courses with same code index; No proper crosslisting"
    end
  end
  # get all sections of the course offering
  sections = get_org_unit_sections(parent_course["Identifier"])
  sections.each do |sect|
    if sect["Code"].include? code[-5..-1]
      section_data = sect
    end
  end
  return section_data
end

def get_section_id_by_section_code(code)
  get_section_data_by_code(code)["SectionId"]
end
=end
############
############
# Retrieve all the sections for a provided org unit.
def get_org_unit_sections(org_unit_id)
  path = "/d2l/api/lp/#{$lp_ver}/#{org_unit_id}/sections/"
  _get(path)
    # returns a JSON array of SectionData blocks in the Fetch form
end

# Retrieve the section property data for an org unit.
def get_org_unit_section_property_data(org_unit_id)
  path = "/d2l/api/lp/#{$lp_ver}/#{org_unit_id}/sections/settings"
  _get(path)
    # returns a SectionPropertyData JSON block in the Fetch form.
end

# Retrieve a section from a particular org unit.
def get_section_data(org_unit_id, section_id)
  path = "/d2l/api/lp/#{$lp_ver}/#{org_unit_id}/sections/#{section_id}"
  _get(path)
    # returns a SectionData JSON block in the Fetch form.
end

# Check the validity of the SectionData that is passed as a payload
def check_section_data_validity(section_data)
    schema = {
        'type' => 'object',
        'required' => %w(Name Code Description),
        'properties' => {
            'Name' => { 'type' => 'string' },
            'Code' => { 'type' => 'string' },
            'Description' =>
            {
                'type' => 'object',
                'properties' =>
                {
                    'Content' => 'string',
                    'Type' => 'string'
                }
            }
        }
    }
    JSON::Validator.validate!(schema, section_data, validate_schema: true)
end

# Create a new section in a particular org unit.
def create_org_unit_section(org_unit_id, section_data)
  payload = { 'Name' => '', # String
              'Code' => '', # String
              'Description' => {}, # RichTextInput -- e.g. {'Content'=>'x', 'Type'=>'y'}
            }.merge!(section_data)
  # Check the validity of the SectionData that is passed as a payload
  check_section_data_validity(payload)
  path = "/d2l/api/lp/#{$lp_ver}/#{org_unit_id}/sections/"
  # JSON param: SectionData
  _post(path, payload)
    # returns the SectionData JSON block, in its Fetch form, for the
    # org unit's new section.
end

# Check the validity of the SectionEnrollment that is passed as a payload
def check_section_enrollment_validity(section_enrollment)
    schema = {
        'type' => 'object',
        'required' => %w(UserId),
        'properties' => {
            'UserId' => { 'type' => 'integer' }
        }
    }
    JSON::Validator.validate!(schema, section_enrollment, validate_schema: true)
end

# Enroll a user in a section for a particular org unit.
def enroll_user_in_org_unit_section(org_unit_id,section_id, section_data)
  payload = { 'UserId' => 9999, # Number : D2LID
            }.merge!(section_data)
  # Check the validity of the SectionEnrollment that is passed as a payload
  check_section_enrollment_validity(payload)
  path = "/d2l/api/lp/#{$lp_ver}/#{org_unit_id}/sections/#{section_id}/enrollments/"
  # JSON param: SectionEnrollment
  _post(path, payload)
end

# Check the validity of the SectionPropertyData that is passed as a payload
def check_section_property_data_validity(section_property_data)
    schema = {
        'type' => 'object',
        'required' => %w(Name Code Description),
        'properties' => {
            'EnrollmentStyle' => { 'type' => 'integer' },
            'EnrollmentQuantity' => { 'type' => 'integer' },
            'AutoEnroll' => { 'type' => 'boolean' },
            'RandomizeEnrollments' => { 'type' => 'boolean' }
        }
    }
    JSON::Validator.validate!(schema, section_property_data, validate_schema: true)
end

# Initialize one or more sections for a particular org unit.
def initialize_org_unit_sections(org_unit_id, section_property_data)
    payload = {
        'EnrollmentStyle' => 0,
        'EnrollmentQuantity' => 0,
        'AutoEnroll' => false,
        'RandomizeEnrollments' => false
    }.merge!(section_property_data)
    # Check the validity of the SectionPropertyData that is passed as a payload
    check_section_property_data_validity(payload)
    path = "/d2l/api/lp/#{$lp_ver}/#{org_unit_id}/sections/"
    # JSON param: SectionPropertyData
    _put(path, payload)
    # returns a JSON array of SectionData data blocks, in the Fetch
    # form, for the org unit’s initial section(s)
end

# Update the section properties for an org unit.
def update_org_unit_section_properties(org_unit_id, section_property_data)
    payload = {
        'EnrollmentStyle' => 0,
        'EnrollmentQuantity' => 0,
        'AutoEnroll' => false,
        'RandomizeEnrollments' => false
    }.merge!(section_property_data)
    # Check the validity of the SectionPropertyData that is passed as a payload
    check_section_property_data_validity(payload)
    path = "/d2l/api/lp/#{$lp_ver}/#{org_unit_id}/sections/settings"
    # JSON param: SectionPropertyData
    _put(path, payload)
    # returns the SectionPropertyData JSON block, in its Fetch form,
    # for the org unit’s updated section properties.
end

def update_org_unit_section_info(org_unit_id, section_id, section_data)
    payload = { 'Name' => '', # String
                'Code' => '', # String
                'Description' => {}, # RichTextInput -- e.g. {'Content'=>'x', 'Type'=>'y'}
              }.merge!(section_data)
    # Check the validity of the SectionData that is passed as a payload
    check_section_data_validity(payload)
    path = "/d2l/api/lp/#{$lp_ver}/#{org_unit_id}/sections/section_id"
    # JSON param: SectionData
    _put(path, payload)
    # returns the SectionData JSON block, in its Fetch form
end

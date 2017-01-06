require_relative 'requests'
require 'json-schema'
########################
# SECTIONS:##############
########################

# Delete a section from a provided org unit.
def delete_section(org_unit_id, section_id)
  path = "/d2l/api/lp/#{$version}/#{org_unit_id}/sections/#{section_id}"
  _delete(path)
end

# Retrieve all the sections for a provided org unit.
def get_org_unit_sections(org_unit_id)
  path = "/d2l/api/lp/#{$version}/#{org_unit_id}/sections/"
  _get(path)
    # returns a JSON array of SectionData blocks in the Fetch form
end

# Retrieve the section property data for an org unit.
def get_org_unit_section_property_data(org_unit_id)
  path = "/d2l/api/lp/#{$version}/#{org_unit_id}/sections/settings"
  _get(path)
    # returns a SectionPropertyData JSON block in the Fetch form.
end

# Retrieve a section from a particular org unit.
def get_section_data(org_unit_id, section_id)
  path = "/d2l/api/lp/#{$version}/#{org_unit_id}/sections/#{section_id}"
  _get(path)
    # returns a SectionData JSON block in the Fetch form.
end

# Check the validity of the SectionData that is passed as a payload
def check_section_data_validity(course_data)
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
    JSON::Validator.validate!(schema, course_data, validate_schema: true)
end

# Create a new section in a particular org unit.
def create_org_unit_section(org_unit_id, section_data)
  payload = { 'Name' => '', # String
              'Code' => '', # String
              'Description' => {}, # RichTextInput -- e.g. {'Content'=>'x', 'Type'=>'y'}
            }.merge!(section_data)
  # Check the validity of the SectionData that is passed as a payload
  check_section_data_validity(payload)
  path = "/d2l/api/lp/#{$version}/#{org_unit_id}/sections/"
  # JSON param: SectionData
  _post(path, payload)
    # returns the SectionData JSON block, in its Fetch form, for the
    # org unit's new section.
end

# Check the validity of the SectionEnrollment that is passed as a payload
def check_section_enrollment_validity(course_data)
    schema = {
        'type' => 'object',
        'required' => %w(UserId),
        'properties' => {
            'UserId' => { 'type' => 'integer' }
        }
    }
    JSON::Validator.validate!(schema, course_data, validate_schema: true)
end

# Enroll a user in a section for a particular org unit.
def enroll_user_in_org_unit_section(org_unit_id,section_id, section_data)
  payload = { 'UserId' => 9999, # Number : D2LID
            }.merge!(section_data)
  # Check the validity of the SectionEnrollment that is passed as a payload
  check_section_enrollment_validity(payload)
  path = "/d2l/api/lp/#{$version}/#{org_unit_id}/sections/#{section_id}/enrollments/"
  # JSON param: SectionEnrollment
  _post(path, payload)
end

# Check the validity of the SectionPropertyData that is passed as a payload
def check_section_property_data_validity(course_data)
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
    JSON::Validator.validate!(schema, course_data, validate_schema: true)
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
    path = "/d2l/api/lp/#{$version}/#{org_unit_id}/sections/"
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
    path = "/d2l/api/lp/#{$version}/#{org_unit_id}/sections/settings"
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
    path = "/d2l/api/lp/#{$version}/#{org_unit_id}/sections/section_id"
    # JSON param: SectionData
    _put(path, payload)
    # returns the SectionData JSON block, in its Fetch form
end

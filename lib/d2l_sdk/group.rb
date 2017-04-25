require_relative 'requests'
require 'json-schema'
####################################
# Groups/Group Categories:##########
####################################

# Delete a particular group category from an org unit.
def delete_group_category(org_unit_id, group_category_id)
   path = "/d2l/api/lp/#{$lp_ver}/#{org_unit_id}/groupcategories/#{group_category_id}"
   _delete(path)
end

# Delete a particular group from an org unit.
def delete_group(org_unit_id, group_category_id, group_id)
  path = "/d2l/api/lp/#{$lp_ver}/#{org_unit_id}/groupcategories/#{group_category_id}/groups/#{group_id}"
  _delete(path)
end

# Remove a particular user from a group.
def remove_user_from_group(org_unit_id, group_category_id, group_id, user_id)
  path = "/d2l/api/lp/#{$lp_ver}/#{org_unit_id}/groupcategories/#{group_category_id}/groups/#{group_id}/enrollments/#{user_id}"
  _delete(path)
end

# Retrieve a list of all the group categories for the provided org unit.
def get_all_org_unit_group_categories(org_unit_id)
  path = "/d2l/api/lp/#{$lp_ver}/#{org_unit_id}/groupcategories/"
  _get(path)
end

# Retrieve a particular group category for an org unit.
def get_org_unit_group_category(org_unit_id, group_category_id)
  path = "/d2l/api/lp/#{$lp_ver}/#{org_unit_id}/groupcategories/#{group_category_id}"
  _get(path)
end

# Retrieve a list of all the groups in a specific group category for an OrgUnit
def get_all_group_category_groups(org_unit_id, group_category_id)
  path = "/d2l/api/lp/#{$lp_ver}/#{org_unit_id}/groupcategories/#{group_category_id}/groups/"
  _get(path)
end

# Retrieve a particular group in an org unit.
def get_org_unit_group(org_unit_id, group_category_id, group_id)
  path = "/d2l/api/lp/#{$lp_ver}/#{org_unit_id}/groupcategories/#{group_category_id}/groups/#{group_id}"
  _get(path)
end

######
######

def validate_create_group_category_data(group_category_data)
  schema = {
      'type' => 'object',
      'required' => %w(Name Description EnrollmentStyle
                       EnrollmentQuality AutoEnroll RandomizeEnrollments
                       NumberOfGroups MaxUsersPerGroup AllocateAfterExpiry
                       SelfEnrollmentExpiryDate GroupPrefix),
      'properties' => {
          'Name' => { 'type' => 'string' },
          'Description' =>
          {
            'type' => 'object',
            'properties' => {
              "Content" => "string",
              "Type" => "string" # "Text|HTML"
            }
          }, # RichTextInput
          # if set to SingleUserMemberSpecificGroup, values set for NumberOfGroups
          # and MaxUsersPerGroup are IGNORED
          # ----------------------------------
          # GPRENROLL_T integer value meanings
          # 0 = NumberOfGrupsNoEnrollment ^
          # 1 = PeoplePerGroupAutoEnrollment
          # 2 = NumerOfGroupsAutoEnrollment
          # 3 = PeoplePerGroupSelfEnrollment
          # 4 = SelfEnrollmentNumberOfGroups
          # 5 = PeoplePerNumberOfGroupsSelfEnrollment
          # ----------------------------------
          'EnrollmentStyle' => { 'type' => 'integer' }, # num GRPENROLL_T
           # if non-nil, values for NumberOfGroups and MaxUsersPerGroup are IGNORED
          'EnrollmentQuantity' => { 'type' => %w(integer null) },
          'AutoEnroll' => { 'type' => 'boolean' },
          'RandomizeEnrollments' => { 'type' => 'boolean' },
          'NumberOfGroups' => { 'type' => %w(integer null) }, # nil, 0, 1, 3, 5
          'MaxUsersPerGroup' => { 'type' => %w(integer null) }, # 1, 3, 5
          # if MaxUsersPerGroup has a value, then set this to true.
          'AllocateAfterExpiry' => { 'type' => 'boolean' },
          'SelfEnrollmentExpiryDate' => { 'type' => %w(string null) }, # UTCDATETIME
          # Prepends group prefix to GroupName and GroupCode
          'GroupPrefix' => { 'type' => %w(string null) }
      }
  }
  JSON::Validator.validate!(schema, group_category_data, validate_schema: true)
end

####
#### See +validate_create_group_category_data+ for details on schema formal
#### requirements of values
# Create a new group category for an org unit.
def create_org_unit_group_category(org_unit_id, group_category_data)
  payload = { 
    'Name' => '', # String
    'Description' => {}, # RichTextInput
    'EnrollmentStyle' => 0, # number : group_enroll
    'EnrollmentQuantity' => nil, # number | null
    'AutoEnroll' => false, # bool
    'RandomizeEnrollments' => false, # bool
    'NumberOfGroups' => nil, # number | nil
    'MaxUsersPerGroup' => nil, # number | nil
    'AllocateAfterExpiry' => false, # bool
    'SelfEnrollmentExpiryDate' => nil, # string: UTCDateTime | nil
    'GroupPrefix' => nil, # String | nil
  }.merge!(group_category_data)
  # Requires: JSON block of GroupCategoryData
  path = "/d2l/api/lp/#{$lp_ver}/#{org_unit_id}/groupcategories/"
  _post(path, payload)
  # returns a GroupCategoryData JSON block, in the Fetch form, of the new categ.
end

def validate_group_data(group_data)
  schema =
  {
      'type' => 'object',
      'required' => %w(Name Code Description),
      'properties' =>
      {
          'Name' => { 'type' => 'string' },
          "Code" => {'type' => 'string'},
          'Description' =>
          {
            'type' => 'object',
            'properties' =>
            {
              "Content" => "string",
              "Type" => "string" #"Text|HTML"
            }
          }
      }
  }
  JSON::Validator.validate!(schema, group_data, validate_schema: true)
end

# Create a new group for an org unit.
def create_org_unit_group(org_unit_id, group_category_id, group_data)
  payload =
  {
    "Name" => "string",
    "Code" => "string",
    "Description" => {}
  }.merge!(group_data)
  # Requires: JSON block of GroupData
  path = "/d2l/api/lp/#{$lp_ver}/#{org_unit_id}/groupcategories/#{group_category_id}/groups/"
  _post(path, payload)
  # returns a GroupData JSON block, in the Fetch form, of the new group
end

# Update a particular group for an org unit
def update_org_unit_group(org_unit_id, group_category_id, group_id, group_data)
  payload = {
    "Name" => "string",
    "Code" => "string",
    "Description" => {}
  }.merge!(group_data)
  # Requires: JSON block of GroupData
  validate_group_data(payload)
  path = "/d2l/api/lp/#{$lp_ver}/#{org_unit_id}/groupcategories/#{group_category_id}/groups/#{group_id}"
  # returns a GroupData JSON block, in the Fetch form, of the updated group.
  _put(path, payload)
end

def validate_group_enrollment_data(group_enrollment_data)
  schema = {
      'type' => 'object',
      'required' => %w(UserId),
      'properties' => {
          'UserId' => { 'type' => 'integer' }
      }
  }
  JSON::Validator.validate!(schema, course_data, validate_schema: true)
end

# Enroll a user in a group
def enroll_user_in_group(org_unit_id, group_category_id, group_id, user_id)
  payload = {
    "UserId" => user_id
  }
  # Requires: JSON block of GroupEnrollment
  path = "/d2l/api/lp/#{$lp_ver}/#{org_unit_id}/groupcategories/#{group_category_id}/groups/#{group_id}/enrollments/"
  validate_group_enrollment_data(payload)
  _post(path, payload)
end

def validate_update_group_category_data(group_category_data)
  schema = {
      'type' => 'object',
      'required' => %w(Name Description AutoEnroll RandomizeEnrollments),
      'properties' => {
          'Name' => { 'type' => 'string' },
          'Description' =>
          {
            'type' => 'object',
            'properties'=>{
              "Content" => "string",
              "Type" => "string" #"Text|HTML"
            }
          },
          'AutoEnroll' => { 'type' => 'boolean'},
          'RandomizeEnrollments' => { 'type' => 'boolean' }
      }
  }
  JSON::Validator.validate!(schema, group_category_data, validate_schema: true)
end

# update a particular group category for an org unit
def update_org_unit_group_category(org_unit_id, group_category_id, group_category_data)
  payload = { 'Name' => '', # String
              'Description' => {}, # RichTextInput
              'AutoEnroll' => false, # bool
              'RandomizeEnrollments' => false, # bool
            }.merge!(group_category_data)
  # Requires: JSON block of GroupCategoryData
  validate_update_group_category_data(payload)
  path = "/d2l/api/lp/#{$lp_ver}/#{org_unit_id}/groupcategories/#{group_category_data}"
  _put(path, payload)
  # Returns a GroupCategoryData JSON block, in the Fetch form, of updated grp. cat.
end

def group_category_locker_set_up?(org_unit_id, group_category_id)
    path = "/d2l/api/lp/#{$lp_ver}/#{org_unit_id}/groupcategories/#{group_category_id}/locker"
    _get(path)["HasLocker"]
    # returns true if the group cat. locker has been setup already
end

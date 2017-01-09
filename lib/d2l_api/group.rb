require_relative 'requests'
require 'json-schema'
####################################
# Groups/Group Categories:##########
####################################
# Delete a particular group category from an org unit.
def delete_group_category(org_unit_id, group_category_id)
   path = "/d2l/api/lp/#{$version}/#{org_unit_id}/groupcategories/#{group_category_id}"
   _delete(path)
end

# Delete a particular group from an org unit.
def delete_group(org_unit_id, group_category_id, group_id)
  path = "/d2l/api/lp/#{$version}/#{org_unit_id}/groupcategories/#{group_category_id}/groups/(groupId)"
  _delete(path)
end

# Remove a particular user from a group.
def remove_user_from_group(org_unit_id, group_category_id, group_id, user_id)
  path = "/d2l/api/lp/#{$version}/#{org_unit_id}/groupcategories/#{group_category_id}/groups/#{group_id}/enrollments/#{user_id}"
  _delete(path)
end

# Retrieve a list of all the group categories for the provided org unit.
def get_all_org_unit_group_categories(org_unit_id)
  path = "/d2l/api/lp/#{$version}/#{org_unit_id}/groupcategories/"
  _get(path)
end

# Retrieve a particular group category for an org unit.
def get_org_unit_group_category(org_unit_id, group_category_id)
  path = "/d2l/api/lp/#{$version}/#{org_unit_id}/groupcategories/#{group_category_id}"
  _get(path)
end

# Retrieve a list of all the groups in a specific group category for an OrgUnit
def get_all_group_category_groups(org_unit_id, group_category_id)
  path = "/d2l/api/lp/#{$version}/#{org_unit_id}/groupcategories/#{group_category_id}/groups/"
  _get(path)
end

# Retrieve a particular group in an org unit.
def get_org_unit_group(org_unit_id, group_category_id, group_id)
  path = "/d2l/api/lp/#{$version}/#{org_unit_id}/groupcategories/#{group_category_id}/groups/#{group_id}"
  _get(path)
end

######
######

def validate_create_group_category_data(group_category_data)
# TO DO
end

#####
####
# Create a new group category for an org unit.
def create_org_unit_group_category(org_unit_id, group_category_data)
  payload = { 'Name' => '', # String
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
  path = "/d2l/api/lp/#{$version}/#{org_unit_id}/groupcategories/"
  _post(path, payload)
  # returns a GroupCategoryData JSON block, in the Fetch form, of the new categ.
end

# Create a new group for an org unit.
def create_org_unit_group(org_unit_id, group_category_id, group_data)
  # Requires: JSON block of GroupData
  # path = "/d2l/api/lp/#{$version}/#{org_unit_id}/groupcategories/#{group_category_id}/groups/"
  # _post(path, payload)
  # returns a GroupData JSON block, in the Fetch form, of the new group
end

# Enroll a user in a group
def enroll_user_in_group(org_unit_id, group_category_id, group_id, group_enrollment_data)
  # Requires: JSON block of GroupEnrollment
end

# update a particular group category for an org unit
def update_org_unit_group_category(org_unit_id, group_category_id, group_category_data)
  # Requires: JSON block of GroupCategoryData
  # Returns a GroupCategoryData JSON block, in the Fetch form, of updated grp. cat.
end

# Update a particular group for an org unit
def update_org_unit_group(org_unit_id, group_category_id, group_id, group_data)
  # Requires: JSON block of GroupData
  # returns a GroupData JSON block, in the Fetch form, of the updated group.
end

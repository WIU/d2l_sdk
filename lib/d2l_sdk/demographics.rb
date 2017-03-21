require_relative 'requests'
require 'json-schema'

########################
# ACTIONS:##############
########################

# Delete one or more of a particular user's associated demographics entries.
# if no entries specified, it DELETES ALL.
# entry_ids are added as additional variables
# entry_ids is a CSV formatted string
def delete_user_demographics(user_id, entry_ids = '')
  path = "/d2l/api/lp/#{$lp_ver}/demographics/users/#{user_id}"
  path += "?entryIds=" + entry_ids if entry_ids != ''
  _delete(path)
end

# Retrieve all the demographics entries for all users enrolled in an OU
# optional params: fieldIds, roleIds, and userIds are CSV formatted Strings
#                  search and bookmark are Strings
def get_all_demographics_by_org_unit(org_unit_id, field_ids = '', role_ids = '',
                                     user_ids = '', search = '', bookmark = '')
    path = "/d2l/api/lp/#{$lp_ver}/demographics/orgUnits/#{org_unit_id}/users/"
    path += "?"
    path += "fieldIds=#{field_ids}&" if field_ids != ''
    path += "roleIds=#{role_ids}&" if role_ids != ''
    path += "userIds=#{user_ids}&" if user_ids != ''
    path += "search=#{search}&" if search != ''
    path += "bookmark=#{bookmark}&" if bookmark != ''
    _get(path)
    # returns paged result set of DemographicsUserEntryData JSON blocks
end

# Retrieve all the demographics entries for a specific user within an OU
def get_all_demographics_by_org_unit_by_user(org_unit_id, user_id, field_ids = '')
  path = "/d2l/api/lp/#{$lp_ver}/demographics/orgUnits/#{org_unit_id}/users/(#{user_id})"
  path += "?fieldIds=#{field_ids}" if field_ids != ''
  _get(path)
  # returns DemographicsUserEntryData JSON block
end

# Retrieve all demographics entries for all users with specified filters
def get_all_demographics(field_ids = '', role_ids = '', user_ids = '',
                         search = '', bookmark = '')
  path = "/d2l/api/lp/#{$lp_ver}/demographics/users/"
  path += "?"
  path += "fieldIds=#{field_ids}&" if field_ids != ''
  path += "roleIds=#{role_ids}&" if role_ids != ''
  path += "userIds=#{user_ids}&" if user_ids != ''
  path += "search=#{search}&" if search != ''
  path += "bookmark=#{bookmark}" if bookmark != ''
  _get(path)
  # returns paged result set of DemographicsUserEntryData JSON blocks
end

# Retrieve all the demographics entries for a single user.
def get_user_demographics(user_id, field_ids = '', bookmark = '')
  path = "/d2l/api/lp/#{$lp_ver}/demographics/users/#{user_id}"
  path += "?"
  path += "fieldIds=#{field_ids}&" if field_ids != ''
  path += "bookmark=#{bookmark}" if bookmark != ''
end

# TODO: Update the demographics entries for a single user.
# Return: a DemographicsUserEntryData JSON block containing the user’s updated entries.
def update_user_demographics(user_id, demographics_entry_data)
  # PUT /d2l/api/lp/(version)/demographics/users/(userId)
end

########################
## FIELDS:##############
########################

# TODO: Delete a single demographic field, provided it has no associated entries.
def delete_demographics_field(field_id)
  #DELETE /d2l/api/lp/(version)/demographics/fields/(fieldId)
end

# Retrieve list of all demographics fields
def get_all_demographic_fields(bookmark = '')
  path = "/d2l/api/lp/#{$lp_ver}/demographics/fields/"
  path += "#{bookmark}" if bookmark != ''
  _get(path)
  # returns paged result set of DemographicsField JSON blocks
end

# Retrieve a single demographic field
def get_demographic_field(field_id)
  path = "/d2l/api/lp/#{$lp_ver}/demographics/fields/#{field_id}"
  _get(path)
  # returns fetch form of DemographicsField JSON block
end

# TODO: Create new demographic field
# Input: DemographicsField (Demographics.Demographicsfield)
# RETURNS: fetch form of a DemographicsField JSON block
def create_demographic_field(demographics_field)
  # POST /d2l/api/lp/(version)/demographics/fields/
  # RETURNS: fetch form of a DemographicsField JSON block
end

# TODO: Update demographic field
# Input: DemographicsField (Demographics.Demographicsfield)
# RETURNS: fetch form of a DemographicsField JSON block
def create_demographic_field(field_id, demographics_field)
  # PUT /d2l/api/lp/(version)/demographics/fields/(fieldId)
  # RETURNS: fetch form of a DemographicsField JSON block
end

########################
## DATA TYPES:##########
########################

# Retrieve the list of all demographics data types
# uses DataTypeId's as a paging control value
def get_all_demographic_types(bookmark = '')
  path = "/d2l/api/lp/#{$lp_ver}/demographics/dataTypes/"
  path += "#{bookmark}" if bookmark != ''
  _get(path)
  # returns paged result set of DemographicsDataType JSON blocks
end

# retrieve a single demographic data type
def get_demographic_type(data_type_id)
  path = "/d2l/api/lp/#{$lp_ver}/demographics/dataTypes/#{data_type_id}"
  _get(path)
  # returns DemographicsDataType JSON block
end

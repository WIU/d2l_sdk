require_relative 'requests'
require 'json-schema'

########################
# DEMOGRPAHICS:#########
########################

###### Actions

# Delete one or more of a particular user's associated demographics entries.
# if no entries specified, it DELETES ALL.
# entry_ids are added as additional variables
# entry_ids is a CSV formatted string
def delete_user_demographics(user_id, entry_ids = '')
  path = "/d2l/api/lp/#{$lp_ver}/demographics/users/#{user_id}"
  path += "?entryIds=" + entry_ids if entry_ids != ''
  _delete(path)
end

# optional params: fieldIds, roleIds, and userIds are CSV formatted Strings
#                  search and bookmark are Strings
# retrieve all the demographics entries for all users enrolled in an OU
def get_all_demographics_by_org_unit(org_unit_id, field_ids = '', role_ids = '',
                                     user_ids = '', search = '', bookmark = '')
    path = "/d2l/api/lp/#{$lp_ver}/demographics/orgUnits/#{org_unit_id}/users/"
    path += "?fieldIds=" + field_ids if field_ids != ''
    path += "?roleIds=" + role_ids if role_ids != ''
    path += "?userIds=" + user_ids if user_ids != ''
    path += "?search=" + search if search != ''
    path += "?bookmark=" + bookmark if bookmark != ''
    _get(path)
    # returns paged result set of DemographicsUserEntryData JSON blocks
end

# retrieve all the demographics entries for a specific user within an OU
def get_all_demographics_by_org_unit_by_user(org_unit_id, user_id, field_ids = '')
  path = "/d2l/api/lp/#{$lp_ver}/demographics/orgUnits/#{org_unit_id}/users/(#{user_id})"
  path += "#{field_ids}" if field_ids != ''
  _get(path)
  # returns DemographicsUserEntryData JSON block
end

# retrieve all demographics entries for all users with specified filters
def get_all_demographics(field_ids = '', role_ids = '', user_ids = '',
                         search = '', bookmark = '')
  path = "/d2l/api/lp/#{$lp_ver}/demographics/users/"
  path += "#{field_ids}" if field_ids != ''
  path += "#{role_ids}" if role_ids != ''
  path += "#{user_ids}" if user_ids != ''
  path += "#{search}" if search != ''
  path += "#{bookmark}" if bookmark != ''
  _get(path)
  # returns paged result set of DemographicsUserEntryData JSON blocks
end


###### FIELDS
# retrieve list of all demographics fields
def get_all_demographic_fields(bookmark = '')
  path = "/d2l/api/lp/#{$lp_ver}/demographics/fields/"
  path += "#{bookmark}" if bookmark != ''
  _get(path)
  # returns paged result set of DemographicsField JSON blocks
end

# retrieve a single demographic field
def get_demographic_field(field_id)
  path = "/d2l/api/lp/#{$lp_ver}/demographics/fields/#{field_id}"
  _get(path)
  # returns fetch form of DemographicsField JSON block
end

###### DATA TYPES

# retrieve the list of all demographics data types
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

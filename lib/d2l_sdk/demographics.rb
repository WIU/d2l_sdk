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
  _get(path)
end

def check_demographics_entry_data_validity(demographics_entry_data)
    # A hash with one value, "EntryValues", which is an array of hashes that
    # include the keys "Name" and "Values", where "Name" is a string and "Values"
    # is an array of string.
    # { "key" => [ { "key" => "string", "key" => [] } ] }
    schema = {
        'type' => 'object',
        'required' => %w(EntryValues),
        'properties' => {
            'EntryValues' => # DemographicsEntryData
            {
              'type' => 'array',
              'items' => # Items = <composite:DemographicsEntry>
              {
                'type' => 'object',
                'minItems' => 1,
                'required' => %w(Name Values),
                'properties' =>
                {
                  'Name' => { 'type' => 'string' },
                  'Values' =>
                  {
                    'type' => 'array',
                    'items' =>
                    {
                      'type' => 'string',
                      'minItems' => 1
                    }
                  }
                }
              }
            }
        }
    }
    JSON::Validator.validate!(schema, demographics_entry_data, validate_schema: true)
end


# REVIEW: Update the demographics entries for a single user.
# Return: a DemographicsUserEntryData JSON block containing the user’s updated entries.
def update_user_demographics(user_id, demographics_entry_data)
  payload =
  {
    "EntryValues" =>
    [
      {
        "Name" => "placeholder_name",
        "Values" =>
        [
          "value1",
          "value2"
        ]
      }
    ]
  }.merge!(demographics_entry_data)
  # PUT /d2l/api/lp/(version)/demographics/users/(userId)
  path = "/d2l/api/lp/#{$lp_ver}/demographics/users/#{user_id}"
  check_demographics_user_entry_data_validity(payload)
  _put(path, payload)
end

########################
## FIELDS:##############
########################

# REVIEW: Delete a single demographic field, provided it has no associated entries.
def delete_demographics_field(field_id)
  path = "/d2l/api/lp/#{$lp_ver}/demographics/fields/#{field_id}"
  _delete(path)
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

# Additional function added to check that the demographics data (create form)
# conforms to the JSON schema required by D2L's backend.
def check_create_demographics_field(demographics_data)
    schema = {
        'type' => 'object',
        'required' => %w(Name Description DataTypeId),
        'properties' => {
            'Name' => { 'type' => 'string' },
            'Description' => { 'type' => 'string' },
            'DataTypeId' => { 'type' => 'string' }
        }
    }
    JSON::Validator.validate!(schema, demographics_data, validate_schema: true)
end

# REVIEW: Create new demographic field
# Input: DemographicsField (Demographics.Demographicsfield)
# RETURNS: fetch form of a DemographicsField JSON block
def create_demographic_field(demographics_field)
  # POST /d2l/api/lp/(version)/demographics/fields/
  path = "/d2l/api/lp/#{$lp_ver}/demographics/fields/"
  payload = {
    "Name" => "String",
    "Description" => "String",
    "DataTypeId" => "String:GUID"
  }
  check_create_demographics_field(payload)
  _post(path, payload)
  # RETURNS: fetch form of a DemographicsField JSON block
end

# Additional function added to check that the demographics data (update form)
# conforms to the JSON schema required by D2L's backend.
def check_update_demographics_field(demographics_data)
    schema = {
        'type' => 'object',
        'required' => %w(Name Description),
        'properties' => {
            'Name' => { 'type' => 'string' },
            'Description' => { 'type' => 'string' }
        }
    }
    JSON::Validator.validate!(schema, demographics_data, validate_schema: true)
end

# REVIEW: Update a single demographic field.
# Input: DemographicsField (Demographics.Demographicsfield)
# RETURNS: fetch form of a DemographicsField JSON block
def update_demographics_field(field_id, demographics_field)
  # PUT /d2l/api/lp/(version)/demographics/fields/(fieldId)
  path = "/d2l/api/lp/#{$lp_ver}/demographics/fields/#{field_id}"
  payload = {
    "Name" => "String",
    "Description" => "String",
    "DataTypeId" => "String:GUID"
  }.merge!(demographics_field)
  check_update_demographics_field(payload)
  _put(path, payload)
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

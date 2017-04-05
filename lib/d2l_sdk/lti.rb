require_relative 'requests'
require 'json-schema'

##################
## ACTIONS: ######
##################

# REVIEW: Remove an LTI link.
# => DELETE /d2l/api/le/(version)/lti/link/(ltiLinkId)
def delete_lti_link(lti_link_id)
  path = "/d2l/api/le/#{$le_ver}/lti/link/#{lti_link_id}"
  _delete(path)
end

# REVIEW: Retrieve the information for all LTI links registered for an org unit.
# => GET /d2l/api/le/(version)/lti/link/(orgUnitId)/
def get_org_unit_lti_links(org_unit_id)
  path = "/d2l/api/le/#{$le_ver}/lti/link/#{org_unit_id}/"
  _get(path)
end

# REVIEW: Retrieve the information for a particular LTI link.
# => GET /d2l/api/le/(version)/lti/link/(orgUnitId)/(ltiLinkId)
def get_lti_link_info(org_unit_id, lti_link_id)
  path = "/d2l/api/le/#{$le_ver}/lti/link/#{org_unit_id}/#{lti_link_id}"
  _get(path)
end

def check_create_lti_link_data_validity(create_lti_link_data)
    schema = {
        'type' => 'object',
        'required' => %w(Title Url Description Key PlainSecret
                         IsVisible SignMessage SignWithTc SendTcInfo
                         SendContextInfo SendUserId SendUserName SendUserEmail
                         SendLinkTitle SendLinkDescription SendD2LUserName
                         SendD2LOrgDefinedId SendD2LOrgRoleId
                         UseToolProviderSecuritySettings CustomParameters),
        'properties' =>
        {
            "Title" => { 'type' => 'string' },
            "Url" => { 'type' => 'string' },
            "Description" => { 'type' => 'string' },
            "Key" => { 'type' => 'string' },
            "PlainSecret" => { 'type' => 'string' },
            "IsVisible" => { 'type' => 'boolean' },
            "SignMessage" => { 'type' => 'boolean' },
            "SignWithTc" => { 'type' => 'boolean' },
            "SendTcInfo" => { 'type' => 'boolean' },
            "SendContextInfo" => { 'type' => 'boolean' },
            "SendUserId" => { 'type' => 'boolean' },
            "SendUserName" => { 'type' => 'boolean' },
            "SendUserEmail" => { 'type' => 'boolean' },
            "SendLinkTitle" => { 'type' => 'boolean' },
            "SendLinkDescription" => { 'type' => 'boolean' },
            "SendD2LUserName" => { 'type' => 'boolean' },
            "SendD2LOrgDefinedId" => { 'type' => 'boolean' },
            "SendD2LOrgRoleId" => { 'type' => 'boolean' },
            "UseToolProviderSecuritySettings" => { 'type' => 'boolean' },
            "CustomParameters" =>
            { # define the CustomParameter array
                # 'description' => 'The array of CustomParameters
                'type' => %w(array null),
                'items' =>
                  {
                      'type' => "object",
                      "properties" => 
                      {
                        "Name" => {'type'=>"string"},
                        "Value" => {'type'=>"string"}
                      }
                  }
            }
        }
    }
    JSON::Validator.validate!(schema, create_lti_link_data, validate_schema: true)
end

# REVIEW: Register a new LTI link for an org unit.
# => POST /d2l/api/le/(version)/lti/link/(orgUnitId)
def register_lti_link(org_unit_id, create_lti_link_data)
  path = "/d2l/api/le/#{$le_ver}/lti/link/#{org_unit_id}"
  payload = {
    "Title" => '',
    "Url" => '',
    "Description" => '',
    "Key" => '',
    "PlainSecret" => '',
    "IsVisible" => false,
    "SignMessage" => false,
    "SignWithTc" => false,
    "SendTcInfo" => false,
    "SendContextInfo" => false,
    "SendUserId" => false,
    "SendUserName" => false,
    "SendUserEmail" => false,
    "SendLinkTitle" => false,
    "SendLinkDescription" => false,
    "SendD2LUserName" => false,
    "SendD2LOrgDefinedId" => false,
    "SendD2LOrgRoleId" => false,
    "UseToolProviderSecuritySettings" => false,
    "CustomParameters" => nil # or Array of CustomParameter
    # e.g. [{"Name" => "", "Value" => ""},{"Name" => "", "Value" => ""}]
  }.merge!(create_lti_link_data)
  check_create_lti_link_data_validity(payload)
  _post(path, payload)
end


# REVIEW: Build a new quicklink around an existing LTI link.
# => POST /d2l/api/le/(version)/lti/quicklink/(orgUnitId)/(ltiLinkId)
def create_lti_quicklink(org_unit_id, lti_link_id)
  path = "/d2l/api/le/#{$le_ver}/lti/quicklink/#{org_unit_id}/#{lti_link_id}"
  _post(path, {})
end

# REVIEW: Update the information associated with a registered LTI link.
# => PUT /d2l/api/le/(version)/lti/link/(ltiLinkId)
def update_lti_link(lti_link_id, create_lti_link_data)
  path = "/d2l/api/le/#{$le_ver}/lti/link/#{lti_link_id}"
  payload = {
    "Title" => '',
    "Url" => '',
    "Description" => '',
    "Key" => '',
    "PlainSecret" => '',
    "IsVisible" => false,
    "SignMessage" => false,
    "SignWithTc" => false,
    "SendTcInfo" => false,
    "SendContextInfo" => false,
    "SendUserId" => false,
    "SendUserName" => false,
    "SendUserEmail" => false,
    "SendLinkTitle" => false,
    "SendLinkDescription" => false,
    "SendD2LUserName" => false,
    "SendD2LOrgDefinedId" => false,
    "SendD2LOrgRoleId" => false,
    "UseToolProviderSecuritySettings" => false,
    "CustomParameters" => nil # or Array of CustomParameter
    # e.g. [{"Name" => "", "Value" => ""},{"Name" => "", "Value" => ""}]
  }.merge!(create_lti_link_data)
  check_create_lti_link_data_validity(payload)
  _put(path, payload)
end

#############################
## LTI TOOL PROVIDERS: ######
#############################

# REVIEW: Remove the registration for an LTI tool provider.
# => DELETE /d2l/api/le/(version)/lti/tp/(tpId)
def delete_LTI_tool_provider_registration(tp_id)
  path = "/d2l/api/le/#{$le_ver}/lti/tp/#{tp_id}"
  _delete(path)
end

# REVIEW: Retrieve the information for all LTI tool providers registered for an org unit.
# => GET /d2l/api/le/(version)/lti/tp/(orgUnitId)/
def get_org_unit_lti_tool_providers(org_unit_id)
  path = "/d2l/api/le/#{$le_ver}/lti/tp/#{org_unit_id}/"
  _get(path)
end

# REVIEW: Retrieve the information for a particular LTI tool provider.
# => GET /d2l/api/le/(version)/lti/tp/(orgUnitId)/(tpId)
def get_lti_tool_provider_information(org_unit_id, tp_id)
  path = "/d2l/api/le/#{$le_ver}/lti/tp/#{org_unit_id}/#{tp_id}"
  _get(path)
end

# Schema to check the CreateLtiProviderData JSON block validity.
def check_create_lti_provider_data_validity(create_lti_provider_data)
    schema = {
        'type' => 'object',
        'required' => %w(LaunchPoint Secret UseDefaultTcInfo Key Name
                         Description ContactEmail SendTcInfo
                         SendContextInfo SendUserId SendUserName SendUserEmail
                         SendLinkTitle SendLinkDescription SendD2LUserName
                         SendD2LOrgDefinedId SendD2LOrgRoleId),
        'properties' =>
        {
            "LaunchPoint" => { 'type' => 'string' },
            "Secret" => { 'type' => 'string' },
            "UseDefaultTcInfo" => { 'type' => 'string' },
            "Key" => { 'type' => 'string' },
            "Name" => { 'type' => 'string' },
            "Description" => { 'type' => 'string' },
            "ContactEmail" => { 'type' => 'string' },
            "IsVisible" => { 'type' => 'boolean' },
            "SendTcInfo" => { 'type' => 'boolean' }, # LE's 1.12+
            "SendContextInfo" => { 'type' => 'boolean' }, # LE's 1.12+
            "SendUserId" => { 'type' => 'boolean' }, # LE's 1.12+
            "SendUserName" => { 'type' => 'boolean' }, # LE's 1.12+
            "SendUserEmail" => { 'type' => 'boolean' }, # LE's 1.12+
            "SendLinkTitle" => { 'type' => 'boolean' }, # LE's 1.12+
            "SendLinkDescription" => { 'type' => 'boolean' }, # LE's 1.12+
            "SendD2LUserName" => { 'type' => 'boolean' }, # LE's 1.12+
            "SendD2LOrgDefinedId" => { 'type' => 'boolean' }, # LE's 1.12+
            "SendD2LOrgRoleId" => { 'type' => 'boolean' } # LE's 1.12+
        }
    }
    JSON::Validator.validate!(schema, create_lti_provider_data, validate_schema: true)
end

# REVIEW: Register a new LTI tool provider for an org unit.
# => POST /d2l/api/le/(version)/lti/tp/(orgUnitId)
# INPUT: LTI.CreateLtiProviderData
def register_lti_tool_provider(org_unit_id, create_lti_provider_data)
  path = "/d2l/api/le/#{$le_ver}/lti/tp/#{org_unit_id}"
  payload = {
    "LaunchPoint" => '',
    "Secret" => '',
    "UseDefaultTcInfo" => '',
    "Key" => '',
    "Name" => '',
    "Description" => '',
    "ContactEmail" => '',
    "IsVisible" => false,
    "SendTcInfo" => false, # Appears in LE's 1.12+ contract as of LE v10.6.0
    "SendContextInfo" => false, # Appears in LE's 1.12+ contract as of LE v10.6.0
    "SendUserId" => false, # Appears in LE's 1.12+ contract as of LE v10.6.0
    "SendUserName" => false, # Appears in LE's 1.12+ contract as of LE v10.6.0
    "SendUserEmail" => false, # Appears in LE's 1.12+ contract as of LE v10.6.0
    "SendLinkTitle" => false, # Appears in LE's 1.12+ contract as of LE v10.6.0
    "SendLinkDescription" => false, # Appears in LE's 1.12+ contract as of LE v10.6.0
    "SendD2LUserName" => false, # Appears in LE's 1.12+ contract as of LE v10.6.0
    "SendD2LOrgDefinedId" => false, # Appears in LE's 1.12+ contract as of LE v10.6.0
    "SendD2LOrgRoleId" => false # Appears in LE's 1.12+ contract as of LE v10.6.0
  }.merge!(create_lti_provider_data)
  check_create_lti_provider_data_validity(payload)
  _post(path, payload)
  # RETURNS: a LtiToolProviderData JSON block
end


# REVIEW: Update the information associated with a registered LTI tool provider.
# => PUT /d2l/api/le/(version)/lti/tp/(tpId)
# INPUT: LTI.CreateLtiProviderData
def update_lti_tool_provider(tp_id, create_lti_provider_data)
  path = "/d2l/api/le/#{$le_ver}/lti/tp/#{tp_id}" # tp_id = tool provider id
  payload = {
    "LaunchPoint" => '',
    "Secret" => '',
    "UseDefaultTcInfo" => '',
    "Key" => '',
    "Name" => '',
    "Description" => '',
    "ContactEmail" => '',
    "IsVisible" => false,
    "SendTcInfo" => false, # Appears in LE's 1.12+ contract as of LE v10.6.0
    "SendContextInfo" => false, # Appears in LE's 1.12+ contract as of LE v10.6.0
    "SendUserId" => false, # Appears in LE's 1.12+ contract as of LE v10.6.0
    "SendUserName" => false, # Appears in LE's 1.12+ contract as of LE v10.6.0
    "SendUserEmail" => false, # Appears in LE's 1.12+ contract as of LE v10.6.0
    "SendLinkTitle" => false, # Appears in LE's 1.12+ contract as of LE v10.6.0
    "SendLinkDescription" => false, # Appears in LE's 1.12+ contract as of LE v10.6.0
    "SendD2LUserName" => false, # Appears in LE's 1.12+ contract as of LE v10.6.0
    "SendD2LOrgDefinedId" => false, # Appears in LE's 1.12+ contract as of LE v10.6.0
    "SendD2LOrgRoleId" => false # Appears in LE's 1.12+ contract as of LE v10.6.0
  }.merge!(create_lti_provider_data)
  check_create_lti_provider_data_validity(payload)
  _put(path, payload)
  # RETURNS: a LtiToolProviderData JSON block
end

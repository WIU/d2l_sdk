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

# TODO: Register a new LTI link for an org unit.
# => POST /d2l/api/le/(version)/lti/link/(orgUnitId)
=begin
# Example of an LTI.CreateLtiLinkData
# TODO: Develop schema to check that POST/PUT data conforms to this structure.
{
    "Title": <string>,
    "Url": <string>,
    "Description": <string>,
    "Key": <string>,
    "PlainSecret": <string>,
    "IsVisible": <boolean>,
    "SignMessage": <boolean>,
    "SignWithTc": <boolean>,
    "SendTcInfo": <boolean>,
    "SendContextInfo": <boolean>,
    "SendUserId": <boolean>,
    "SendUserName": <boolean>,
    "SendUserEmail": <boolean>,
    "SendLinkTitle": <boolean>,
    "SendLinkDescription": <boolean>,
    "SendD2LUserName": <boolean>,
    "SendD2LOrgDefinedId": <boolean>,
    "SendD2LOrgRoleId": <boolean>,
    "UseToolProviderSecuritySettings": <boolean>,  // Appears in LE's 1.12+ contract as of LE v10.6.0
    "CustomParameters": null|[ <LTI.CustomParameter>, ... ]
}
=end

# REVIEW: Build a new quicklink around an existing LTI link.
# => POST /d2l/api/le/(version)/lti/quicklink/(orgUnitId)/(ltiLinkId)
def create_lti_quicklink(org_unit_id, lti_link_id)
  path = "/d2l/api/le/#{$le_ver}/lti/quicklink/#{org_unit_id}/#{lti_link_id}"
  _post(path, {})
end

# TODO: Update the information associated with a registered LTI link.
# => PUT /d2l/api/le/(version)/lti/link/(ltiLinkId)
# TODO: Use the schema developed for LTI.CreateLtiLinkData to check the PUT payload

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

# TODO: Register a new LTI tool provider for an org unit.
# => POST /d2l/api/le/(version)/lti/tp/(orgUnitId)
# INPUT: LTI.CreateLtiProviderData
# TODO: Develop schema for the required input

# TODO: Update the information associated with a registered LTI tool provider.
# => PUT /d2l/api/le/(version)/lti/tp/(tpId)
# INPUT: LTI.CreateLtiProviderData
# TODO: Use the developed schema for LTI.CreateLtiProviderData to check the
#       PUT request payload.

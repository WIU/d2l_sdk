require_relative 'auth'


@debug = false

########################
# DEFINITIONS:##########
########################
# NOTE: These provide access to the definition meta-data
#       surrounding configuration variables.

# Retrieve the definitions for all the configuration variables the
# user has access to view.
def get_all_config_var_definitions(search = '', bookmark = '')
  path = "/d2l/api/lp/#{$lp_ver}/configVariables/definitions/"
  path += "?search=#{search}" if search != ''
  path += "?bookmark=#{bookmark}" if bookmark != ''
  _get(path)
  # returns paged result set of Definition JSON data blocks
end

# Retrieve the definitions for a configuration variable.
def get_config_var_definitions(variable_id)
  path = "/d2l/api/lp/#{$lp_ver}/configVariables/(#{variable_id}/definition"
  _get(path)
  # returns Definition JSON data block
end

########################
# VALUES:###############
########################
# NOTE: These provide access to the values assigned to configuration
#       variables in the running back-end service.

# Retrieve the value summary for a configuration variable.
def get_config_var_values(variable_id)
  path = "/d2l/api/lp/#{$lp_ver}/configVariables/#{variable_id}/values"
  _get(path)
  # returns Values JSON data block
end

# Retrieve the current org value for a configuration variable.
def get_config_var_current_org_value(variable_id)
  path = "/d2l/api/lp/#{$lp_ver}/configVariables/#{variable_id}/values/org"
  _get(path)
  # returns OrgValue JSON data block
end

# Retrieve all the org unit override values for a configuration variable.
def get_all_config_var_org_unit_override_values(variable_id, bookmark = '')
  path = "/d2l/api/lp/#{$lp_ver}/configVariables/#{variable_id}/values/orgUnits/"
  path += "?bookmark=#{bookmark}" if bookmark != ''
  _get(path)
  # returns paged result set of OrgUnitValue data blocks
end

# Retrieve an org unit override value for a configuration variable.
def get_config_var_org_unit_override_value(variable_id, org_unit_id)
  path = "/d2l/api/lp/#{$lp_ver}/configVariables/#{variable_id}/values/orgUnits/#{org_unit_id}"
  _get(path)
  # returns OrgUnitValue JSON block
end

# NOTE: UNSTABLE!!!
# Retrieve the effective value for a configuration variable within an org unit.
def get_config_var_org_unit_effective_value(variable_id, org_unit_id)
  path = "/d2l/api/lp/#{$lp_ver}/configVariables/#{variable_id}/effectiveValues/orgUnits/#{org_unit_id}"
  _get(path)
  # returns OrgUnitValue JSON block
end

# Retrieve all the role override values for a configuration variable.
def get_all_config_var_org_unit_role_override_values(variable_id, bookmark = '')
  path = "/d2l/api/lp/#{$lp_ver}/configVariables/#{variable_id}/values/roles/"
  path += "?bookmark=#{bookmark}" if bookmark != ''
  _get(path)
  # returns paged result set with RoleValue JSON data blocks
end

def get_config_var_role_override_value(variable_id, role_id)
  path = "/d2l/api/lp/#{$lp_ver}/configVariables/#{variable_id}/values/roles/#{role_id}"
  _get(path)
end

def get_config_var_system_value(variable_id)
  path = "/d2l/api/lp/#{$lp_ver}/configVariables/#{variable_id}/values/system"
  _get(path)
end

# REVIEW: Set a new org value for a configuration variable.
def set_config_var_org_value(variable_id, org_value)
  path = "/d2l/api/lp/#{$lp_ver}/configVariables/#{variable_id}/values/org"
  if org_value.is_a?(String) || org_value.nil?
    payload = { 'OrgValue' => org_value }
    _put(path, payload)
  else
    raise ArgumentError, "Argument 'org_value' is not a String or nil"
  end
end

# REVIEW: Set a new org unit override value for a configuration variable.
def set_config_var_override_value(variable_id, org_unit_id, org_unit_value)
  path = "/d2l/api/lp/#{$lp_ver}/configVariables/#{variable_id}/values/orgUnits/#{org_unit_id}"
  raise ArgumentError, "Argument 'org_unit_value' is not a String or nil" unless org_unit_value.is_a?(String) || org_unit_value.nil? 
  payload = { 'OrgUnitValue' => org_unit_value }
  _put(path, payload)
end

# REVIEW: Set a new role override value for a configuration variable.
def set_config_var_role_value(variable_id, role_id, role_value)
  path = "/d2l/api/lp/#{$lp_ver}/configVariables/#{variable_id}/values/roles/#{role_id}"
  raise ArgumentError, "Argument 'role_value' is not a String or nil" unless role_value.is_a? String || role_value.nil?
    payload = { 'RoleValue' => role_value }
    _put(path, payload)
end

# REVIEW: Set a new system value for a configuration variable.
def set_config_var_system_value(variable_id, system_value)
  path = "/d2l/api/lp/#{$lp_ver}/configVariables/#{variable_id}/values/system"
    raise ArgumentError, "Argument 'system_value' is not a String or nil" unless system_value.is_a?(String) || system_value.nil?
    payload = { 'SystemValue' => system_value }
    _put(path, payload)
end

########################
# RESOLVER:#############
########################
# NOTE: These provide a way to manage a configuration variable’s
#       resolution strategy.

# NOTE: UNSTABLE!!!
# TODO: UNSTABLE!!! --Restore the default resolution strategy for an org unit configuration variable.
def restore_default_org_unit_config_var_resolution(variable_id); end
  # DELETE /d2l/api/lp/(version)/configVariables/(variableId)/resolver


# NOTE: UNSTABLE!!!
# REVIEW: Retrieve the resolution strategy for an org unit configuration variable.
def get_config_var_resolver(variable_id)
  path = "/d2l/api/lp/#{lp_ver}/configVariables/#{variable_id}/resolver"
  _get(path)
end

# NOTE: UNSTABLE!!!
# TODO: UNSTABLE!!! --Update the resolution strategy for an org unit configuration variable.
def update_org_unit_config_var_resolution(resolver_value); end
  # PUT /d2l/api/lp/(version)/configVariables/(variableId)/resolver


################################################################################
###############################     TOOLS    ###################################
################################################################################
# NOTE: This section has been appended to config variables due to its similar
#       placement in the GUI and the fact that tools functions are rather small
#       in number.

########################
# ORGANIZATION:#########
########################

# REVIEW: Retrieve the current organization-level information for all tools.
# => GET /d2l/api/lp/(version)/tools/org/
# RETURNS: paged result set containing the resulting OrgInformation data blocks
def get_org_tools_info(include_restricted_tools = nil, bookmark = '')
  path = "/d2l/api/lp/#{$lp_ver}/tools/org/?"
  path += "includeRestrictedTools=#{includeRestrictedTools}&" unless include_restricted_tools.nil?
  path += "bookmark=#{bookmark}" unless bookmark == ''
  _get(path)
  # RETURNS: paged result set containing the resulting OrgInformation data blocks
end

# REVIEW: Retrieve the current organization-level information for a tool.
# => GET /d2l/api/lp/(version)/tools/org/(toolId)
# RETURNS: an OrgInformation JSON block
def get_org_tool_info(tool_id)
  path = "GET /d2l/api/lp/#{$lp_ver}/tools/org/#{tool_id}"
  _get(path)
  # RETURNS: an OrgInformation JSON block
end

# NOTE: Not inherent d2l_api function. This is to check that the update_status
#       is actually a boolean and return a formatted UpdateStatus JSON block.
def check_and_create_update_status_payload(update_status)
  if update_status != true && update_status != false
    raise ArgumentError, 'update_status is not a boolean'
  end
  payload = { 'Status' => update_status } # Tools.UpdateStatus JSON data block
  payload
end

# REVIEW: Update the organization-level status for a tool.
# => PUT /d2l/api/lp/(version)/tools/org/(toolId)
def update_org_tool_status(tool_id, update_status)
  path = "/d2l/api/lp/#{$lp_ver}/tools/org/#{tool_id}"
  payload = check_and_create_update_status_payload(update_status)
  _put(path, payload)
end

# REVIEW: Update a tool’s default status for new org units.
# => PUT /d2l/api/lp/(version)/tools/org/(toolId)/OUDefault
def update_tool_default_status(tool_id, update_status)
  path = "/d2l/api/lp/#{$lp_ver}/tools/org/#{tool_id}/OUDefault"
  payload = check_and_create_update_status_payload(update_status)
  _put(path, payload)
end

# REVIEW: Update a tool’s current status for all org units.
# => PUT /d2l/api/lp/(version)/tools/org/(toolId)/OUDefault/override
def update_all_org_unit_tool_status(tool_id, update_status)
  path = "/d2l/api/lp/#{$lp_ver}/tools/org/#{tool_id}/OUDefault/override"
  payload = check_and_create_update_status_payload(update_status)
  _put(path, payload)
end

########################
# ORG UNITS:############
########################

# REVIEW: Retrieve the current information for all tools enabled for the provided org unit.
# => GET /d2l/api/lp/(version)/tools/orgUnits/(orgUnitId)
def get_org_enabled_tools_info(org_unit_id, bookmark = '')
  path = "/d2l/api/lp/#{$lp_ver}/tools/orgUnits/#{org_unit_id}?"
  path += "bookmark=#{bookmark}" unless bookmark == ''
  _get(path)
end

# REVIEW: Retrieve the current information for a tool enabled for the provided org unit.
# => GET /d2l/api/lp/(version)/tools/orgUnits/(orgUnitId)/(toolId)
def get_org_enabled_tool_info(org_unit_id, tool_id)
  path = "/d2l/api/lp/#{$lp_ver}/tools/orgUnits/#{org_unit_id}/#{tool_id}"
  _get(path)
end

def check_org_unit_information_validity(data_block)
    schema = {
        'type' => 'object',
        'required' => %w(ToolId DisplayName OrgUnitId Status CustomNavbarName),
        'properties' => {
            'ToolId' => { 'type' => 'string' },
            'DisplayName' => { 'type' => 'string' },
            'CallbackUrl' => { 'type' => 'integer' },
            'Status' => { 'type' => 'boolean' },
            'CustomNavbarName' => { 'type' => 'string' }
        }
    }
    JSON::Validator.validate!(schema, data_block, validate_schema: true)
end

# REVIEW: Update the org unit-level information for a tool.
# INPUT: OrgUnitInformation JSON block
# => PUT /d2l/api/lp/(version)/tools/orgUnits/(orgUnitId)/(toolId)
def update_org_unit_level_tool_info(org_unit_id, tool_id, org_unit_information)
  path = "/d2l/api/lp/#{$lp_ver}/tools/orgUnits/#{org_unit_id}/#{tool_id}"
  payload =
  {
    'ToolId' => '', # <string:D2LID>
    'DisplayName' => '', # <string> ## added with LP v1.6 API
    'OrgUnitId' => 0, # D2LID:number
    'Status' => false, # boolean
    'CustomNavbarName' => '' # <string>
  }.merge!(org_unit_information)
  check_org_unit_information_validity(payload) # NOTE: Check this later.
  _put(path, payload)
end

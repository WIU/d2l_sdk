require_relative 'auth'


@debug = false

########################
# DEFINITIONS:##########
########################
# NOTE: These provide access to the definition meta-data
#       surrounding configuration variables.

# Retrieve the definitions for all the configuration variables the
# user has access to view.
def get_all_config_var_definitions(search='', bookmark='')
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

#Retrieve the value summary for a configuration variable.
def get_config_var_values(variable_id)
  path = "/d2l/api/lp/#{$lp_ver}/configVariables/#{variable_id}/values"
  _get(path)
  # returns Values JSON data block
end

#Retrieve the current org value for a configuration variable.
def get_config_var_current_org_value(variable_id)
  path = "/d2l/api/lp/#{$lp_ver}/configVariables/#{variable_id}/values/org"
  _get(path)
  # returns OrgValue JSON data block
end

# Retrieve all the org unit override values for a configuration variable.
def get_all_config_var_org_unit_override_values(variable_id, bookmark='')
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
def get_all_config_var_org_unit_role_override_values(variable_id, bookmark='')
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
  if org_value.is_a? String || org_value.nil?
    payload = {"OrgValue" => org_value}
    _put(path, payload)
  else
    raise ArgumentError, "Argument 'org_value' is not a String or nil"
  end
end

# REVIEW: Set a new org unit override value for a configuration variable.
def set_config_var_override_value(variable_id, org_unit_id, org_unit_value)
  path = "/d2l/api/lp/#{$lp_ver}/configVariables/#{variable_id}/values/orgUnits/#{org_unit_id}"
  if org_unit_value.is_a? String || org_unit_value.nil?
    payload = {"OrgUnitValue" => org_unit_value}
    _put(path, payload)
  else
    raise ArgumentError, "Argument 'org_unit_value' is not a String or nil"
  end
end

# REVIEW: Set a new role override value for a configuration variable.
def set_config_var_role_value(variable_id, role_id, role_value)
  path = "/d2l/api/lp/#{$lp_ver}/configVariables/#{variable_id}/values/roles/#{role_id}"
  if role_value.is_a? String || role_value.nil?
    payload = {"RoleValue" => role_value}
    _put(path, payload)
  else
    raise ArgumentError, "Argument 'role_value' is not a String or nil"
  end
end

# REVIEW: Set a new system value for a configuration variable.
def set_config_var_system_value(variable_id, system_value)
  path = "/d2l/api/lp/#{$lp_ver}/configVariables/#{variable_id}/values/system"
  if system_value.is_a?(String) || system_value.nil?
    payload = {"SystemValue" => system_value}
    _put(path, payload)
  else
    raise ArgumentError, "Argument 'system_value' is not a String or nil"
  end
end

########################
# RESOLVER:#############
########################
# NOTE: These provide a way to manage a configuration variable’s
#       resolution strategy.

# NOTE: UNSTABLE!!!
# TODO: UNSTABLE!!! --Restore the default resolution strategy for an org unit configuration variable.
def restore_default_org_unit_config_var_resolution(variable_id)
  # DELETE /d2l/api/lp/(version)/configVariables/(variableId)/resolver
end

# NOTE: UNSTABLE!!!
# REVIEW: Retrieve the resolution strategy for an org unit configuration variable.
def get_config_var_resolver(variable_id)
  path = "/d2l/api/lp/#{lp_ver}/configVariables/#{variable_id}/resolver"
  _get(path)
end

# NOTE: UNSTABLE!!!
# TODO: Update the resolution strategy for an org unit configuration variable.
def update_org_unit_config_var_resolution(resolver_value)
  # PUT /d2l/api/lp/(version)/configVariables/(variableId)/resolver
end

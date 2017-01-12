require_relative 'auth'

########################
# CONFIG VARIABLES:#####
########################
@debug = false

#Retrieve the definitions for all the configuration variables the user has access to view.
def get_all_config_var_definitions(search='', bookmark='')
  path = "/d2l/api/lp/#{$lp_ver}/configVariables/definitions/"
  path += "?search=#{search}" if search != ''
  path += "?bookmark=#{bookmark}" if bookmark != ''
  _get(path)
  #returns paged result set of Definition JSON data blocks
end

#Retrieve the definitions for a configuration variable.
def get_config_var_definitions(variable_id)
  path = "/d2l/api/lp/#{$lp_ver}/configVariables/(#{variable_id}/definition"
  _get(path)
  # returns Definition JSON data block
end

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

def get_config_var_resolver(variable_id)
  path = "/d2l/api/lp/#{lp_ver}/configVariables/#{variable_id}/resolver"
  _get(path)
end

require_relative "requests"
########################
# Org Units:############
########################
def get_org_unit_descendants(org_unit_id)
    path = "/d2l/api/lp/#{$version}/orgstructure/" + org_unit_id.to_s + '/descendants/'
    _get(path)
    # return json of org_unit descendants
end

def get_org_unit_parents(org_unit_id)
    path = "/d2l/api/lp/#{$version}/orgstructure/" + org_unit_id.to_s + '/parents/'
    _get(path)
    # return json of org_unit parents
end

def get_org_unit_children(org_unit_id)
    path = "/d2l/api/lp/#{$version}/orgstructure/" + org_unit_id.to_s + '/children/'
    _get(path)
    # return json of org_unit children
end

def get_org_unit_properties(org_unit_id)
    path = "/d2l/api/lp/#{$version}/orgstructure/" + org_unit_id.to_s
    _get(path)
    # return json of org_unit properties
end

def add_child_org_unit(org_unit_id, child_org_unit_id)
    path = "/d2l/api/lp/#{$version}/orgstructure/#{org_unit_id}/children/"
    _post(path, child_org_unit_id)
end

def recycle_org_unit(org_unit_id)
    path = "/d2l/api/lp/#{$version}/orgstructure/recyclebin/#{org_unit_id}/recycle"
    _post(path, {})
end
#Functions considered for basic added functionality to api, not sure if needed.
=begin
def create_custom_orgunit
    # POST /d2l/api/lp/(version)/orgstructure/
    payload = {
      "Identifier" =>...
  }
end

def update_orgunit
    # PUT /d2l/api/lp/(version)/orgstructure/(orgUnitId)
end
=end
def get_organization_info
    path = "/d2l/api/lp/#{$version}/organization/info"
    _get(path)
end

def get_outype(outype_id)
    path = "/d2l/api/lp/#{$version}/outypes/" + outype_id
    _get(path)
end

def get_all_outypes
    path = "/d2l/api/lp/#{$version}/outypes/"
    _get(path)
end

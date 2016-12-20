require_relative "requests"
########################
# Org Units:############
########################

# gets all descendents of a particular org unit, as referenced by the
# "org_unit_id" argument. A get request is then performed by a preformatted
# path.
def get_org_unit_descendants(org_unit_id)
    path = "/d2l/api/lp/#{$version}/orgstructure/" + org_unit_id.to_s + '/descendants/'
    _get(path)
    # return json of org_unit descendants
end

# gets all parents of a particular org unit, as referenced by the
# "org_unit_id" argument. A get request is then performed by a preformatted
# path.
def get_org_unit_parents(org_unit_id)
    path = "/d2l/api/lp/#{$version}/orgstructure/" + org_unit_id.to_s + '/parents/'
    _get(path)
    # return json of org_unit parents
end

# gets all children of a particular org unit, as referenced by the
# "org_unit_id" argument. A get request is then performed by a preformatted
# path.
def get_org_unit_children(org_unit_id)
    path = "/d2l/api/lp/#{$version}/orgstructure/" + org_unit_id.to_s + '/children/'
    _get(path)
    # return json of org_unit children
end

# gets all properties of a particular org unit, as referenced by the
# "org_unit_id" argument. A get request is then performed by a preformatted
# path.
def get_org_unit_properties(org_unit_id)
    path = "/d2l/api/lp/#{$version}/orgstructure/" + org_unit_id.to_s
    _get(path)
    # return json of org_unit properties
end

# Adds a child to the org unit by using org_unit_id to reference the soon-to-be
# parent of the child_org_unit and referencing the soon-to-be child through the
# child_org_unit_id argument. Then, a path is created to reference the children
# of the soon-to-be parent and executing a post http method that adds the child.
#
# TL;DR, this adds a child org_unit to the children of an org_unit.
def add_child_org_unit(org_unit_id, child_org_unit_id)
    path = "/d2l/api/lp/#{$version}/orgstructure/#{org_unit_id}/children/"
    _post(path, child_org_unit_id)
end

# An org unit is recycled by executing a POST http method and recycling it. The
# path for the recycling is created using the org_unit_id argument and then the
# post method is executed afterwards.
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

# Retrieves the organization info. Only gets a small amount of information,
# but may be useful in some instances.
def get_organization_info
    path = "/d2l/api/lp/#{$version}/organization/info"
    _get(path)
end

# This retrieves information about a partituclar org unit type, referenced via
# the outype_id argument. This is then returned as a JSON object.
def get_outype(outype_id)
    path = "/d2l/api/lp/#{$version}/outypes/" + outype_id
    _get(path)
end

# retrieves all outypes that are known and visible. This is returned as a JSON
# array of orgunittype data blocks.
def get_all_outypes
    path = "/d2l/api/lp/#{$version}/outypes/"
    _get(path)
end

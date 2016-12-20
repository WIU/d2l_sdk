require_relative 'requests'
########################
# Org Units:############
########################

# gets all descendents of a particular org unit, as referenced by the
# "org_unit_id" argument. A get request is then performed by a preformatted
# path.
def get_org_unit_descendants(org_unit_id)
    path = "/d2l/api/lp/#{$version}/orgstructure/#{org_unit_id}/descendants/"
    _get(path)
    # return json of org_unit descendants
end

def get_paged_org_unit_descendants(org_unit_id)
    path = "/d2l/api/lp/#{$version}/orgstructure/#{org_unit_id}/descendants/paged/"
    _get(path)
    # return json of org_unit descendants
end

# gets all parents of a particular org unit, as referenced by the
# "org_unit_id" argument. A get request is then performed by a preformatted
# path.
def get_org_unit_parents(org_unit_id)
    path = "/d2l/api/lp/#{$version}/orgstructure/#{org_unit_id}/parents/"
    _get(path)
    # return json of org_unit parents
end

def add_parent_to_org_unit(parent_ou_id, child_ou_id)
    # Must follow structure of data
    # (course <-- semester <== org -->custom dept--> dept -->templates--> courses)
    # Refer to valence documentation for further structural understanding..
    path = "/d2l/api/lp/#{$version}/orgstructure/#{child_ou_id}/parents/"
    _post(path, parent_ou_id)
    # return json of org_unit parents
end

def get_org_unit_ancestors(org_unit_id)
    path = "/d2l/api/lp/#{$version}/orgstructure/#{org_unit_id}/ancestors/"
    _get(path)
    # return json of org_unit parents
end

# gets all children of a particular org unit, as referenced by the
# "org_unit_id" argument. A get request is then performed by a preformatted
# path.
def get_org_unit_children(org_unit_id)
    path = "/d2l/api/lp/#{$version}/orgstructure/#{org_unit_id}/children/"
    _get(path)
    # return json of org_unit children
end

def get_paged_org_unit_children(org_unit_id)
    path = "/d2l/api/lp/#{$version}/orgstructure/#{org_unit_id}/children/paged/"
    _get(path)
    # return json of org_unit children
end

# gets all properties of a particular org unit, as referenced by the
# "org_unit_id" argument. A get request is then performed by a preformatted
# path.
def get_org_unit_properties(org_unit_id)
    path = "/d2l/api/lp/#{$version}/orgstructure/#{org_unit_id}"
    _get(path)
    # return json of org_unit properties
end

def delete_relationship_of_child_with_parent(parent_ou_id, child_ou_id)
    path = "/d2l/api/lp/#{$version}/orgstructure/#{parent_ou_id}/children/#{child_ou_id}"
    _delete(path)
end

def delete_relationship_of_parent_with_child(parent_ou_id, child_ou_id)
    path = "/d2l/api/lp/#{$version}/orgstructure/#{child_ou_id}/parents/#{parent_ou_id}"
    _delete(path)
end

def get_all_childless_org_units
    path = "/d2l/api/lp/#{$version}/orgstructure/childless/"
    _get(path)
    # ONLY RETRIEVES FIRST 100
end

def get_all_orphans
    path = "/d2l/api/lp/#{$version}/orgstructure/orphans/"
    _get(path)
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

def get_recycled_org_units
    path = "/d2l/api/lp/#{$version}/orgstructure/recyclebin/"
    _get(path)
    # GETS ONLY FIRST 100
end

# An org unit is recycled by executing a POST http method and recycling it. The
# path for the recycling is created using the org_unit_id argument and then the
# post method is executed afterwards.
def recycle_org_unit(org_unit_id)
    path = "/d2l/api/lp/#{$version}/orgstructure/recyclebin/#{org_unit_id}/recycle"
    _post(path, {})
end

def delete_recycled_org_unit(org_unit_id)
    path = "/d2l/api/lp/#{$version}/orgstructure/recyclebin/#{org_unit_id}"
    _delete(path)
end

def restore_recycled_org_unit(org_unit_id)
    path = "/d2l/api/lp/#{$version}/orgstructure/recyclebin/#{org_unit_id}/restore"
    _post(path, {})
end

# Functions considered for basic added functionality to api, not sure if needed.
def create_custom_org_unit(org_unit_data)
    # Requires the type to have the correct parent. This will work fine in this
    # sample, as the department (101) can have the parent Organiation (6606)
    payload = { 'Type' => 101, # Number:D2LID
                'Name' => 'custom_ou_name', # String
                'Code' => 'custom_ou_code', # String
                'Parents' => [6606], # Number:D2LID
              }.merge!(org_unit_data)
    path = "/d2l/api/lp/#{$version}/orgstructure/"
    _post(path, payload)
end

def update_org_unit(org_unit_id, org_unit_data)
    previous_data = get_org_unit_properties(org_unit_id)
    payload = { # Can only update NAME, CODE, and PATH variables
        'Identifier' => org_unit_id.to_s, # String: D2LID // DO NOT CHANGE
        'Name' => previous_data['Name'], # String
        # String #YearNUM where NUM{sp:01,su:06,fl:08}  | nil
        'Code' => previous_data['Code'],
        # String: /content/enforced/IDENTIFIER-CODE/
        'Path' => "/content/enforced/#{org_unit_id}-#{previous_data['Code']}/",
        'Type' => previous_data['Type']
        # example:
        # { # DO NOT CHANGE THESE
        #    'Id' => 5, # <number:D2LID>
        #    'Code' => 'Semester', # <string>
        #    'Name' => 'Semester', # <string>
        # }
    }.merge!(org_unit_data)
    path = "/d2l/api/lp/#{$version}/orgstructure/#{org_unit_id}"
    puts '[-] Attempting put request (updating orgunit)...'
    _put(path, payload)
    puts '[+] Semester update completed successfully'.green
end

# Retrieves the organization info. Only gets a small amount of information,
# but may be useful in some instances.
def get_organization_info
    path = "/d2l/api/lp/#{$version}/organization/info"
    _get(path)
end

def get_all_org_units_by_type_id(outype_id)
  path = "/d2l/api/lp/#{$version}/orgstructure/6606/children/?ouTypeId=#{outype_id}"
  _get(path)
end

# This retrieves information about a partituclar org unit type, referenced via
# the outype_id argument. This is then returned as a JSON object.
def get_outype(outype_id)
    path = "/d2l/api/lp/#{$version}/outypes/#{outype_id}"
    _get(path)
end

# retrieves all outypes that are known and visible. This is returned as a JSON
# array of orgunittype data blocks.
def get_all_outypes
    path = "/d2l/api/lp/#{$version}/outypes/"
    _get(path)
end

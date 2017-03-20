require_relative 'requests'
require 'json-schema'
########################
# GRADES:###############
########################

# TODO: Delete a specific grade object for a particular org unit.
# Return: nil
def delete_org_unit_grade_object(org_unit_id, grade_object_id)
  # TODO
end

# REVIEW: Retrieve all the current grade objects for a particular org unit.
# Return: This action returns a JSON array of GradeObject blocks.
def get_org_unit_grades(org_unit_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/grades/"
  _get(path)
  # RETURN: This action returns a JSON array of GradeObject blocks.
end

# REVIEW: Retrieve a specific grade object for a particular org unit.
# Return: This action returns a GradeObject JSON block.
def get_org_unit_grade_object(org_unit_id, grade_object_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/grades/#{grade_object_id}"
  _get(path)
  # RETURN: This action returns a GradeObject JSON block.
end

# TODO: Create a new grade object for a particular org unit.
# Return: This action returns a GradeObject JSON block for the grade object
# that the service just created, so you can quickly retrieve the grade object ID
def create_org_unit_grade_object(org_unit_id, grade_object)
  # TODO
  # NOTE: must be grade object of type numeric, passfail, selectbox, or text
  # NOTE: the name must be unique!
  # Return: This action returns a GradeObject JSON block for the grade object
  # that the service just created, so you can quickly retrieve the grade object
  # ID
end

# TODO: Update a specific grade object.
def update_org_unit_grade_object(org_unit_id, grade_object)
  # NOTE: if new name, it must be Unique
  # NOTE: must be grade object of type numeric, passfail, selectbox, or text
  # TODO
  # Return: This action returns a GradeObject JSON block for the grade object
  # that the service just updated.
end

########################
# GRADE CATEGORIES:#####
########################

# TODO: Delete a specific grade category for a provided org unit.
def delete_org_unit_grade_category(org_unit_id, category_id)
  # TODO
end

# REVIEW: Retrieve a list of all grade categories for a provided org unit.
# Return: This action retrieves a JSON array of GradeObjectCategory blocks.
def get_org_unit_grade_categories(org_unit_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/grades/categories/"
  _get(path)
  # Return: This action retrieves a JSON array of GradeObjectCategory blocks.
end

# REVIEW: Retrieve a specific grade category for a provided org unit.
# Return: This action retrieves a GradeObjectCategory JSON block.
def get_org_unit_grade_category(org_unit_id, category_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/categories/#{category_id}"
  _get(path)
  # Return: This action retrieves a GradeObjectCategory JSON block.
end

# TODO: Create a new grade category for a provided org unit.
# Return. This action returns the newly created grade object category in a
# GradeObjectCategory JSON block, so that you can quickly gather its grade
# category ID.
def create_org_unit_grade_category(org_unit_id, grade_category_data)
  # TODO
  # Return. This action returns the newly created grade object category in a
  # GradeObjectCategory JSON block, so that you can quickly gather its grade
  # category ID.
end

########################
# GRADE SCHEMES:########
########################

# REVIEW: Retrieve all the grade schemes for a provided org unit.
# Return: This action returns a JSON array of GradeScheme blocks.
def get_org_unit_grade_schemes(org_unit_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/grades/schemes/"
  _get(path)
  # Return: This action returns a JSON array of GradeScheme blocks.
end

# REVIEW: Retrieve a particular grade scheme.
# Return: This action returns a GradeScheme JSON block.
def get_org_unit_grade_scheme(org_unit_id, grade_scheme_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/grades/schemes/#{grade_scheme_id}"
  _get(path)
  # Return: This action returns a GradeScheme JSON block.
end

########################
# GRADE VALUES:#########
########################

# REVIEW: Retrieve the final grade value for the current user context.
# Return: This action returns a GradeValue JSON block containing the final
# calculated grade value for the current user context.
def get_current_user_final_grade(org_unit_id)
 path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/grades/final/values/myGradeValue"
 _get(path)
 # Return: This action returns a GradeValue JSON block containing the final
 # calculated grade value for the current user context.
end

# TODO: Retrieve a list of final grade values for the current user
# context across a number of org units.
# -INPUT: Input. When calling this action, you must provide a list of org unit
# IDs that amount to some or all of the calling user’s active enrollments.
# -RETURN: This action returns an ObjectListPage JSON block containing a list of
# final calculated grade values sorted by the OrgUnitIds that match the provided
# query parameter filters.
def get_current_user_final_grades(org_unit_ids_csv)
  # TODO
  # RETURN: This action returns an ObjectListPage JSON block containing a list
  # of final calculated grade values sorted by the OrgUnitIds that match the
  # provided query parameter filters.
end

# REVIEW: Retrieve the final grade value for a particular user.
# INPUT: grade_type is an optional parameter. Forces grade to be returned as a certain
# grade type, such as calculated or adjusted.
# Return: This action returns a GradeValue JSON block containing the final
# calculated grade value for the provided user.
def get_user_final_grade(org_unit_id, user_id, grade_type = '')
  path = "/d2l/api/le/#{le_ver}/#{org_unit_id}/grades/final/values/#{user_id}"
  path += "?gradeType=#{grade_type}" if grade_type != ''
  _get(path)
  # Return: This action returns a GradeValue JSON block containing the final
  # calculated grade value for the provided user.
end

# REVIEW: Retrieve each user’s grade value for a particular grade object.
# INPUT: sort = string, page_size = number, is_graded = boolean, search_text = string
# RETURN: This action returns an ObjectListPage JSON block containing a list
# of user grade values for your provided grade object.
def get_all_grade_object_grades(org_unit_id, grade_object_id, sort = '',
                                page_size = 0, is_graded = nil, search_text = '')
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/grades/#{grade_object_id}/values/"
  path += "?"
  path += "sort=#{sort}&" if sort != ''
  path += "pageSize=#{page_size}&" if page_size != 0
  path += "isGraded=#{is_graded}&" if is_graded != nil
  path += "searchText=#{search_text}" if search_text != ''
  _get(path)
  # RETURN: This action returns an ObjectListPage JSON block containing a list
  # of user grade values for your provided grade object.
end

# REVIEW: Retrieve a specific grade value for the current user context assigned
# in a particular org unit.
# RETURN: This action returns a GradeValue JSON block.
def get_user_grade_object_grade(org_unit_id, grade_object_id, user_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/grades/#{grade_object_id}/values/#{user_id}"
  _get(path)
  # RETURN: This action returns a GradeValue JSON block.
end

# REVIEW: Retrieve all the grade objects for the current user context assigned
# in a particular org unit.
def get_current_user_org_unit_grades(org_unit_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/grades/values/myGradeValues/"
  _get(path)
  # RETURN: This action returns a JSON array of GradeValue blocks.
end

# REVIEW: Retrieve all the grade objects for a particular user assigned in an org unit.
def get_user_org_unit_grades(org_unit_id, user_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/grades/values/#{user_id}/"
  _get(path)
  # RETURN: This action returns a JSON array of GradeValue blocks.
end

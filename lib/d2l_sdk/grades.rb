require_relative 'requests'
require 'json-schema'
########################
# GRADES:###############
########################

# REVIEW: Delete a specific grade object for a particular org unit.
# Return: nil
def delete_org_unit_grade_object(org_unit_id, grade_object_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/grades/#{grade_object_id}"
  _delete(path)
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
  # POST /d2l/api/le/(version)/(orgUnitId)/grades/
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
  # PUT /d2l/api/le/(version)/(orgUnitId)/grades/(gradeObjectId)
  # Return: This action returns a GradeObject JSON block for the grade object
  # that the service just updated.
end

########################
# GRADE CATEGORIES:#####
########################

# REVIEW: Delete a specific grade category for a provided org unit.
def delete_org_unit_grade_category(org_unit_id, category_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/grades/categories/#{category_id}"
  _delete(path)
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
  # POST /d2l/api/le/(version)/(orgUnitId)/grades/
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

########################
# GRADE VALUES:#########
########################

# REVIEW: Delete a course completion.
# RETURNS: nil
def delete_course_completion(org_unit_id, completion_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/grades/courseCompletion/#{completion_id}"
  _delete(path)
end

# REVIEW: Retrieve all the course completion records for an org unit.
# RETURNS: This action returns a paged result set containing the resulting
# CourseCompletion data blocks for the segment following your bookmark
# parameter (or the first segment if the parameter is empty or missing).
def get_org_unit_completion_records(org_unit_id, user_id = 0, start_expiry = '',
                                    end_expiry = '', bookmark = '')
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/grades/courseCompletion/"
  path += "?"
  path += "userId=#{user_id}&" if user_id != 0
  path += "startExpiry=#{start_expiry}&" if startExpiry != ''
  path += "endExpiry=#{end_expiry}&" if endExpiry != ''
  path += "bookmark=#{bookmark}" if bookmark != ''
  _get(path)
  # RETURNS: This action returns a paged result set containing the resulting
  # CourseCompletion data blocks for the segment following your bookmark
  # parameter (or the first segment if the parameter is empty or missing).
end

# REVIEW: Retrieve all the course completion records for a user.
# RETURNS: This action returns a paged result set containing the resulting
# CourseCompletion data blocks for the segment following your bookmark
# parameter (or the first segment if the parameter is empty or missing).
def get_user_completion_records(user_id, start_expiry = '', end_expiry = '',
                                bookmark = '')
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/grades/courseCompletion/"
  path += "?"
  path += "startExpiry=#{start_expiry}&" if startExpiry != ''
  path += "endExpiry=#{end_expiry}&" if endExpiry != ''
  path += "bookmark=#{bookmark}" if bookmark != ''
  _get(path)
  # RETURNS: This action returns a paged result set containing the resulting
  # CourseCompletion data blocks for the segment following your bookmark
  # parameter (or the first segment if the parameter is empty or missing).
end

# TODO: Create a new course completion for an org unit.
# RETURNS: a CourseCompletion JSON block with the newly created course completion record.
def create_course_completion(org_unit_id, course_completion_data)
  #CourseCompletionCreationData JSON data block example:
  # {"UserId" => 0,
  # "CompletedDate" => "UTCDateTime",
  # "ExpiryDate" => "UTCDateTime" || nil}
  # POST /d2l/api/le/(version)/(orgUnitId)/grades/courseCompletion/
end

# TODO: Update an existing course completion.
# RETURNS: a CourseCompletion JSON block with the newly created course completion record.
def update_course_completion(org_unit_id, completion_id, course_completion_data)
  # CourseCompletionUpdateData JSON data block example:
  # {"CompletedDate" => "UTCDateTime",
  # "ExpiryDate" => "UTCDateTime" || nil}
  # PUT /d2l/api/le/(version)/(orgUnitId)/grades/courseCompletion/(completionId)
end

########################
# GRADE STATISTICS:#####
########################

# REVIEW: Get statistics for a specified grade item.
# RETURNS: a GradeStatisticsInfo JSON block.
def get_grade_item_statistics(org_unit_id, grade_object_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/grades/#{grade_object_id}/statistics"
  _get(path)
  # RETURNS: a GradeStatisticsInfo JSON block.
end

########################
# GRADE SETUP:##########
########################

# REVIEW: Retrieve the grades configuration for the org unit.
# RETURNS: a GradeSetupInfo JSON block.
def get_org_unit_grade_config(org_unit_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/grades/setup/"
  _get(path)
  # RETURNS: a GradeSetupInfo JSON block.
end

# TODO: Update the grades configuration for the org unit.
# INPUT: a GradeSetupInfo JSON block. (grade_setup_info)
# RETURNS: a GradeSetupInfo JSON block.
def update_org_unit_grade_config(org_unit_id, grade_setup_info)
  # Grade.GradeSetupInfo JSON data block example:
  # {"GradingSystem" => "Points", # Other types: "Weighted", "Formula"
  # "IsNullGradeZero" => false,
  # "DefaultGradeSchemeId" => 0}
  # PUT /d2l/api/le/(version)/(orgUnitId)/grades/setup/
  # RETURNS: a GradeSetupInfo JSON block.
end

########################
# GRADE EXEMPTIONS:#####
########################

# REVIEW: Retrieve all the exempt users for a provided grade.
# RETURNS: a JSON array of User blocks.
def get_grade_exempt_users(org_unit_id, grade_object_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/grades/#{grade_object_id}/exemptions/"
  _get(path)
  # RETURNS: a JSON array of User blocks.
end

# REVIEW: Determine if a user is exempt from a grade.
# RETURNS: a User JSON block.
def get_is_user_exempt(org_unit_id, grade_object_id, user_id)
  path = "GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/grades/#{grade_object_id}/exemptions/#{user_id}"
  _get(path)
  # RETURNS: a User JSON block.
end

# REVIEW: Exempt a user from a grade.
# RETURNS: a User JSON block.
def exempt_user_from_grade(org_unit_id, grade_object_id, user_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/grades/#{grade_object_id}/exemptions/#{user_id}"
  _post(path, {})
  # RETURNS: a User JSON block.
end

# REVIEW: Remove a user’s exemption from a grade.
# RETURNS: nil
def remove_user_grade_exemption(org_unit_id, grade_object_id, user_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/grades/#{grade_object_id}/exemptions/#{user_id}"
  _delete(path)
  # RETURNS: nil
end

#############################
# BULK GRADE EXEMPTIONS:#####
#############################

# REVIEW: Retrieve all the grade objects for a provided user in a provided org unit with exemption status included.
# RETURNS: BulkGradeObjectExemptionResult JSON block.
def get_user_grade_exemptions(org_unit_id, user_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/grades/exemptions/#{user_id}"
  _get(path)
  # RETURNS: BulkGradeObjectExemptionResult JSON block.
end

# TODO: Attempt to exempt or unexempt a set of grades for a user.
# INPUT: a BulkGradeObjectExemptionUpdate.
# NOTE: If a grade has been changed since the provided ExemptionAccessDate,
#       a conflict will be added to the result set and that grade will not
#       be exempted or unexempted.
# RETURNS: a JSON array of BulkGradeObjectExemptionConflict blocks.
def bulk_grade_exemption_update(org_unit_id, user_id, bulk_grade_exmption_update_block)
  # Grade.BulkGradeObjectExemptionUpdate JSON data block example:
  # {"ExemptedIds" => [0,1,2,3], # D2LIDs
  # "UnexemptedIds" => [0,1,2,3], # D2LIDs
  # "ExemptionAccessDate" => 'UTCDateTime'}

  # POST /d2l/api/le/(version)/(orgUnitId)/grades/exemptions/(userId)
  # RETURNS: a JSON array of BulkGradeObjectExemptionConflict blocks.
end

###################
# ASSESSMENTS:#####
###################

# TODO: --UNSTABLE-- Retrieve rubrics for an object in an org unit.
# RETURNS: a JSON array of Rubric blocks.
def get_org_unit_rubrics(org_unit_id, object_type, object_id)
  # GET /d2l/api/le/(version)/(orgUnitId)/rubrics
  # RETURNS: a JSON array of Rubric blocks.
end

# TODO: --UNSTABLE-- Retrieve an assessment in an org unit.
# RETURNS: a RubricAssessment JSON structure.
def get_org_unit_assessment(org_unit_id, assessment_type, object_type, object_id, user_id)
  # GET /d2l/api/le/(version)/(orgUnitId)/assessment
  # RETURNS: a RubricAssessment JSON structure.
end

# TODO: --UNSTABLE-- Update an assessment in an org unit.
# RETURNS: value of the assessment in a RubricAssessment JSON structure.
def update_org_unit_assessment(org_unit_id, assessment_type, object_type, object_id, user_id)
  # PUT /d2l/api/le/(version)/(orgUnitId)/assessment
  # RETURNS: value of the assessment in a RubricAssessment JSON structure.
end

require_relative 'requests'
require 'json-schema'

##################
## ACTIONS: ######
##################

# REVIEW: Retrieve all dropbox folders for an org unit.
# => GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/
def get_org_unit_dropbox_folders(org_unit_id, only_current_students_and_groups = nil)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/"
  path += "?onlyCurrentStudentsAndGroups=#{only_current_students_and_groups}" if only_current_students_and_groups == true || only_current_students_and_groups == false
  _get(path)
end

# REVIEW: Retrieve a specific dropbox folder.
# => GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}
def get_dropbox_folder(org_unit_id, folder_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}"
  _get(path)
end

# REVIEW: Retrieve a file attachment (identified by file ID) from a specific dropbox folder.
# => GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/attachments/#{file_id}
def get_dropbox_file_attachment(org_unit_id, folder_id, file_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/attachments/#{file_id}"
  _get(path)
end

# TODO: Create a new dropbox folder in an org unit.
# => POST /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/
# TODO: Update a particular dropbox folder in an org unit.
# => PUT /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}

# REVIEW: Retrieve a list of org units for which the current user context has an
#       assessment role on their dropbox folders (can see submissions and provide feedback).
# => GET /d2l/api/le/#{$le_ver}/dropbox/orgUnits/feedback/
def get_current_user_assessable_folders(type = nil)
  path = "/d2l/api/le/#{$le_ver}/dropbox/orgUnits/feedback/"
  path += "?type=#{type}" if type == 0 || type == 1
  _get(path)
end


##################
## SUBMISSIONS: ##
##################

# REVIEW: Retrieve all the submissions for a specific dropbox folder.
# => GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/submissions/
def get_dropbox_folder_submissions(org_unit_id, folder_id, active_only = nil)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/submissions/"
  path += "?activeOnly=#{active_only}" if active_only == true || active_only == false
  _get(path)
end

# REVIEW: Retrieve one of the files included in a submission for a particular dropbox folder.
# => GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/submissions/#{submission_id}/files/#{file_id}
def get_dropbox_submission_file(org_unit_id, folder_id, submission_id, file_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/submissions/#{submission_id}/files/#{file_id}"
  _get(path)
end

# TODO: Post a new group submission to a particular dropbox folder.
# => POST /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/submissions/group/(groupId)
# TODO: Post a new submission for the current user context to a particular dropbox folder.
# => POST /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/submissions/mysubmissions/
# TODO: Mark a submitted file as read.
# => POST /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/submissions/#{submission_id}/files/#{file_id}/markAsRead

##################
## FEEDBACK: #####
##################

# TODO: Remove a particular file attachment from an entity’s feedback entry within a specified dropbox folder.
# => DELETE /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/feedback/#{entity_type}/(entityId)/attachments/#{file_id}

# REVIEW: Retrieve the feedback entry from a dropbox folder for the provided entity.
# => GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/feedback/#{entity_type}/(entityId)
def get_dropbox_folder_entity_feedback_entry(org_unit_id, folder_id, entity_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/feedback/#{entity_type}/(entityId)"
  _get(path)
end

# REVIEW: Retrieve a feedback entry’s file attachment from a dropbox folder for the provided entity.
# => GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/feedback/#{entity_type}/(entityId)/attachments/#{file_id}
def get_feedback_entry_file_attachment(org_unit_id, folder_id, entity_id, file_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/feedback/#{entity_type}/(entityId)/attachments/#{file_id}"
  _get(path)
end

# TODO: Post feedback (without attachment) for a particular submission in a specific dropbox folder.
# => POST /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/feedback/#{entity_type}/(entityId)
# TODO: Attach an uploaded file to a particular entity’s feedback entry in a specific dropbox folder.
# => POST /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/feedback/#{entity_type}/(entityId)/attach
# TODO: Initiate a resumable file upload request for a particular entity’s feedback for a specific dropbox folder.
# => POST /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/feedback/#{entity_type}/(entityId)/upload

##########################
## FOLDER CATEGORIES: ####
##########################

# REVIEW: Retrieve all dropbox folder categories for the provided org unit.
# => GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/categories/
def get_dropbox_folder_categories(org_unit_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/categories/"
  _get(path)
end

# REVIEW: Retrieve the information for a specific dropbox folder category.
# => GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/categories/#{category_id}
def get_dropbox_folder_category_info(org_unit_id, category_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/categories/#{category_id}"
  _get(path)
end

# TODO: Create a new dropbox folder category for the provided org unit.
# => POST /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/categories/
# TODO: Update the information for a specific dropbox folder category.
# => PUT /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/categories/#{category_id}

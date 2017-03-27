require_relative 'requests'
require 'json-schema'

##################
## ACTIONS: ######
##################

# TODO: Retrieve all dropbox folders for an org unit.
# => GET /d2l/api/le/(version)/(orgUnitId)/dropbox/folders/
# TODO: Retrieve a specific dropbox folder.
# => GET /d2l/api/le/(version)/(orgUnitId)/dropbox/folders/(folderId)
# TODO: Retrieve a file attachment (identified by file ID) from a specific dropbox folder.
# => GET /d2l/api/le/(version)/(orgUnitId)/dropbox/folders/(folderId)/attachments/(fileId)
# TODO: Create a new dropbox folder in an org unit.
# => POST /d2l/api/le/(version)/(orgUnitId)/dropbox/folders/
# TODO: Update a particular dropbox folder in an org unit.
# => PUT /d2l/api/le/(version)/(orgUnitId)/dropbox/folders/(folderId)
# TODO: Retrieve a list of org units for which the current user context has an
#       assessment role on their dropbox folders (can see submissions and provide feedback).
# => GET /d2l/api/le/(version)/dropbox/orgUnits/feedback/

##################
## SUBMISSIONS: ##
##################

# TODO: Retrieve all the submissions for a specific dropbox folder.
# => GET /d2l/api/le/(version)/(orgUnitId)/dropbox/folders/(folderId)/submissions/
# TODO: Retrieve one of the files included in a submission for a particular dropbox folder.
# => GET /d2l/api/le/(version)/(orgUnitId)/dropbox/folders/(folderId)/submissions/(submissionId)/files/(fileId)
# TODO: Post a new group submission to a particular dropbox folder.
# => POST /d2l/api/le/(version)/(orgUnitId)/dropbox/folders/(folderId)/submissions/group/(groupId)
# TODO: Post a new submission for the current user context to a particular dropbox folder.
# => POST /d2l/api/le/(version)/(orgUnitId)/dropbox/folders/(folderId)/submissions/mysubmissions/
# TODO: Mark a submitted file as read.
# => POST /d2l/api/le/(version)/(orgUnitId)/dropbox/folders/(folderId)/submissions/(submissionId)/files/(fileId)/markAsRead

##################
## FEEDBACK: #####
##################

# TODO: Remove a particular file attachment from an entity’s feedback entry within a specified dropbox folder.
# => DELETE /d2l/api/le/(version)/(orgUnitId)/dropbox/folders/(folderId)/feedback/(entityType)/(entityId)/attachments/(fileId)
# TODO: Retrieve the feedback entry from a dropbox folder for the provided entity.
# => GET /d2l/api/le/(version)/(orgUnitId)/dropbox/folders/(folderId)/feedback/(entityType)/(entityId)
# TODO: Retrieve a feedback entry’s file attachment from a dropbox folder for the provided entity.
# => GET /d2l/api/le/(version)/(orgUnitId)/dropbox/folders/(folderId)/feedback/(entityType)/(entityId)/attachments/(fileId)
# TODO: Post feedback (without attachment) for a particular submission in a specific dropbox folder.
# => POST /d2l/api/le/(version)/(orgUnitId)/dropbox/folders/(folderId)/feedback/(entityType)/(entityId)
# TODO: Attach an uploaded file to a particular entity’s feedback entry in a specific dropbox folder.
# => POST /d2l/api/le/(version)/(orgUnitId)/dropbox/folders/(folderId)/feedback/(entityType)/(entityId)/attach
# TODO: Initiate a resumable file upload request for a particular entity’s feedback for a specific dropbox folder.
# => POST /d2l/api/le/(version)/(orgUnitId)/dropbox/folders/(folderId)/feedback/(entityType)/(entityId)/upload

##########################
## FOLDER CATEGORIES: ####
##########################

# TODO: Retrieve all dropbox folder categories for the provided org unit.
# => GET /d2l/api/le/(version)/(orgUnitId)/dropbox/categories/
# TODO: Retrieve the information for a specific dropbox folder category.
# => GET /d2l/api/le/(version)/(orgUnitId)/dropbox/categories/(categoryId)
# TODO: Create a new dropbox folder category for the provided org unit.
# => POST /d2l/api/le/(version)/(orgUnitId)/dropbox/categories/
# TODO: Update the information for a specific dropbox folder category.
# => PUT /d2l/api/le/(version)/(orgUnitId)/dropbox/categories/(categoryId)

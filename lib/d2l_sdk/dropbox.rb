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

def check_dropbox_folder_update_data_validity(dropbox_folder_update_data)
    schema = {
        'type' => 'object',
        'required' => %w(CategoryId Name CustomInstructions Availability
                         GroupTypeId DueDate DisplayInCalendar NotificationEmail),
        'properties' =>
        {
            'CategoryId' => { 'type' => %w(integer null) },
            'Name' => { 'type' => 'string' },
            'CustomInstructions' =>
            {
              'type' => 'object',
              'properties' =>
                {
                    'Content' => { 'type' => 'string' },
                    'Type' => { 'type' => 'string' } # either 'Text' or 'HTML'
                }
            },
            'Availability' =>
            {
                'type' => ['object', "null"],
                'properties' =>
                  {
                      'StartDate' => { 'type' => 'string' },
                      'EndDate' => { 'type' => 'string' }
                  }
            },
            'GroupTypeId' => { 'type' => %w(integer null) },
            'DueDate' => { 'type' => %w(string null) },
            'DisplayInCalendar' => { 'type' => 'boolean' },
            'NotificationEmail' => { 'type' => %w(string null) }
        }
    }
    JSON::Validator.validate!(schema, dropbox_folder_update_data, validate_schema: true)
end

# REVIEW: Create a new dropbox folder in an org unit.
# => POST /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/
def create_dropbox_folder(org_unit_id, dropbox_folder_update_data)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/"
  payload = {
    "CategoryId" => nil, # or a number
    "Name" => "string",
    "CustomInstructions" => {
      "Content" => "string",
      "Text" => "Text|HTML"
    },
    "Availability" => {
      "StartDate" => "string or nil", # or nil
      "EndDate" => "string or nil" # or nil
    },
    "GroupTypeId" => nil, # or a number
    "DueDate" => nil,
    "DisplayInCalendar" => false,
    "NotificationEmail" => nil # or a string --- Added in LE v1.21
  }.merge!(dropbox_folder_update_data)
  check_dropbox_folder_update_data_validity(payload)
  _post(path, payload)
  # RETURNS: DropboxFolder JSON block
end

# REVIEW: Update a particular dropbox folder in an org unit.
# => PUT /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}
def update_dropbox_folder(org_unit_id, dropbox_folder_update_data)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}"
  payload = {
    "CategoryId" => nil, # or a number
    "Name" => "string",
    "CustomInstructions" => {
      "Content" => "string",
      "Text" => "Text|HTML"
    },
    "Availability" => {
      "StartDate" => "string or nil", # or nil
      "EndDate" => "string or nil" # or nil
    },
    "GroupTypeId" => nil, # or a number
    "DueDate" => nil,
    "DisplayInCalendar" => false,
    "NotificationEmail" => nil # or a string --- Added in LE v1.21
  }.merge!(dropbox_folder_update_data)
  check_dropbox_folder_update_data_validity(payload)
  _put(path, payload)
  # RETURNS: DropboxFolder JSON block
end

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
# INPUT: multipart/mixed body should contain a JSON part encoding the submission’s descriptive comments
#        in RichText, followed by the submission file’s data.
def post_new_group_submission

end

# TODO: Post a new submission for the current user context to a particular dropbox folder.
# => POST /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/submissions/mysubmissions/
# INPUT: multipart/mixed body should contain a JSON part encoding the submission’s descriptive comments
#        in RichText, followed by the submission file’s data.
def post_current_user_new_submission

end

# REVIEW: Mark a submitted file as read.
# => POST /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/submissions/#{submission_id}/files/#{file_id}/markAsRead
# INPUT: "Provide an empty post body."
def mark_file_as_read(org_unit_id, folder_id, submission_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/submissions/#{submission_id}/files/#{file_id}/markAsRead"
  _post(path, {})
end

##################
## FEEDBACK: #####
##################

# REVIEW: Remove a particular file attachment from an entity’s feedback entry within a specified dropbox folder.
# => DELETE /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/feedback/#{entity_type}/#{entity_id}/attachments/#{file_id}
def remove_feedback_entry_file_attachment(org_unit_id, folder_id, entity_type, entity_id, file_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/feedback/#{entity_type}/#{entity_id}/attachments/#{file_id}"
  _delete(path)
end

# REVIEW: Retrieve the feedback entry from a dropbox folder for the provided entity.
# => GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/feedback/#{entity_type}/#{entity_id}
def get_dropbox_folder_entity_feedback_entry(org_unit_id, folder_id, entity_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/feedback/#{entity_type}/#{entity_id}"
  _get(path)
end

# REVIEW: Retrieve a feedback entry’s file attachment from a dropbox folder for the provided entity.
# => GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/feedback/#{entity_type}/#{entity_id}/attachments/#{file_id}
def get_feedback_entry_file_attachment(org_unit_id, folder_id, entity_id, file_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/feedback/#{entity_type}/#{entity_id}/attachments/#{file_id}"
  _get(path)
end

# TODO: Post feedback (without attachment) for a particular submission in a specific dropbox folder.
# => POST /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/feedback/#{entity_type}/#{entity_id}
# INPUT: Dropbox.DropboxFeedback
def post_feedback_without_attachment(org_unit_id, folder_id, entity_id, entity_type, dropbox_feedback)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/feedback/#{entity_type}/#{entity_id}"
  payload = {
    "Score" => 1,
    "Feedback" =>
    {
      "Text" => "String",
      "Html" => "String"
    },
    "RubricAssessments" =>
    [
      {
        "RubricId" => 0,
        "OverallScore" => nil, # or null
        "OverallFeedback" =>
        { # RICHTEXT
          "Text" => "String",
          "Html" => "String"
        },
        "OverallLevel" =>
        { # or null
          "LevelId" => 0,
          "Feedback" =>
          { # RICHTEXT
            "Text" => "String",
            "Html" => "String"
          }
        },
        "OverallScoreOverridden" => false,
        "OverallFeedbackOverridden" => false,
        "CriteriaOutcome" =>
        [ # Array of CriterionOutcome hashes
          { # Example CriterionOutcome hash. Set for merging as
            # it is assumed -at least- one is required.
            "CriterionId" => 0,
            "LevelId" => nil, # or a D2LID::Integer
            "Score" => nil, # or a decimal
            "ScoreIsOverridden" => false,
            "Feedback" =>
            { # RICHTEXT
              "Text" => "String",
              "Html" => "String"
            }, 
            "FeedbackIsOverridden" => false
          },
          # more CriterionOutcome hashes here! :D
        ]
      }
    ],
    "IsGraded" => false
  }.merge!(dropbox_feedback)
  # TODO: Create a schema to validate this payload against... :/
  _post(path, payload)
end

# TODO: Attach an uploaded file to a particular entity’s feedback entry in a specific dropbox folder.
# => POST /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/feedback/#{entity_type}/#{entity_id}/attach
def attach_file_to_feedback_entry

end

# TODO: Initiate a resumable file upload request for a particular entity’s feedback for a specific dropbox folder.
# => POST /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/folders/#{folder_id}/feedback/#{entity_type}/#{entity_id}/upload
def initiate_feedback_entry_file_upload

end

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

# REVIEW: Create a new dropbox folder category for the provided org unit.
# => POST /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/categories/
# INPUT: DropboxCategory JSON data block
# RETURNS: a single DropboxCategory block.
# NOTE: Few enough required values in the JSON data block,
#       so they can simply be passed as arguments and checked
#       for conformity by themselves.
def create_dropbox_folder_category(org_unit_id, dropbox_category_id, dropbox_category_name)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/categories/"
  # Check that the values conform to the JSON schema.
  if !dropbox_category_id.is_a? Numeric
    raise ArgumentError, "Argument 'dropbox_category_id' with value #{dropbox_category_id} is not an integer value."
  elsif !dropbox_category_name.is_a? String
    raise ArgumentError, "Argument 'dropbox_category_name' with value #{dropbox_category_name} is not a String value."
  end
  payload = {
    'Id' => dropbox_category_id,
    'Name' => dropbox_category_name
  }
  _post(path, payload)
end

# REVIEW: Update the information for a specific dropbox folder category.
# => PUT /d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/categories/#{category_id}
# INPUT: DropboxCategory JSON data block.
# RETURNS: a single DropboxCategory block.
def update_dropbox_folder_category(org_unit_id, category_id, dropbox_category_id, dropbox_category_name)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/dropbox/categories/#{category_id}"
  # Check that the values conform to the JSON schema.
  if !dropbox_category_id.is_a? Numeric
    raise ArgumentError, "Argument 'dropbox_category_id' with value #{dropbox_category_id} is not an integer value."
  elsif !dropbox_category_name.is_a? String
    raise ArgumentError, "Argument 'dropbox_category_name' with value #{dropbox_category_name} is not a String value."
  end
  payload = {
    'Id' => dropbox_category_id,
    'Name' => dropbox_category_name
  }
  _put(path, payload)
end
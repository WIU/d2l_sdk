
########################
### CONTENT ACTIONS#####
########################

# Delete a specific module from an org unit.
def delete_module(org_unit_id, module_id) # DELETE
  query_string = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/content/modules/#{module_id}"
  _delete(query_string)
end

# Delete a specific topic from an org unit.
def delete_topic(org_unit_id, topic_id) # DELETE
  query_string = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/content/topics/#{topic_id}"
  _delete(query_string)
end

# Retrieve a specific module for an org unit.
# Returns ContentObject JSON data block of type Module
def get_module(org_unit_id, module_id) # GET
  query_string = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/content/modules/#{module_id}"
  _get(query_string)
end

# Retrieve the structure for a specific module in an org unit.
# Returns JSON array of ContentObject data blocks (either Module or Topic)
def get_module_structure(org_unit_id, module_id) # GET
  query_string = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/content/modules/#{module_id}/structure/"
  _get(query_string)
end

# Retrieve the root module(s) for an org unit.
# Returns JSON array of ContentObject data blocks of type Module
def get_root_modules(org_unit_id) # GET
  query_string = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/root/"
  _get(query_string)
end

# Retrieve a specific topic for an org unit.
# Returns a ContentObject JSON data block of type Topic
def get_topic(org_unit_id, topic_id) # GET
  query_string = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/content/topics/#{topic_id}"
  _get(query_string)
end

# Retrieve the content topic file for a content topic.
# Returns underlying file for a file content topic
def get_topic_file(org_unit_id, topic_id, stream = false) # GET
  query_string = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/content/topics/#{topic_id}/file"
  query_string += "?stream=true" if stream == true
  _get(query_string)
end

# TODO: Add a child +module+ or +topic+ to a specific module’s structure.
# Can be used in multiple ways. D2L categorizes it into 3 different ways:
# --Module: add child module to parent module
# --Link Topic: add child topic to parent module structure consisting of a LINK
#               type topic.
# --File Topic: add child topic to parent module structure consisting of a FILE
#               type topic.
# INPUT: (depends upon if its module, link topic, or file topic)
# --Module: POST body containing a +ContentObjectData+ JSON data block of type Module
# --Link Topic: POST body containing a +ContentObjectData+ JSON data block of type Topic
#               URL property in it points to resource you want to the link to point to.
# --File Topic: Multipart/mixed post body w/ 2 parts
#               1. +ContentObjectData+ JSON data block of type Topic
#               2. File attachment data itself you want to store in OU content area
# Returns (if successful) a JSON data block containing properties of the newly created object
def add_child_to_module(org_unit_id, module_id, child = {}) # POST
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/content/modules/#{module_id}/structure/"
  payload = {}
  # TODO: Add child module to a module
  if child.key?("module")
    payload = {
      "Title" => "title_string", # String
      "ShortTitle" => "title_short_string", # String
      "Type" => 0,
      "ModuleStartDate" => nil, # nil || string:UTCDateTime
      "ModuleEndDate" => nil, # nil || string:UTCDateTime
      "ModuleDueDate" => nil, # nil || string:UTCDateTime
      "IsHidden" => false,
      "IsLocked" => false,
      "description" => {
        "Text" => "blank",
        "HTML" => ""
      },
      "Duration" => nil, # nil, number
    }.merge!(child["module"])
    _post(path, payload)
  # TODO: Add child link-type topics to a module
  elsif child.key?("link")
    payload = {
      "Title" => "title_string", # String
      "ShortTitle" => "title_short_string", # String
      "Type" => 1,
      "TopicType" => 3, # <number:TOPIC_T>
      "Url" => "URL", # the URL you want to fetch when the user opens the link-type topic.
      "StartDate" => nil, # nil || string:UTCDateTime
      "EndDate" => nil, # nil || string:UTCDateTime
      "DueDate" => nil, # nil || string:UTCDateTime
      "IsHidden" => false,
      "IsLocked" => false,
      "OpenAsExternalResource" => nil, # or boolean
      "description" => {
        "Text" => "",
        "HTML" => nil # -or- HTML formatted string
      },
      "MajorUpdate" => nil, # or bool
      "MajorUpdateText" => "MajorUpdateText",
      "ResetCompletionTracking" => nil, # or bool
      "Duration" => nil, # nil, number
    }.merge!(child["module"])
    _post(path, payload)
  # TODO: Add child file-type topics to a module
  elsif child.key?("file")
    _course_content_upload(query_string, payload, file, "POST")
  end
end

def check_content_module_validity(content_module)
    schema = {
        'type' => 'object',
        'required' => %w(Title ShortTitle Type ModuleStartDate
                         ModuleEndDate ModuleDueDate IsHidden
                         IsLocked Description Duration),
        'properties' => {
            'Title' => { 'type' => 'string' },
            'ShortTitle' => { 'type' => 'string' },
            'Type' => { 'type' => 'integer' },
            'ModuleStartDate' => { 'type' => %w(string null) },
            'ModuleEndDate' => { 'type' => %w(string null) },
            'ModuleDueDate' => { 'type' => %w(string null) },
            'IsHidden' => { 'type' => %w(string null) },
            'IsLocked' => { 'type' => 'boolean' },
            'Description' => {
              'type' => 'object',
              'properties' =>
              {
                "Content" => "string",
                "Type" => "string" # "Text|HTML"
              }
            }, # Added with LE v1.10 API
            'Duration' => { 'type' => %w(integer null) } # Added in LE's unstable contract as of LE v10.6.8
        }
    }
    JSON::Validator.validate!(schema, content_module, validate_schema: true)
end

def check_content_topic_validity(content_topic)
    schema = {
        'type' => 'object',
        'required' => %w(Title ShortTitle Type TopicType Url StartDate
                         EndDate DueDate IsHidden IsLocked OpenAsExternalResource
                         Description MajoyUpdate MajorUpdateText ResetCompletionTracking),
        'properties' => {
            'Title' => { 'type' => 'string' },
            'ShortTitle' => { 'type' => 'string' },
            'Type' => { 'type' => 'integer' },
            'TopicType' => { 'type' => 'integer' },
            'StartDate' => { 'type' => %w(string null) },
            'EndDate' => { 'type' => %w(string null) },
            'DueDate' => { 'type' => %w(string null) },
            'IsHidden' => { 'type' => %w(string null) },
            'IsLocked' => { 'type' => 'boolean' },
            'OpenAsExternalResource' => { 'type' => %w(boolean null) }, # Added with LE v1.6 API
            'Description' => { # Added with LE v1.10 API
              'type' => 'object',
              'properties' =>
              {
                "Content" => "string",
                "Type" => "string" # "Text|HTML"
              }
            },
            'MajorUpdate' => { 'type' => %w(boolean null) }, # Added with LE v1.12 API
            'MajorUpdateText' => { 'type' => 'string' }, # Added with LE v1.12 API
            'ResetCompletionTracking' => { 'type' => %w(boolean null) } # Added with LE v1.12 API
        }
    }
    JSON::Validator.validate!(schema, content_topic, validate_schema: true)
end

# Create a new root module for an org unit.
# INPUT: ContentObjectData (of type Module) – New root module property data.
# Returns JSON array of ContentObject data blocks of type Module
def create_root_module(org_unit_id, content_module) # GET
  query_string = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/root/"
  payload = {
    "Title" => "",
    "ShortTitle" => "",
    "Type" => 0,
    "ModuleStartDate" => nil, # <string:UTCDateTime>|null
    "ModuleEndDate" => nil, # <string:UTCDateTime>|null
    "ModuleDueDate" => nil, # <string:UTCDateTime>|null
    "IsHidden" => false,
    "IsLocked" => false,
    "Description" => nil, # { <composite:RichTextInput> }|null --Added with LE v1.10 API
    "Duration" => nil #  <number>|null --Added in LE's +unstable+ contract as of LE v10.6.8
  }.merge!(content_module)
  check_content_module_validity(payload)
  _post(query_string, payload)
end

# Update a particular module for an org unit.
# INPUT: ContentObjectData of type Module
# NOTE: Cannot use this action to affect a module’s existing Structure property.
def update_module(org_unit_id, module_id, content_module) # PUT
  query_string = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/content/modules/#{module_id}"
  payload = {
    "Title" => "",
    "ShortTitle" => "",
    "Type" => 0,
    "ModuleStartDate" => nil, # <string:UTCDateTime>|null
    "ModuleEndDate" => nil, # <string:UTCDateTime>|null
    "ModuleDueDate" => nil, # <string:UTCDateTime>|null
    "IsHidden" => false,
    "IsLocked" => false,
    "Description" => nil, # { <composite:RichTextInput> }|null --Added with LE v1.10 API
    "Duration" => nil #  <number>|null --Added in LE's +unstable+ contract as of LE v10.6.8
  }.merge!(content_module)
  check_content_module_validity(payload)
  _put(query_string, payload)
end

# Update a particular topic for an org unit.
# INPUT: ContentObjectData of type Topic
# Returns underlying file for a file content topic
def update_topic(org_unit_id, topic_id, content_topic) # GET
  query_string = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/content/topics/#{topic_id}"
  payload = {
      'Title' => "",
      'ShortTitle' => "",
      'Type' => 0,
      'TopicType' => 0,
      'StartDate' => nil,
      'EndDate' => nil,
      'DueDate' => nil,
      'IsHidden' => nil,
      'IsLocked' => false,
      'OpenAsExternalResource' => nil, # Added with LE v1.6 API
      'Description' => nil,
      'MajorUpdate' => nil, # Added with LE v1.12 API
      'MajorUpdateText' => "", # Added with LE v1.12 API
      'ResetCompletionTracking' => nil # Added with LE v1.12 API
  }.merge!(content_topic)
  check_content_topic_validity(content_topic)
  _put(query_string, payload)
end

#########################
### CONTENT OVERVIEW#####
#########################

# Retrieve the overview for a course offering.
def get_course_overview(org_unit_id) # GET
  query_string = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/overview"
  ap query_string
  _get(query_string)
  # Returns: a Overview JSON data block containing
  # the course offering overview’s details.
end

# Retrieve the overview file attachment for a course offering.
def get_course_overview_file_attachment(org_unit_id) # GET
  query_string = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/overview/attachment"
  _get(query_string)
  # Returns: a file stream containing the course offering’s overview attachment.
end

##############
### ISBN #####
##############

# Remove the association between an ISBN and org unit.
def delete_isbn_association(org_unit_id, isbn) # DELETE
  query_string = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/content/isbn/#{isbn}"
  _delete(query_string)
end

# Retrieve all the org units associated with an ISBN.
def get_org_units_of_isbn(isbn) # GET
  query_string = "/d2l/api/le/#{$le_ver}/content/isbn/#{isbn}"
  _get(query_string)
  # Returns: JSON array of IsbnAssociation data blocks specifying
  # all the org units associated with the provided ISBN.
end

# Retrieve all ISBNs associated with an org unit.
def get_isbns_of_org_unit(org_unit_id) # GET
  query_string = "/d2l/api/le/#{$le_ver}/#{org_unit_id}content/isbn/"
  _get(query_string)
  # Returns: JSON array of IsbnAssociation data blocks specifying
  # all the org units associated with the provided ISBN.
end

# Retrieve the association between a ISBN and org unit.
def get_isbn_org_unit_association(org_unit_id, isbn) # GET
  query_string = "/d2l/api/le/#{$le_ver}/#{org_unit_id}content/isbn/#{isbn}"
  _get(query_string)
  # Returns: a IsbnAssociation JSON data block specifying
  # the association between an org unit and an ISBN.
end

def validate_isbn_association_data(isbn_association_data)
  schema = {
      'type' => 'object',
      'required' => %w(OrgUnitId Isbn),
      'properties' => {
          'OrgUnitId' => { 'type' => 'integer' },
          'Isbn' => { 'type' => 'string' },
          'IsRequired' => { 'type' => 'boolean' }
      }
  }
  JSON::Validator.validate!(schema, isbn_association_data, validate_schema: true)
end

# Create a new association between an ISBN and an org unit.
def create_isbn_org_unit_association(org_unit_id, isbn_association_data) # GET
  query_string = "/d2l/api/le/#{$le_ver}/#{org_unit_id}content/isbn/"
  payload = {
    "OrgUnitId" => 0,
    "Isbn" => ""
    # "IsRequired" => false ## optional
  }.merge!(isbn_association_data)
  _post(query_string, payload)
  # Returns: a IsbnAssociation JSON data block specifying
  # the association between an org unit and an ISBN.
end

#########################
### SCHEDULED ITEMS######
#########################

# REVIEW: Retrieve the calling user scheduled items.
def get_calling_user_scheduled_items(org_unit_ids_CSV, completion = nil,
                                     start_date_time = '', end_date_time = '') # GET
  query_string = "/d2l/api/le/#{$le_ver}/content/myItems/?"
  query_string += "orgUnitIdsCSV=#{org_unit_ids_CSV}&"
  query_string += "completion=#{completion}&" unless completion.nil?
  query_string += "startDateTime=#{start_date_time}&" unless start_date_time == ''
  query_string += "endDateTime=#{end_date_time}&" unless end_date_time == ''
  _get(query_string)
  # Returns: An ObjectListPage JSON block containing a list of ScheduledItem blocks
end

# REVIEW: Retrieve the calling user scheduled items still due.
def get_current_user_scheduled_items_still_due(org_unit_ids_CSV, completion = nil,
                                               start_date_time = '', end_date_time = '')
  query_string = "/d2l/api/le/#{$le_ver}/content/myItems/due/?"
  query_string += "orgUnitIdsCSV=#{org_unit_ids_CSV}&"
  query_string += "completion=#{completion}&" unless completion.nil?
  query_string += "startDateTime=#{start_date_time}&" unless start_date_time == ''
  query_string += "endDateTime=#{end_date_time}&" unless end_date_time == ''
  _get(query_string)
  # Returns: An ObjectListPage JSON block containing a list of ScheduledItem blocks
end

# REVIEW: Retrieve the quantities of the calling user scheduled items, organized by org unit.
# GET /d2l/api/le/(version)/content/myItems/itemCounts/
def get_current_user_organized_scheduled_items(org_unit_ids_CSV,
                                               completion = nil,
                                               start_date_time = '',
                                               end_date_time = '')
  query_string = "/d2l/api/le/#{$le_ver}/content/myItems/itemCounts/?"
  query_string += "orgUnitIdsCSV=#{org_unit_ids_CSV}&"
  query_string += "completion=#{completion}&" unless completion.nil?
  query_string += "startDateTime=#{start_date_time}&" unless start_date_time == ''
  query_string += "endDateTime=#{end_date_time}&" unless end_date_time == ''
  _get(query_string)
  # Returns: An ObjectListPage JSON block containing a list of ScheduledItem blocks
end

# REVIEW: Retrieve the quantities of the calling user’s scheduled items still due.
# GET /d2l/api/le/(version)/content/myItems/due/itemCounts/
def get_current_user_scheduled_item_count(org_unit_ids_CSV, completion = nil,
                                          start_date_time = '', end_date_time = '') # GET
  query_string = "/d2l/api/le/#{$le_ver}/content/myItems/due/itemCounts/?"
  query_string += "orgUnitIdsCSV=#{org_unit_ids_CSV}&"
  query_string += "completion=#{completion}&" unless completion.nil?
  query_string += "startDateTime=#{start_date_time}&" unless start_date_time == ''
  query_string += "endDateTime=#{end_date_time}&" unless end_date_time == ''
  _get(query_string)
  # Returns: An ObjectListPage JSON block containing a list of ScheduledItem blocks
end

# REVIEW: Retrieve the calling user completed scheduled items.
# GET /d2l/api/le/(version)/content/myItems/completions/
def get_current_user_completed_scheduled_items(org_unit_ids_CSV,
                                               completion_from_date_time = '',
                                               completed_to_date_time = '')
  query_string = "/d2l/api/le/#{$le_ver}/content/myItems/completions/?"
  query_string += "orgUnitIdsCSV=#{org_unit_ids_CSV}&"
  query_string += "completedFromDateTime=#{completion_from_date_time}&" unless completion_from_date_time == ''
  query_string += "completedToDateTime=#{completed_to_date_time}&" unless completed_to_date_time == ''
  _get(query_string)
  # Returns: An ObjectListPage JSON block containing a list of ScheduledItem blocks
end

# REVIEW: Retrieve the calling user’s completed scheduled items that have a due date.
# GET /d2l/api/le/(version)/content/myItems/completions/due/
def get_current_user_completed_scheduled_items_with_due_date(org_unit_ids_CSV,
                                                             completion_from_date_time = '',
                                                             completed_to_date_time = '')
  query_string = "/d2l/api/le/#{$le_ver}/content/myItems/completions/due/?"
  query_string += "orgUnitIdsCSV=#{org_unit_ids_CSV}&"
  query_string += "completedFromDateTime=#{completion_from_date_time}&" unless completion_from_date_time == ''
  query_string += "completedToDateTime=#{completed_to_date_time}&" unless completed_to_date_time == ''
  _get(query_string)
  # Returns: An ObjectListPage JSON block containing a list of ScheduledItem blocks
end

# REVIEW: Retrieve the calling user scheduled items for a particular org unit.
# GET /d2l/api/le/(version)/#{org_unit_id}/content/myItems/
def get_current_user_scheduled_items_by_org_unit(org_unit_id, completion = nil,
                                                 start_date_time = '',
                                                 end_date_time = '')
  query_string = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/content/myItems/?"
  query_string += "completion=#{completion}&" unless completion.nil?
  query_string += "startDateTime=#{start_date_time}&" unless start_date_time == ''
  query_string += "endDateTime=#{end_date_time}&" unless end_date_time == ''
  _get(query_string)
  # Returns: An ObjectListPage JSON block containing a list of ScheduledItem blocks
end

# REVIEW: Retrieve the calling user’s scheduled items still due for a particular org unit.
# GET /d2l/api/le/(version)/#{org_unit_id}/content/myItems/due/
def get_current_user_org_unit_scheduled_items(org_unit_id, completion = nil,
                                              start_date_time = '',
                                              end_date_time = '') # GET
  query_string = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/content/myItems/due/?"
  query_string += "completion=#{completion}&" unless completion.nil?
  query_string += "startDateTime=#{start_date_time}&" unless start_date_time == ''
  query_string += "endDateTime=#{end_date_time}&" unless end_date_time == ''
  _get(query_string)
  # Returns: An ObjectListPage JSON block containing a list of ScheduledItem blocks
end

# REVIEW: Retrieve the quantity of the calling user scheduled items for provided org unit.
# GET /d2l/api/le/(version)/#{org_unit_id}/content/myItems/itemCount
def get_calling_user_overdue_items_count(org_unit_id, completion = nil, start_date_time = '',
                                         end_date_time = '') # GET
  query_string = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/content/myItems/itemCount?"
  query_string += "completion=#{completion}&" unless completion.nil?
  query_string += "startDateTime=#{start_date_time}&" unless start_date_time == ''
  query_string += "endDateTime=#{end_date_time}&" unless end_date_time == ''
  _get(query_string)
  # Returns: An ObjectListPage JSON block containing a list of ScheduledItem blocks
end

# REVIEW: Retrieve quantity of the calling user’s scheduled items still due for a particular org unit.
# GET /d2l/api/le/(version)/#{org_unit_id}/content/myItems/due/itemCount
def get_calling_user_due_items_count(org_unit_id, completion = nil, start_date_time = '',
                                     end_date_time = '') # GET
  query_string = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/content/myItems/due/itemCount?"
  query_string += "completion=#{completion}&" unless completion.nil?
  query_string += "startDateTime=#{start_date_time}&" unless start_date_time == ''
  query_string += "endDateTime=#{end_date_time}&" unless end_date_time == ''
  _get(query_string)
  # Returns: An ObjectListPage JSON block containing a list of ScheduledItem blocks
end

# Retrieve the overdue items for a particular user in a particular org unit.
# +org_unit_ids_CSV+ is a CSV of D2LIDs or rather Org unit IDs (optional)
# Viewing user overdue items depends upon the current calling user's permissions.
# Returns: An ObjectListPage JSON block containing a list of OverdueItem.
def get_user_overdue_items(user_id, org_unit_ids_CSV = nil) # GET
  query_string = "/d2l/api/le/#{$le_ver}/overdueItems/"
  query_string += "?userId=#{user_id}"
  query_string += "&orgUnitIdsCSV=#{org_unit_ids_CSV}" unless org_unit_ids_CSV.nil?
  _get(query_string)
  # Returns: An ObjectListPage JSON block containing a list of OverdueItem.
end

# Retrieves the calling user’s overdue items, within a number of org units.
# org_unit_ids_CSV is a CSV of D2LIDs or rather Org unit IDs (optional)
# Returns: An ObjectListPage JSON block containing a list of OverdueItem.
# NOTE: If using a support account, try not to use this without defining a csv...
#       It will consider all courses designated as somehow linked to the acc.
#       and return ALL overdue items EVER for the support account.
def get_current_user_overdue_items(org_unit_ids_CSV = nil) # GET
  query_string = "/d2l/api/le/#{$le_ver}/overdueItems/myItems"
  query_string += "?orgUnitIdsCSV=#{org_unit_ids_CSV}" unless org_unit_ids_CSV.nil?
  _get(query_string)
  # Returns: An ObjectListPage JSON block containing a list of OverdueItem.
end

#########################
### TABLE OF CONTENTS####
#########################

# Retrieve a list of topics that have been bookmarked.
def get_bookmarked_topics(org_unit_id) # GET
  query_string = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/content/bookmarks"
  _get(query_string)
  # Returns: a JSON array of Topic ToC entries.
end

# Retrieve a list of the most recently visited topics.
def get_most_recently_visited_topics(org_unit_id) # GET
  query_string = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/content/recent"
  _get(query_string)
  # Returns: a JSON array of Topic ToC entries.
end

# Retrieve the table of course content for an org unit.
def get_org_unit_toc(org_unit_id, ignore_module_data_restrictions = false) # GET
  query_string = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/content/toc"
  query_string += '?ignoreModuleDateRestrictions=true' if ignore_module_data_restrictions
  _get(query_string)
  # Returns: a TableOfContents JSON block.
end

#################
### USER PROGRESS
#################

# Retrieves the aggregate count of completed and required content topics
# in an org unit for the calling user.
# levels: 1=OrgUnit, 2=RootModule, 3=Topic
def get_current_user_progress(org_unit_id, level) # GET
  query_string = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/content/completions/mycount/"
  query_string += "?level=#{level}"
  _get(query_string)
  # Returns: ObjectListPage JSON block containing
  # a list of ContentAggregateCompletion items.
end

# TODO: --UNSTABLE-- Retrieve the user progress items in an org unit, for specific users or content topics.
# _get "/d2l/api/le/#{$le_ver}/#{org_unit_id}/content/userprogress/"
def get_progress_of_users; end

# TODO: --UNSTABLE-- Retrieve one user’s progress within an org unit for a particular content topic.
# _get "/d2l/api/le/#{$le_ver}/#{org_unit_id}/content/userprogress/#{topic_id}"
def get_user_progress; end

# TODO: --UNSTABLE-- Update a user progress item.
# _post "/d2l/api/le/#{$le_ver}/#{org_unit_id}/content/userprogress/"
# payload: UserProgressData
def update_user_progress; end
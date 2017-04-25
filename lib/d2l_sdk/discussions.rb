require_relative 'requests'
require 'json-schema'

##################
## ACTIONS: ######
##################

# REVIEW: Delete a particular discussion forum from an org unit.
# => DELETE /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}
def delete_org_unit_discussion(org_unit_id, forum_id)
    path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}"
    _delete(path)
end

# REVIEW: Retrieve a list of all discussion forums for an org unit.
# => GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/
def get_org_unit_discussions(org_unit_id)
    path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/"
    _get(path)
end

# REVIEW: Retrieve a particular discussion forum for an org unit.
# => GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}
def get_org_unit_discussion(org_unit_id, forum_id)
    path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}"
    _get(path)
end

def check_forum_data_validity(forum_data)
  schema = {
      'type' => 'object',
      'required' => %w(Name Description ShowDescriptionInTopics StartDate
                       EndDate PostStartDate PostEndDate IsHidden
                       IsLocked RequiresApproval MustPostToParticipate
                       DisplayInCalendar DisplayPostDatesInCalendar),
      'properties' => {
          'Name' => { 'type' => 'string' },
          'Description' => {
            'type' => 'object',
            'properties' =>
            {
              "Text" => { 'type' => "string" },
              "Html" => { 'type' => %w(string null) }
            }
          },
          'ShowDescriptionInTopics' => { 'type' => %w(boolean null) },
          'StartDate' => { 'type' => %w(string null) },
          'EndDate' => { 'type' => %w(string null) },
          'PostStartDate' => { 'type' => %w(string null) },
          'PostEndDate' => { 'type' => %w(string null) },
          'IsHidden' => { 'type' => 'boolean' },
          'IsLocked' => { 'type' => 'boolean' },
          'RequiresApproval' => { 'type' => 'boolean' }, #: <boolean>,
          'MustPostToParticipate' => { 'type' => %w(boolean null) },
          'DisplayInCalendar' => { 'type' => %w(boolean null) }, # Added with LE API v1.11
          'DisplayPostDatesInCalendar' => { 'type' => %w(boolean null) }
      }
  }
  JSON::Validator.validate!(schema, forum_data, validate_schema: true)
end

# REVIEW: Create a new forum for an org unit.
# => POST /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/
def create_org_unit_discussion(org_unit_id, forum_data)
    path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/"
    payload =
    {
        'Name' => '', #: <string>,
        'Description' => #: { <composite:RichText> },
        {
            "Text" => "", # <string:plaintext_version_of_text>,
            "Html" => nil # <string:HTML_formatted_version_of_text>|null
        },
        'ShowDescriptionInTopics' => nil, # : <boolean>|null,  // Added with LE API v1.14
        'StartDate' => nil, #: <string:UTCDateTime>|null,
        'EndDate' => nil, #: <string:UTCDateTime>|null,
        'PostStartDate' => nil, #: <string:UTCDateTime>|null,
        'PostEndDate' => nil, # <string:UTCDateTime>|null,
        'AllowAnonymous' => false, # <boolean>,
        'IsLocked' => false,  #: <boolean>,
        'IsHidden' => false,  #: <boolean>,
        'RequiresApproval' => '', #: <boolean>,
        'MustPostToParticipate' => nil, #: <boolean>|null,
        'DisplayInCalendar' => nil, #: <boolean>|null,  // Added with LE API v1.11
        'DisplayPostDatesInCalendar' => nil, #: <boolean>|null  // Added with LE API v1.11
    }.merge!(forum_data)
    # REVIEW: Validate payload
    check_forum_data_validity(payload)
    _post(path, payload)
end

# REVIEW: Update a forum for an org unit.
# => PUT /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}
# NOTE: <  LE v 1.10 ignores date filed of the forum_data
# NOTE: >= LE v 1.11 applies date fields that are sent, otherwise they're
#       assumed null.
def update_forum(org_unit_id, forum_id, forum_data)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/"
  payload =
  {
      'Name' => '', #: <string>,
      'Description' => #: { <composite:RichText> },
      {
          "Text" => "", # <string:plaintext_version_of_text>,
          "Html" => nil # <string:HTML_formatted_version_of_text>|null
      },
      'ShowDescriptionInTopics' => nil, #: <boolean>|null,  // Added with LE API v1.14
      'StartDate' => nil, #: <string:UTCDateTime>|null,
      'EndDate' => nil, #: <string:UTCDateTime>|null,
      'PostStartDate' => nil, #: <string:UTCDateTime>|null,
      'PostEndDate' => nil, # <string:UTCDateTime>|null,
      'AllowAnonymous' => false, # <boolean>,
      'IsLocked' => false,  #: <boolean>,
      'IsHidden' => false,  #: <boolean>,
      'RequiresApproval' => '', #: <boolean>,
      'MustPostToParticipate' => nil, #: <boolean>|null,
      'DisplayInCalendar' => nil, #: <boolean>|null,  // Added with LE API v1.11
      'DisplayPostDatesInCalendar' => nil, #: <boolean>|null  // Added with LE API v1.11
  }.merge!(forum_data)
  # REVIEW: Validate payload
  check_forum_data_validity(payload)
  _put(path, payload)
# RETURNS: Forum JSON block
end

##################
## TOPICS: #######
##################

# REVIEW: Delete a particular topic from the provided discussion forum in an org unit.
# => DELETE /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}
def delete_topic(org_unit_id, forum_id, topic_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}"
  _delete(path)
end

# REVIEW: Delete a group restriction for a discussion forum topic.
# => DELETE /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/groupRestrictions/
def delete_topic_group_restriction(org_unit_id, forum_id, topic_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/groupRestrictions/"
  _delete(path)
end

# REVIEW: Retrieve topics from the provided discussion forum in an org unit.
# => GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/
def get_forum_topics(org_unit_id, forum_id)
    path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/"
    _get(path)
end

# REVIEW: Retrieve a particular topic from the provided discussion forum in an org unit.
# => GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}
def get_forum_topic(org_unit_id, forum_id, topic_id)
    path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}"
    _get(path)
end

# REVIEW: Retrieve the group restrictions for a discussion forum topic.
# => GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/groupRestrictions/
def get_forum_topic_group_restrictions(org_unit_id, forum_id, topic_id)
    path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/groupRestrictions/"
    _get(path)
end

def check_create_topic_data_validity(create_topic_data)
  schema = {
      'type' => 'object',
      'required' => %w(Name Description AllowAnonymousPosts StartDate
                       EndDate UnlockStartDate UnlockEndDate IsHidden
                       IsLocked RequiresApproval ScoreOutOf IsAutoScore
                       IncludeNonScoredValues ScoringType MustPostToParticipate
                       RatingType DisplayInCalendar DisplayUnlockDatesInCalendar),
      'properties' =>
      {
          'Name' => { 'type' => 'string' },
          'Description' =>
          {
            'type' => 'object',
            'properties'=>
            {
              "Content" => { 'type' => "string" },
              "Type" => { 'type' => "string" }
            }
          },
          'AllowAnonymousPosts' => { 'type' => 'boolean' },
          'StartDate' => { 'type' => %w(string null) },
          'EndDate' => { 'type' => %w(string null) },
          'UnlockStartDate' => { 'type' => %w(string null) },
          'UnlockEndDate' => { 'type' => %w(string null) },
          'IsHidden' => { 'type' => 'boolean' },
          'IsLocked' => { 'type' => 'boolean' },
          'RequiresApproval' => { 'type' => 'boolean' }, #: <boolean>,
          'ScoreOutOf' => { 'type' => %w(integer null) },
          'IsAutoScore' => { 'type' => 'boolean' },  # Added with LE API v1.11
          'IncludeNonScoredValues' => { 'type' => 'boolean' },
          'ScoringType' => { 'type' => %w(string null) },
          'MustPostToParticipate' => { 'type' => 'boolean' }, #: <boolean>,
          'RatingType' => { 'type' => %w(string null) },
          'DisplayInCalendar' => { 'type' => %w(boolean null) }, # Added with LE API v1.12
          'DisplayUnlockDatesInCalendar' => { 'type' => %w(boolean null) } # Added with LE API v1.12
      }
  }
  JSON::Validator.validate!(schema, create_topic_data, validate_schema: true)
end

# REVIEW: Create a new topic for the provided discussion forum in an org unit.
# => POST /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/
def create_forum_topic(org_unit_id, forum_id, create_topic_data)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/"
  payload =
  {
    "Name" => "", # : <string>,
    "Description" =>
    {
        "Text" => "", # <string:plaintext_version_of_text>,
        "Html" => nil # <string:HTML_formatted_version_of_text>|null
    }, # { <composite:RichTextInput> },
    "AllowAnonymousPosts" => false, # <boolean>,
    "StartDate" => nil, # <string:UTCDateTime>|null,
    "EndDate" => nil, # : <string:UTCDateTime>|null,
    "IsHidden" => false, # : <boolean>,
    "UnlockStartDate" => nil, # : <string:UTCDateTime>|null,
    "UnlockEndDate" => nil, # : <string:UTCDateTime>|null,
    "RequiresApproval" => false, # : <boolean>,
    "ScoreOutOf" => nil, # : <number>|null,
    "IsAutoScore" => false, # : <boolean>,
    "IncludeNonScoredValues" => "", # : <boolean>,
    "ScoringType" => nil, # : <string:SCORING_T>|null,
    "IsLocked" => false, # : <boolean>,
    "MustPostToParticipate" => false, # : <boolean>,
    "RatingType" => nil, # : <string:RATING_T>|null,
    "DisplayInCalendar" => nil, # : <boolean>|null,  // Added with LE API v1.12
    "DisplayUnlockDatesInCalendar" => nil, # : <boolean>|null  // Added with LE API v1.12
  }.merge!(create_topic_data)
  check_create_topic_data_validity(payload) # REVIEW: Validity check of topic data
  _post(path, payload)
  # RETURNS: Topic JSON data block
end

# REVIEW: Update an existing topic for the provided discussion forum in an org unit.
# => PUT /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}
def update_forum_topic(org_unit_id, forum_id, topic_id, create_topic_data)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}"
  payload =
  {
    "Name" => "", # : <string>,
    "Description" =>
    {
        "Text" => "", # <string:plaintext_version_of_text>,
        "Html" => nil # <string:HTML_formatted_version_of_text>|null
    }, # { <composite:RichTextInput> },
    "AllowAnonymousPosts" => false, # <boolean>,
    "StartDate" => nil, # <string:UTCDateTime>|null,
    "EndDate" => nil, # : <string:UTCDateTime>|null,
    "IsHidden" => false, # : <boolean>,
    "UnlockStartDate" => nil, # : <string:UTCDateTime>|null,
    "UnlockEndDate" => nil, # : <string:UTCDateTime>|null,
    "RequiresApproval" => false, # : <boolean>,
    "ScoreOutOf" => nil, # : <number>|null,
    "IsAutoScore" => false, # : <boolean>,
    "IncludeNonScoredValues" => "", # : <boolean>,
    "ScoringType" => nil, # : <string:SCORING_T>|null,
    "IsLocked" => false, # : <boolean>,
    "MustPostToParticipate" => false, # : <boolean>,
    "RatingType" => nil, # : <string:RATING_T>|null,
    "DisplayInCalendar" => nil, # : <boolean>|null,  // Added with LE API v1.12
    "DisplayUnlockDatesInCalendar" => nil, # : <boolean>|null  // Added with LE API v1.12
  }.merge!(create_topic_data)
  check_create_topic_data_validity(payload) # REVIEW: Validity check of topic data
  _post(path, payload)
  # RETURNS: Topic JSON data block
end

# REVIEW: Add a group to the group restriction list for a discussion forum topic.
# => PUT /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/groupRestrictions/
def add_group_to_group_restriction_list(org_unit_id, forum_id, topic_id, group_id)
  if !group_id.is_a? Numeric
    raise ArgumentError, "Argument 'group_id' is not numeric value."
  else
    path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/groupRestrictions/"
    payload =
    {
      "GroupRestriction" =>
      {
          "GroupId" => group_id
      }
    }
    _put(path, payload)
    # RETURNS: ??
  end
end

##################
## POSTS: ########
##################

# REVIEW: Delete a particular post from a discussion forum topic.
# => DELETE /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}
def delete_topic_post(org_unit_id, forum_id, topic_id, post_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}"
  _delete(path)
end

# REVIEW: DELETE /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/Rating/MyRating
# => Delete the current user context’s rating for a particular post from a discussion forum topic.
def delete_current_user_context_post_rating
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/Rating/MyRating"
  _delete(path)
  # NOTE: Doing so is actually an update, setting the current user's rating
  #       of a post to null
end

# REVIEW: Retrieve all posts in a discussion forum topic.
# => GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/
# RETURNS: JSON array of Post data blocks containing the properties for all the post
def get_forum_topic_posts(org_unit_id, forum_id, topic_id, page_size = 0, page_number = 0,
                          threads_only = nil, thread_id = 0, sort = '')
    path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/?"
    path += "pageSize=#{page_size}&" unless page_size.zero?
    path += "pageNumber=#{page_number}&" unless page_number.zero?
    path += "threadsOnly=#{threads_only}&" unless threads_only.nil?
    path += "threadId=#{thread_id}&" unless thread_id.zero?
    path += "sort=#{sort}" unless sort == ''
    _get(path)
    # RETURNS: JSON array of Post data blocks containing the properties for all the post
end

# REVIEW: Retrieve a particular post in a discussion forum topic.
# => GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}
def get_forum_topic_post(org_unit_id, forum_id, topic_id, post_id)
    path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}"
    _get(path)
    # RETURNS: Post data block
end

# REVIEW: Retrieve the approval status for a particular post in a discussion forum topic.
# => GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/Approval
def get_forum_topic_post_approval_status(org_unit_id, forum_id, topic_id, post_id)
    path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/Approval"
    _get(path)
    # RETURNS: ApprovalData JSON data block
end

# REVIEW: Retrieve the flagged status for a particular post in a discussion forum topic.
# => GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/Flag
def get_forum_topic_post_flagged_status(org_unit_id, forum_id, topic_id, post_id)
    path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/Flag"
    _get(path)
    # RETURNS: FlagData JSON data block
end

# REVIEW: Retrieve the rating data for a particular post in a discussion forum topic.
# => GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/Rating
def get_forum_topic_post_rating_data(org_unit_id, forum_id, topic_id, post_id)
    path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/Rating"
    _get(path)
    # RETURNS: RatingData JSON data block
end

# REVIEW: Retrieve the current user context’s rating data for a particular post in a discussion forum topic.
# => GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/Rating/MyRating
def get_current_user_forum_topic_post_rating_data(org_unit_id, forum_id, topic_id, post_id)
    path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/Rating/MyRating"
    _get(path)
    # RETURNS: UserRatingData JSON data block
end

# REVIEW: Retrieve the current read status for a particular post in a discussion forum topic.
# => GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/ReadStatus
def get_forum_topic_post_read_status(org_unit_id, forum_id, topic_id, post_id)
    path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/ReadStatus"
    _get(path)
    # RETURNS: ReadStatusData JSON data block
end

# REVIEW: Retrieve all the vote data for a particular post in a discussion forum topic.
# => GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/Votes
def get_forum_topic_post_vote_data(org_unit_id, forum_id, topic_id, post_id)
    path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/Votes"
    _get(path)
    # RETURNS: VotesData JSON data block
end

# REVIEW: Retrieve the current user’s vote data for a particular post in a discussion forum topic.
# => GET /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/Votes/MyVote
def get_current_user_forum_topic_post_vote_data(org_unit_id, forum_id, topic_id, post_id)
    path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/Votes/MyVote"
    _get(path)
    # RETURNS: UserVoteData JSON data block
end

def check_create_post_data_validity(create_post_data)
  schema = {
      'type' => 'object',
      'required' => %w(ParentPostId Subject Message IsAnonymous),
      'properties' =>
      {
          'ParentPostId' => { 'type' => %w(integer null) },
          'Subject' => { 'type' => "string" },
          'Message' =>
          {
            'type' => 'object',
            'properties'=>
            {
              "Content" => { 'type' => "string" },
              "Type" => { 'type' => "string" }
            }
          },
          'IsAnonymous' => { 'type' => 'boolean' }
      }
  }
  JSON::Validator.validate!(schema, create_post_data, validate_schema: true)
end

# REVIEW: Create a new post in a discussion forum topic.
# => POST /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/
# NOTE: No file attachments? Send it normally :)
# NOTE: File attachments? Send using Multipart/Mixed body conforming to RFC2388
# RETURNS: Post JSON data block
def create_topic_post(org_unit_id, forum_id, topic_id, create_post_data, files = [])
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/"
  payload = {
    "ParentPostId" => nil, # integer or nil
    "Subject" => "",
    "Message" => {
      "Content" => "",
      "Type" => "Text|Html"
    },
    "IsAnonymous" => false
  }.merge!(create_post_data)
  check_create_post_data_validity(payload)
  if files == []
    # can do a simple POST request.
    _post(path, payload)
  else
    # Have to do multipart/mixed body custom POST request.
    _upload_post_data(path, payload, files, "POST")
  end
end

# REVIEW: Update a particular post in a discussion forum topic.
# => PUT /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}
# RETURNS: Post JSON data block
def update_topic_post(org_unit_id, forum_id, topic_id, post_id, create_post_data)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}"
  payload = {
    "ParentPostId" => nil, # integer or nil
    "Subject" => "",
    "Message" => {
      "Content" => "",
      "Type" => "Text|Html"
    },
    "IsAnonymous" => false
  }.merge!(create_post_data)
  check_create_post_data_validity(payload)
  _put(path, payload)
end

# REVIEW: Update the approval status of a particular post in a discussion forum topic.
# => PUT /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/Approval
# RETURNS: ApprovalData JSON data block
def update_topic_post_approval_status(org_unit_id, forum_id, topic_id, post_id, is_approved)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/Approval"
  unless is_approved == true || is_approved == false
    raise ArgumentError, "Argument 'is_approved' is not a boolean value."
  else
    payload = {
      "IsApproved" => is_approved
    }
    _put(path, payload)
  end
end


# REVIEW: Update the flagged status of a particular post in a discussion forum topic.
# => PUT /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/Flag
# RETURNS: FlagData JSON data block
def update_topic_post_flagged_status(org_unit_id, forum_id, topic_id, post_id, is_flagged)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/Flag"
  unless is_flagged == true || is_flagged == false
    raise ArgumentError, "Argument 'is_flagged' is not a boolean value."
  else
    payload = {
      "IsFlagged" => is_flagged
    }
    _put(path, payload)
  end
end

# REVIEW: Update the current user context’s rating for a particular post in a discussion forum topic.
# => PUT /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/Rating/MyRating
# RETURNS: UserRatingData JSON data block
def update_topic_post_current_user_rating(org_unit_id, forum_id, topic_id, post_id, rating)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/Rating/MyRating"
  unless rating.is_a?(Numeric) || rating.nil?
    raise ArgumentError, "Argument 'rating' is not a number or null value."
  else
    payload = {
      "Rating" => rating
    }
    _put(path, payload)
  end
end

# REVIEW: Update the read status of a particular post in a discussion forum topic.
# => PUT /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/ReadStatus
# RETURNS: ReadStatusData JSON data block
def update_topic_post_read_status(org_unit_id, forum_id, topic_id, post_id, is_read)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/ReadStatus"
  unless is_read == true || is_read == false
    raise ArgumentError, "Argument 'is_read' is not a boolean value."
  else
    payload = {
      "IsRead" => is_read
    }
    _put(path, payload)
  end
end

# REVIEW: Update a discussion forum topic post’s vote data for the current user.
# => PUT /d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/Votes/MyVote
# RETURNS: ??
def update_topic_post_current_user_vote_data(org_unit_id, forum_id, topic_id, post_id, vote)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}/Votes/MyVote"
  unless vote.is_a? String
    raise ArgumentError, "Argument 'vote' is not a string value."
  else
    payload = {
      "Vote" => vote
    }
    _put(path, payload)
  end
end

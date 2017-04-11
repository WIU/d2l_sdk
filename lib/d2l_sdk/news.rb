require_relative 'requests'
require 'json-schema'
#################
# News:##########
#################

# REVIEW: Delete a particular news item from an org unit.
def delete_news_item(org_unit_id, news_item_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/news/#{news_item_id}"
  _delete(path)
end

# REVIEW: Delete an attachment from an org unit’s news item.
def delete_news_item_attachment(org_unit_id, news_item_id, file_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/news/#{news_item_id}/attachments/#{file_id}"
  _delete(path)
end

# REVIEW: Fetch the feed for the current user context.
# if since not specified, only includes most 'recent' feed items
# if since specified but until is not, all items since 'since' are fetched
# if since and until are specified, all items between these two dates are fetched
# if since > until, an empty feed list is returned
# purpose: fetch the feed for the current user context
def get_current_user_feed(since = "", until_ = "")
  path = "/d2l/api/lp/#{$lp_ver}/feed/"
  # if since is specified, then until can be. Until is not required though.
  if since != ""
    path += "?since=#{since}"
    path += "&until=#{until_}" if until_ != ""
  end
  _get(path)
end

# REVIEW: Retrieve a list of news items for an org unit.
def get_org_unit_news_items(org_unit_id, since = "")
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/news/"
  path += "?since=#{since}" if since != ""
  _get(path)
end

# NOTE: UNSTABLE!!!
# REVIEW: Retrieve data blocks containing the properties of deleted news items.
def get_deleted_news(org_unit_id, global = nil)
  # GET /d2l/api/le/(version)/(orgUnitId)/news/deleted/
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/news/deleted/"
  path += "?global=#{global}" unless global.nil?
  _get(path)
end

# REVIEW: Retrieve a particular news item for an org unit.
def get_org_unit_news_item(org_unit_id, news_item_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/news/#{news_item_id}"
  _get(path)
end

# REVIEW: Retrieve an attachment for an org unit’s news item.
def get_news_item_attachment(org_unit_id, news_item_id, file_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/news/#{news_item_id}/attachments/#{file_id}"
  _get(path)
end


# TODO: Create a news item for an org unit.
# INPUT: multipart/mixed POST body
#   part 1: news item data JSON
#   part 2: attachments
def create_news_item(org_unit_id, news_item_data, attachments = [])
  # POST /d2l/api/le/(version)/(orgUnitId)/news/
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/news/"
  json =
  {
    "Title" => "Placeholder_title",
    "Body" =>
    { # Composite: RichText
      "Text" => "plaintext_text_here",
      "HTML" => nil # OR the HTML_Formatted_version_of_text
    },
    "StartDate" => "UTCDateTime",
    "EndDate" => nil, # nil or UTCDateTime -- e.g. 2017-03-28T18:54:56.000Z
    "IsGlobal" => false,
    "IsPublished" => false, # sets it as a draft
    "ShowOnlyInCourseOfferings" => false
  }.merge!(news_item_data)
  files = attachments
  method = "POST"
  ap json
  ap _news_upload(path, json, files, method)
  # RETURNS a NewsItem JSON data block
end

# NOTE: UNSTABLE!!!
# REVIEW: Restore a particular news item by its news_item_id
def restore_news_item(org_unit_id, news_item_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/news/deleted/#{news_item_id}/restore"
  _post(path, {})
end

# TODO: Add an attachment to a news item for an org unit.
# INPUT: Use a multipart/form-data POST body to provide the attachment data to
#        add to the news item, with the part’s Content-Disposition header’s
#        name field set to “file”.
def add_news_item_attachment(org_unit_id, news_item_id, attachment_data)
  # POST /d2l/api/le/(version)/(orgUnitId)/news/(newsItemId)/attachments/
end

# REVIEW: Dismiss (hide) a news item for an org unit.
def hide_news_item(org_unit_id, news_item_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/news/#{news_item_id}/dismiss"
  _post(path, {})
end

# REVIEW: Publish a draft news item for an org unit.
def publish_draft_news_item(org_unit_id, news_item_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/news/#{news_item_id}/publish"
  _post(path, {})
end

# REVIEW: Restore (unhide) a news item for an org unit.
def unhide_news_item(org_unit_id, news_item_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/news/#{news_item_id}/restore"
  _post(path, {})
end

# TODO: Update a news item for an org unit.
# INPUT: JSON Parameter of type NewsItemData (News.NewsItemData)
def update_news_item(org_unit_id, news_item_id, news_item_data)
  # Example of News.NewsItemData JSON Data Block:
  #   {"Title" => "string",
  #   "Body" => {'Content' => "content", "Type" => "type"} # RichTextInput -- e.g. {'Content'=>'x', 'Type'=>'y'}
  #   "StartDate": "<string:UTCDateTime>",
  #   "EndDate": "<string:UTCDateTime>", # or nil
  #   "IsGlobal": false,
  #   "IsPublished": false,
  #   "ShowOnlyInCourseOfferings": false}
  # PUT /d2l/api/le/(version)/(orgUnitId)/news/(newsItemId)
end

require_relative 'requests'
require 'json-schema'

##################
## ACTIONS: ######
##################

# TODO: Delete a particular discussion forum from an org unit.
# => DELETE /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)

# REVIEW: Retrieve a list of all discussion forums for an org unit.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/
def get_org_unit_discussions(org_unit_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/"
  _get(path)
end

# REVIEW: Retrieve a particular discussion forum for an org unit.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)
def get_org_unit_discussion(org_unit_id, forum_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}"
  _get(path)
end

# TODO: Create a new forum for an org unit.
# => POST /d2l/api/le/(version)/(orgUnitId)/discussions/forums/

# TODO: Update a forum for an org unit.
# => PUT /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)


##################
## TOPICS: #######
##################

# TODO: Delete a particular topic from the provided discussion forum in an org unit.
# => DELETE /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)
# TODO: Delete a group restriction for a discussion forum topic.
# => DELETE /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/groupRestrictions/
# REVIEW: Retrieve topics from the provided discussion forum in an org unit.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/
def get_forum_topics(org_unit_id, forum_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/"
  _get(path)
end

# REVIEW: Retrieve a particular topic from the provided discussion forum in an org unit.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)
def get_forum_topic(org_unit_id, forum_id, topic_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}"
  _get(path)
end

# REVIEW: Retrieve the group restrictions for a discussion forum topic.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/groupRestrictions/
def get_forum_topic_group_restrictions(org_unit_id, forum_id, topic_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/groupRestrictions/"
  _get(path)
end

# TODO: Create a new topic for the provided discussion forum in an org unit.
# => POST /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/
# TODO: Update an existing topic for the provided discussion forum in an org unit.
# => PUT /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)
# TODO: Add a group to the group restriction list for a discussion forum topic.
# => PUT /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/groupRestrictions/

##################
## POSTS: ########
##################

# TODO: Delete a particular post from a discussion forum topic.
# => DELETE /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/(postId)
# TODO: DELETE /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/(postId)/Rating/MyRating
# => Delete the current user context’s rating for a particular post from a discussion forum topic.
# TODO: Retrieve all posts in a discussion forum topic.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/
def get_forum_topic_posts(org_unit_id, forum_id, topic_id, page_size = 0, page_number = 0
                          threads_only = nil, thread_id = 0, sort = "")
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/?"
  path += "pageSize=#{page_size}&" unless page_size == 0
  path += "pageNumber=#{page_number}&" unless page_number == 0
  path += "threadsOnly=#{threads_only}&" unless threads_only.nil?
  path += "threadId=#{thread_id}&" unless thread_id == 0
  path += "sort=#{sort}" unless sort == ""
  _get(path)
end
# TODO: Retrieve a particular post in a discussion forum topic.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/(postId)
def get_forum_topic_post(org_unit_id, forum_id, topic_id, post_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/discussions/forums/#{forum_id}/topics/#{topic_id}/posts/#{post_id}"
  _get(path)
end

# TODO: Retrieve the approval status for a particular post in a discussion forum topic.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/(postId)/Approval
def get_forum_topic_post_approval_status(org_unit_id, forum_id, topic_id, post_id)
  path = ""
  _get(path)
end

# TODO: Retrieve the flagged status for a particular post in a discussion forum topic.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/(postId)/Flag
def get_forum_topic_post_flagged_status(org_unit_id, forum_id, topic_id, post_id)
  path = ""
  _get(path)
end

# TODO: Retrieve the rating data for a particular post in a discussion forum topic.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/(postId)/Rating
def get_forum_topic_post_rating_data(org_unit_id, forum_id, topic_id, post_id)
  path = ""
  _get(path)
end

# TODO: Retrieve the current user context’s rating data for a particular post in a discussion forum topic.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/(postId)/Rating/MyRating
def get_current_user_forum_topic_post_rating_data(org_unit_id, forum_id, topic_id, post_id)
  path = ""
  _get(path)
end

# TODO: Retrieve the current read status for a particular post in a discussion forum topic.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/(postId)/ReadStatus
def get_forum_topic_post_read_status(org_unit_id, forum_id, topic_id, post_id)
  path = ""
  _get(path)
end

# TODO: Retrieve all the vote data for a particular post in a discussion forum topic.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/(postId)/Votes
def get_forum_topic_post_vote_data(org_unit_id, forum_id, topic_id, post_id)
  path = ""
  _get(path)
end

# TODO: Retrieve the current user’s vote data for a particular post in a discussion forum topic.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/(postId)/Votes/MyVote
def get_current_user_forum_topic_post_vote_data(org_unit_id, forum_id, topic_id, post_id)
  path = ""
  _get(path)
end

# TODO: Create a new post in a discussion forum topic.
# => POST /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/
# TODO: Update a particular post in a discussion forum topic.
# => PUT /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/(postId)
# TODO: Update the approval status of a particular post in a discussion forum topic.
# => PUT /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/(postId)/Approval
# TODO: Update the flagged status of a particular post in a discussion forum topic.
# => PUT /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/(postId)/Flag
# TODO: Update the current user context’s rating for a particular post in a discussion forum topic.
# => PUT /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/(postId)/Rating/MyRating
# TODO: Update the read status of a particular post in a discussion forum topic.
# => PUT /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/(postId)/ReadStatus
# TODO: Update a discussion forum topic post’s vote data for the current user.
# => PUT /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/(postId)/Votes/MyVote

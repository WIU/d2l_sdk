require_relative 'requests'
require 'json-schema'

##################
## ACTIONS: ######
##################

# TODO: Delete a particular discussion forum from an org unit.
# => DELETE /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)
# TODO: Retrieve a list of all discussion forums for an org unit.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/
# TODO: Retrieve a particular discussion forum for an org unit.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)
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
# TODO: Retrieve topics from the provided discussion forum in an org unit.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/
# TODO: Retrieve a particular topic from the provided discussion forum in an org unit.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)
# TODO: Retrieve the group restrictions for a discussion forum topic.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/groupRestrictions/
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
# TODO: Retrieve a particular post in a discussion forum topic.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/(postId)
# TODO: Retrieve the approval status for a particular post in a discussion forum topic.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/(postId)/Approval
# TODO: Retrieve the flagged status for a particular post in a discussion forum topic.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/(postId)/Flag
# TODO: Retrieve the rating data for a particular post in a discussion forum topic.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/(postId)/Rating
# TODO: Retrieve the current user context’s rating data for a particular post in a discussion forum topic.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/(postId)/Rating/MyRating
# TODO: Retrieve the current read status for a particular post in a discussion forum topic.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/(postId)/ReadStatus
# TODO: Retrieve all the vote data for a particular post in a discussion forum topic.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/(postId)/Votes
# TODO: Retrieve the current user’s vote data for a particular post in a discussion forum topic.
# => GET /d2l/api/le/(version)/(orgUnitId)/discussions/forums/(forumId)/topics/(topicId)/posts/(postId)/Votes/MyVote
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

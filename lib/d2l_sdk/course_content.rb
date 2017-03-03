
###################
### CONTENT ACTIONS
###################

# Delete a specific module from an org unit.
def delete_module(org_unit_id, module_id) # DELETE
  query_string = "/d2l/api/le/#{$version}/#{org_unit_id}/content/modules/#{module_id}"

end

# Delete a specific topic from an org unit.
def delete_topic(org_unit_id, topic_id) # DELETE
  query_string = "/d2l/api/le/#{$version}/#{org_unit_id}/content/topics/#{topic_id}"
  # TODO
end

# Retrieve a specific module for an org unit.
# Returns ContentObject JSON data block of type Module
def get_module(org_unit_id, module_id) # GET
  query_string = "/d2l/api/le/#{$version}/#{org_unit_id}/content/modules/#{module_id}"
  # TODO
end

# Retrieve the structure for a specific module in an org unit.
# Returns JSON array of ContentObject data blocks (either Module or Topic)
def get_module_structure(org_unit_id, module_id) # GET
  query_string = "/d2l/api/le/#{$version}/#{org_unit_id}/content/modules/#{module_id}/structure/"
  # TODO
end

# Retrieve the root module(s) for an org unit.
# Returns JSON array of ContentObject data blocks of type Module
def get_root_modules(org_unit_id) # GET
  query_string = "/d2l/api/le/#{$version}/#{org_unit_id}/root/"
  # TODO
end

# Retrieve a specific topic for an org unit.
# Returns a ContentObject JSON data block of type Topic
def get_topic(org_unit_id, topic_id) # GET
  query_string = "/d2l/api/le/#{$version}/#{org_unit_id}/content/topics/#{topic_id}"
  # TODO
end

# Retrieve the content topic file for a content topic.
# Returns underlying file for a file content topic
def get_topic_file(org_unit_id, topic_id) # GET
  query_string = "/d2l/api/le/#{$version}/#{org_unit_id}/content/topics/#{topic_id}/file"
  # TODO
end

# Add a child +module+ or +topic+ to a specific module’s structure.
# INPUT: TODO
# Returns (if successful) a JSON data block containing properties of the newly created object
def add_child_to_module(org_unit_id, module_id) # POST
  query_string = "/d2l/api/le/#{$version}/#{org_unit_id}/content/modules/#{module_id}/structure/"
  # TODO
end

# Create a new root module for an org unit.
# INPUT: TODO
# Returns JSON array of ContentObject data blocks of type Module
def create_root_module(org_unit_id) # GET
  query_string = "/d2l/api/le/#{$version}/#{org_unit_id}/root/"
  # TODO
end

# Update a particular module for an org unit.
# INPUT: TODO
# NOTE: Cannot use this action to affect a module’s existing Structure property.
def update_module(org_unit_id, module_id) # PUT
  query_string = "/d2l/api/le/#{$version}/#{org_unit_id}/content/modules/#{module_id}"
  # TODO
end

# Update a particular topic for an org unit.
# INPUT: TODO
# Returns underlying file for a file content topic
def update_topic(org_unit_id, topic_id) # GET
  query_string = "/d2l/api/le/#{$version}/#{org_unit_id}/content/topics/#{topic_id}"
  # TODO
end

####################
### CONTENT OVERVIEW
####################

# Retrieve the overview for a course offering.
# TODO

# Retrieve the overview file attachment for a course offering.
# TODO

########
### ISBN
########

# Remove the association between an ISBN and org unit.
# TODO

# Retrieve all the org units associated with an ISBN.
# TODO

# Retrieve all ISBNs associated with an org unit.
# TODO

# Retrieve the association between a ISBN and org unit.
# TODO

# Create a new association between an ISBN and an org unit.
# TODO

####################
### SCHEDULED ITEMS
####################

# Retrieve the overdue items for a particular user in a particular org unit.
# TODO

# Retrieves the calling user’s overdue items, within a number of org units.
# TODO

#####################
### TABLE OF CONTENTS
#####################

# Retrieve a list of topics that have been bookmarked.
# TODO

# Retrieve a list of the most recently visited topics.
# TODO

# Retrieve the table of course content for an org unit.
# TODO

#################
### USER PROGRESS
#################

# Retrieves the aggregate count of completed and required content topics in an org unit for the calling user.
# TODO

# Retrieve the user progress items in an org unit, for specific users or content topics.
# NOTE: UNSTABLE

# Retrieve one user’s progress within an org unit for a particular content topic.
# NOTE: UNSTABLE

# Update a user progress item.
# NOTE: UNSTABLE

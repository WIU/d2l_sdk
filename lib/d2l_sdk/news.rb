require_relative 'requests'
require 'json-schema'
#################
# News:##########
#################

# if since not specified, only includes most 'recent' feed items
# if since specified but until is not, all items since 'since' are fetched
# if since and until are specified, all items between these two dates are fetched
# if since > until, an empty feed list is returned
# purpose: fetch the feed for the current user context
def get_current_user_feed(since = "", _until = "")
  path = "/d2l/api/lp/#{$lp_ver}/feed/"
  # if since is specified, then until can be. Until is not required though.
  if since != ""
    path += "?since=#{since}"
    path += "&until=#{_until}" if _until != ""
  end
  _get(path)
end

require_relative 'requests'
require 'json-schema'

##################
## ACTIONS: ######
##################

# TODO: Remove an LTI link.
# => DELETE /d2l/api/le/(version)/lti/link/(ltiLinkId)
# TODO: Retrieve the information for all LTI links registered for an org unit.
# => GET /d2l/api/le/(version)/lti/link/(orgUnitId)/
# TODO: Retrieve the information for a particular LTI link.
# => GET /d2l/api/le/(version)/lti/link/(orgUnitId)/(ltiLinkId)
# TODO: Register a new LTI link for an org unit.
# => POST /d2l/api/le/(version)/lti/link/(orgUnitId)
# TODO: Build a new quicklink around an existing LTI link.
# => POST /d2l/api/le/(version)/lti/quicklink/(orgUnitId)/(ltiLinkId)
# TODO: Update the information associated with a registered LTI link.
# => PUT /d2l/api/le/(version)/lti/link/(ltiLinkId)

#############################
## LTI TOOL PROVIDERS: ######
#############################

# TODO: Remove the registration for an LTI tool provider.
# => DELETE /d2l/api/le/(version)/lti/tp/(tpId)
# TODO: Retrieve the information for all LTI tool providers registered for an org unit.
# => GET /d2l/api/le/(version)/lti/tp/(orgUnitId)/
# TODO: Retrieve the information for a particular LTI tool provider.
# => GET /d2l/api/le/(version)/lti/tp/(orgUnitId)/(tpId)
# TODO: Register a new LTI tool provider for an org unit.
# => POST /d2l/api/le/(version)/lti/tp/(orgUnitId)
# TODO: Update the information associated with a registered LTI tool provider.
# => PUT /d2l/api/le/(version)/lti/tp/(tpId)

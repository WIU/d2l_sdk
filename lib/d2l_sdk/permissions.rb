require_relative 'requests'
require 'json-schema'

########################
# ACTIONS:##############
########################

# TODO: --UNSTABLE-- Remove the specified capability.
# => DELETE /d2l/api/lp/(version)/permissions/tools/(toolId)/capabilities/(capabilityId)
# TODO: --UNSTABLE-- Reset a permission grant to “not allowed”.
# => DELETE /d2l/api/lp/(version)/permissions/tools/(toolId)/claims/allowed/(grantId)
# TODO: --UNSTABLE-- Retrieve all the capability grants for a tool.
# => GET /d2l/api/lp/(version)/permissions/tools/(toolId)/capabilities/
# TODO: --UNSTABLE-- Retrieve all the permission grants for a tool’s permissions claims.
# => GET /d2l/api/lp/(version)/permissions/tools/(toolId)/claims/
# TODO: --UNSTABLE-- Retrieve all the allowed permission grants for a tool for a tool’s permissions claims.
# => GET /d2l/api/lp/(version)/permissions/tools/(toolId)/claims/allowed/
# TODO: --UNSTABLE-- Determine the allowance state of a permission grant.
# => GET /d2l/api/lp/(version)/permissions/tools/(toolId)/claims/allowed/(grantId)
# TODO: --UNSTABLE-- Retrieve the meta-data for all of a tool’s permission claims.
# => GET /d2l/api/lp/(version)/permissions/tools/(toolId)/claims/metadata/
# TODO: --UNSTABLE-- Retrieve the meta-data for one of a tool’s permission claims.
# => GET /d2l/api/lp/(version)/permissions/tools/(toolId)/claims/metadata/(claimId)
# TODO: --UNSTABLE-- Grant a tool capability.
# => POST /d2l/api/lp/(version)/permissions/tools/(toolId)/capabilities/
# TODO: --UNSTABLE-- Set a permission grant to “allowed”.
# => PUT /d2l/api/lp/(version)/permissions/tools/(toolId)/claims/allowed/(grantId)

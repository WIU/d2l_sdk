require_relative 'requests'
require 'json-schema'

##################
## ACTIONS: ######
##################

# TODO: Delete a file or folder from the current user’s locker.
# => DELETE /d2l/api/le/(version)/locker/myLocker/(path)
# TODO: Delete a file or folder from the provided user’s locker.
# => DELETE /d2l/api/le/(version)/locker/user/(userId)/(path)
# TODO: Retrieve a specific object from the current user’s locker.
# => GET /d2l/api/le/(version)/locker/myLocker/(path)
# TODO: Retrieve a specific object from a provided user’s locker.
# => GET /d2l/api/le/(version)/locker/user/(userId)/(path)
# TODO: Add a new file or folder to the current user’s locker.
# => POST /d2l/api/le/(version)/locker/myLocker/(path)
# TODO: Add a new file or folder to the provided user’s locker.
# => POST /d2l/api/le/(version)/locker/user/(userId)/(path)
# TODO: Rename a folder in the current user’s locker.
# => PUT /d2l/api/le/(version)/locker/myLocker/(path)
# TODO: Rename a folder in the provided user’s locker.
# => PUT /d2l/api/le/(version)/locker/user/(userId)/(path)

##################
## LOCKERS: ######
##################

# TODO: Delete a file or folder from the locker of a group in the provided org unit.
# => DELETE /d2l/api/le/(version)/(orgUnitId)/locker/group/(groupId)/(path)
# TODO: Determine if a locker has been set up for a group category within an org unit.
# => GET /d2l/api/lp/(version)/(orgUnitId)/groupcategories/(groupCategoryId)/locker
# TODO: Retrieve a specific object from a provided group’s locker.
# => GET /d2l/api/le/(version)/(orgUnitId)/locker/group/(groupId)/(path)
# TODO: Set up the locker for a group category within an org unit.
# => POST /d2l/api/lp/(version)/(orgUnitId)/groupcategories/(groupCategoryId)/locker
# TODO: Add a new file or folder to the locker for a group in the provided org unit.
# => POST /d2l/api/le/(version)/(orgUnitId)/locker/group/(groupId)/(path)
# TODO: Rename a folder in the locker for a group in the provided org unit.
# => PUT /d2l/api/le/(version)/(orgUnitId)/locker/group/(groupId)/(path)

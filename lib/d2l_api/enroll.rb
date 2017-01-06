require_relative 'requests'
require 'json-schema'
########################
# Enrollments:##########
########################

# Check the validity of the CreateEnrollmentData that is passed as a payload
def check_create_enrollment_data_validity(course_data)
    schema = {
        'type' => 'object',
        'required' => %w(OrgUnitId UserId RoleId),
        'properties' => {
            'OrgUnitId' => { 'type' => 'integer' },
            'UserId' => { 'type' => 'integer' },
            'RoleId' => { 'type' => 'integer' },
        }
    }
    JSON::Validator.validate!(schema, course_data, validate_schema: true)
end

# Create a new enrollment for a user.
def create_user_enrollment(course_enrollment_data)
    payload = { 'OrgUnitId' => '', # String
                'UserId' => '', # String
                'RoleId' => '', # String
              }.merge!(course_enrollment_data)
    # ap payload
    path = "/d2l/api/lp/#{$version}/enrollments/"
    _post(path, payload)
    puts '[+] User successfully enrolled'.green
    # Returns: EnrollmentData JSON block for the newly enrolled user.
end

# Retrieve enrollment details in an org unit for the provided user.
# Same as +get_org_unit_enrollment_data_by_user+ -- speed of access may differ?
def get_user_enrollment_data_by_org_unit(user_id, org_unit_id)
    path = "/d2l/api/lp/#{$version}/enrollments/users/#{user_id}/orgUnits/#{org_unit_id}"
    _get(path)
    # Returns: EnrollmentData JSON block.
end

# Retrieve a list of all enrollments for the provided user.
# Optional params:
# --orgUnitTypeId (CSV of D2LIDs)
# --roleId: D2LIDs
# --bookmark: string
def get_all_enrollments_of_user(user_id)
    path = "/d2l/api/lp/#{$version}/users/#{user_id}/orgUnits/"
    _get(path)
    # Returns: paged result set w/ the resulting UserOrgUnit data blocks
end

# Retrieve enrollment details for a user in the provided org unit.
# Same as +get_user_enrollment_data_by_org_unit+ -- speed of access may differ?
def get_org_unit_enrollment_data_by_user(org_unit_id, user_id)
    path = "/d2l/api/lp/#{$version}/orgUnits/#{org_unit_id}/users/#{user_id}"
    _get(path)
    # Returns: EnrollmentData JSON block.
end

# Retrieve the collection of users enrolled in the identified org unit.
# Optional params:
# --roleId: D2LID
# --bookmark: String
def get_org_unit_enrollments(org_unit_id)
    path = "/d2l/api/lp/#{$version}/enrollments/orgUnits/#{org_unit_id}/users/"
    _get(path)
    # Returns: paged result set containing the resulting OrgUnitUser data blocks
end

# Retrieve the enrollment details for the current user in the provided org unit.
def get_enrollments_details_of_current_user
    path = "/d2l/api/lp/#{$version}/enrollments/myenrollments/org_unit_id/"
    _get(path)
    # Returns: MyOrgUnitInfo JSON block.
end

# Retrieve the list of all enrollments for the current user
# Optional params:
# --orgUnitTypeId: CSV of D2LIDs
# --bookmark: String
# --sortBy: string
# --isActive: bool
# --startDateTime: UTCDateTime
# --endDateTime: UTCDateTime
# --canAccess: bool
def get_all_enrollments_of_current_user
    path = "/d2l/api/lp/#{$version}/enrollments/myenrollments/"
    _get(path)
    # Returns: paged result set containing the resulting MyOrgUnitInfo data blocks
end

# Retrieve the enrolled users in the classlist for an org unit
def get_enrolled_users_in_classlist(org_unit_id)
    path = "/d2l/api/lp/#{$version}/#{org_unit_id}/classlist/"
    _get(path)
    # Returns: JSON array of ClasslistUser data blocks.
end

# Delete a user’s enrollment in a provided org unit.
def delete_user_enrollment(user_id, org_unit_id)
    path = "/d2l/api/lp/#{$version}/users/#{user_id}/orgUnits/#{org_unit_id}"
    _delete(path)
    # Returns: EnrollmentData JSON block showing the enrollment status
    #          just before this action deleted the enrollment of the user
end

# Delete a user’s enrollment in a provided org unit.
def delete_user_enrollment(user_id, org_unit_id)
    path = "/d2l/api/lp/#{$version}/enrollments/orgUnits/#{org_unit_id}/users/#{user_id}"
    _delete(path)
    # Returns: EnrollmentData JSON block showing the enrollment status
    #          just before this action deleted the enrollment of the user
end

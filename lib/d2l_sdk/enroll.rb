require_relative 'requests'
require 'json-schema'

########################
# Enrollments:##########
########################

# Delete a user’s enrollment in a provided org unit.
def delete_user_enrollment(user_id, org_unit_id)
    path = "/d2l/api/lp/#{$lp_ver}/users/#{user_id}/orgUnits/#{org_unit_id}"
    _delete(path)
    # Returns: EnrollmentData JSON block showing the enrollment status
    #          just before this action deleted the enrollment of the user
end

# Delete a user’s enrollment in a provided org unit.
def delete_user_enrollment_alternative(user_id, org_unit_id)
    path = "/d2l/api/lp/#{$lp_ver}/enrollments/orgUnits/#{org_unit_id}/users/#{user_id}"
    _delete(path)
    # Returns: EnrollmentData JSON block showing the enrollment status
    #          just before this action deleted the enrollment of the user
end

# Retrieve the enrolled users in the classlist for an org unit
def get_enrolled_users_in_classlist(org_unit_id)
    path = "/d2l/api/lp/#{$lp_ver}/#{org_unit_id}/classlist/"
    _get(path)
    # Returns: JSON array of ClasslistUser data blocks.
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
def get_all_enrollments_of_current_user(bookmark = '', sort_by = '', is_active = nil,
                                        start_date_time = '', end_date_time = '',
                                        can_access = nil)
    path = "/d2l/api/lp/#{$lp_ver}/enrollments/myenrollments/"
    path += "?bookmark=#{bookmark}" if bookmark != ''
    path += "?sortBy=#{sort_by}" if sort_by != ''
    path += "?isActive=#{is_active}" if is_active != nil
    path += "?startDateTime=#{start_date_time}" if start_date_time != ''
    path += "?endDateTime=#{end_date_time}" if end_date_time != ''
    path += "?canAccess=#{can_access}" if can_access != nil
    _get(path)
    # Returns: paged result set containing the resulting MyOrgUnitInfo data blocks
end

# Retrieve the enrollment details for the current user in the provided org unit.
def get_enrollments_details_of_current_user(org_unit_id)
    path = "/d2l/api/lp/#{$lp_ver}/enrollments/myenrollments/#{org_unit_id}/"
    _get(path)
    # Returns: MyOrgUnitInfo JSON block.
end

# Retrieve the collection of users enrolled in the identified org unit.
# Optional params:
# --roleId: D2LID
# --bookmark: String
def get_org_unit_enrollments(org_unit_id, role_id = 0, bookmark = '')
    path = "/d2l/api/lp/#{$lp_ver}/enrollments/orgUnits/#{org_unit_id}/users/"
    path += "?roleId=#{role_id}" if role_id != 0
    path += "?bookmark=#{bookmark}" if bookmark != ''
    _get(path)
    # Returns: paged result set containing the resulting OrgUnitUser data blocks
end

# Retrieve enrollment details for a user in the provided org unit.
# Note:
# Same as +get_user_enrollment_data_by_org_unit+
# This call is equivalent to the route that fetches by specifying the user first,
# and then the org unit.
def get_org_unit_enrollment_data_by_user(org_unit_id, user_id)
    path = "/d2l/api/lp/#{$lp_ver}/orgUnits/#{org_unit_id}/users/#{user_id}"
    _get(path)
    # Returns: EnrollmentData JSON block.
end

# Retrieve a list of all enrollments for the provided user.
# Optional params:
# --orgUnitTypeId (CSV of D2LIDs)
# --roleId: D2LIDs
# --bookmark: string
def get_all_enrollments_of_user(user_id, org_unit_type_id = 0, role_id = 0,
                                bookmark = '')
    path = "/d2l/api/lp/1.3/enrollments/users/#{user_id}/orgUnits/"
    path += "?orgUnitTypeId=#{org_unit_type_id}" if org_unit_type_id != 0
    path += "?roleId=#{role_id}" if role_id != 0
    path += "?bookmark=#{bookmark}" if bookmark != ''
    _get(path)
    # Returns: paged result set w/ the resulting UserOrgUnit data blocks
end

# Retrieve enrollment details in an org unit for the provided user.
# Same as +get_org_unit_enrollment_data_by_user+
def get_user_enrollment_data_by_org_unit(user_id, org_unit_id)
    path = "/d2l/api/lp/#{$lp_ver}/enrollments/users/#{user_id}/orgUnits/#{org_unit_id}"
    _get(path)
    # Returns: EnrollmentData JSON block.
end

# Check the validity of the CreateEnrollmentData that is passed as a payload
def check_create_enrollment_data_validity(enrollment_data)
    schema = {
        'type' => 'object',
        'required' => %w(OrgUnitId UserId RoleId),
        'properties' => {
            'OrgUnitId' => { 'type' => 'integer' },
            'UserId' => { 'type' => 'integer' },
            'RoleId' => { 'type' => 'integer' },
        }
    }
    JSON::Validator.validate!(schema, enrollment_data, validate_schema: true)
end

# Create a new enrollment for a user.
def create_user_enrollment(course_enrollment_data)
    payload = { 'OrgUnitId' => '', # String
                'UserId' => '', # String
                'RoleId' => '', # String
              }.merge!(course_enrollment_data)
    # ap payload
    # requires: CreateEnrollmentData JSON block
    path = "/d2l/api/lp/#{$lp_ver}/enrollments/"
    _post(path, payload)
    puts '[+] User successfully enrolled'.green
    # Returns: EnrollmentData JSON block for the newly enrolled user.
end


########################
# PINNING:##############
########################

# REVIEW: Remove the pin from the provided org unit.
def delete_current_user_org_unit_pin(org_unit_id)
  path = "/d2l/api/lp/#{$lp_ver}/enrollments/myenrollments/#{org_unit_id}/pin"
  _delete(path)
  # RETURNS: nil
end

# REVIEW: Pin an org unit to the top of the list of a user’s enrollments.
def pin_org_unit_for_current_context(org_unit_id)
  path = "/d2l/api/lp/#{$lp_ver}/enrollments/myenrollments/#{org_unit_id}/pin"
  _post(path, {})
  # RETURNS: MyOrgUnitInfo JSON block.
end

########################
# GROUPS:###############
########################
# NOTE: Groups functions now in "group.rb"

########################
# SECTIONS:#############
########################
# NOTE: Sections functions now in "section.rb"

########################
# AUDITORS:#############
########################
# NOTE: auditor_id's and auditee_id's are just user_id's.

# REVIEW: Remove an auditee from the list of users that an auditor is auditing.
# Input: auditee_id (D2LID as single JSON number) - Auditee to be removed
def remove_auditee(auditor_id, auditee_id)
  path = "/d2l/api/le/#{$le_ver}/auditing/auditors/#{auditor_id}/auditees/"
  _delete(path, true, {AuditeeId: auditee_id})
end

# REVIEW: Retrieve information for an auditee.
# RETURNS: a AuditedUser JSON block.
def get_auditee(auditee_id)
  path = "/d2l/api/le/#{$le_ver}/auditing/auditees/#{auditee_id}"
  _get(path)
  # RETURNS: a AuditedUser JSON block.
end

# REVIEW: Retrieve information for an auditor.
# RETURNS: a Auditor JSON block.
def get_auditor(auditor_id)
  path = "/d2l/api/le/#{$le_ver}/auditing/auditors/#{auditor_id}"
  _get(path)
  # RETURNS: a Auditor JSON block
end

# REVIEW: Retrieve the list of users an auditor is auditing.
# RETURNS: a JSON array of Auditee blocks.
def get_auditor_auditees(auditor_id)
  path = "/d2l/api/le/#{$le_ver}/auditing/auditors/#{auditor_id}/auditees/"
  _get(path)
  # RETURNS: a JSON array of Auditee blocks.
end

# REVIEW: Add a user to the list of those an auditor is auditing.
# INPUT:
#    JSON Param - auditee_id (D2LID as single JSON number) - Auditee to be added
# RETURNS: nil?
def add_auditor_auditee(auditor_id, auditee_id)
  path = "/d2l/api/le/#{$le_ver}/auditing/auditors/#{auditor_id}/auditees/"
  _post(path, auditee_id)
  # RETURNS: nil?
end

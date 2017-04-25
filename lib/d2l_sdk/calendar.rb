require_relative 'requests'
require 'json-schema'

##################
## Calendar ######
##################
# REVIEW: Remove a calendar event from a particular org unit.
# Returns: ?
def delete_org_unit_calendar_event(org_unit_id, event_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/calendar/event/#{event_id}"
  _delete(path)
end

# REVIEW: Retrieve a calendar event from a particular org unit.
# Returns: a EventDataInfo JSON data block
def get_org_unit_calendar_event(org_unit_id, event_id)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/calendar/event/#{event_id}"
  _get(path)
end

# REVIEW: Retrieve all the calendar events for the calling user,
#       within the provided org unit context.
# RETURNS: This action returns a JSON array of EventDataInfo data blocks.
def get_current_user_calendar_events_by_org_unit(org_unit_id, associated_events_only = nil)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/calendar/events/"
  path += "?associatedEventsOnly=#{associated_events_only}" unless associated_events_only.nil?
  _get(path)
end

# REVIEW: Retrieve the calling user’s calendar events, within a
#       number of org units (see query parameter)
# RETURNS: An ObjectListPage JSON block containing a list of EventDataInfo JSON data blocks.
def get_current_user_calendar_events_by_org_units(association = nil, event_type = nil,
                                                  org_unit_ids_csv, start_date_time,
                                                  end_date_time)
  path = "/d2l/api/le/#{$le_ver}/calendar/events/myEvents/"
  path += "?orgUnitIdsCSV=#{org_unit_ids_csv}"
  path += "&startDateTime=#{start_date_time}"
  path += "&endDateTime=#{end_date_time}"
  path += "&association=#{association}" unless association.nil?
  path += "&eventType=#{event_type}" unless event_type.nil?
  _get(path)
end

# REVIEW: Retrieve the calling user’s events for a particular org unit.
# RETURNS: An ObjectListPage JSON block containing a list of EventDataInfo JSON data blocks.
def get_current_user_events_by_org_unit(association = nil, event_type = nil,
                                        start_date_time, end_date_time)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/calendar/events/myEvents/"
  path += "&startDateTime=#{start_date_time}"
  path += "&endDateTime=#{end_date_time}"
  path += "&association=#{association}" unless association.nil?
  path += "&eventType=#{event_type}" unless event_type.nil?
  _get(path)
end

# REVIEW: Retrieve a count of calling user’s calendar events, within a number of org units
# RETURNS: An ObjectListPage JSON block containing a list of EventCountInfo JSON data blocks.
def get_calendar_event_count(association = nil, event_type = nil, org_unit_ids_csv,
                             start_date_time, end_date_time)
  path = "/d2l/api/le/#{$le_ver}/calendar/events/myEvents/itemCounts/"
  path += "?orgUnitIdsCSV=#{org_unit_ids_csv}"
  path += "&startDateTime=#{start_date_time}"
  path += "&endDateTime=#{end_date_time}"
  path += "&association=#{association}" unless association.nil?
  path += "&eventType=#{event_type}" unless event_type.nil?
  _get(path)
end

# REVIEW: Retrieve a count of calling user’s calendar events, within the
#       provided org unit context.
# RETURNS: An EventCountInfo JSON data block.
def get_org_unit_calendar_event_count(association = nil, event_type = nil,
                                      start_date_time, end_date_time)
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/calendar/events/myEvents/itemCounts/"
  path += "?startDateTime=#{start_date_time}"
  path += "&endDateTime=#{end_date_time}"
  path += "&association=#{association}" unless association.nil?
  path += "&eventType=#{event_type}" unless event_type.nil?
  _get(path)
end

# REVIEW: Retrieve all the calendar events for the calling user, within a number of org units.
# RETURNS: a paged result set containing the resulting EventDataInfo JSON data blocks
def get_paged_calendar_events_by_org_units(org_unit_ids_csv, start_date_time,
                                           end_date_time, bookmark = '')
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/calendar/events/orgunits/"
  path += "?orgUnitIdsCSV=#{org_unit_ids_csv}"
  path += "&startDateTime=#{start_date_time}"
  path += "&endDateTime=#{end_date_time}"
  path += "&bookmark=#{bookmark}" unless bookmark == ''
  _get(path)
end

# REVIEW: Retrieve all the calendar events for a specified user’s explicit
#       enrollments within the organization containing the specified org unit.
# RETURNS: a paged result set containing the resulting EventDataInfo JSON data blocks
def get_user_calendar_events(org_unit_id, user_id, start_date_time, end_date_time,
                             bookmark = '')
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/calendar/events/user/"
  path += "?userId=#{user_id}"
  path += "&startDateTime=#{start_date_time}"
  path += "&endDateTime=#{end_date_time}"
  path += "&bookmark=#{bookmark}" unless bookmark == ''
  _get(path)
  # RETURNS: a paged result set containing the resulting EventDataInfo JSON data blocks
end

# Check the validity of the Calendar.EventData that is passed as a payload
def check_calendar_event_data_validity(event_data)
  schema =
    {
        'type' => 'object',
        'required' => %w(Title Description StartDateTime EndDateTime StartDay
                         EndDay GroupId RecurrenceInfo HasVisibilityRestrictions
                         VisibilityRestrictions CalendarEventViewUrl),
        'properties' =>
        {
            'Title' => { 'type' => 'integer' },
            "Description" => { 'type' => 'integer' },
            "StartDateTime" => { 'type' => %w(string nil) }, # UTCDateTime || nil
            "EndDateTime" => { 'type' => %w(string nil) }, # UTCDateTime || nil
            "StartDay" => { 'type' => %w(string nil) }, # LocalDateTime || nil
            "EndDay" => { 'type' => %w(string nil) }, # LocalDateTime || nil
            "GroupId" => { 'type' => %w(integer nil) }, # D2LID || nil
            "RecurrenceInfo" =>
            {
              'type' => 'object',
              'required' => %w(RepeatType RepeatEvery RepeatOnInfo RepeatUntilDate),
              'properties' =>
              {
                "RepeatType" => { 'type' => 'integer' }, # number -- repeat type
                "RepeatEvery" => { 'type' => 'integer' }, # number
                "RepeatOnInfo" => # Calendar.RepeatOnInfo
                {
                  'type' => 'object',
                  'required' => %w(Monday Tuesday Wednesday Thursday Friday
                                   Saturday Sunday),
                  'properties' =>
                  {
                    "Monday" => { 'type' => 'boolean' }, # boolean
                    "Tuesday" => { 'type' => 'boolean' }, # boolean
                    "Wednesday" => { 'type' => 'boolean' }, # boolean
                    "Thursday" => { 'type' => 'boolean' }, # boolean
                    "Friday" => { 'type' => 'boolean' }, # boolean
                    "Saturday" => { 'type' => 'boolean' }, # boolean
                    "Sunday" => { 'type' => 'boolean' }, # boolean
                  }
                },
                "RepeatUntilDate" => { 'type' => 'string' } # UTCDATETIME
              }
            }, # Calendar.RecurrenceInfo
            "HasVisibilityRestrictions" => { 'type' => 'boolean' },
            "VisibilityRestrictions" =>
            {
              'type' => 'object',
              'required' => %w(Type Range HiddenRangeUnitType StartDate EndDate),
              'properties' =>
              {
                "Type" => { 'type' => 'integer' }, # <number:VISIBILITY_T>,
                "Range" => { 'type' => %w(integer nil) }, # <number>|null,
                "HiddenRangeUnitType" => { 'type' => %w(integer nil) }, # <number:HIDDENUNIT_T>|null,
                "StartDate" => { 'type' => %w(string nil) }, # <string:UTCDateTime>|null,
                "EndDate" => { 'type' => %w(string nil) } # <string:UTCDateTime>|null,
              }
            }, # Calendar.VisibilityInfo
            "CalendarEventViewUrl" => { 'type' => 'string' } # url
        }
    }
  JSON::Validator.validate!(schema, event_data, validate_schema: true)
end

# REVIEW: Create Schema checker; Check that this payload conforms to it.
# Create a new event.
# INPUT: Calendar.EventData
# RETURNS:a EventDataInfo data block for the newly created event.
def create_event(org_unit_id, event_data)
  # POST /d2l/api/le/#{$le_ver}/#{org_unit_id}/calendar/event/
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/calendar/event/"
  payload = { # Calendar.EventDataInfo
    "Title" => "",
    "Description" => "",
    "StartDateTime" => nil, # UTCDateTime || nil
    "EndDateTime" => nil, # UTCDateTime || nil
    "StartDay" => nil, # LocalDateTime || nil
    "EndDay" => nil, # LocalDateTime || nil
    "GroupId" => nil, # D2LID || nil
    "RecurrenceInfo" => # Calendar.RecurrenceInfo
    {
      "RepeatType" => 0, # number -- repeat type
      "RepeatEvery" => 0, # number
      "RepeatOnInfo" => # Calendar.RepeatOnInfo
      {
        "Monday" => false, # boolean
        "Tuesday" => false, # boolean
        "Wednesday" => false, # boolean
        "Thursday" => false, # boolean
        "Friday" => false, # boolean
        "Saturday" => false, # boolean
        "Sunday" => false, # boolean
      },
      "RepeatUntilDate" => "" # UTCDATETIME
    },
    "HasVisibilityRestrictions" => false,
    "VisibilityRestrictions" => # Calendar.VisibilityInfo
    {
      "Type" => 0, # <number:VISIBILITY_T>,
      "Range" => nil, # <number>|null,
      "HiddenRangeUnitType" => nil, # <number:HIDDENUNIT_T>|null,
      "StartDate" => nil, # <string:UTCDateTime>|null,
      "EndDate" => nil # <string:UTCDateTime>|null,
    },
    "CalendarEventViewUrl" => "" # String:URL
  }.merge!(event_data)
  check_calendar_event_data_validity(payload) # NOTE: Test later
  _post(path, payload)
end

# REVIEW: Create Schema checker; Check that this payload conforms to it.
# Update the properties for a calendar event from a particular org unit.
# INPUT: Calendar.EventData
# RETURNS:a EventDataInfo data block for the newly updated event.
def update_event(org_unit_id, event_id, event_data)
  # PUT /d2l/api/le/#{$le_ver}/#{org_unit_id}/calendar/event/#{event_id}
  path = "/d2l/api/le/#{$le_ver}/#{org_unit_id}/calendar/event/#{event_id}"
  payload = { #Calendar.EventDataInfo
    "Title" => "",
    "Description" => "",
    "StartDateTime" => nil, # UTCDateTime || nil
    "EndDateTime" => nil, # UTCDateTime || nil
    "StartDay" => nil, # LocalDateTime || nil
    "EndDay" => nil, # LocalDateTime || nil
    "GroupId" => nil, # D2LID || nil
    "RecurrenceInfo" => # Calendar.RecurrenceInfo
    {
      "RepeatType" => 0, # number -- repeat type
      "RepeatEvery" => 0, # number
      "RepeatOnInfo" => # Calendar.RepeatOnInfo
      {
        "Monday" => false, # boolean
        "Tuesday" => false, # boolean
        "Wednesday" => false, # boolean
        "Thursday" => false, # boolean
        "Friday" => false, # boolean
        "Saturday" => false, # boolean
        "Sunday" => false, # boolean
      },
      "RepeatUntilDate" => "" # UTCDATETIME
    },
    "HasVisibilityRestrictions" => false,
    "VisibilityRestrictions" => # Calendar.VisibilityInfo
    {
      "Type" => 0, # <number:VISIBILITY_T>,
      "Range" => nil, # <number>|null,
      "HiddenRangeUnitType" => nil, # <number:HIDDENUNIT_T>|null,
      "StartDate" => nil, # <string:UTCDateTime>|null,
      "EndDate" => nil # <string:UTCDateTime>|null,
    },
    "CalendarEventViewUrl" => "" # String:URL
  }.merge!(event_data)
  check_calendar_event_data_validity(payload) # NOTE: Test later
  _put(path, payload)
end

require_relative 'requests'

########################
# LOGGING:##############
########################

# retrieve all current log messages
# with MANY parameters possible for filtering.
# REQUIRED PARAMS: date_range_start; date_range_end
# logLevel is CSV formatted, so simple delimit each value with a comma
def get_all_logs(date_range_start, date_range_end, search = '', log_level = '',
                 logger_assembly = '', user_id = 0, message_group_id = 0,
                 include_traces = nil, org_unit_id = 0, bookmark = '')
    path = "/d2l/api/lp/#{$lp_ver}/logging/"
    path += "?dateRangeStart=#{date_range_start}"
    path += "&dateRangeEnd=#{date_range_end}"
    path += "&search=#{search}" if search != ''
    path += "&logLevel=#{log_level}" if log_level != ''
    path += "&loggerAssembly=#{logger_assembly}" if logger_assembly != ''
    path += "&userId=#{user_id}" if user_id != 0
    path += "&messageGroupId=#{message_group_id}" if message_group_id != 0
    path += "&includeTraces=#{include_traces}" if include_traces != nil
    path += "&orgUnitId=#{org_unit_id}" if org_unit_id != 0
    path += "&bookmark=#{bookmark}" if bookmark != ''
    ap path
    _get(path)
    # returns paged result set of Message data blocks
end

# retrieve all current log arranged in message groups
# REQUIRED PARAMS: date_range_start; date_range_end
# logLevel is CSV formatted, so simple delimit each value with a comma
def get_all_message_group_logs(date_range_start, date_range_end, search = '',
                               log_level = '', logger_assembly = '', user_id = 0,
                               message_group_id = 0, org_unit_id = 0,
                               bookmark = '')
    path = "/d2l/api/lp/#{$lp_ver}/logging/grouped/"
    path += "?dateRangeStart=#{date_range_start}"
    path += "&dateRangeEnd=#{date_range_end}"
    path += "&search=#{search}" if search != ''
    path += "&logLevel=#{log_level}" if log_level != ''
    path += "&loggerAssembly=#{logger_assembly}" if logger_assembly != ''
    path += "&userId=#{user_id}" if user_id != 0
    path += "&messageGroupId=#{message_group_id}" if message_group_id != 0
    path += "&orgUnitId=#{org_unit_id}" if org_unit_id != 0
    path += "&bookmark=#{bookmark}" if bookmark != ''
    _get(path)
    # returns paged result set of MessageGroupSummary data blocks
end

# retrieve identified log message
def get_log_message(log_message_id, include_traces = nil)
  path = "/d2l/api/lp/#{$lp_ver}/logging/#{log_message_id}/"
  path += "?includeTraces=#{include_traces}" if !include_traces.nil?
  _get(path)
  # returns Message JSON block
end

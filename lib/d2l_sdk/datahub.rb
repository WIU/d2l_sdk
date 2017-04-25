require_relative 'requests'
require 'json-schema'
require 'zip'
require 'csv'
##########################
# DATA HUB Import/Export##
##########################

# Requirements to work properly:
# !!! 1. Custom Reporting Framework must be on
# --- Organization Tools > Custom Reporting Framework > Click "Availability" Slider
# --- This should have enabled it, otherwise you may need further permissions
# !!! 2. Next, the API user must have the permissions
# --- Roles and Permissions > ROLE > Filter by 'Custom Reporting Framework' >
# --- Enable all reports you need.
# !!! 3. EACH data set has its own permissions. These must be enabled.
# --- The Insights tool must be on, this can be checked at:
# ----- "Config variable browser" > tools > insights > ETL > isEnabled
# ----- If the value is 0, then you must contact support to enable it
# ----- If the value is 1, then move onto the next sub-step
# --- Roles and Permissions > ROLES> Filter by 'Insights' > Enable "Can Export
# --- Data Warehouse Reports" permission

# Lists all available data sets
def get_all_data_sets
    _get("/d2l/api/lp/#{$lp_ver}/dataExport/list")
    # returns a JSON array of DataSetData blocks
end

# Retrieve a data set
def get_data_set(data_set_id)
    _get("/d2l/api/lp/#{$lp_ver}/dataExport/list/#{data_set_id}")
    # returns a DataSetData JSON block
end

# assures that the CreateExportJobData JSON block is valid based off of a
# specified JSON schema.
# filter names: startDate, endDate, roles, and parentOrgUnitId
# --- startDate and EndDate must be UTC dates
# --- parentOrgUnitId and roles are integers corresponding to an ou_id & role_id
def validate_create_export_job_data(create_export_job_data)
    schema = {
        'type' => 'object',
        # 'title'=>'the CreateExportJobData JSON block',
        'required' => %w(DataSetId Filters),
        'properties' => {
            'DataSetId' => { 'type' => 'string' },
            'Filters' => { # define the filter array
                # 'description' => 'The array of filters for CreateExportJobData',
                'type' => 'array',
                'items' =>
                  {
                      'type' => "object",
                      "properties" => {
                        "Name" => { 'type' => "string" },
                        "Value" => { 'type' => "string" }
                      }
                  }
            }
        }
    }
    # ap schema
    JSON::Validator.validate!(schema, create_export_job_data, validate_schema: true)
    # returns true if the CreateExportJobData JSON block is valid
end

# Create an export job for the requested data set
def create_export_job(create_export_job_data)
    # init payload and merge with export job data
    payload = {
        'DataSetId' => '',
        'Filters' => [] # {"Name"=> "startDate", "Value" => UTCDATETIME STRING}
    }.merge!(create_export_job_data)
    validate_create_export_job_data(payload)
    # Requires: CreateExportJobData JSON parameter
    path = "/d2l/api/lp/#{$lp_ver}/dataExport/create"
    _post(path, payload)
    # returns ExportJobData JSON block
end

# List all available export jobs that you have previously submitted
def get_all_export_jobs(bookmark = '') # optional parameter page -- integer
    path = "/d2l/api/lp/#{$lp_ver}/dataExport/jobs"
    path += "?bookmark=#{bookmark}" if bookmark != ''
    _get(path)
    # returns: JSON array of paged ExportJobData blocks, sorted by SubmitDate
end

# Retrieves information about a data export job that you have previously submitted.
def get_data_export_job(export_job_id)
    _get("/d2l/api/lp/#{$lp_ver}/dataExport/jobs/#{export_job_id}")
    # returns: ExportJobData JSON block
end

def get_job_status_code(export_job_id)
  get_data_export_job(export_job_id)["Status"] # if 2 is OKAY/COMPLETED
end

# Downloads the identified job and stores the zip within the working directory
# Extracts zipped job contents in "export_jobs" folder of working directory
def download_job_csv(export_job_id)
    attempt = 0
    puts "Attempting to download job: #{export_job_id}"
    while attempt < 20 # Attempts 20 times (~3 mins) unless job failed.
      status = get_job_status_code(export_job_id)
      case status
      when 2 # If the status was okay, break loop + return download of job
        zip_fname = 'export1.zip'
        puts "Job complete, writing to zip: #{zip_fname}"
        File.write(zip_fname, _get_raw("/d2l/api/lp/#{$lp_ver}/dataExport/download/#{export_job_id}"))
        unzip(zip_fname, /sec_|off_/) # unzip file; filter if Enrollments + CSV
        puts "file downloaded and unzipped"
        break
      when /3|4/
        puts "Job download failed due to status: #{status}"
        if status == 3
          puts "Status description: Error - An error occurred when processing the export"
        else
          puts "Status description: Deleted - File was deleted from file system"
        end
        break
      else # else, print out the status and wait 10 seconds before next attempt
        puts "The job is not currently ready to download\n Status Code: #{status}"
        if status.zero?
          puts "Status description: Queued -  Export job has been received for processing."
        else
          puts "Status description: Processing - Currently in process of exporting data set."
        end
        puts "Sleeping for 10 seconds.."
        sleep 10
        attempt += 1
      end
      # returns: ZIP file containing a CSV file of data from the export job
    end
end

# Unzip the file, applying a regex filter to the CSV if
# the file is Enrollments data.
def unzip(file_path, csv_filter = //)
  puts "Unzipping file: #{file_path}"
  # Unzip the file
  Zip::File.open(file_path) do |zip_file|
    # for each file in the zip file
    zip_file.each do |f|
       # create file path of export_jobs/#{f.name}
       f_path = File.join("export_jobs", f.name)
       # make the directory if not already made
       FileUtils.mkdir_p(File.dirname(f_path))
       # extract the file unless the file already exists
       zip_file.extract(f, f_path) unless File.exist?(f_path)
       # if the file is CSV and Enrollments, apply filters and proper
       # CSV formatting to the file, writing it as base f.name  + filtered.csv
       if (f.name.include? ".csv") && (f.name.include? "Enrollments")
         filter_formatted_enrollments("export_jobs/#{f.name}", csv_filter, "export_jobs/instr.csv")
       end
    end
  end
end

# Get all 'current' courses, assuming all instr courses are current
# and add their sec/off course_term_star_num codes to a set.
# return: set of current classes formatted as "#{course_term}_#{star_number}"
def get_current_courses(csv_fname)
  puts "Retrieving current courses from #{csv_fname}"
  instr_courses = Set.new
  CSV.foreach(csv_fname, headers: true) do |row|
    star_number = row[0]
    course_term = row[10]
    instr_courses.add("#{course_term}_#{star_number}")
  end
  instr_courses
end

# Filter all enrollments and withdrawals in a csv file, excluding data
# that is not properly formatted (based on ou code), not a current or
# future course, or nil for their ou code.
def filter_formatted_enrollments(csv_fname, instr_fname, regex_filter = //)
  # Create csv with 'filtered' pre-appended to '.csv' substring
  filtered_csv = csv_fname.gsub(/\.csv/, "filtered.csv")
  File.open(filtered_csv, 'w') do |file|
    # set row num to 0 to keep track of headers
    row_num = 0
    current = get_current_courses(instr_fname)
    # for each row
    puts "Filtering #{csv_fname}"
    CSV.foreach(csv_fname) do |row|
      # the line is initialized as an empty string
      line = ""
      # Skip the row if not a valid
        # or skip in-filter OU_code,
        # or skip if the header
        # or skip if not within the INSTR SET of current/future courses
      if row[3].nil? || row_num > 0 && (row[3] !~ regex_filter) || (!current.include? row[3][4..-1])
        row_num += 1
        next
      end
      # for values not filtered from above ^
      # for all of these values
      row[0..-1].each do |value|
        # If it a UTC date time value, then parse as Time.
        if value =~ /\b[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]*Z\b/ # if the value is UTC formatted
          line << "\"#{Time.parse(value)}\""
        elsif value == row[-1] # if its the last value in the row
          line << "\"#{value}\"" #  then dont put a comma at the end.
        else # not the last value in the row,
          line << "\"#{value}\"," # throw a comma after the value
        end
      end
      file.write(line + "\n") # append this line to the csv
      row_num += 1 # increment the row number
    end
  end
end

require_relative 'requests'
require 'json-schema'

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
                        "Name" => {'type'=>"string"},
                        "Value" => {'type'=>"string"}
                      }
                  }
            }
        }
    }
    #ap schema
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
  get_data_export_job(export_job_id)["Status"]
end

# Returns a ZIP file containing a CSV file with the data of the requested
# export job that you previosly submitted.
#
def download_job_csv(export_job_id)
    attempt = 0
    while attempt < 7 # Attempts 7 times, waiting ~75 seconds total
      status = get_job_status_code(export_job_id)
      case status
      when 2 # If the status was okay, break loop + return download of job
        break _get("/d2l/api/lp/#{$lp_ver}/dataExport/download/#{export_job_id}")
      else # else, print out the status and wait 10 seconds before next attempt
        puts "The job is not currently ready to download\n Status Code: #{status}"
        puts "Sleeping for 10 seconds.."
        sleep 10
        attempt = attempt + 1
      end
      # returns: ZIP file containing a CSV file of data from the export job
    end
end

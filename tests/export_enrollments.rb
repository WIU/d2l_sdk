require_relative "../lib/d2l_sdk"

# puts "printing out possible data sets..."
# ap get_all_data_sets

data_set_id = "c1bf7603-669f-4bef-8cf4-651b914c4678"
payload = {
  'DataSetId' => data_set_id,
  'Filters' => [
    {
      'Name'=>'startDate',
      'Value'=>'2015-01-17T19:39:19.787Z'
    },
    {
      'Name'=>'endDate',
      'Value'=>'2017-01-18T19:39:19.787Z'
    }
  ]
}

puts "retrieving data set #{data_set_id}"
ap get_data_set(data_set_id)

puts "The data set attempted for exporting a job is..."
ap payload

response = create_export_job(payload)
job_id =  response["ExportJobId"]
puts "job id: #{job_id}"
puts "job status code: #{get_job_status_code(job_id)}"

ap download_job_csv(job_id)

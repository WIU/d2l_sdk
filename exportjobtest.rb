require_relative "lib/d2l_sdk.rb"
begin
  payload = {"DataSetId" => "2", "Filters" => [{"Name"=> "startDate", "Value" => "1"}] }
  ap payload
  ap validate_create_export_job_data(payload)
rescue => exception
  puts exception
end

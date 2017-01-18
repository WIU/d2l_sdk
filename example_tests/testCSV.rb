require 'csv'
require 'Time'
#Smaller version of Enroll/Withdrawals-01
csv_fname = "lib/export_jobs/Enrollments and Withdrawals-01-17-2017T10-40-29.csv"
# "export_jobs/Enrollments and Withdrawals-01-17-2017T14-11-41.csv"
# "lib/export_jobs/Enrollments and Withdrawals-01-17-2017T10-40-29.csv"

def fix_csv_format(csv_fname)
  # for this csv file...
  File.open(csv_fname + ".csv", 'w') do |file|
    # set row num to 0 to keep track of headers
    row_num = 0
    # for each row
    CSV.foreach(csv_fname) do |row|
      # the line is initialized as an empty string
      line = ""
      # for all of these values
      row[0..-1].each do |value|
        # If it a UTC date time value, then parse as Time.
        if value =~ /\b[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]*Z\b/ # if the value is UTC formatted
          line << "\"#{Time.parse(value)}\""
        # if its the last value in the row then dont put a comma at the end.
        elsif value == row[-1]
          line <<"\"#{value}\""
        # not the last value in the row, throw a comma after the value
        else
          line << "\"#{value}\","
        end
      end
      # append this line to the csv
      file.write(line + "\n")
      # increment the row number
      row_num += 1
    end
  end
end

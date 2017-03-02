require_relative "lib/d2l_sdk"
require "set"

@debug = false
@testing = false
start = Time.now
puts "Getting all courses"
all_courses = get_all_courses
duration  = Time.now - start
puts "#{all_courses.size} courses retrieved. Time taken: #{Time.at(duration).strftime "%M:%S"}"
iteration = 0 #if @testing
max_iterations = 10 if @testing
start = Time.now

def get_adjusted_courses(file_path)
  # If there isnt already a file containing all adjusted courses, create one
  File.write(file_path, '') {} unless File.exist?(file_path)
  puts "Grabbing adjusted courses from file at: #{file_path}"
  adjusted_courses = Set.new [] # assures unique student ids // none processed >1 times
  File.open(file_path, 'r') do |file_handle|
    file_handle.each_line do |line|
      adjusted_courses.add(line.gsub(/\n/,''))
    end
  end
  puts "adjusted courses pulled from file and stored in array 'adjusted_courses'"
  adjusted_courses # Returns set of adjusted course OU IDs (would ruin time complexity with an array)
end
file_path = "adjusted_courses.txt"
adjusted_courses = get_adjusted_courses(file_path)
year_ago = Time.new(2016)
all_courses.each do |course_arr_item|

    # testing constraints to limit number of iterations.
    iteration += 1
    if @testing
      break if iteration >= max_iterations
    end

    # append to a file (asserted that its already created as get_adjusted_courses handles this.)
    course_id = course_arr_item["Identifier"]
    if adjusted_courses.include?(course_id)
      puts "Course [#{course_id}] already has been adjusted." if @debug
      next
    end
    if course_arr_item["Identifier"].nil?
      ap course_arr_item
      next
    end
    # Retrieve course data by ID
    course = get_course_by_id(course_id)
    puts "Original course information returned by its id:" if @debug
    File.open(file_path, 'a'){ |f| f << "#{course_id}\n"}
    puts "Course [#{course["Name"]} (#{course_id})] has been added to #{file_path}" if @debug

    ap course if @debug
    new_end_date = course["EndDate"]
    # if course endDate is nil, print a message and skip it
    if new_end_date.nil?
      puts "Course [#{course["Name"]} (#{course_id})] does not have a valid endDate (reason: nil)" if @debug
      next
    end
    puts "[#{iteration}/#{all_courses.size}]Course [#{course["Name"]} (#{course_id})] original end date: #{new_end_date}"# if @debug
    new_end_date = Time.parse(new_end_date) + (60 * 60 * 24 * 7) # Seconds * Minutes * Hours * Days
    if new_end_date < year_ago # if before 2016...
      puts "Course [#{course["Name"]} (#{course_id})] is not within the filtered set of classes (reason: before 2016)" if @debug
      next
    end
    new_end_date = new_end_date.iso8601(3)

    update_payload = {
      'Name' => course["Name"], # String
      'Code' => course["Code"], # String
      'StartDate' => course["StartDate"], # String: UTCDateTime | nil
      'EndDate' => "#{new_end_date}", # String: UTCDateTime | nil
      'IsActive' => course["IsActive"] # bool
    }
    ap update_payload if @debug
    update_course_data(course_id, update_payload)
    updated_course = get_course_by_id(course_id)
    puts "Course [#{updated_course["Name"]} (#{course_id})] adjusted end date: #{updated_course["EndDate"]}"

    puts "Updated course information returned by its id:" if @debug
    ap get_course_by_id(course_id) if @debug
end
#ap adjusted_courses.to_a
#print "[!] duration of 5000 iterations, where 3000 have already been completed: "
duration  = Time.now - start
puts Time.at(duration).strftime "%M:%S"

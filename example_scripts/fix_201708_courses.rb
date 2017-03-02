require_relative "lib/d2l_sdk"

# ap get_all_semesters.reject{|semester| !semester["Code"].include?(201708.to_s)}
semester_201708_id = "111723" # Fall '17 semester recieved through line of code above
courses = get_courses_by_code(201708) # get all courses coded as 201708
courses_done = 0
courses.each do |course| # for each of these 201708 courses
  # print out progress thus far
  puts "Progress: #{courses_done}/#{courses.length} (#{(courses_done/courses.length).to_i})" if courses_done % 10 == 0
  course_id = course["Identifier"] # get their identifier
  add_parent_to_org_unit(semester_201708_id, course_id) # add the semester as the parent
  courses_done += 1
end

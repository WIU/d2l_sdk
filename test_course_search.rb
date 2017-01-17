require_relative "lib/d2l_sdk"
require 'benchmark'

#ap get_org_unit_sections(23434)
=begin
courses = get_all_courses
#ap courses[0..30]
courses[0..300].each do |course|
  section = get_org_unit_sections(course["Identifier"])
  if section != nil
    puts section
    break
  end
end
=end
ap get_org_unit_properties(6840)


#search_var = "test"
#ap get_courses_by_code(search_var)
#n = get_courses_by_code_(search_var)


#ASSUMPTION: get_all_courses is slower.
#m = []
#get_courses_by_code(search_var).each do |course|
#  course.delete("Path")
#  m.push(course)
#end
#ap get_all_courses.size
#ap get_all_courses_["Items"]

#puts "get_courses_by_code_ has #{n.size - m.size} more courses returned than its alternative"
#puts "Courses not included in get_courses_by_code_"
#ap m - n
#puts "Courses not included in get_courses_by_code"
#ap n - m

#Benchmark.bmbm do |x|
#  x.report("get_courses_by_code_"){ap get_courses_by_code_(search_var).size}
#  x.report("get_all_paged_courses_by_code"){ap get_all_paged_courses_by_code(search_var).size}
#end
=begin
Benchmark.bmbm do |x|
  x.report("get_all_courses"){get_all_courses}
  x.report("get_all_courses_"){get_all_courses_}
end
=end

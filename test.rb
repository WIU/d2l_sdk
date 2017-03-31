require_relative "lib/d2l_sdk"

def test_news_upload
  create_news_item(11215, {"StartDate"=>"2017-03-28T18:54:56.000Z"}, ["lol.txt"])
  puts "\r\n\r\n\r\n"
  ap get_org_unit_news_items(11215)
end

def test_module_upload
  ap get_root_modules(11215)
  ap get_course_overview(11215)
  ap get_org_unit_toc(11215)
  #ap get_whoami
  #ap get_org_unit_children(11215)
  #ap get_course_by_id(11215)
end

#test_module_upload
test_news_upload

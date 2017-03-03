require_relative 'lib/d2l_sdk'
user =  get_user_by_user_id(get_whoami['Identifier'])
date_range_start = '2017-01-17T19:39:19.000Z'
date_range_end = '2017-01-27T19:39:19.000Z'
# logs_csv = get_all_logs(date_range_start, date_range_end, 'login', '', '', user_id = user["UserId"])
# logs_csv = get_all_logs(date_range_start, date_range_end)
# puts _get('/d2l/api/lp/1.5/logging/?dateRangeStart=2017-01-17T19%3a39%3a19.7Z&dateRangeEnd=2017-02-27T19%3a39%3a19.7Z')
#ap get_all_enrollments_of_current_user
ap user['UserId']
# query_string = "/d2l/api/le/1.22/6705/content/userprogress/?userId=#{user['UserId']}"

query_string = "/d2l/api/le/1.22/6705/competencies/structure"
query_string = "/d2l/api/le/1.22/21400/content/root/"
query_string = "/d2l/api/le/1.22/21400/content/toc"
ap _get(query_string)["Modules"][1]["Topics"][1]["Title"]
topic =  _get(query_string)["Modules"][1]["Topics"][1]["TopicId"]
query_string = "/d2l/api/le/1.20/21400/content/userprogress/#{topic}?userId=#{user['UserId']}"
ap query_string
ap _get(query_string)
ap _get("/d2l/api/le/1.22/6705/content/recent")

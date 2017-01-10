# Ruby Valence API
[![Gem Version](https://badge.fury.io/rb/d2l_api.svg)](https://badge.fury.io/rb/d2l_api)

The Ruby Valence API is a CRUD based API that facilitates HTTP methods coinciding with Brightspace's routing table to perform common CRUD functions.

You can:
  - create, get, update, and delete users, courses, semesters, org_units, and course_templates.
  - search for users and courses based on their parameters, as opposed to the API's need for explicitly stated Usernames and Id's.

The Valence API

> The Valence API is Rest-like, allowing interactions through HTTP with the back-end of a host. Most all of the Learning Platform functions that comprise D2L's Rest-like API are usable through this Ruby API implementation.

While not all functions have been implemented for the Learning Platform of the Valence API, all critical CRUD functionalities have been implemented.

### Index
1. [Tech] (#tech)
2. [Installation] (#installation)
3. [Usage] (#usage)
4. [List Of Methods] (#list-of-methods)
5. [Contributing] (#contributing)
6. [History] (#history)
7. [Credits] (#credits)
8. [License] (#license)

### Tech

The Ruby Valence API uses a number of required libraries and gems:

* [Test::Unit](https://ruby-doc.org/stdlib-1.8.7/libdoc/test/unit/rdoc/Test/Unit.html) - Ruby unit testing for d2l_api
* [rubygems](https://github.com/rubygems/rubygems) -  package manager for the Ruby programming language
* [awesome_print](https://github.com/awesome-print/awesome_print) - Pretty print your Ruby objects with style
* [Base64](https://ruby-doc.org/stdlib-2.3.0/libdoc/base64/rdoc/Base64.html) - Encoding and decoding of binary data using Base64 representation.
* [JSON](http://ruby-doc.org/stdlib-2.0.0/libdoc/json/rdoc/JSON.html) - JavaScript Object Notation module for data inter-change formatting
* [restclient](https://github.com/rest-client/rest-client) - Simple HTTP and REST client for Ruby
* [openssl](http://ruby-doc.org/stdlib-2.0.0/libdoc/openssl/rdoc/OpenSSL.html) - provides SSL, TLS and general purpose cryptography
* [open-uri](https://ruby-doc.org/stdlib-2.1.0/libdoc/open-uri/rdoc/OpenURI.html) - an easy-to-use wrapper for Net::HTTP, Net::HTTPS and Net::FTP.
* [colorize](https://rubygems.org/gems/colorize) - Awesome colors for clarity in terminal/cmd
* [json schema](https://github.com/ruby-json-schema/json-schema) - Validates all POST and PUT JSON payloads against their schema

Of course, this requires a Desire2Learn/Valence server to work with.

### Installation

Ruby Valence API can be installed using the following statement:

```sh
$ gem install d2l_api
```

Once installed, the config file of the gem must be setup. To do this, you must first unpack the gem, go to bin/lib/ and alter config.rb with your own api and user keys.

Example:
```sh
$ gem unpack d2l_api
$ cd d2l_api-0.1.1/lib/d2l_api/
$ vim config.rb
```

### Usage
Complete the installation, require the 'd2l_api' gem in your ruby file, and use the many functions supported by the api to perform CRUD methods.
Example:
```sh
$ irb
$ require "d2l_api"
$ x =  multithreaded_user_search("FirstName", "test", 17) #searches using 17 threads for a user based on 'test' being in the first name.
$ get_user_by_user_id(x[0])
$ update_user_data(x[0]["Identifier"], x[0].merge!('FirstName'=>"Test2"))
```

One may also simply clone this repository, edit the lib/d2l_api/config.rb, run rake build within a local repository and gem install that gem. This can be done as follows:
```sh
$ git clone -b restructuring git@gitlab.wiu.edu:ajk142/valence_testing.git
```
Edit the config.rb for your api keys, version, and hostname
```sh
$ rake build
$ gem install d2l_api pkg/d2l_api-[VERSION].gem
```
Uninstalling the previous version can be done by this command:
```sh
$ gem uninstall d2l_api --version [PREVIOUS-VERSION]
```




### List of Methods

1. Users
  * create_user_data(JSON user_data)
  * get_whoami
  * get_users(String org_defined_id, String username, String bookmark)
  * get_user_by_username(String username)
  * get_users_by_bookmark(String bookmark)
  * does_user_exist(String username)
  * multithreaded_user_search(String parameter, String search_string, Int num_of_threads, Boolean regex)
  * get_user_by_user_id(String user_id)
  * update_user_data(String user_id, JSON new_data)
  * delete_user_data(String user_id)
2. Semesters
  * create_semester_data(JSON semester_data)
  * get_all_semesters
  * get_semester_by_id(String org_unit_id)
  * add_course_to_semester(Int course_id, Int semester_id)
  * remove_course_from_semester(Int course_id, Int semester_id)
  * get_semester_by_name(String search_string)
  * update_semester_data(String org_unit_id, JSON semester_data)
  * recycle_semester_data(String org_unit_id)
  * recycle_semester_by_name(String name)
3. Courses
  * create_course_data(JSON course_data)
  * get_org_department_classes(String org_unit_id)
  * get_course_by_id(String org_unit_id)
  * get_all_courses
  * get_courses_by_name(String org_unit_name)
  * get_courses_by_property_by_string(String property, String search_string)
  * get_courses_by_property_by_regex(String property, regular-expression regex)
  * update_course_data(String course_id, JSON new_data)
  * delete_course_by_id(String org_unit_id)
4. Course Templates
  * create_course_template(JSON course_template_data)
  * get_course_template(String org_unit_id)
  * get_all_course_templates
  * get_course_template_by_name(String org_unit_name)
  * get_course_templates_by_schema
  * update_course_template(String org_unit_id, JSON new_data)
  * delete_course_template(String org_unit_id)
  * delete_all_course_templates_with_name(String name)
5. Org Units
  * get_org_unit_descendants(String org_unit_id, Int ou_type_id)
  * get_paged_org_unit_descendants(String org_unit_id, Int ou_type_id, String bookmark)
  * get_org_unit_parents(String org_unit_id, Int ou_type_id)
  * add_parent_to_org_unit(Int parent_ou_id, Int child_ou_id)
  * get_org_unit_ancestors(String org_unit_id, Int ou_type_id)
  * get_org_unit_children(String org_unit_id, Int ou_type_id)
  * get_paged_org_unit_children(String org_unit_id, String bookmark)
  * get_org_unit_properties(String org_unit_id)
  * delete_relationship_of_child_with_parent(Int parent_ou_id, Int child_ou_id)
  * delete_relationship_of_parent_with_child(Int parent_ou_id, Int child_ou_id)
  * get_all_childless_org_units(String org_unit_type String org_unit_code, String org_unit_name, String bookmark)
  * get_all_orphans(String org_unit_type String org_unit_code, String org_unit_name, String bookmark)
  * add_child_org_unit(String org_unit_id, Int child_org_unit_id)
  * get_recycled_org_units(String bookmark)
  * recycle_org_unit(String org_unit_id)
  * delete_recycled_org_unit(String org_unit_id)
  * restore_recyced_org_unit(string org_unit_id)
  * create_custom_org_unit(JSON org_unit_data)
  * update_org_unit(String org_unit_id, JSON org_unit_data)
  * get_organization_info
  * get_all_org_units_by_type_id(Int outype_id)
  * get_outype(Int outype_id)
  * get_all_outypes
6. Enrollments
  * create_user_enrollment(JSON course_enrollment_data)
  * get_user_enrollment_data_by_org_unit(String user_id, String org_unit_id)
  * get_all_enrollments_of_user(String user_id, optional String org_unit_type_id, optional String role_d, optional String bookmark)
  * get_org_unit_enrollment_data_by_user(String org_unit_id, String user_id)
  * get_enrollments_details_of_current_user
  * get_all_enrollments_of_current_user(optional String bookmark, optional String sort_by, optional boolean is_active, optional UTCDATETIME start_date_time, optional UTCDATETIME end_date_time, optional boolean can_access)
  * get_enrolled_users_in_classlist(String org_unit_id)
  * delete_user_enrollment(String user_id, String org_unit_id)
7. Groups
  * delete_group_category(String org_unit_id, String group_category_id)
  * delete_group(String org_unit_id, String group_category_id, String group_id)
  * remove_user_from_group(String org_unit_id, String group_category_id, String group_id, String user_id)
  * get_all_org_unit_group_categories(String org_unit_id)
  * get_org_unit_group_category(String org_unit_id, String group_category_id)
  * get_all_group_category_groups(String org_unit_id, String group_category_id)
  * get_org_unit_group(String org_unit_id, String group_category_id, String group_id)
  * create_org_unit_group_category(String org_unit_id, JSON group_category_data)
  * create_org_unit_group(String org_unit_id String group_category_id, JSON group_data)
  * update_org_unit_group(String org_unit_id, String group_category_id, String group_id, JSON group_data)
  * enroll_user_in_group(String org_unit_id, String group_category_id, String group_id, String user_id)
  * update_org_unit_group_category(String org_unit_id, String group_category_id, JSON group_category_data)
8. Sections
  * delete_section(String org_unit_id, String section_id)
  * get_org_unit_sections(String org_unit_id)
  * get_org_unit_section_property_data(String org_unit_id)
  * get_section_data(String org_unit_id, String section_id)
  * create_org_unit_section(String org_unit_id JSON section_data)
  * enroll_user_in_org_section(String org_unit_id, String section_id, JSON section_data)
  * update_org_unit_section_properties(String org_unit_id, JSON section_property_data)
  * update_org_unit_section_info(String org_unit_id, String section_id, JSON section_data)

## Contributing
1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :)

## History
* December 1, 2016: Project began
* December 20, 2016: Release version 0.1.2 published to RubyGems.org

## Credits
Matt Mencel: Assigning and assisting in this project.

## License
Pending..

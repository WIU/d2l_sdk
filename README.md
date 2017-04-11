# Ruby Valence SDK
[![Gem Version](https://badge.fury.io/rb/d2l_sdk.svg)](https://badge.fury.io/rb/d2l_sdk) <a href = "https://docs.google.com/presentation/d/1RjwFW2URxTPECRUJzhJBpF6IPyHj_rOp47_DP1qEg7E/edit#slide=id.p" ><img src="https://lh3.ggpht.com/9rwhkrvgiLhXVBeKtScn1jlenYk-4k3Wyqt1PsbUr9jhGew0Gt1w9xbwO4oePPd5yOM=w300" width="25"></a>

The Ruby Valence SDK utilizes a CRUD based API that facilitates HTTP methods coinciding with Brightspace's routing table to perform common CRUD functions.

You can:

  - create, get, update, and delete users, courses, semesters, organizational units, and course templates, etc.
  - search for users and courses based on their parameters, as opposed to the API's need for explicitly stated Usernames and Id's.

The Valence sdk

> The Valence API is Rest-like, allowing interactions through HTTP with the back-end of a host. Most all of the Learning Platform functions that comprise D2L's Rest-like API are usable through this Ruby SDK implementation.

While not all functions have been implemented for the Learning Platform of the Valence sdk, all critical CRUD functionalities have been implemented.

***NOTE:*** I have been previously asked if some functions could be implemented without requiring input that is a Hash conforming particularly to D2L's specified API. Unfortunately, there are more often times than not JSON blocks that need to be passed with over 10 values defined. In these cases, it is unfortunately rather ugly to call functions with all of these arguments. Some API calls have been done this way due to their relatively small number of required JSON parameter values. Others quite simply cannot be done this way. 

If, at any time, you feel that you have an idea for a particular function of the SDK or just want to suggest something, please submit an Issue. Also, if there are any issues, for obvious reasons, please submit an Issue for this too. I greatly appreciate any feedback or contribution!!

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

The Ruby Valence sdk uses a number of required libraries and gems:

* [Test::Unit](https://ruby-doc.org/stdlib-1.8.7/libdoc/test/unit/rdoc/Test/Unit.html) - Ruby unit testing for d2l_sdk
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

Ruby Valence sdk can be installed using the following statement at a later date (upon repackaging as a gem):

```sh
$ gem install d2l_sdk
```

Once installed, the config file of the gem must be setup. This will be done upon the first use.

Of course, if a proper `d2l_config.json` is created within the current directory, the setup will not be required. Here is the format of this file, should you wish to pre-create it:

```
{
  "hostname": "YOUR HOSTNAME",
  "user_id": "YOUR USER ID",
  "user_key": "YOUR USER KEY",
  "app_id": "YOUR APP ID",
  "app_key": "YOUR APP KEY"
}
```


### Usage
Complete the installation, require the 'd2l_sdk' library in your ruby file, and use the many functions supported by the api to perform CRUD methods.
Example:

```sh
$ irb
$ require "d2l_sdk"
$ x =  multithreaded_user_search("FirstName", "test", 17) #searches using 17 threads for a user based on 'test' being in the first name.
$ get_user_by_user_id(x[0])
$ update_user_data(x[0]["Identifier"], x[0].merge!('FirstName'=>"Test2"))
```

One may also simply install the gem via `gem install d2l_sdk`. Once this is done, just require it in your script using `require 'd2l_sdk'` and utilize a number of the methods to streamline your app development process for D2L.


Uninstalling the previous version can be done by this command:
```sh
$ gem uninstall d2l_sdk --version [PREVIOUS-VERSION]
```

or

```sh
$ gem cleanup d2l_sdk
```




### List of Methods

1. Users
  * `create_user_data(JSON user_data)`
  * `get_whoami`
  * `get_users(String org_defined_id, String username, String bookmark)`
  * `get_user_by_username(String username)`
  * `does_user_exist(String username)`
  * `multithreaded_user_search(String parameter, String search_string, Int num_of_threads, Boolean regex)`
  * `get_user_by_user_id(String user_id)`
  * `update_user_data(String user_id, JSON new_data)`
  * `delete_user_data(String user_id)`
  * `get_user_activation_settings(String user_id)`
  * `update_user_activation_settings(String user_id, boolean is_active)`
  * **TODO:**`link_user_google_apps_account`
  * `delete_subscription(int carrier_id, int message_type_id`
  * `get_all_notification_carrier_channels`
  * `subscribe_to_carrier_notification(int carrier_id, int message_type_id`
  * `delete_user_password(String user_id)`
  * `reset_user_password(String user_id)`
  * `update_user_password(String user_id, String new_password)`
  * `get_all_user_roles`
  * `get_user_role(int role_id)`
  * `get_enrolled_roles_in_org_unit(String org_unit_id)`
  * **TODO:**`create_new_role_from_existing_role`
  * `remove_current_user_profile_image`
  * `remove_profile_image_by_profile_id(int profile_id)`
  * `remove_profile_image_by_user_id(int user_id)`
  * `get_current_user_profile`
  * `get_current_user_profile_image(int thumbnail_size)`
  * `get_user_profile_by_profile_id(optional int profile_id)`
  * `get_profile_image(int profile_id, optional int thumbnail_size)`
  * `get_user_profile_by_user_id(int user_id)`
  * `get_user_profile_image(int user_id)`
  * **TODO:**`update_current_user_profile_image`
  * **TODO:**`update_profile_image_by_profile_id`
  * **TODO:**`update_profile_image_by_user_id`
  * **TODO:**`update_current_user_profile_data`
  * **TODO:**`update_profile_by_profile_id`
  * UNSTABLE:`get_lis_roles(optional String lis_urn)`
  * UNSTABLE:`get_user_role_lis_mappings_by_urn(optional String lis_urn, optional int d2lid)`
  * UNSTABLE:`get_user_role_lis_mappings_by_role(String role_id, optional int d2lid)`
  * **TODO:**&&UNSTABLE:`map_user_role_to_lis_roles(String role_id, String[] mappings)`
  * `get_current_user_locale_settings`
  * `get_local_account_settings(int user_id)`
  * `update_current_user_locale_account_settings(int locale_id)`
  * `update_user_locale_account_settings(int user_id, int locale_id)`
  * UNSTABLE:`get_all_locales(optional String bookmark)`
  * UNSTABLE:`get_locale_properties(int locale_id)`
2. Semesters
  * `create_semester_data(JSON semester_data)`
  * `get_all_semesters`
  * `get_semester_by_id(String org_unit_id)`
  * `add_course_to_semester(Int course_id, Int semester_id)`
  * `remove_course_from_semester(Int course_id, Int semester_id)`
  * `get_semester_by_name(String search_string)`
  * `update_semester_data(String org_unit_id, JSON semester_data)`
  * `recycle_semester_data(String org_unit_id)`
  * `recycle_semester_by_name(String name)`
3. Courses
  * `delete_course_by_id(int org_unit_id)`
  * `get_parent_outypes_courses_schema_constraints`
  * `get_course_by_id(String org_unit_id)`
  * `get_course_image(int org_unit_id, optional int width, optional int height)`
  * `create_course_data(JSON course_data)`
  * `update_course_data(int course_id, JSON course_data)`
  * `update_course_image(int org_unit_id, String image_file_path)`
  * `get_copy_job_request_status(int org_unit_id, String job_token)`
  * `create_new_copy_job_request(int org_unit_it, JSON create_copy_job_request)`
  * **TODO:**UNSTABLE:`get_copy_job_logs(optional String bookmark, optional int page_size, optional int source_org_unit_id, optional int destination_org_unit_id, optional String start_date, optional String end_date)`
  * `get_course_import_job_request_status(int org_unit_id, string job_token)`
  * `get_course_import_job_request_logs(int org_unit_id, String job_token, optional String bookmark)`
  * `create_course_import_request(int org_unit_id, String file_path, optional String callback_url)`
  * `get_org_department_classes(String org_unit_id)`
  * `get_all_courses`
  * `get_courses_by_name(String org_unit_name)`
  * `get_courses_by_property_by_string(String property, String search_string)`
  * `get_courses_by_property_by_regex(String property, regular-expression regex)`
4. Course Templates
  * `delete_course_template(String org_unit_id)`
  * `get_course_template(String org_unit_id)`
  * `get_course_templates_schema`
  * `create_course_template(JSON course_template_data)`
  * `update_course_template(String org_unit_id, JSON new_data)`
  * `get_all_course_templates`
  * `get_course_template_by_name(String org_unit_name)`
  * `delete_all_course_templates_with_name(String name)`
  * **TODO:**``delete_all_course_templates_by_regex(Regexp regex)``
5. Org Units
  * `get_organization_info`
  * `delete_relationship_of_child_with_parent(Int parent_ou_id, Int child_ou_id)`
  * `delete_relationship_of_parent_with_child(Int parent_ou_id, Int child_ou_id)`
  * `get_properties_of_all_org_units(optional String org_unit_type, optional String org_unit_code, optional String org_unit_name, optional String bookmark)`
  * `get_org_unit_properties(String org_unit_id)`
  * `get_all_childless_org_units(optional String org_unit_type, optional String org_unit_code, optional String org_unit_name, optional String bookmark)`
  * `get_all_orphans(optional String org_unit_type, optional String org_unit_code, optional String org_unit_name, optional String bookmark)`
  * `get_org_unit_ancestors(String org_unit_id, optional int ou_type_id)`
  * `get_org_unit_children(String org_unit_id, optional Int ou_type_id)`
  * `get_paged_org_unit_children(String org_unit_id, String bookmark)`
  * `get_org_unit_descendants(String org_unit_id, Int ou_type_id)`
  * `get_paged_org_unit_descendants(String org_unit_id, Int ou_type_id, String bookmark)`
  * `get_org_unit_parents(String org_unit_id, Int ou_type_id)`
  * `create_custom_org_unit(JSON org_unit_data)`
  * `add_child_org_unit(String org_unit_id, String child_org_unit_id)`
  * `add_parent_to_org_unit(Int parent_ou_id, Int child_ou_id)`
  * `update_org_unit(String org_unit_id, JSON org_unit_data)`
  * **TODO:**`get_org_unit_color_scheme(String org_unit_id)`
  * **TODO:**`set_new_org_unit_color_scheme(String org_unit_id, JSON color_scheme)`
  * `delete_recycled_org_unit(String org_unit_id)`
  * `get_recycled_org_units(String bookmark)`
  * `recycle_org_unit(String org_unit_id)`
  * `restore_recyced_org_unit(string org_unit_id)`
  * `delete_outype(string outype_id)`
  * `get_all_outypes`
  * `get_outype(Int outype_id)`
  * `get_department_outype`
  * `get_semester_outype`
  * `create_custom_outype(JSON create_org_unit_type_data)`
  * `update_custom_outype(Int outype_id, JSON create_org_unit_type_data)`
  * `get_all_org_units_by_type_id(Int outype_id)`
6. Enrollments
  * `delete_user_enrollment(String user_id, String org_unit_id)`
  * `get_enrolled_users_in_classlist(String org_unit_id)`
  * `get_all_enrollments_of_current_user(optional String bookmark, optional String sort_by, optional boolean is_active, optional UTCDATETIME start_date_time, optional UTCDATETIME end_date_time, optional boolean can_access)`
  * `get_enrollments_details_of_current_user(String org_unit_id)`
  * `get_org_unit_enrollments(org_unit_id, optional Int role_id, optional Int bookmark)`
  * `get_org_unit_enrollment_data_by_user(String org_unit_id, String user_id)`
  * `get_all_enrollments_of_user(String user_id, optional String org_unit_type_id, optional String role_d, optional String bookmark)`
  * `create_user_enrollment(JSON course_enrollment_data)`
  * `get_user_enrollment_data_by_org_unit(String user_id, String org_unit_id)`
  * `delete_current_user_org_unit_pin(String org_unit_id)`
  * `pin_org_unit_for_current_context(String org_unit_id)`
  * `remove_auditee(String auditor_id, String auditee_id)`
  * `get_auditee(String auditee_id)`
  * `get_auditor(String auditor_id)`
  * `get_auditor_auditees(String auditor_id)`
  * `add_auditor_auditee(String auditor_id, String auditee_id)`
7. Groups
  * `delete_group_category(String org_unit_id, String group_category_id)`
  * `delete_group(String org_unit_id, String group_category_id, String group_id)`
  * `remove_user_from_group(String org_unit_id, String group_category_id, String group_id, String user_id)`
  * `get_all_org_unit_group_categories(String org_unit_id)`
  * `get_org_unit_group_category(String org_unit_id, String group_category_id)`
  * `get_all_group_category_groups(String org_unit_id, String group_category_id)`
  * `get_org_unit_group(String org_unit_id, String group_category_id, String group_id)`
  * `create_org_unit_group_category(String org_unit_id, JSON group_category_data)`
  * `create_org_unit_group(String org_unit_id String group_category_id, JSON group_data)`
  * `update_org_unit_group(String org_unit_id, String group_category_id, String group_id, JSON group_data)`
  * `enroll_user_in_group(String org_unit_id, String group_category_id, String group_id, String user_id)`
  * `update_org_unit_group_category(String org_unit_id, String group_category_id, JSON group_category_data)`
  * `is_group_category_locker_set_up(String org_unit_id, String group_category_id)`
8. Sections
  * `delete_section(String org_unit_id, String section_id)`
  * `get_org_unit_sections(String org_unit_id)`
  * `get_org_unit_section_property_data(String org_unit_id)`
  * `get_section_data(String org_unit_id, String section_id)`
  * `create_org_unit_section(String org_unit_id JSON section_data)`
  * `enroll_user_in_org_section(String org_unit_id, String section_id, JSON section_data)`
  * `initialize_org_unit_sections(String org_unit_id, JSON section_property_data)`
  * `update_org_unit_section_properties(String org_unit_id, JSON section_property_data)`
  * `update_org_unit_section_info(String org_unit_id, String section_id, JSON section_data)`
  * `create_section_code(String star_number, String course_data)`
  * `get_section_by_section_code(String code)`
  * `get_section_id_by_section_code(String code)`
  * `get_section_data_by_code(String code)`
9. **TODO:** Course Content
  * `delete_module(String org_unit_id, String module_id)`
  * `delete_topic(String org_unit_id, String topic_id)`
  * `get_module(String org_unit_id, String module_id)`
  * `get_module_structure(String org_unit_id, String module_id)`
  * `get_root_modules(String org_unit_id)`
  * `get_topic(String org_unit_id, String topic_id)`
  * `get_topic_file(String org_unit_id, String topic_id, optional Bool stream)`
  * **TODO:**`add_child_to_module(String org_unit_id, String module_id, optional JSON child)`
  * `create_root_module(String org_unit_id, JSON content_module)`
  * `update_module(String org_unit_id, String module_id, JSON content_module)`
  * `update_topic(String org_unit_id, String topic_id, JSON content_topic)`
  * `get_course_overview(String org_unit_id)`
  * `get_course_overview_file_attachment(String org_unit_id)`
  * `delete_isbn_association(String org_unit_id, String isbn)`
  * `get_org_units_of_isbn(String isbn)`
  * `get_isbns_of_org_unit(String org_unit_id)`
  * `get_isbn_org_unit_association(String org_unit_id, String isbn)`
  * `create_isbn_org_unit_association(String org_unit_id, JSON isbn_association_data)`
  * `get_user_overdue_items(String org_unit_ids_CSV, optional boolean completion, optional String start_date_time, optional end_date_time)`
  * `get_current_user_still_due_items(String org_unit_ids_CSV, optional boolean completion, optional String start_date_time, optional end_date_time)`
  * `get_current_user_organized_scheduled_items(String org_unit_ids_CSV, optional boolean completion, optional String start_date_time, optional end_date_time)`
  * `get_current_user_scheduled_item_count(String org_unit_ids_CSV, optional boolean completion, optional String start_date_time, optional end_date_time)`
  * `get_current_user_completed_scheduled_items(String org_unit_ids_CSV, optional String completion_from_date_time, optional completed_to_date_time)`
  * `get_current_user_completed_scheduled_items_with_due_date(String org_unit_ids_CSV, optional String completion_from_date_time, optional completed_to_date_time)`
  * `get_current_user_scheduled_item_count(String org_unit_ids_CSV, optional boolean completion, optional String start_date_time, optional end_date_time)`
  * `get_current_user_org_unit_scheduled_item_count(String org_unit_ids_CSV, optional boolean completion, optional String start_date_time, optional end_date_time)`
  * `get_user_overdue_items(String org_unit_ids_CSV, optional boolean completion, optional String start_date_time, optional end_date_time)`
10. **TODO:** Course Templates
11. **TODO:** Datahub
12. **TODO:** Demographics
13. **TODO:** Discussions
14. **TODO:** Dropbox
15. **TODO:** Grades
16. **TODO:** Lockers
17. **TODO:** Logging
18. **TODO:** LTI
19. **TODO:** News
20. **TODO:** Permissions
21. ???
 

## Contributing
1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :)

## History
* December 1, 2016: Project began
* December 20, 2016: Release version 0.1.2 published to RubyGems.org as `d2l_api`
* March 7, 2017: Release version 0.1.7 published to RubyGems.org as `d2l_sdk`

## Credits
Matt Mencel: Assigning and assisting in this project.

## License
MIT License (MIT) per the License.txt file.

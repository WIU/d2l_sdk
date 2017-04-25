# Ruby Valence SDK
[![Gem Version](https://badge.fury.io/rb/d2l_sdk.svg)](https://badge.fury.io/rb/d2l_sdk) [![Codacy Badge](https://api.codacy.com/project/badge/Grade/dc8a7273c7d046c788ce312b0af45452)](https://www.codacy.com/app/Andrew-Kulpa/d2l_sdk?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=WIU/d2l_sdk&amp;utm_campaign=Badge_Grade) [![Code Climate](https://codeclimate.com/github/WIU/d2l_sdk/badges/gpa.svg)](https://codeclimate.com/github/WIU/d2l_sdk) <a href = "https://docs.google.com/presentation/d/1RjwFW2URxTPECRUJzhJBpF6IPyHj_rOp47_DP1qEg7E/edit#slide=id.p" ><img src="https://lh3.ggpht.com/9rwhkrvgiLhXVBeKtScn1jlenYk-4k3Wyqt1PsbUr9jhGew0Gt1w9xbwO4oePPd5yOM=w300" width="25"></a> <a href = "https://community.brightspace.com/tlc/wiki/illinois_connection_april_7_2017" > <img src="https://ltsa.sheridancollege.ca/learning-technology-portal/wp-content/uploads/sites/9/2014/10/brightspace-logo.jpeg" width="25"></a> 

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
  * `get_user_by_user_id(Int user_id)`
  * `update_user_data(Int user_id, JSON new_data)`
  * `delete_user_data(Int user_id)`
  * `get_user_activation_settings(Int user_id)`
  * `update_user_activation_settings(Int user_id, boolean is_active)`
  * **TODO:**`link_user_google_apps_account`
  * `delete_subscription(int carrier_id, int message_type_id`
  * `get_all_notification_carrier_channels`
  * `subscribe_to_carrier_notification(int carrier_id, int message_type_id`
  * `delete_user_password(Int user_id)`
  * `reset_user_password(Int user_id)`
  * `update_user_password(Int user_id, String new_password)`
  * `get_all_user_roles`
  * `get_user_role(int role_id)`
  * `get_enrolled_roles_in_org_unit(Int org_unit_id)`
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
  * `get_semester_by_id(Int org_unit_id)`
  * `add_course_to_semester(Int course_id, Int semester_id)`
  * `remove_course_from_semester(Int course_id, Int semester_id)`
  * `get_semester_by_name(String search_string)`
  * `update_semester_data(Int org_unit_id, JSON semester_data)`
  * `recycle_semester_data(Int org_unit_id)`
  * `recycle_semester_by_name(String name)`
3. Courses
  * `delete_course_by_id(int org_unit_id)`
  * `get_parent_outypes_courses_schema_constraints`
  * `get_course_by_id(Int org_unit_id)`
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
  * `get_org_department_classes(Int org_unit_id)`
  * `get_all_courses`
  * `get_courses_by_name(String org_unit_name)`
  * `get_courses_by_property_by_string(String property, String search_string)`
  * `get_courses_by_property_by_regex(String property, regular-expression regex)`
4. Course Templates
  * `delete_course_template(Int org_unit_id)`
  * `get_course_template(Int org_unit_id)`
  * `get_course_templates_schema`
  * `create_course_template(JSON course_template_data)`
  * `update_course_template(Int org_unit_id, JSON new_data)`
  * `get_all_course_templates`
  * `get_course_template_by_name(String org_unit_name)`
  * `delete_all_course_templates_with_name(String name)`
  * **TODO:**``delete_all_course_templates_by_regex(Regexp regex)``
5. Org Units
  * `get_organization_info`
  * `delete_relationship_of_child_with_parent(Int parent_ou_id, Int child_ou_id)`
  * `delete_relationship_of_parent_with_child(Int parent_ou_id, Int child_ou_id)`
  * `get_properties_of_all_org_units(optional String org_unit_type, optional String org_unit_code, optional String org_unit_name, optional String bookmark)`
  * `get_org_unit_properties(Int org_unit_id)`
  * `get_all_childless_org_units(optional String org_unit_type, optional String org_unit_code, optional String org_unit_name, optional String bookmark)`
  * `get_all_orphans(optional String org_unit_type, optional String org_unit_code, optional String org_unit_name, optional String bookmark)`
  * `get_org_unit_ancestors(Int org_unit_id, optional int ou_type_id)`
  * `get_org_unit_children(Int org_unit_id, optional Int ou_type_id)`
  * `get_paged_org_unit_children(Int org_unit_id, String bookmark)`
  * `get_org_unit_descendants(Int org_unit_id, Int ou_type_id)`
  * `get_paged_org_unit_descendants(Int org_unit_id, Int ou_type_id, String bookmark)`
  * `get_org_unit_parents(Int org_unit_id, Int ou_type_id)`
  * `create_custom_org_unit(JSON org_unit_data)`
  * `add_child_org_unit(Int org_unit_id, Int child_org_unit_id)`
  * `add_parent_to_org_unit(Int parent_ou_id, Int child_ou_id)`
  * `update_org_unit(Int org_unit_id, JSON org_unit_data)`
  * **TODO:**`get_org_unit_color_scheme(Int org_unit_id)`
  * **TODO:**`set_new_org_unit_color_scheme(Int org_unit_id, JSON color_scheme)`
  * `delete_recycled_org_unit(Int org_unit_id)`
  * `get_recycled_org_units(String bookmark)`
  * `recycle_org_unit(Int org_unit_id)`
  * `restore_recyced_org_unit(Int org_unit_id)`
  * `delete_outype(string outype_id)`
  * `get_all_outypes`
  * `get_outype(Int outype_id)`
  * `get_department_outype`
  * `get_semester_outype`
  * `create_custom_outype(JSON create_org_unit_type_data)`
  * `update_custom_outype(Int outype_id, JSON create_org_unit_type_data)`
  * `get_all_org_units_by_type_id(Int outype_id)`
6. Enrollments
  * `delete_user_enrollment(Int user_id, Int org_unit_id)`
  * `get_enrolled_users_in_classlist(Int org_unit_id)`
  * `get_all_enrollments_of_current_user(optional String bookmark, optional String sort_by, optional boolean is_active, optional UTCDATETIME start_date_time, optional UTCDATETIME end_date_time, optional boolean can_access)`
  * `get_enrollments_details_of_current_user(Int org_unit_id)`
  * `get_org_unit_enrollments(Int org_unit_id, optional Int role_id, optional Int bookmark)`
  * `get_org_unit_enrollment_data_by_user(Int org_unit_id, Int user_id)`
  * `get_all_enrollments_of_user(Int user_id, optional Int org_unit_type_id, optional String role_d, optional String bookmark)`
  * `create_user_enrollment(JSON course_enrollment_data)`
  * `get_user_enrollment_data_by_org_unit(Int user_id, Int org_unit_id)`
  * `delete_current_user_org_unit_pin(Int org_unit_id)`
  * `pin_org_unit_for_current_context(Int org_unit_id)`
  * `remove_auditee(Int auditor_id, Int auditee_id)`
  * `get_auditee(Int auditee_id)`
  * `get_auditor(Int auditor_id)`
  * `get_auditor_auditees(Int auditor_id)`
  * `add_auditor_auditee(Int auditor_id, Int auditee_id)`
7. Groups
  * `delete_group_category(Int org_unit_id, Int group_category_id)`
  * `delete_group(Int org_unit_id, Int group_category_id, Int group_id)`
  * `remove_user_from_group(Int org_unit_id, Int group_category_id, Int group_id, Int user_id)`
  * `get_all_org_unit_group_categories(Int org_unit_id)`
  * `get_org_unit_group_category(Int org_unit_id, Int group_category_id)`
  * `get_all_group_category_groups(Int org_unit_id, Int group_category_id)`
  * `get_org_unit_group(Int org_unit_id, Int group_category_id, Int group_id)`
  * `create_org_unit_group_category(Int org_unit_id, JSON group_category_data)`
  * `create_org_unit_group(Int org_unit_id, Int group_category_id, JSON group_data)`
  * `update_org_unit_group(Int org_unit_id, Int group_category_id, Int group_id, JSON group_data)`
  * `enroll_user_in_group(Int org_unit_id, Int group_category_id, Int group_id, Int user_id)`
  * `update_org_unit_group_category(Int org_unit_id, Int group_category_id, JSON group_category_data)`
  * `is_group_category_locker_set_up(Int org_unit_id, Int group_category_id)`
8. Sections
  * `delete_section(Int org_unit_id, Int section_id)`
  * `get_org_unit_sections(Int org_unit_id)`
  * `get_org_unit_section_property_data(Int org_unit_id)`
  * `get_section_data(Int org_unit_id, Int section_id)`
  * `create_org_unit_section(Int org_unit_id JSON section_data)`
  * `enroll_user_in_org_section(Int org_unit_id, Int section_id, JSON section_data)`
  * `initialize_org_unit_sections(Int org_unit_id, JSON section_property_data)`
  * `update_org_unit_section_properties(Int org_unit_id, JSON section_property_data)`
  * `update_org_unit_section_info(Int org_unit_id, Int section_id, JSON section_data)`
  * `create_section_code(String star_number, String course_data)`
  * `get_section_by_section_code(String code)`
  * `get_section_id_by_section_code(String code)`
  * `get_section_data_by_code(String code)`
9. **TODO:** Course Content
  * `delete_module(Int org_unit_id, Int module_id)`
  * `delete_topic(Int org_unit_id, Int topic_id)`
  * `get_module(Int org_unit_id, Int module_id)`
  * `get_module_structure(Int org_unit_id, Int module_id)`
  * `get_root_modules(Int org_unit_id)`
  * `get_topic(Int org_unit_id, Int topic_id)`
  * `get_topic_file(Int org_unit_id, Int topic_id, optional Bool stream)`
  * **TODO:**`add_child_to_module(Int org_unit_id, Int module_id, optional JSON child)`
  * `create_root_module(Int org_unit_id, JSON content_module)`
  * `update_module(Int org_unit_id, Int module_id, JSON content_module)`
  * `update_topic(Int org_unit_id, Int topic_id, JSON content_topic)`
  * `get_course_overview(Int org_unit_id)`
  * `get_course_overview_file_attachment(Int org_unit_id)`
  * `delete_isbn_association(Int org_unit_id, String isbn)`
  * `get_org_units_of_isbn(String isbn)`
  * `get_isbns_of_org_unit(Int org_unit_id)`
  * `get_isbn_org_unit_association(Int org_unit_id, String isbn)`
  * `create_isbn_org_unit_association(Int org_unit_id, JSON isbn_association_data)`
  * `get_user_overdue_items(Int org_unit_ids_CSV, optional boolean completion, optional String start_date_time, optional end_date_time)`
  * `get_current_user_still_due_items(Int org_unit_ids_CSV, optional boolean completion, optional String start_date_time, optional end_date_time)`
  * `get_current_user_organized_scheduled_items(Int org_unit_ids_CSV, optional boolean completion, optional String start_date_time, optional end_date_time)`
  * `get_current_user_scheduled_item_count(Int org_unit_ids_CSV, optional boolean completion, optional String start_date_time, optional end_date_time)`
  * `get_current_user_completed_scheduled_items(Int org_unit_ids_CSV, optional String completion_from_date_time, optional completed_to_date_time)`
  * `get_current_user_completed_scheduled_items_with_due_date(Int org_unit_ids_CSV, optional String completion_from_date_time, optional completed_to_date_time)`
  * `get_current_user_scheduled_items(Int org_unit_ids_CSV, optional boolean completion, optional String start_date_time, optional end_date_time)`
  * `get_current_user_org_unit_scheduled_item_count(Int org_unit_ids_CSV, optional boolean completion, optional String start_date_time, optional end_date_time)`
  * `get_user_overdue_items_count(Int user_id, Int org_unit_ids_CSV)`
  * `get_current_user_overdue_items_count(Int org_unit_ids_CSV)`
  * `get_bookmarked_topics(Int org_unit_id)`
  * `get_most_recently_visited_topics(Int org_unit_id)`
  * `get_org_unit_toc(Int org_unit_id, optional boolean ignore_module_data_restrictions)`
  * `get_current_user_progress(Int org_unit_id, String level)`
  * **TODO:**UNSTABLE:`get_progress_of_users`
  * **TODO:**UNSTABLE:`get_user_progress`
  * **TODO:**UNSTABLE:`update_user_progress`
10. Course Templates
  * `delete_course_template(Int org_unit_id)`
  * `get_course_template(Int org_unit_id)`
  * `get_course_templates_schema`
  * `create_course_template(JSON course_template_data)`
  * `update_course_template(Int org_unit_id, JSON course_template_data)`
  * `get_all_course_templates`
  * `get_course_template_by_name(String org_unit_name)`
  * `delete_all_course_templates_with_name(String name)`
  * **TODO:**`delete_all_course_templates_by_regex(regex)`
11. Datahub
  * `get_all_data_sets`
  * `get_data_set(String data_set_id)`
  * `create_export_job(JSON create_export_job_data)`
  * `get_all_export_jobs(optional String bookmark)`
  * `get_data_export_job(String export_job_id)`
  * `get_job_status_code(String export_job_id)`
  * `download_job_csv(String export_job_id)`
  * `unzip(String file_path, regex csv_filter)`
  * `get_current_courses(String csv_fname)`
  * WIU_filter_formatted_via_instr:`filter_formatted_enrollments(String csv_fname, optional regex regex_filter, String instr_fname)`
12. Demographics
  * `delete_user_demographics(Int user_id, optional String entry_ids)`
  * `get_all_demographics_by_org_unit(Int user_id, optional String field_ids, optional String role_ids, optional Int user_ids, optional String search, optional   String bookmark)`
  * `get_all_demographics_by_org_unit_by_user(Int org_unit_id, Int user_id, optional String field_ids)`
  * `get_all_demographics(Int user_id, optional String field_ids, optional String role_ids, optional Int user_ids, optional String search, optional String   bookmark)`
  * `get_user_demographics(Int user_id, optional String field_ids, optional String bookmark)`
  * `update_user_demographics(Int user_id, JSON demographics_entry_data)`
  * `delete_demographics_field(String field_id)`
  * `get_all_demographic_fields(optional String bookmark)`
  * `get_demographic_field(String field_id)`
  * `create_demographic_field(JSON demographics_field)`
  * `update_demographics_field(String field_id, JSON demographics_field)`
  * `get_all_demographic_types(optional String bookmark)`
  * `get_demographic_type(String data_type_id)`
13. Discussions
  * `delete_org_unit_discussion(Int org_unit_id, Int forum_id)`
  * `get_org_unit_discussions(Int org_unit_id)`
  * `get_org_unit_discussion(Int org_unit_id, Int forum_id)`
  * `create_org_unit_discussion(Int org_unit_id, JSON forum_data)`
  * `update_forum(Int org_unit_id, Int forum_id, JSON forum_data)`
  * `delete_topic(Int org_unit_id, Int forum_id, Int topic_id)`
  * `delete_topic_group_restriction(Int org_unit_id, Int forum_id, Int topic_id)`
  * `get_forum_topics(Int org_unit_id, Int forum_id)`
  * `get_forum_topic(Int org_unit_id, Int forum_id, Int topic_id)`
  * `get_forum_topic_group_restrictions(Int org_unit_id, Int forum_id, Int topic_id)`
  * `create_forum_topic(Int org_unit_id, Int forum_id, JSON create_topic_data)`
  * `update_forum_topic(Int org_unit_id, Int forum_id, Int topic_id, JSON create_topic_data)`
  * `add_group_to_group_restriction_list(Int org_unit_id, Int forum_id, Int topic_id, Int group_id)`
  * `delete_topic_post(Int org_unit_id, Int forum_id, Int topic_id, Int post_id)`
  * `get_forum_topic_posts(Int org_unit_id, Int forum_id, Int topic_id, optional Int page_size, optional Int page_number, optional boolean threads_only, optional Int thread_id, optional String sort)`
  * `get_forum_topic_post(Int org_unit_id, Int forum_id, Int topic_id, Int post_id)`
  * `get_forum_topic_post_approval_status(Int org_unit_id, Int forum_id, Int topic_id, Int post_id)`
  * `get_forum_topic_post_flagged_status(Int org_unit_id, Int forum_id, Int topic_id, Int post_id)`
  * `get_forum_topic_post_rating_data(Int org_unit_id, Int forum_id, Int topic_id, Int post_id)`
  * `get_current_user_forum_topic_post_rating_data(Int org_unit_id, Int forum_id, Int topic_id, Int post_id)`
  * `get_forum_topic_post_read_status(Int org_unit_id, Int forum_id, Int topic_id, Int post_id)`
  * `get_forum_topic_post_vote_data(Int org_unit_id, Int forum_id, Int topic_id, Int post_id)`
  * `get_current_user_forum_topic_post_vote_data(Int org_unit_id, Int forum_id, Int topic_id, Int post_id)`
  * `create_topic_post(Int org_unit_id, Int forum_id, Int topic_id, JSON create_post_data, optional String[] files)`
  * `update_topic_post(Int org_unit_id, Int forum_id, Int topic_id, Int post_id, JSON create_post_data)`
  * `update_topic_post_approval_status(Int org_unit_id, Int forum_id, Int topic_id, Int post_id, boolean is_approved)`
  * `update_topic_post_flagged_status(Int org_unit_id, Int forum_id, Int topic_id, Int post_id, boolean is_flagged)`
  * `update_topic_post_current_user_rating(Int org_unit_id, Int forum_id, Int topic_id, Int post_id, Int rating)`
  * `update_topic_post_read_status(Int org_unit_id, Int forum_id, Int topic_id, Int post_id, boolean is_read)`
  * `update_topic_post_current_user_vote_data(Int org_unit_id, Int forum_id, Int topic_id, Int post_id, String vote)`
14. Dropbox
  * `get_org_unit_dropbox_folders(Int org_unit_id, optional boolean only_current_students_and_groups)`
  * `get_dropbox_folder(Int org_unit_id, Int folder_id)`
  * `get_dropbox_file_attachment(Int org_unit_id, Int folder_id, Int file_id)`
  * `create_dropbox_folder(Int org_unit_id, JSON dropbox_folder_update_data)`
  * `update_dropbox_folder(Int org_unit_id, JSON dropbox_folder_update_data)`
  * `get_current_user_assessable_folders(optional int type)`
  * `get_dropbox_folder_submissions(Int org_unit_id, Int folder_id, optional boolean active_only)`
  * `get_dropbox_submission_file(Int org_unit_id, Int folder_id, Int submission_id, Int file_id)`
  * TODO:`post_new_group_submission(???)`
  * TODO:`post_current_user_new_submission(???)`
  * `mark_file_as_read(Int org_unit_id, Int folder_id, Int submission_id)`
  * `remove_feedback_entry_file_attachment(Int org_unit_id, Int folder_id, entity_type, Int entity_id, Int file_id)`
  * `get_dropbox_folder_entity_feedback_entry(Int org_unit_id, Int folder_id, Int entity_id)`
  * `get_feedback_entry_file_attachment(Int org_unit_id, Int folder_id, Int entity_id, Int file_id)`
  * TODO:`post_feedback_without_attachment(Int org_unit_id, Int folder_id, Int entity_id, entity_type, ??? dropbox_feedback)`
  * TODO:`attach_file_to_feedback_entry(???)`
  * TODO:`initiate_feedback_entry_file_upload(???)`
  * `get_dropbox_folder_categories(Int org_unit_id)`
  * `get_dropbox_folder_category_info(Int org_unit_id, Int category_id)`
  * `update_dropbox_folder_category(Int org_unit_id, Int category_id, Int dropbox_category_id, String dropbox_category_name)`
15. Grades
  * `delete_org_unit_grade_object(Int org_unit_id, Int grade_object_id)`
  * `get_org_unit_grades(Int org_unit_id)`
  * `get_org_unit_grade_object(Int org_unit_id, Int grade_object_id)`
  * TODO:`create_org_unit_grade_object(Int org_unit_id, JSON grade_object, ?? type)`
  * TODO:`update_org_unit_grade_object(Int org_unit_id, JSON grade_object)`
  * `delete_org_unit_grade_category(Int org_unit_id, Int category_id)`
  * `get_org_unit_grade_categories(Int org_unit_id)`
  * `get_org_unit_grade_category(Int org_unit_id, Int category_id)`
  * `create_org_unit_grade_category(Int org_unit_id, JSON grade_category_data)`
  * `get_org_unit_grade_schemes(Int org_unit_id)`
  * `get_org_unit_grade_scheme(Int org_unit_id, Int grade_scheme_id)`
  * `get_current_user_final_grade(Int org_unit_id)`
  * TODO:`get_current_user_final_grades(Int org_unit_ids_csv)`
  * `get_user_final_grade(Int org_unit_id, Int user_id, optional String grade_type)`
  * `get_all_grade_object_grades(Int org_unit_id, Int grade_object_id, optional String sort , optional Int page_size, optional boolean is_graded, optional String search_text)`
  * `get_user_grade_object_grade(Int org_unit_id, Int grade_object_id, Int user_id)`
  * `get_current_user_org_unit_grades(Int org_unit_id)`
  * `get_user_org_unit_grades(Int org_unit_id, Int user_id)`
  * `delete_course_completion(Int org_unit_id, Int completion_id)`
  * `get_org_unit_completion_records(Int org_unit_id, optional Int user_id, optional String start_expiry , optional String end_expiry , optional String bookmark)`
  * `get_user_completion_records(user_id, optional String start_expiry , optional String end_expiry , optional String bookmark)`
  * TODO:`create_course_completion(Int org_unit_id, JSON course_completion_data)`
  * TODO:`update_course_completion(Int org_unit_id, Int completion_id, JSON course_completion_data)`
  * `get_grade_item_statistics(Int org_unit_id, Int grade_object_id)`
  * `get_org_unit_grade_config(Int org_unit_id)`
  * TODO:`update_org_unit_grade_config(Int org_unit_id, ??? grade_setup_info)`
  * `get_grade_exempt_users(Int org_unit_id, Int grade_object_id)`
  * `get_is_user_exempt(Int org_unit_id, Int grade_object_id, Int user_id)`
  * `exempt_user_from_grade(Int org_unit_id, Int grade_object_id, Int user_id)`
  * `remove_user_grade_exemption(Int org_unit_id, Int grade_object_id, Int user_id)`
  * `get_user_grade_exemptions(Int org_unit_id, Int user_id)`
  * TODO:`bulk_grade_exemption_update(Int org_unit_id, Int user_id, JSON bulk_grade_exemption_update_block)`
  * TODO:UNSTABLE:`get_org_unit_rubrics`
  * TODO:UNSTABLE:`get_org_unit_assessment`
  * TODO:UNSTABLE:`update_org_unit_assessment`
16. **TODO:** Lockers
17. **TODO:** Logging
18. LTI
  * `delete_lti_link(Int lti_link_id)`
  * `get_org_unit_lti_links(Int org_unit_id)`
  * `get_lti_link_info(Int org_unit_id, Int lti_link_id)`
  * `register_lti_link(Int org_unit_id, JSON create_lti_link_data)`
  * `create_lti_quicklink(Int org_unit_id, Int lti_link_id)`
  * `update_lti_link(Int lti_link_id, JSON create_lti_link_data)`
  * `delete_LTI_tool_provider_registration(Int tp_id)`
  * `get_org_unit_lti_tool_providers(Int org_unit_id)`
  * `get_lti_tool_provider_information(Int org_unit_id, Int tp_id)`
  * `register_lti_tool_provider(Int org_unit_id, JSON create_lti_provider_data)`
  * `update_lti_tool_provider(Int tp_id, JSON create_lti_provider_data)`
19. News
  * `delete_news_item(Int org_unit_id, Int news_item_id)`
  * `delete_news_item_attachment(Int org_unit_id, Int news_item_id, Int file_id)`
  * `get_current_user_feed(optional String since , optional String until )`
  * `get_org_unit_news_items(Int org_unit_id, optional String since )`
  * UNSTABLE:`get_deleted_news(Int org_unit_id, optional boolean global)`
  * `get_org_unit_news_item(Int org_unit_id, Int news_item_id)`
  * `get_news_item_attachment(Int org_unit_id, Int news_item_id, Int file_id)`
  * TODO:`create_news_item(Int org_unit_id, JSON news_item_data, optional String[] attachments)`
  * UNSTABLE:`restore_news_item(Int org_unit_id, Int news_item_id)`
  * TODO:`add_news_item_attachment(Int org_unit_id, Int news_item_id, JSON attachment_data)`
  * `hide_news_item(Int org_unit_id, Int news_item_id)`
  * `publish_draft_news_item(Int org_unit_id, Int news_item_id)`
  * `unhide_news_item(Int org_unit_id, Int news_item_id)`
  * TODO:`update_news_item(Int org_unit_id, Int news_item_id, JSON news_item_data)`
20. **TODO::UNSTABLE:** Permissions
21. Calendar
  * `delete_org_unit_calendar_event(Int org_unit_id, Int event_id)`
  * `get_org_unit_calendar_event(Int org_unit_id, Int event_id)`
  * `get_current_user_calendar_events_by_org_unit(Int org_unit_id, optional boolean associated_events_only)`
  * `get_current_user_calendar_events_by_org_units(optional boolean association, optional boolean event_type, Int org_unit_ids_csv, UTCDateTime start_date_time, UTCDateTime end_date_time)`
  * `get_current_user_events_by_org_unit(optional boolean association, optional boolean event_type, UTCDateTime start_date_time, UTCDateTime end_date_time)`
  * `get_calendar_event_count(optional boolean association, optional boolean event_type, org_unit_ids_csv, UTCDateTime start_date_time, UTCDateTime end_date_time)`
  * `get_org_unit_calendar_event_count(optional boolean association, optional boolean event_type, UTCDateTime start_date_time, UTCDateTime end_date_time)`
  * `get_paged_calendar_events_by_org_units(Int org_unit_ids_csv, UTCDateTime start_date_time, UTCDateTime end_date_time, optional String bookmark)`
  * `get_user_calendar_events(Int org_unit_id, Int user_id, UTCDateTime start_date_time, UTCDateTime end_date_time, optional String bookmark)`
  * `create_event(Int org_unit_id, JSON event_data)`
  * `update_event(Int org_unit_id, Int event_id, JSON event_data)`
22. ???
23. Profit
 

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
* April 7, 2017: Presentation at Brightspace Illinois Connection on the SDK.

## Credits
Matt Mencel: Assigning and assisting in this project.

## License
MIT License (MIT) per the License.txt file.

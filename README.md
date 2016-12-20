# Ruby Valence API
[![Gem Version](https://badge.fury.io/rb/d2l_api.svg)](https://badge.fury.io/rb/d2l_api)

The Ruby Valence API is a CRUD based API that facilitates HTTP methods coinciding with Brightspace's routing table to perform common CRUD functions.

You can:
  - create, get, update, and delete users, courses, semesters, org_units, and course_templates.
  - search for users and courses based on their parameters, as opposed to the API's need for explicitly stated Usernames and Id's.

The Valence API

> The Valence API is Rest-like, allowing interactions through HTTP with the back-end of a host. Most all of the Learning Platform functions that comprise D2L's Rest-like API are usable through this Ruby API implementation.

While not all functions have been implemented for the Learning Platform of the Valence API, all critical CRUD functionalities have been implemented.

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

Of course, this requires a Desire2Learn/Valence server to work with.

## Installation
TODO: This project requires a multitude of gems...
I should probably denote these in the gemfile.

###### Anyways:

This project requires numerous gems, so simply install them via the gemfile and have all the files hierarchically the same in your directory, and they should work fine. If they do not, simply put in an issue with me and I will look into it ASAP.

## Usage
Complete the installation, require the 'd2l_api.rb' file in your ruby file, and use the many functions supported by the api to perform CRUD methods.

## Contributing
1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :)

## History
TODO: Write history

## Credits
Matt Mencel: Assigning and assisting in this project.

## License
Pending..

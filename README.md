phocoder-rb
================

Phocoder-rb is a ruby gem for easy interaction with the  [Phocoder](http://phocoder.com) image processing service.
It allows you to easily add image handling to your app without needint to create or manage image processing infrastructure.

## Getting Started

First you'll need to include the library and set your API key.

```ruby
require 'phocoder'
Phocoder.api_key = 'sdg98lq4fc9ask2'
```

## Responses

All calls in the Phocoder library either raise Phocoder::HTTPError or return a Phocoder::Response.

A Phocoder::Response can be used as follows:

```ruby
response = Phocoder::Job.list
response.success?     # => true if the response code was 200 through 299
response.code         # => 200
response.body         # => the JSON-parsed body or raw body if unparseable
response.raw_body     # => the body pre-JSON-parsing
response.raw_response # => the raw Net::HTTP or Typhoeus response (see below for how to use Typhoeus)
```

## Creating Jobs

To create a job you'd do something like this:

```ruby
Phocoder::Job.create {
  :type => "ThumbnailJob",
  :input => "http://www.octolabs.com/assets/octologo.png",
  :thumbnails => [
    {
      :width => 100,
      :height => 100,
      :aspect_mode => 'preserve',
      :label => 'small'
    },
    {
      :width => 50,
      :height => 100,
      :aspect_mode => 'crop',
      :label => 'tiny'
    }
  ]
}
```
    
## Listing Jobs

To get a list of your recent jobs you could do:

```ruby
job_response = Phocoder::Job.list
jobs = job_response.body
```

## Phocoder API

Please see the [Phocoder API documentation](http://www.phocoder.com/api) for more information about the details
and options you can use when creating jobs.
    
## Advanced HTTP

### Alternate HTTP Libraries

By default this library will use Net::HTTP to make all API calls. You can change the backend or add your own:

```ruby
require 'typhoeus'
Phocoder::HTTP.http_backend = Phocoder::HTTP::Typhoeus

require 'my_favorite_http_library'
Phocoder::HTTP.http_backend = MyFavoriteHTTPBackend
```

See the HTTP backends in this library to get started on your own.

### Advanced Options

A secondary options hash can be passed to any method call which will then be passed on to the HTTP backend. You can pass `timeout` (in milliseconds), `headers`, and `params` (will be added to the query string) to any of the backends. If you are using Typhoeus, see their documentation for further options. In the following example the timeout is set to one second:

```ruby
Phocoder::Job.create({:input => '....', ...}, {:timeout => 1000})
```


### SSL Verification

We will use our bundled SSL CA chain for SSL peer verification which should almost always work without a hitch. However, if you'd like to skip SSL verification you can pass an option in the secondary options hash.

**NOTE: WE HIGHLY DISCOURAGE THIS! THIS WILL LEAVE YOU VULNERABLE TO MAN-IN-THE-MIDDLE ATTACKS!**

```ruby
Phocoder::Job.create({:input => '....', ...}, {:skip_ssl_verify => true})
```

Alternatively you can add it to the default options.

```ruby
Phocoder::HTTP.default_options.merge!(:skip_ssl_verify => true)
```

### Default Options

Default options are passed to the HTTP backend. These can be retrieved and modified.

```ruby
Phocoder::HTTP.default_options = {:timeout => 3000,
                                  :headers => {'Accept' => 'application/json',
                                               'Content-Type' => 'application/json'}}
```


Contributing to phocoder-rb
-----------------------------

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

### Copyright

Copyright (c) 2010 Jeremy Green. See LICENSE.txt for
further details.


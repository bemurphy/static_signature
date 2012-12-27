# StaticSignature

Rack Middleware for adding query string cache busting signatures on
script and style assets.  This is accomplished by parsing html responses
and appending an md5 hexdigest of file contents to the querystring.

In other words it turns this:
```html
<link href="/stylesheets/screen.css" rel="stylesheet">
```

into this:
```html
<link href="/stylesheets/screen.css?4a75c99cdc76e7e0f3f3a0d6a44338a4" rel="stylesheet">
```

This is intended to be a very limited implementation and makes a few
assumptions:

* You are OK with Nokogiri parsing and modifying all text/html responses
* The markup all uses simple urls that don't already have query params or
  such appended already
* Query params style cachebusting gotchas aren't going to post a big problem
  for you

If you need a more feature rich implementation, Sprockets/AssetPipeline would
better fit the bill.  This is intended for getting small, sinatra-esque apps
up quickly where the gorilla isn't needed yet.

## Installation

Add this line to your application's Gemfile:

    gem 'static_signature'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install static_signature

## Usage

Enable the middleware providing the path to your static assets directory:

```ruby
use StaticSignature::Middleware, :static_dir => File.join(File.dirname(__FILE__), "public")
```

Note the `static_dir` option is mandatory and must be an absolute path.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

require_relative "test_helper"

class MiddlewareTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  # Read first so we don't exhaust DATA
  # after a single test
  TEST_HTML = DATA.read.freeze

  def app
    Rack::Builder.new do
      use StaticSignature::Middleware, :static_dir => File.join(File.dirname(__FILE__), "data")
      run lambda { |env| [200, {'Content-Type' => "text/html"}, [TEST_HTML]]}
    end
  end

  def response_doc
    Nokogiri::HTML(last_response.body)
  end

  def test_link_tag_busting
    get "/"
    node = response_doc.search("link").first
    assert_equal "/css/app.css?b7a03f662ff6716c8a95cad9299de15e", node["href"]
  end

  def test_script_tag_busting
    get "/"
    node = response_doc.search("script").first
    assert_equal "/js/app.js?0677e7d10a89eb91d1292cbe35036a15", node["src"]
  end

  def test_skip_protocol_busting
    get "/"
    assert_match /asset\.js\Z/, response_doc.search("script")[1]["src"]
    assert_match /vendor\.js\Z/, response_doc.search("script")[2]["src"]
  end

  def test_end_tags_intact
    get "/"
    assert_match %r{</body>}, last_response.body
    assert_match %r{</html>}, last_response.body
  end
end

__END__

<!DOCTYPE html>
<html>
  <head>
    <title>Test HTML</title>
    <link href="/css/app.css" rel="stylesheet" media="screen">
  </head
  <body>
    <h1>Hello, world!</h1>
    <script src="/js/app.js"></script>
    <script src="http://www.example.com/js/asset.js"></script>
    <script src="//www.example.com/js/vendor.js"></script>
  </body>
</html>


require "static_signature/version"
require "thread"
require "nokogiri"

module StaticSignature
  class Middleware
    def initialize(app, options = {})
      @app = app
      @static_dir = options.fetch(:static_dir)
      @mutex = Mutex.new
    end

    def call(env)
      dup._call(env)
    end

    def _call(env)
      status, headers, response = @app.call(env)

      if headers["Content-Type"] !~ /text\/html/
        [status, headers, response]
      else
        body = ""
        response.each do |part|
          body << part
        end
        doc = Nokogiri::HTML(body)
        bust_tag(doc, "link", "href")
        bust_tag(doc, "script", "src")
        body = doc.to_html
        headers["Content-Length"] = body.bytesize.to_s
        [status, headers, [body]]
      end
    end

    def bust_tag(doc, tag_name, attribute)
      doc.search(tag_name).each do |node|
        if node[attribute] && ! node[attribute].include?("//")
          node[attribute] += "?#{asset_signature(node[attribute])}"
        end
      end
    end

    def asset_signature(path)
      full_path = File.join(@static_dir, path)

      @mutex.synchronize {
        signature_cache[path] ||= Digest::MD5.hexdigest(File.read(full_path))
      }
    end

    def signature_cache
      Thread.current[:_signature_cache] ||= {}
    end
  end
end

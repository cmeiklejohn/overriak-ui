require 'rubygems'
require 'bundler/setup'
require 'json'

class Application < Rack::Directory
  def call(env)
    request_uri = env['REQUEST_URI']

    if request_uri =~ /(clusters)\/(.*)/
      [200, { 'Content-Type' => 'application/json' }, [JSON.generate(fixture_for($1, $2))]]
    else
      super
    end
  end

  def fixture_for(type, id = nil)
    fixtures = send("#{type}_fixture".to_sym)
    id ? fixtures.detect { |x| x[:id] == id } : fixtures
  end

  def clusters_fixture
    [{ :id => '1', :name => 'my cluster' }]
  end
end

use Rack::CommonLogger

run Application.new(Dir.pwd)

require 'rubygems'
require 'bundler/setup'
require 'json'
require 'uri'
require 'cgi'

class Application < Rack::Directory
  def call(env)
    uri = URI.parse(env['REQUEST_URI'])
    query = CGI.parse(uri.query) if uri.query

    if uri.path =~ /(#{AVAILABLE_FIXTURES})\/(.*)/
      fixture_for($1, $2) if $2
    elsif uri.path =~ /(#{AVAILABLE_FIXTURES})/
      fixture_for($1, query["ids[]"])
    else
      super
    end
  end

  def fixture_for(type, ids = nil)
    fixtures = send("#{type}_fixture".to_sym)

    if ids.is_a?(Array)
      valid = !ids.empty? ? fixtures.select { |x| ids.map(&:to_i).include?(x[:id].to_i) } : fixtures
    else
      valid = ids ? fixtures.detect { |x| x[:id].to_i == ids.to_i } : fixtures
    end

    root = valid.is_a?(Array) ? type : type.slice(0...-1)
    response = { root.to_sym => valid }

    [200, { 'Content-Type' => 'application/json' }, [JSON.generate(response)]]
  end

  AVAILABLE = [:nodes, :clusters, :samples]
  AVAILABLE_FIXTURES = AVAILABLE.map(&:to_s).join('|')

  def samples_fixture
    [
      { :id => 1, :cpu_avg5 => '10', :created_at => Time.now.to_i },
      { :id => 2, :cpu_avg5 => '60', :created_at => Time.now.to_i },
      { :id => 3, :cpu_avg5 => '10', :created_at => Time.now.to_i },
      { :id => 4, :cpu_avg5 => '40', :created_at => Time.now.to_i }
    ]
  end

  def nodes_fixture
    [
      { :id => 1, :ip_address => '127.0.0.1', :samples => [1, 2] },
      { :id => 2, :ip_address => '127.0.0.2', :samples => [3, 4] }
    ]
  end

  def clusters_fixture
    [{ :id => 1, :name => 'my cluster', :nodes => [1, 2] }]
  end
end

use Rack::CommonLogger

run Application.new(Dir.pwd)

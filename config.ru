require 'rubygems'
require 'bundler/setup'
require 'json'

class Application < Rack::Directory
  def call(env)
    request_uri = env['REQUEST_URI']

    if request_uri =~ /clusters/
      [
        200,         
        {             
          'Content-Type' => 'application/json'
        },
        [JSON.generate(cluster_fixture)]
      ]
    else
      super
    end
  end

  def cluster_fixture
    { :name => 'my cluster' }
  end
end

use Rack::CommonLogger

run Application.new(Dir.pwd)

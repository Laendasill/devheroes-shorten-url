require "rack"
require "./Model"
require "./View"
class App

  def initialize
    @db = HashModel.new
  end

  def call(env)
    @request = Rack::Request.new(env)
    @response = Rack::Response.new
    @response.add_header("Content-type", "text/html")
    route
  end

  def route
    case @request.path_info
    when '/'
      IndexPage.new(@response, @request, @db).render
    when '/shorten'
      ShortenPage.new(@response, @request, @db).render
    else
      RedirectPage.new(@response, @request, @db).render
    end
  end
end

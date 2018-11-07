require "./UrlShortenService"
require "./UrlShortenForm"
require "rack"
require "./Model"
require "./View"

def error_page(response, message, status = 404)
  response.status = status
  response.write("errors occured: #{message}")
  response.finish
end

def redirect(response,request, url)
  response.status = 302
  response.add_header('Location', "http://#{request.get_header('HTTP_HOST')}#{url}")
  response.finish
end

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

require "./UrlShortenService"
require "./UrlShortenForm"
require "rack"
require "./Model"

db = Model.new
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

App = lambda { |env|
  request = Rack::Request.new(env)
  response = Rack::Response.new
  response.add_header("Content-type", "text/html")
  case request.path_info
  when '/'
    response.status = 200
    response.write(%(
      <form method='POST' action='shorten'>
          <input type='text' name='url_name' style='width: auto;'/>
          <button type='submit'>Shorten your url!</button>
      </form>
    ))
  when '/shorten'
    return redirect(response, request, '/') unless request.post?

    url = UrlShortenForm.new(request.params['url_name'], db)
    if url.save
      response.status = 200
      response.write(%(
        <a href="http://#{env['HTTP_HOST']}/#{url.short}">
          http://#{env['HTTP_HOST']}/#{url.short}
        </a>
      ))
    else
      return error_page(response, url.errors.join("\n"))
    end
  else
    return error_page(response, 'shorten url not found') unless db.key?(request.path_info[1..-1])

    response.status = 301
    response.add_header('HTTP_HOST', db.get(env['PATH_INFO'][1..-1]).split('/')[2])
    response.add_header('Location', db.get(env['PATH_INFO'][1..-1]).to_s)
  end
  response.finish
}

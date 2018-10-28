db = {}
require "./UrlShortenService"
require "./UrlShortenForm"
require "rack"

def error_page(message, status = 404)
  response = Rack::Response.new
  response.status = status
  response.write(message)
  response.finish
end

def redirect(response, url)
  response.status = 302
  response.add_header('Location', "http://#{env['HTTP_HOST']}#{url}")
  response.finish
end

App = lambda { |env|
  request = Rack::Request.new(env)
  response = Rack::Response.new
  case request.path_info
  when '/'
    response.status = 200
    response.write(%(
      <form method='POST' action='shorten'>
          <input type='text' name='url_name' style='width: auto;'/>
          <button type='submit'>Shorten your url!</button>
      </form>
    ))
    response.finish
  when '/shorten'
    redirect(response, '/') unless request.post?

    url = UrlShortenForm.new(request.params['url_name'], db)
    if url.save
      response.status = 200
      response.write(%(
        <a href="http://#{env['HTTP_HOST']}/#{url.short}">
          http://#{env['HTTP_HOST']}/#{url.short}
        </a>
      ))
      response.finish
    else
      error_page(url.errors.join("\n"))
    end
  else
    return error_page('shorten url not found') unless db.key?(request.path_info[1..-1])

    response.status = 301
    response.add_header('HTTP_HOST', db[env['PATH_INFO'][1..-1]].split('/')[2])
    response.add_header('Location', db[env['PATH_INFO'][1..-1]].to_s)
    response.finish
  end
}

db = {}
require "./UrlShortenService"
require "rack"

def error_page(message, status = 404)
  response = Rack::Response.new
  response.status = status
  response.write(message)
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
    if request.post?
      if request.params['url_name']
        url = request.params['url_name']
        unless url.start_with?('http')
          return error_page("\"#{url}\" It's not a valid URL")
        end

        short = UrlShortenService.call(url: url, db: db)
        response.status = 200
        response.write(%(
          <a href="http://#{env['HTTP_HOST']}/#{short}">http://#{env['HTTP_HOST']}/#{short}</a>
        ))
        return response.finish
      else
        return error_page('bad url')
      end
    else
      response.status = 302
      response.add_header('Location', "http://#{env['HTTP_HOST']}")
      response.finish
    end
  else
    if db.key?(request.path_info[1..-1])
      response.status = 301
      response.add_header('HTTP_HOST', db[env['PATH_INFO'][1..-1]].split('/')[2])
      response.add_header('Location', db[env['PATH_INFO'][1..-1]].to_s)
      return response.finish
    else
      return error_page('shorten url not found')
    end
  end
}

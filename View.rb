require "./url_shorten_service"
require "./redirect_link_service"
require "./url_shorten_form"
require "./Helpers"
class View
  def initialize(response, request, db)
    @db = db
    @response = response
    @request = request
  end

  protected

  def error_page(message, status = 404)
    @response.status = status
    @response.write("errors occured: #{message}")
    @response.finish
  end

  def redirect(url)
    @response.status = 302
    @response.add_header('Location', "http://#{@request.get_header('HTTP_HOST')}#{url}")
    @response.finish
  end
end

class IndexPage < View


  def initialize(response, request, db)
    super(response, request, db)
  end

  def error_page(message)
    super(message)
  end

  def redirect(url)
    super(url)
  end

  def render
    @response.status = 200
    @response.write(%(
        <form method='POST' action='shorten'>
            <input type='text' name='url_name' style='width: auto;'/>
            <button type='submit'>Shorten your url!</button>
        </form>
      ))
    @response.finish
  end
end

class ShortenPage < View
  include Helpers::View
  def initialize(response, request, db)
    super(response, request, db)
  end

  def error_page(message)
    super(message)
  end

  def redirect(url)
    super(url)
  end

  def render
    return redirect('/') unless @request.post?

    url = UrlShortenForm.new(@request.params['url_name'], @db)
    if url.save
      @response.status = 200
      @response.write(html_link(RedirectLinkService.call(@request, url)))
      @response.finish
    else
      return error_page(url.errors.join("\n"))
    end
  end
end

class RedirectPage < View
  def initialize(response, request, db)
    super(response, request, db)
  end

  def error_page(message)
    super(message)
  end

  def redirect(url)
    super(url)
  end

  def render
    location = @db.get(@request.path_info[1..-1])
    return redirect('/') unless location

    host = location.split('/')[2]
    @response.status = 301
    @response.add_header('HTTP_HOST', host)
    @response.add_header('Location', location.to_s)
    @response.finish
  end
end
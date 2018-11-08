require "./base_service"

class RedirectLinkService < BaseService

  def initialize(request, url_form)
    @request = request
    @url_form = url_form
  end

  def call
    redirect_link
  end

  def redirect_link
    host = @request.get_header('HTTP_HOST')
    schema = @request.scheme
    "#{schema}://#{host}/#{@url_form.short}"
  end
end

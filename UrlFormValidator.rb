
class UrlFormValidaotr
  BLANK_ERROR = "url can't be blank".freeze
  attr_reader :errors
  def initialize(url)
    @url = url
  end

  def validate
    @errors = []
    if url_empty?
      errors.push(BLANK_ERROR)
      return
    end
    errors.push("\"#{@url}\" It's not a valid URL") unless valid_url?
  end

  def errors?
    @errors.empty? == false
  end

  private

  def url_empty?
    @url.to_s.empty?
  end

  def valid_url?
    @url.start_with?('http')
  end
end
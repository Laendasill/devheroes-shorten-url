require './UrlShortenService'

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

class UrlShortenForm
  attr_accessor :url_name, :short

  def initialize(url, db)
    @url_name = url
    @db = db
  end

  def save
    return false unless valid?

    @short = UrlShortenService.call(@db)
    @db[@short] = @url_name
    true
  end

  def validate
    @validator ||= UrlFormValidaotr.new(@url_name)
    @validator.validate
  end

  def errors
    return @validator.errors if @validator
  
    []
  end

  def valid?
    validate
    @validator.errors? == false
  end
end

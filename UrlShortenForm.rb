require './UrlShortenService'
require './UrlFormValidator'

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

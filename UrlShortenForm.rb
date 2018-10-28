require './UrlShortenService'

class UrlShortenForm
  attr_accessor :url_name, :short

  def initialize(url, db)
    @url_name = url
    @db = db
  end

  def save
    if valid?
      @short = UrlShortenService.call(@db)
      @db[@short] = @url_name
      true
    else
      false
    end
  end

  def valid?
    @url_name.start_with?('http')
  end

  def errors
    ["\"#{@url_name}\" It's not a valid URL"] unless valid?
  end
end

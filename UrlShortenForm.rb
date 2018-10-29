require './UrlShortenService'

class UrlShortenForm
  attr_accessor :url_name, :short
  attr_reader :errors
  BLANK_ERROR = "url can't be blank"
  def initialize(url, db)
    @url_name = url
    @db = db
    @errors = []
  end

  def save
    false unless valid?

    @short = UrlShortenService.call(@db)
    @db[@short] = @url_name
    true
  end

  def validate
    errors = []
    if @url_name.to_s.empty?
      errors.push(BLANK_ERROR)
      return
    end
    errors.push("\"#{@url_name}\" It's not a valid URL") unless @url_name.start_with?('http')
    errors  
  end

  def valid?
    @errors = validate
    puts "printing errors"
    puts @errors
    puts @errors.empty?
    true if @errors.empty?
    false
  end
end

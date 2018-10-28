class BaseService
  def self.call(*args, &block)
    new(*args, &block).call
  end
end

class UrlShortenService < BaseService
  def initialize(url:, db:)
    @url = url
    @db = db
  end

  def call
    shorten(@url, @db)
  end

  def shorten(url, db)
    while rand = Array.new(8).map { ('a'..'z').to_a[rand(26)] }.join
      unless db.key?(rand)
        db[rand] = url
        break
      end
    end
    rand
  end
end

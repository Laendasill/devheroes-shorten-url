class BaseService
  def self.call(*args, &block)
    new(*args, &block).call
  end
end

class UrlShortenService < BaseService
  def initialize(db)
    @db = db
  end

  def call
    shorten(@db)
  end

  def shorten(db)
    while rand = Array.new(8).map { ('a'..'z').to_a[rand(26)] }.join
      break unless db.key?(rand)
    end
    rand
  end
end

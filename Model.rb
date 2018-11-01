class Model

  def initialize(db={})
    @db = db
  end

  def key?(key)
    @db.key?(key)
  end

  def add(key:, value:)
    @db[key] = value
  end

  def get(key)
    return @db[key] if key?(key)
  end
end
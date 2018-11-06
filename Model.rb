class Model

  def initialize
    raise "abstract class"
  end

  def key?(key); end

  def add(key:, value:); end

  def get(key); end
end

class HashModel < Model
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

require 'pg'

def pg_connection
  uri = URI.parse(ENV['DATABASE_URL'])
  con = PG.connect(user: uri.user, host: uri.host, port: uri.port, password: uri.password)
  con
rescue PG::Error => e
  puts e.message
ensure
  con.close if con
end

class PgModel < Model

  def initialize(config={})
    @db = pg_connection
    @db.prepare('add', %q{insert into urls (short,original) VALUES($1,$2);})
    @db.prepare('exist', %{select count(id) from urls where short = $1;})
    @db.prepare('find_id', %q{select original from urls where short=$1})
  end

  def key?(key)
    @db.exec_prepared('exist', [key]) do |result|
      return result[0]['count'] == '0'
    end
  end

  def add(key:, value:)
    @db.exec_prepared('add', [key, value])
    true
  rescue PG::Error => e
    puts e.message
    false
  end

  def get(key)
    result = @db.exec_prepared('find_id', [key])
    result.first()['original'] if result.first()
  end
end

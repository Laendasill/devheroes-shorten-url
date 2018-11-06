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
require 'logger'



def pg_connection
  logger = Logger.new(STDOUT)
  uri = URI.parse(ENV['DATABASE_URL'])
  con = PG.connect(user: uri.user, host: uri.host, port: uri.port, password: uri.password, dbname: uri.path[1..-1])
  con
rescue PG::Error => e
  logger.fatal(e.message)
end

class PgModel < Model

  def initialize(config={})
    @logger = Logger.new(STDOUT)
    @db = pg_connection
    @db.prepare('add', %q{insert into urls (short,original) VALUES($1,$2);})
    @db.prepare('exist', %q{select count(id) from urls where short = $1;})
    @db.prepare('find_id', %q{select original from urls where short=$1})
  end

  def key?(key)
    return false unless key

    @db.exec_prepared('exist', [@db.quote_ident(key)]) do |result|
      return result[0]['count'].zero? if result[0]

      false
    end
  rescue PG::Error => e
    @logger.fatal(e.message)
  end

  def add(key:, value:)
    @db.exec_prepared('add', [@db.quote_ident(key), @db.quote_ident(value)])
    true
  rescue PG::Error => e
    @logger.fatal(e.message)
    false
  end

  def get(key)
    result = @db.exec_prepared('find_id', [@db.quote_ident(key)])
    result.first()['original'] if result.first()
  rescue PG::Error => e
    @logger.fatal(e.message)
    false
  end
end

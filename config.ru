db = {}


def shorten(url, db)
  while rand = ('a'..'z').to_a.shuffle[0,8].join
    if !db.key?(rand)
      db[rand] = url
      break
  end
end
run lambda { |env|
    case env['PATH_INFO']
    when "/"
        [200, {'Content-Type'=>'text/plain'}, StringIO.new("Hello World!\n")] 
    else
      if db.key?(env['PATH_INFO'])
        [200, {'Content-Type'=>'text/plain'}, StringIO.new(db[env['PATH_INFO']])
      else
        [404, {'Content-Type'=>'text/plain'}, StringIO.new("not found\n")] 
    end
}

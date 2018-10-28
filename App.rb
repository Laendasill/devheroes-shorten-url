db = {}

def shorten(url, db)
  while rand = 8.times.map{('a'..'z').to_a[rand(26)]}.join
    if !db.key?(rand)
      db[rand] = url
      break
    end
  end
  return rand
end

App = lambda { |env|
    case env['PATH_INFO']
    when "/"
        [200, {'Content-Type'=>'text/html'}, StringIO.new(%q(
        
        <form method='POST' action='shorten'>
            <input type='text' name='url_name' style='width: auto;'/>
            <button type='submit'>Shorten your url!</button>
        </form>
        ))]
    when "/shorten"
        if env['REQUEST_METHOD'] == "POST"
            post_data = URI.decode_www_form(env['rack.input'].read).flatten
            idx = post_data.find_index("url_name")
            if idx >= 0
                url = post_data[idx+1]
                if !url.start_with?("http")
                    return [404, {'Content-Type'=>'text/plain'}, StringIO.new("\"#{url}\" It's not a valid URL")] 
                end
                short =  shorten(url,db)
                return [200, {'Content-Type'=>'text/html'}, StringIO.new(%Q(
                    <a href="http://#{env['HTTP_HOST']}/#{short}">http://#{env['HTTP_HOST']}/#{short}</a>)
                )]    
            else
                return [404, {'Content-Type'=>'text/plain'}, StringIO.new("bad url")] 
            end
        else  
            return [ 302, {'Location' =>"http://#{env['HTTP_HOST']}"}, [] ]
        end
    else
      if db.key?(env['PATH_INFO'][1..-1])
        return [ 301, {'HTTP_HOST' => db[env['PATH_INFO'][1..-1]].split("/")[2] , 'Location' =>"#{db[env['PATH_INFO'][1..-1]]}"}, []]
      else
        return [404, {'Content-Type'=>'text/plain'}, StringIO.new(env)] 
      end
    end
}

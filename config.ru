run lambda { |env|
    case env['PATH_INFO']
    when "/"
        [200, {'Content-Type'=>'text/plain'}, StringIO.new("Hello World!\n")] 
    else
        [404, {'Content-Type'=>'text/plain'}, StringIO.new("not found\n")] 
    end
}
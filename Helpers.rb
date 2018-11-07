module Helpers
  module View
    def html_link(url, name = nil)
      %Q(<a href=#{url}>
          #{name || url}
      </a>)
    end
  end
end

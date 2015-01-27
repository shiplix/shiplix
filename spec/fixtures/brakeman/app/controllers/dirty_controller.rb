module Brakeman
  class DirtyController < ApplicationController
    def redirect_to_some_places
      if something
        redirect_to params.merge(:host => "example.com") # Should not warn
      elsif something_else
        redirect_to params.merge(:host => User.canonical_url) # Should not warn
      else
        redirect_to params.merge(:host => params[:host]) # Should warn
      end
    end
  end
end

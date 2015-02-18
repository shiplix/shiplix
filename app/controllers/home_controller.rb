class HomeController < ApplicationController
  skip_before_action :authenticate, only: [:index]

  add_breadcrumb 'Home', :root_path

  def index
  end
end

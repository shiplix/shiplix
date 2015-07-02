class HomeController < ApplicationController
  layout "front"

  skip_before_action :authenticate, only: [:index]

  def index
    redirect_to repos_path if signed_in?
  end
end

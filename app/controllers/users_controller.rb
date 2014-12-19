class UsersController < ApplicationController
  skip_before_action :authenticate, only: [:index]

  def index
  end
end

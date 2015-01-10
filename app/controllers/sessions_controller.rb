class SessionsController < ApplicationController
  skip_before_action :authenticate, only: [:create]

  def create
    user = find_user || create_user
    create_session_for(user)
    update_access_token(user)

    redirect_to root_path
  end

  def destroy
    destroy_session
    redirect_to root_path
  end

  private

  def find_user
    User.where(github_username: github_username).first
  end

  def create_user
    user = User.create!(
      github_username: github_username,
      email_address: github_email_address,
      access_token: github_token
    )

    user
  end

  def create_session_for(user)
    session[:remember_token] = user.remember_token
  end

  def destroy_session
    session[:remember_token] = nil
  end

  def update_access_token(user)
    user.update(access_token: github_token) if user.access_token != github_token
  end

  def github_username
    request.env["omniauth.auth"]["info"]["nickname"]
  end

  def github_email_address
    request.env["omniauth.auth"]["info"]["email"]
  end

  def github_token
    request.env["omniauth.auth"]["credentials"]["token"]
  end
end

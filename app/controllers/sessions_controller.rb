class SessionsController < ApplicationController
  skip_before_filter :require_login
  layout "sessions"

  def new
  end
  
  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password]) && user.status == 'ACTIVE'
      session[:user_id] = user.id
      redirect_to root_url
    else
      flash.now.alert = 'Email or password is invalid'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'Logged out!'
  end
  
end

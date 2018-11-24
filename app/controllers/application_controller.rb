class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_filter :require_login
    helper_method :logged_in?
    helper_method :current_user

    private

    def logged_in?
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def require_login
        unless session[:user_id]
        redirect_to login_url
        end
    end  
end

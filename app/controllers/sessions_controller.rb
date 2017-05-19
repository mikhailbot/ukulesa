class SessionsController < ApplicationController
  def new
  end

  def create
    begin
      @user = User.from_omniauth(request.env['omniauth.auth'])
      session[:user_id] = @user.id
      RetrieveStarsWorker.perform_async(@user.id)
    rescue => error
      puts error
    end
    redirect_to '/profile'
  end

  def destroy
    if current_user
      session.delete(:user_id)
    end
    redirect_to root_path
  end
end

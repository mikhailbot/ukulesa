class Pages::ProfilesController < ApplicationController
  def index
    if current_user.nil?
      redirect_to '/'
    else
      user = User.find(current_user.id)
      @repos = user.repos
      @user_avatar = user.avatar_url
    end
  end
end

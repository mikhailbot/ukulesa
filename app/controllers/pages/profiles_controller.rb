class Pages::ProfilesController < ApplicationController
  def index
    if current_user.nil?
      redirect_to '/'
    else
      @repos = current_user.repos
      @user_avatar = current_user.avatar_url
    end
  end

  def update
    if current_user.nil?
      redirect_to '/'
    else
      case current_user.notification_schedule
      when 1
        current_user.update(notification_schedule: 2)
      when 2
        current_user.update(notification_schedule: 1)
      else
      end
      redirect_to '/profile'
    end
  end
end

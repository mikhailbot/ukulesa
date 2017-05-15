namespace :users do
  desc 'Send Daily User Email Notifications'
  task send_daily_user_email_notifications: :environment do
    SparkPostService.new().send_daily_notifications
  end
end

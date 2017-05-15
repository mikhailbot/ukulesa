namespace :users do
  desc 'Send Daily User Email Notifications'
  task send_daily_user_email_notifications: :environment do
    log = ActiveSupport::Logger.new('log/send_daily_user_email_notifications.log')
    start_time = Time.now
    log.info "Task started at #{start_time}"

    options = { :content => { :template_id => "ukulesa-daily-notification" }, :recipients => [] }

    User.find_each do |user|
      if user.notification_schedule == 1
        @user_options = {
          :address => { :email => user.email, :name => user.name },
          :substitution_data => { :answered_questions => [], :name => user.name }
        }

        user.repos.each do |repo|
          repo.issues.where("created_at > ?", 1.day.ago).each do |issue|
            @user_options[:substitution_data][:answered_questions] << { :owner => repo.owner_name, :answer => issue.answer, :link => issue.link }
          end
        end

        unless @user_options[:substitution_data][:answered_questions].nil?
          options[:recipients] << (@user_options)
          puts 'SOME EMAIL GETS SENT NOW!'

          SparkPostService.new().send_daily_notification(options)
        end
      end
    end

    end_time = Time.now
    duration = (start_time - end_time) / 1.minute
    log.info "Task finished at #{end_time} and lasted #{duration} minutes."
    log.close
  end
end

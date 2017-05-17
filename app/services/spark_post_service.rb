require 'simple_spark'

class SparkPostService
  def initialize()
    @simple_spark = SimpleSpark::Client.new
  end

  def send_daily_notifications
    User.find_each do |user|
      generate_daily_email(user)
    end
  end

  private

  def generate_daily_email(user)
    @subject = "Ukulesa Daily Update for #{Date.today.to_formatted_s(:long)}"
    @options = { :content => { :template_id => "ukulesa-daily-notification" }, :recipients => [] }

    if user.notification_schedule == 1
      @user_options = {
        :address => { :email => user.email, :name => user.name },
        :substitution_data => { :answered_questions => [], :subject => @subject }
      }

      user.repos.each do |repo|
        repo.issues.where("created_at > ?", 1.day.ago).each do |issue|
          @user_options[:substitution_data][:answered_questions] << {
            :owner => repo.owner_name,
            :answer => issue.answer,
            :link => issue.link.sub(/^https?\:\/\//, ''),
            :number => issue.number,
            :title => issue.title }
        end
      end

      unless @user_options[:substitution_data][:answered_questions].empty? || user.last_notified > 1.day.ago
        @options[:recipients] << (@user_options)
        @simple_spark.transmissions.create(@options)
        user.update(last_notified: Time.now)
      end
    end
  end
end

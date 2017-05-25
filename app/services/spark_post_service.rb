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

  def send_immediate_notification(issue)
    User.find_each do |user|
      generate_immediate_email(user, issue)
    end
  end

  def send_welcome_email(user_id)
    user = User.find_by_id(user_id)

    unless user.sent_welcome_email
      generate_welcome_email(user)
    end
  end

  private

  def generate_daily_email(user)
    subject = "Ukulesa Daily Update for #{Date.today.to_formatted_s(:long)}"
    options = { :content => { :template_id => "ukulesa-daily-update" }, :recipients => [] }

    if user.notification_schedule == 1
      user_options = {
        :address => { :email => user.email, :name => user.name },
        :substitution_data => { :answered_questions => [], :subject => subject }
      }

      user.repos.each do |repo|
        repo.issues.where("created_at > ?", 1.day.ago).each do |issue|
          user_options[:substitution_data][:answered_questions] << {
            :owner => repo.owner_name,
            :answer => issue.answer,
            :link => issue.link.sub(/^https?\:\/\//, ''),
            :number => issue.number,
            :title => issue.title,
            :avatar_url => issue.repo.avatar_url }
          end
        end

        unless user_options[:substitution_data][:answered_questions].empty? || user.last_notified > 1.day.ago
          options[:recipients] << user_options
          @simple_spark.transmissions.create(options)
          user.update(last_notified: Time.now)
        end
      end
    end

    def generate_immediate_email(user, issue)
      subject = "Ukulesa Update for ##{issue.number} #{issue.repo.full_name}"
      options = { :content => { :template_id => "ukulesa-daily-update" }, :recipients => [] }

      if user.notification_schedule == 2
        user_options = {
          :address => { :email => user.email, :name => user.name },
          :substitution_data => { :answered_questions => [], :subject => subject }
        }

        user_options[:substitution_data][:answered_questions] << {
          :owner => issue.repo.owner_name,
          :answer => issue.answer,
          :link => issue.link.sub(/^https?\:\/\//, ''),
          :number => issue.number,
          :title => issue.title,
          :avatar_url => issue.repo.avatar_url }

        unless user_options[:substitution_data][:answered_questions].empty?
          options[:recipients] << user_options
          @simple_spark.transmissions.create(options)
          user.update(last_notified: Time.now)
        end
      end
    end

    def generate_welcome_email(user)
      subject = "Welcome to Ukulesa"
      options = { :content => { :template_id => ""}, :recipients => [] }
      user_options = {
        :address => { :email => user.email, :name => user.name },
        :substitution_data => { :subject => subject, :stars => [] }
      }

      if Star.where(user_id: user.id).exists?
        user.repos.each do |repo|
          user_options[:substitution_data][:stars] << {
            :owner => repo.owner_name,
            :link => "github.com/#{repo.full_name}"
          }
        end

        options[:content][:template_id] = "ukulesa-signed-up-with-stars"
        options[:recipients] << user_options
      else
        options[:content][:template_id] = "ukulesa-signed-up-with-no-stars"
        options[:recipients] << user_options
      end

      @simple_spark.transmissions.create(options)
      user.update(sent_welcome_email: true)
    end
  end

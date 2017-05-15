namespace :users do
  desc 'Retrieves Starred Respositories for Single User'
  task :retrieve_starred_repositories_single_user, [:user_id] =>  :environment do |task, args|
    user_id = args.user_id
    log = ActiveSupport::Logger.new('log/users_retrieve_starred_repositories_single_user.log')
    start_time = Time.now
    log.info "Task started at #{start_time}"

    User.find(user_id) do |user|
      GithubApiService.new(user.oauth_token).retrieve_starred_repositories(user)
    end

    end_time = Time.now
    duration = (start_time - end_time) / 1.minute
    log.info "Task finished at #{end_time} and lasted #{duration} minutes."
    log.close
  end
end

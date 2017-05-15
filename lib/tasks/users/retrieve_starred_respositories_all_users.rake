namespace :users do
  desc 'Retrieves Starred Respositories for All Users'
  task retrieve_starred_repositories_all_users: :environment do
    log = ActiveSupport::Logger.new('log/users_retrieve_starred_repositories_all_users.log')
    start_time = Time.now
    log.info "Task started at #{start_time}"

    GithubApiService.new(ENV['GITHUB_ACCESS_TOKEN']).retrieve_starred_repositories

    end_time = Time.now
    duration = (start_time - end_time) / 1.minute
    log.info "Task finished at #{end_time} and lasted #{duration} minutes."
    log.close
  end
end

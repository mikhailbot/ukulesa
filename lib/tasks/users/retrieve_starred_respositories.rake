namespace :users do
  desc 'Retrieves Starred Respositories for All Users'
  task retrieve_starred_repositories: :environment do
    log = ActiveSupport::Logger.new('log/users_retrieve_starred_repositories.log')
    start_time = Time.now
    repos_count = Repo.count

    log.info "Task started at #{start_time}"

    User.find_each do |user|
      GithubApiService.new(user.oauth_token).retrieve_starred_repositories.each do |starred_repo|
        if (starred_repo.name == 'ama')
          Repo.find_or_create_by(full_name: starred_repo.full_name) do |repo|
            repo.name = starred_repo.name
            repo.full_name = starred_repo.full_name
            repo.owner_name = starred_repo.owner.login
            repo.owner_id = starred_repo.owner.id
            repo.avatar_url = starred_repo.owner.avatar_url
            repo.save!
            log.info "Added #{repo.full_name} for #{user.name}"
          end
        end
      end
    end

    end_time = Time.now
    duration = (start_time - end_time) / 1.minute
    log.info "Task finished at #{end_time} and lasted #{duration} minutes."
    log.close
  end
end
namespace :users do
  desc 'Retrieves Starred Respositories for All Users'
  task :retrieve_starred_repositories_single_user, [:user_id] =>  :environment do |task, args|
    user_id = args.user_id
    log = ActiveSupport::Logger.new('log/users_retrieve_starred_repositories_single_user.log')
    start_time = Time.now
    log.info "Task started at #{start_time}"

    User.find(user_id) do |user|
      GithubApiService.new(user.oauth_token).retrieve_starred_repositories.each do |starred_repo|
        if (starred_repo.name == 'ama')
          @repo = Repo.find_or_create_by(full_name: starred_repo.full_name) do |repo|
            repo.name = starred_repo.name
            repo.full_name = starred_repo.full_name
            repo.owner_name = starred_repo.owner.login
            repo.owner_id = starred_repo.owner.id
            repo.avatar_url = starred_repo.owner.avatar_url
            repo.save!
            log.info "Added #{repo.full_name} by #{user.name}"
          end
          begin
            user.repos << @repo
          rescue ActiveRecord::RecordInvalid
            log.info "Repo #{@repo.full_name} already exists for #{user.username}"
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

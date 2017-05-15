namespace :users do
  desc 'Retrieves Starred Respositories for Single User'
  task :retrieve_starred_repositories_single_user, [:user_id] =>  :environment do |task, args|
    User.find(args.user_id) do |user|
      GithubApiService.new(user.oauth_token).retrieve_starred_repositories(user)
    end
  end
end

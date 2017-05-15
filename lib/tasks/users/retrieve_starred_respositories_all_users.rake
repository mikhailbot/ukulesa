namespace :users do
  desc 'Retrieves Starred Respositories for All Users'
  task retrieve_starred_repositories_all_users: :environment do
    GithubApiService.new(ENV['GITHUB_ACCESS_TOKEN']).retrieve_starred_repositories
  end
end

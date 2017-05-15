namespace :repos do
  desc 'Retrieves New Closed Issues for All Repos'
  task retrieve_new_closed_issues: :environment do
    GithubApiService.new(ENV['GITHUB_ACCESS_TOKEN']).retrieve_new_closed_issues
  end
end

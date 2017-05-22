# Ukulesa | GitHub AMA Email Notifications

For development you need a `.env` file with the following entries:

```ruby
GITHUB_ID=abcdef0123456789
GITHUB_SECRET=abcdef0123456789abcdef0123456789
SPARKPOST_API_KEY=abcdef0123456789abcdef0123456789
ROLLBAR_ACCESS_TOKEN=abcdef0123456789abcdef0123456789
```

Install dependencies and start Rails servers (Ruby 2.3.3, yarn 0.23.4)

```bash
bundle install
bin/rails server
```

## Rake Tasks Available

- `users:retrieve_starred_respositories_all_users`
- `users:retrieve_starred_respositories_single_user`
- `users:send_daily_user_email_notifications`
- `repos:retrieve_new_closed_issues`

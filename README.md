# Ukulesa | GitHub AMA Email Notifications

For development you need a `.env` file with the following entries:

```ruby
GITHUB_ID=abcdef0123456789
GITHUB_SECRET=abcdef0123456789abcdef0123456789
GITHUB_ACCESS_TOKEN=abcdef0123456789abcdef0123456789
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

## Email payload example

```json
{
  "substitution_data": {
    "answered_questions": [
    {
      "owner": "wesbos",
      "answer": "<p>Hey! THanks for the question. I find wire framing to be super valuable because it gets the layout out of the way so I can focus on the design. </p><p>I&#39;ve tried lots of tools for this but since it&#39;s just me, and the sites aren&#39;t all that complex, I tend to just use a pen and a moleskine notebook. Mine are extremely messy and quickly sketched but its enough for me to put a layout together and then get into Sketch to start designing. </p><p>thanks again! </p>",
      "link": "https://github.com/wesbos/ama/issues/150",
      "number": 150,
      "title": "Do you use any wireframing tools when designing the websites for your course?",
      "question": "<p>Hi Wes, thank you for sharing your knowledge to the world via your courses. The websites for each of your course are really nice and on-point. Do you use any wireframe or mockup tools in particular when creating them? Any that you would recommend for newbie in web designing/developing to use?</p><p>Thanks!</p>",
      "avatar_url": "https://avatars1.githubusercontent.com/u/176013?v=3"
    }
    ],
    "subject": "Ukulesa Update for #150 wesbos/ama"
  },
  "metadata": {},
  "options": {}
}
```

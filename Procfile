web: bundle exec puma -p ${PORT:-3000} -e ${RACK_ENV:-development}
worker: bundle exec sidekiq -c 2
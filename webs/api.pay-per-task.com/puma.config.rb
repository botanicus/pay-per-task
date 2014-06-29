# Run with bundle exec puma -C puma.config.rb

threads 8, 32
workers 3
port 7001
preload_app!

class DbUpdateJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "Running db update job"
    unless MyHelpers.is_server_running?
      puts "Server isn't running, clearing crontab"
      system("whenever --clear-crontab")
      return
    end
    puts "Updating database"
    sleep 3
  end
end

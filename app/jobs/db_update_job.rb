class DbUpdateJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "Running db update job"
    unless MyHelpers.is_server_running?
      puts "Server isn't running, clearing crontab"
      system("whenever --clear-crontab")
      return
    end
    update_db
  end
  
  private

  def update_db
    puts "Updating database"
    @api = ChanApi.new
  end

end

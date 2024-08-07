

module MyHelpers

  def self.is_server_running?
    puts "Checking server process"
    begin
      pid = get_server_pid
      return is_process_running?(pid)
    rescue
    end
    return false
  end

  private 
  
  def self.get_server_pid
    return File.read("./tmp/pids/server.pid").to_i
  end

  def self.is_process_running?(pid)
    begin 
      Process.kill(0, pid)
    rescue Errno::ESRCH
      return false
    rescue
      # fall through
    end
    return true
  end

end
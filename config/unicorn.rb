APP_PORT ||= ENV['APP_PORT'] || 3000
puts "app_port: #{APP_PORT}"
APP_PATH = ENV['WORKING_DIRECTORY'] || File.expand_path('../..', __FILE__)
puts "working_directory: #{APP_PATH}"
PID_PATH = ENV['PID_PATH'] || (APP_PATH + "/tmp/pids/unicorn.pid")
puts "pid_path: #{PID_PATH}"
WORKER_PROCESSES = (ENV['UNICORN_WORKER_NUM'] || 5).to_i
puts "worker_processes: #{WORKER_PROCESSES}"

WORKER_PROCESSES = (ENV['UNICORN_WORKER_NUM'] || 5).to_i
puts "worker_processes: #{WORKER_PROCESSES}"

preload_app true
working_directory  APP_PATH
pid PID_PATH

listen APP_PORT, :tcp_nopush => false
listen "/tmp/unicorn.capstrano_demo.sock"

worker_processes WORKER_PROCESSES
timeout 120

if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "#{Rails.root}/Gemfile"
end

before_fork do |server, worker|
  old_pid = "#{Rails.root}/tmp/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      puts "Send 'QUIT' signal to unicorn error!"
    end
  end
end


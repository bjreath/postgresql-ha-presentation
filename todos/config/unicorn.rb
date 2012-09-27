user "vagrant"
worker_processes 2
preload_app true
timeout 30
listen '/tmp/unicorn.sock', :backlog => 2048

stderr_path "/vagrant/todos/log/unicorn.stderr.log"
stdout_path "/vagrant/todos/log/unicorn.stdout.log"

pid '/vagrant/todos/tmp/pids/unicorn.pid'

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  old_pid = '/vagrant/todos/tmp/pids/unicorn.pid.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end

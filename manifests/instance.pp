define unicorn::instance (
  $working_directory,
  $listen,
  $pid,
  $user,
  $before_fork      = "do |server, worker|
  old_pid = \"#{server.config[:pid]}.oldbin\"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill(\"QUIT\", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end",
  $preload_app      = "true
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end",
  $timeout          = 120,
  $worker_processes = 8,) {
  class { 'unicorn': }

  file { "/etc/unicorn.d/${name}": content => template('unicorn/instance.erb') }

  service { "unicorn:${name}":
    ensure     => 'running',
    provider   => 'base',
    pattern    => "unicorn master -Dc /etc/unicorn.d/${name}",
    start      => "/etc/init.d/unicorn start --instance=${name}",
    stop       => "/etc/init.d/unicorn stop --instance=${name}",
    hasrestart => false,
    hasstatus  => false,
    require    => [Class['unicorn'],File["/etc/unicorn.d/${name}"]]
  }
}
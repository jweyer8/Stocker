monit 'monit' do
    httpd_port node[:monit][:port]
    httpd_username node[:monit][:username]
    httpd_password node[:monit][:password]
    httpd_port node[:monit][:port]
    daemon_interval node[:monit][:interval]
    event_slots node[:monit][:event_slots]
    logfile node[:monit][:logfile]
end

monit_config 'postgresql' do
    source 'postgressql.conf.erb'
    variables( { version: node[:postgresql][:defaults][:server][:version] } )
end

monit_check 'postgresql' do
    check "if failed host 127.0.0.1 port 5432 protocol pgsql then restart"
    with "pidfile /var/run/postgresql/<%= @version %>-main.pid"
    start_signal "/etc/init.d/postgresql start"
    stop_signal "/etc/init.d/postgresql stop"
end

monit_check 'postgresql' do
    check 'if failed unixsocket /var/run/postgresql/.s PGSQL.5432 protocol psgsql then restart'
    with "pidfile /var/run/postgresql/#{node[:pg][:version]}-main.pid"
    start_signal "/etc/init.d/postgresql start"
    stop_signal "/etc/init.d/postgresql stop"
end

monit_config 'redis' do
    source 'redis.conf.erb'
end

monit_check 'redis' do
    with "pidfile /var/run/redis-server.pid"
    start_signal "/etc/init.d/redis start"
    stop_signal "/etc/init.d/redis stop"
end

monit_config 'nginx' do
    source 'nginx.conf.erb'
end

monit_check 'nginx' do
    check "if failed host 127.0.0.1 port 5432 protocol pgsql then restart"
    with "pidfile /var/run/nginx.pid"
    start_signal "/etc/init.d/nginx start"
    stop_signal "/etc/init.d/nginx stop"
end

monit_config 'puma' do
    source 'puma.conf.erb'
    variables({user: node['project']['user'], 
              project_root: node[:project][:root],
              rvm: ::File.join('/', 'home', 'user', '.rvm', 'scripts', 'rvm')})
end

monit_check 'puma' do
    with ::File.join('<%= @project_root %>', 'shared', 'tmp', 'pids', 'puma.pid')
    start_signal "/bin/su - <%= @user %> -s /bin/bash -c 'source <%= @rvm %> && cd <%= @project_root %>/current && bundle exec puma -C <%= project_root %>/shared/puma.rb -e <%= node.envionment %> --daemon'"
    stop_signal "/bin/su - <%= @user %> -s /bin/bash -c 'source <%= @rvm %> && cd <%= @project_root %>/current && bundle exec pumactl -P <%= project_root %>/shared/tmp/puma.pid stop"
end
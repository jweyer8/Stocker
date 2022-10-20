# home_path = ::File.join('/', 'home', node[:project][:user])
# shared_path = ::File.join(node[:project][:root], 'shared')
# bundle_path = ::File.join(shared_path, 'vendor', 'bundle')
# config_path = ::File.join(shared_path, 'config')
# ssh_path = ::File.join(shared_path, '.ssh')
# ssh_key_file = ::File.join(ssh_path, node[:project][:user])
# ssh_wrapper_file = ::File.join(ssh_path, 'wrap-ssh4git.sh')
# puma_state_file = ::File.join(shared_path, 'tmp', 'pids', 'puma.state')
# sidekiq_stae_file = ::File.join(shared_path, 'tmp', 'pids', 'sidekiq.pid')
# maintenance_file = ::File.join(shared_path, 'tmp', 'maintenance')

# directory ssh_path do
#     owner node[:project][:user]
#     group node[:project][:group]
#     recursize true
# end

# cookbook_file ssh_key_file do
#     source 'key'
#     owner node[:project][:user]
#     group node[:project][:group]
#     mode 0600
# end

# file ssh_wrapper_file do
#     content <<~BASH
#             #!/bin/bash
#             /usr/bin/env ssh -o "StrictHostKeyChecking=no" -i "#{ssh_key_file}" $1 $2
#             BASH
#     owner node[:project][:user]
#     group node[:project][:group]
#     mode 0755
# end

# %w{config log public/system public/uploads public/assets repo tmp/cache tmp/pids tmp/sockets}.each do |dir|
#     directory ::File.join(shared_path, dir) do
#         owner node[:project][:user]
#         group node[:project][:group]
#         mode 0755
#         recursize true
#     end
# end

# template ::File.join(config_path, 'database.yml') do
#     source ::File.join(node.envirnoment, 'database.yml.erb')
#     variables(
#         environment: node.envirnoment,
#         database: data_bag_item('config', node.envirnoment)['project']['database']['name'],
#         user: data_bag_item('config', node.envirnoment)['project']['database']['user'],
#         password: data_bag_item('config', node.envirnoment)['project']['database']['password']
#     )
#     sensitive true
#     owner node[:project][:user]
#     group node[:project][:group]
#     mode 0644
# end

# file ::File.join(config_path, 'application.yml') do
#     content Hash[node.environment, data_bag_item('config', node.envirnoment)['project']['application']].to_yaml
#     sensitive true
#     owner node[:project][:user]
#     group node[:project][:group]
#     mode 0644
# end

# template ::File.join(config_path, 'sidekiq.yml') do
#     source ::File.join(node.envirnoment, 'sidekiq.yml.erb')
#     variables(envirnoment: node.envirnoment)
#     sensitive true
#     owner node[:project][:user]
#     group node[:project][:group]
#     mode 0644
# end


# Not sure what the best way to do this is

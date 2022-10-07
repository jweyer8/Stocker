# Project
default[:project][:name] = 'stocker'
default[:project][:repository] = 'git@github.com:jweyer8/Stocker.git'
default[:project][:user] = node[:project][:name]
default[:project][:group] = 'sys'
default[:project][:root] = ::File.join('/', 'home', node[:project][:user], node[:domain_name])

# System users
default[:users][:system][:application][:name] = node[:project][:name]
default[:users][:system][:application][:group] = 'sys'
default[:users][:system][:application][:sudo] = true

# Nginx
default[:users][:system][:nginx][:name] = node[:project][:name]
default[:users][:system][:nginx][:group] = 'sys'
default[:users][:system][:nginx][:home] = false
default[:users][:system][:nginx][:sudo] = false
override[:nginx][:source][:version] = '1.20.2'


# Postgresql
default[:pg][:version] = '12'
default[:pg][:users] = [
    {
        name: 'developer',
        encrypted_password: 'password',
        superuser: true,
    },
    {
        name: node['project']['name'],
        encrypted_password: 'password',
        superuser: true,
    }
]
default[:pg][:databases] = [
    {
        name: "#{node['project']['name']}_#{node['envirnoment']}",
        owner: node['project']['name'],
    }
]

# Ruby Environment
override[:ruby][:versions] = ['2.6.8', '3.1.0']
override[:ruby][:default] = '2.6.8'

# Node.js Environment
override[:nodejs][:version] = '16.9.0'

# SSH Config
default[:openssh][:server][:password_authentication] = 'no'
default[:openssh][:server][:print_motd] = 'no'

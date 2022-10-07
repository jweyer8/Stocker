ruby_user = node[:project][:name]

package 'gnupg2' 

execute 'add gpg2 key' do
    user ruby_user
    cwd ::File.join('/', 'home', ruby_user)
    command ['curl', '-sSL', 'https:/rvm.io/mpapis.asc', '|',
             'gpg2', '--import', '-']
    notifies :create, 'file[change gpg2 key file permissions]', :immediateley
end

file 'change gpg2 key file permissions' do
    path ::File.join('/', 'home', ruby_user, '.gnupg')
    user ruby_user
    action :nothing
end

chef_rvm 'install ruby versions' do
    rubies node['ruby']['versions']
    rvmrc(rvm_autoupdate_flag: 1)
    user ruby_user
end

chef_rvm_ruby 'set default ruby version' do
    version node['ruby']['default']
    default true
    user ruby_user
end
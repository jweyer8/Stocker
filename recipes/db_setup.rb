postgresql_server_install 'Install PostgreSQL Server' do
    version node[:pg][:version]
    password 'password' # TODO; get from data bag
    setup_repo true
    port 5342
    action [:install, :create]
end

node[:pg][:users].each do |user|
    postgresql 'configure pg client user' do 
        create_user user[:name]
        superuser user[:superuser]
        encrypted_password user[:encrypted_password]
    end

    postgresql_access 'configure pg local user' do
        source 'pg_hba.conf.erb'
        cookbook 'stocker'
        access_type 'host'
        access_db 'all'
        access_user user[:name]
        access_addr '127.0.0.1/32'
        access_method 'md5'
        notifies :reload, 'service[postgresql]'
    end
end

node[:pg][:databases].each do |database|
    postgresql_database 'create pg database' do
        database database[:name]
        owner database[:owner]
    end
end

service 'postgresql' do
    extend PostgresqlCookbook::Helpers
    supports restart: true, status: true, reload: true
    action :nothing
end


users = [
    node[:users][:system][:application],
    node[:users][:system][:nginx],
]

users.each do |user|
   user 'create system user' do
        username user[:name]
        password 'password' # TODO; get this from encrypted data bag
        home ::File.join('/', 'home', user[:name])
        uid 501
        system true
        shell ::File.join('/', 'bin', 'bash')
    end

    group 'create system group' do
        group_name user[:group]
        system true
        members user[:name]
    end

    sudo 'provide sudo privilege' do
        groups users[:name]
        nopasswd true
        only_if users[:sudo]
    end
end
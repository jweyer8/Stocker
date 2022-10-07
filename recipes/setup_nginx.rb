nginx_install 'install nginx' do
    ohai_plugin_enabled true
    source 'repo'
end

nginx_site 'nginx site config' do
    cookbook 'Stocker'
    template 'nginx_site.erb'
    owner 'root'
    group 'root'
    mode '0644'
    folder_mode '0755'
    variables(
        'upstream' => {
            'puma' => {
                'server' => URI::Generic.build2(scheme: 'unix', path: ::File.join(node[:project][:root], 'shared', 'tmp', 'sockets', 'puma.sock'))
            }
        },
        'server' => {
            'port' => [ '*:80' ],
            'server_name' => [ "#{node[:ipaddress]} #{node[:domain_name]}" ],
            'access_log' => ::File.join('/', 'var', 'log', 'nginx', 'stocker.access.log'),
            'error_log' => ::File.join('/', 'var', 'log', 'nginx', 'stocker.error.log'),
            'client_max_body' => '64M',
            'keepalive_timeout' => '10',
            'root' => ::File.join(node[:project][:root], 'current', 'public'),
            'index' => 'index.html',
            'error_page' => { '503' => '@maintenance' },
            'locations' => {
                '/' => {
                    "if (-f #{::File.join(node[:project][:root], 'shared', 'tmp', 'maintenance')} { return 503 '{}' }" => nil,
                    'proxy_redirect' => 'off',
                    'proxy_set_header' => 'Client-Ip $remote_addr',
                    'proxy_set_header' => 'Host $host',
                    'proxy_set_header' => 'X-Forwarded-For $proxy_add_x_forwarded_for',
                    'proxy_set_header' => 'X-Forwarded-Proto $scheme',
                    'gzip_static' => 'on',
                    'proxy_pass' => URI::HTTP.build(path: 'puma'),
                },
                '~* \.(?:manifest|appcache|html?|json)$' => {
                    'expires' => -1,
                },
                '~* \.(?:css|js)$' => {
                    'try_files' => '$uri =404',
                    'expires' => '1y',
                    'access_log' => 'off',
                    'add_header' => 'Cache-Control "public"',
                },
                '~* \.(?:jpg|jpeg|gif|png|ico|bmp|swf|txt|svg|ttf|woff)$' => {
                    'try_files' => '$uri =404',
                    'access_log' => 'off',
                    'expires' => 'max',
                },
                '@maintenance' => {
                    'rewrite' => '^(.*)$ /maintenance.html break'
                },
            },
        }
    )
    action :create
    notifies :reload, 'nginx_service[nginx]', :delayed
end

nginx_service 'nginx' do
    action :enable
    delayed_action :start
end


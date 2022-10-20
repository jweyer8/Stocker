
name 'stocker'

default_source :supermarket

cookbook 'stocker', path: '.'
cookbook 'postgresql'
cookbook 'chef_rvm'
cookbook 'nodejs'
cookbook 'redis'
cookbook 'nginx'
cookbook 'openssh'
cookbook 'poise-monit'

run_list 'role[setup]',
'role[db]',
'role[web',
'role[security]',
'role[monitoring]'

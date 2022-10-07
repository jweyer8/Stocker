
name 'stocker'

default_source :supermarket

cookbook 'stocker', path: '.'
cookbook 'postgresql'
cookbook 'chef_rvm'
cookbook 'nodejs'
cookbook 'redis'
cookbook 'nginx'
cookbook 'openssh'

run_list 'role[setup]',
'role[db]',
'role[web'

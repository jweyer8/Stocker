name 'web'
description 'setup web server'

run_list 'stocker::install_redis',
'stocker::install_ruby',
'stocker::install_nodejs',
'stocker::setup_nginx'
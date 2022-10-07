name 'setup'
description 'base setup'

run_list 'stocker::set_hostname',
'stocker::create_users'
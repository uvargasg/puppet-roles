define roles::rabbitmq_server::add_user (

  $user                 = $name,
  $pass                 = undef,
  $configure_permission = '.*',
  $read_permission      = '.*',
  $write_permission     = '.*',

) {

  if ! $pass {
    fail('pass parameter must be defined')
  }

  rabbitmq_user { $user:
    password => $pass
  }

  rabbitmq_user_permissions { "${user}@/":
    configure_permission => $configure_permission,
    read_permission      => $read_permission,
    write_permission     => $write_permission,
  }
}

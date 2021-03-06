class roles::mongodb_server (

  $version             = '3.4.2',
  $bind_ip             = '0.0.0.0',
  $manage_package_repo = true,
  $verbose             = false,
  $auth                = undef,
  $keyfile             = undef,
  $key                 = undef,
  $backup              = true,
  $backup_dir          = '/srv',
  $backup_retention    = 7,
  $replset             = undef,
  $nojournal           = undef,
  $smallfiles          = undef,
  $pidfilepath         = '/var/run/mongodb.pid',
  $set_parameter       = undef,
  $nohttpinterface     = false,
  $rest                = true,
  $service_provider    = undef

) inherits roles {

  validate_ip_address($bind_ip)
  validate_bool($manage_package_repo)
  validate_bool($verbose)
  validate_bool($backup)

  apt::key { 'mongodb-org-tools_key':
    id     => '0C49F3730359A14518585931BC711F9BA15703C6',
    server => 'keyserver.ubuntu.com',
    before => Package['mongodb-org-tools']
  }

  class {'::mongodb::globals':
    version             => $version,
    manage_package_repo => true,
    bind_ip             => '0.0.0.0',
    pidfilepath         => $pidfilepath,
    }->
    class {'::mongodb::client': }->
    class {'::mongodb::server':
      verbose          => true,
      auth             => $auth,
      keyfile          => $keyfile,
      key              => $key,
      replset          => $replset,
      nojournal        => $nojournal,
      smallfiles       => $smallfiles,
      set_parameter    => $set_parameter,
      nohttpinterface  => $nohttpinterface,
      rest             => $rest,
      service_provider => $service_provider,
      require          => Class['mongodb::globals']
    }

  package { 'mongodb-org-tools':
    ensure  => present,
    require => Class['mongodb::server']
  }

  if $backup {
    class {roles::mongodb_server::backup:
      backup_dir       => $backup_dir,
      backup_retention => $backup_retention
    }
  }
}

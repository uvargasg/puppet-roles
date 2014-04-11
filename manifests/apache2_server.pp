class roles::apache2_server (

  $ssl               = true,
  $passenger         = true,
  $phalcon           = false,
  $environment       = undef,
  $file_uploads      = undef,
  $file_uploads_size = undef

) inherits roles {

  class {'apache2':
    environment => $environment
  }

  class {'php5':
    fpm               => true,
    phalcon           => $phalcon,
    environment       => $environment,
    file_uploads      => $file_uploads,
    file_uploads_size => $file_uploads_size
  }

  if $ssl {

    apache2::module {'ssl':
      require => Class['apache2::install']
    }

    apache2::site {'default-ssl':
      require => Class['apache2::install']
    }
  }

  if $passenger {
    package {'libapache2-mod-passenger':
      ensure => present,
    }

    apache2::module {'passenger':
      require => Class['apache2::install']
    }

  }
}

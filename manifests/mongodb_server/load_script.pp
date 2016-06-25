define roles::mongodb_server::load_script (

  $script = undef,
  $unless = undef

) {

  include mongodb

  $script_source = $script['source']
  $script_file   = $script['file']

  notice($script['source'])

  if ! $script {

    fail('roles::mongodb_server::load_script needs script parameter.')
  }else{

    if ! is_hash($script) {
      fail('roles::mongodb_server::load_script script parameter needs to be an hash.')
    }
  }

  if $script_file =~ /\.erb$/ {

    file {"load_script_${name}":
      path    => "/tmp/${script_file}",
      content => template("${script_source}/${script_file}"),
    }
  }else{

    file {"load_script_${name}":
      path   => "/tmp/${script_file}",
      source => "puppet:///modules/${script_source}/${script_file}",
    }
  }

  exec {"load_scriptscript_${name}":
    cwd     => '/tmp/',
    command => "/usr/bin/mongo /tmp/${script_file}",
    require => [File["load_script_${name}"], Service['mongodb']],
    unless  => $unless
  }
}

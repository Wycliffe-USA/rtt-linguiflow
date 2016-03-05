class couchdb::backup {

  # used in ERB templates
  $bind_address = $couchdb::bind_address
  validate_re($bind_address, '^\S+$')
  $port = $couchdb::port
  validate_re($port, '^[0-9]+$')
  $backupdir = $couchdb::backupdir
  validate_absolute_path($backupdir)

  file {$backupdir:
    ensure  => directory,
    mode    => '0755',
    require => Package['couchdb'],
  }

  file { '/usr/local/sbin/couchdb-backup.py':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template('couchdb/couchdb-backup.py.erb'),
    require => File[$backupdir],
  }

  cron { 'couchdb-backup':
    command => '/usr/local/sbin/couchdb-backup.py 2> /dev/null',
    hour    => 3,
    minute  => 0,
    require => File['/usr/local/sbin/couchdb-backup.py'],
  }

  case $::osfamily {
    'Debian': {
      include ::python::package::couchdb
      include ::python::package::simplejson
    }
    'RedHat': {
      include ::python::pip::couchdb
      include ::python::package::simplejson
    }
    default: {
      fail "Unsupported Operating System family: ${::osfamily}"
    }
  }

  Package <| alias == 'python-couchdb'    |>
  Package <| alias == 'python-simplejson' |>

}

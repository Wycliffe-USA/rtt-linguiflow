include ::couchdb

class { '::nodejs':
  manage_package_repo       => false,
  nodejs_dev_package_ensure => 'present',
  npm_package_ensure        => 'present',
}

package{'bower':
  ensure   => 'installed',
  provider => 'npm',
  require  => Class['::nodejs'],
}

file {'/usr/bin/node':
  ensure  => 'link',
  target  => '/usr/bin/nodejs',
  require => Class['::nodejs'],
}


package { 'git':
  ensure  => installed,
}

exec { 'npm i':
  cwd     => '/var/www/project/hackstack',
  creates => '/var/www/project/hackstack/node_modules/express/History.md',
  path    => ['/usr/bin'],
  require => Class['::nodejs'],
}

exec {'bower install':
  command => '/usr/local/bin/bower install --config.interactive=false --allow-root',
  cwd     => '/var/www/project/hackstack',
  creates => '/var/www/project/hackstack/bower_components/bootstrap/README.md',
  path    => ['/usr/bin'],
  require => [Package['git'], File['/usr/bin/node']],
}

service { 'linguiflow':
  ensure   => running,
  provider => 'upstart',
  require  => Exec['bower install'],
}

class {'nginx': }

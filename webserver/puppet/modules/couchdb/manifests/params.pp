class couchdb::params {

  if defined('$couchdb_bind_address') {
    $bind_address = $::couchdb_bind_address ? {
      ''      => '127.0.0.1',
      default => $::couchdb_bind_address,
    }
  } else {
    $bind_address = '127.0.0.1'
  }

  if defined('$couchdb_port') {
    $port = $::couchdb_port ? {
      ''      => '5984',
      default => $::couchdb_port,
    }
  } else {
    $port = '5984'
  }

  $backupdir = '/var/backups/couchdb'

}

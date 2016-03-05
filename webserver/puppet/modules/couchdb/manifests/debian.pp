class couchdb::debian {
  include ::couchdb::base

  package {'libjs-jquery':
    ensure => present,
  }

}

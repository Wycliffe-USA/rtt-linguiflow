#
# == Definition: selinux::permissivedomain
#
# put/remove a single domain in permissive mode
#
define selinux::permissivedomain( $ensure='present' ) {

  if versioncmp($::operatingsystemmajrelease, '6') < 0 {
    fail ('selinux permissive domains are only suppported on RHEL6 and higher.')
  }

  if $ensure == 'present' {
    $action = '-a'
    $onlyif = undef
    $unless = "semanage permissive -l | grep -q '^${name}$'"
  } else {
    $action = '-d'
    $onlyif = "semanage permissive -l | grep -q '^${name}$'"
    $unless = undef
  }

  exec { "semanage permissive ${action} ${name}":
    command => "semanage permissive ${action} '${name}'",
    path    => $::path,
    onlyif  => $onlyif,
    unless  => $unless,
  }

}

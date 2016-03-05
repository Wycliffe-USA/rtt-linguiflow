# == Definition: selinux::seport
#
# Adds/removes ports to SELinux security contexts.
#
# Parameters:
#
# - *$name*: security context name
# - *$ensure*: present/absent
# - *$proto*: tcp/udp
# - *$port*: port number to add/remove from security context
# - *$setype*: specify the selinux type, in case $name can't be used
#
# Example usage:
#
#   # allow apache to bind on port 8001
#   selinux::seport { "http_port_t":
#     ensure => present,
#     proto  => "tcp",
#     port   => "8001",
#     before => Service["apache"],
#   }
#
define selinux::seport($port, $ensure='present', $proto='tcp', $setype=undef) {

  # this is dreadful to read, sorry...

  if $setype == undef {
    $type = $name
  } else {
    $type = $setype
  }

  if $ensure == 'present' {
    $cmd  = "semanage port --add --type ${type} --proto ${proto} ${port} || semanage port --modify --type ${type} --proto ${proto} ${port}" # lint:ignore:80chars
    $grep = 'egrep -q'
  } else {
    $cmd  = "semanage port --delete --type ${type} --proto ${proto} ${port}"
    $grep = '! egrep -q'
  }

  $re = "^${type}\\W+${proto}\\W+.*\\W${port}(\\W|$)"

  exec { "semanage port ${port}, proto ${proto}, type ${name}":
    path    => $::path,
    command => $cmd,
    # subshell required to invert return status with !
    unless  => "semanage port --list | ( ${grep} '${re}' )",
  }

}

# == Definition: selinux::module
#
# This definition builds a binary SELinux module from a supplied set of SELinux
# security policies. It is then possible to load it using a Selmodule resource.
#
# Parameters:
#
# - *name*: the name of the SELinux module
# - *workdir*: where the module source and binary files are stored. Defaults to
#   "/etc/puppet/selinux"
# - *dest*: where the binary module must be copied. Defaults to
#   "/usr/share/selinux/targeted/"
# - *content*: inline content or template of the module source
# - *source*: file:// or puppet:// URI of the module source file
#
# Example usage:
#
#   selinux::module { "foobar":
#     notify => Selmodule["foobar"],
#     source => "puppet:///modules/myproject/foobar.te",
#   }
#
#   selmodule { "foobar":
#     ensure      => present,
#     syncversion => true,
#   }
#
define selinux::module (
  $ensure=present,
  $workdir='/etc/puppet/selinux',
  $dest='/usr/share/selinux/targeted',
  $content=undef,
  $source=undef,
  $contentfc=undef,
  $sourcefc=undef,
  $withfc=false,
  $load=true,
) {

  validate_bool($load)

  if str2bool($withfc) == true {
    warning("${name} : \$withfc is deprecated. Use contentfc or sourcefc instead!")
  }

  case $::osfamily {

    'RedHat': {
      selinux::module::redhat{ $name:
        ensure    => $ensure,
        dest      => $dest,
        content   => $content,
        source    => $source,
        contentfc => $contentfc,
        sourcefc  => $sourcefc,
        withfc    => $withfc,
        load      => $load,
      }
    }

    'Debian': {
      selinux::module::debian{ $name:
        ensure  => $ensure,
        workdir => $workdir,
        dest    => $dest,
        content => $content,
        source  => $source,
        load    => $load,
      }
    }

    default: { fail("${::operatingsystem} is not supported.") }

  }

}

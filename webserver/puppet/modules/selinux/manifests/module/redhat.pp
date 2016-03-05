#
# == Definition: selinux::module::redhat
#
# This definition builds a binary SELinux module with the Makefile provided by
# the selinux-policy-devel or selinux-policy package.
# It should only be called ba the selinux::module definition, in case of
# RedHat osfamily.
#
# Parameters:
#
# - *name*: the name of the SELinux module
# - *workdir*: where the module source and binary files are stored. Defaults to
#   "/etc/puppet/selinux" (not used here, yet ?)
# - *dest*: where the binary module must be copied. Defaults to
#   "/usr/share/selinux/targeted/"
# - *content*: inline content or template of the module source
# - *source*: file:// or puppet:// URI of the module source file
# - *contentfc*: inline content or template of the module file context source
# - *sourcefc*: file:// or puppet:// URI of the module file context source file
#
define selinux::module::redhat (
  $ensure=present,
  $dest='/usr/share/selinux/targeted',
  $content=undef,
  $source=undef,
  $contentfc=undef,
  $sourcefc=undef,
  $withfc=false,
  $load=true,
) {

  # lint:ignore:80chars
  case $ensure {
    'present': {
      file { "${dest}/${name}.te":
        ensure  => file,
        content => $content,
        source  => $source,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        notify  => Exec["build selinux policy package ${name} if source changed"],
      }

      # if there is source for file context configuration
      if $sourcefc or $contentfc {
        file{ "${dest}/${name}.fc":
          ensure  => file,
          content => $contentfc,
          source  => $sourcefc,
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          notify  => Exec["build selinux policy package ${name} if source changed"],
        }
      } elsif $withfc {
        $_sourcefc = $sourcefc ? {
          undef   => undef,
          default => regsubst( $source, '(.*)\.te', '\1.fc' ),
        }

        file{ "${dest}/${name}.fc":
          ensure  => file,
          content => $contentfc,
          source  => $_sourcefc,
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          notify  => Exec["build selinux policy package ${name} if source changed"],
        }
      }

      $build_reqs = $::operatingsystemmajrelease  ? {
        /5|7/ => [File["${dest}/${name}.te"], Package['checkpolicy'], Package['selinux-policy-devel']],
        '6'   => [File["${dest}/${name}.te"], Package['checkpolicy']],
      }
      $make_cmd = "make -f /usr/share/selinux/devel/Makefile ${name}.pp"

      # Module building needs to happen in two cases that cannot be defined in a single Exec
      exec { "build selinux policy package ${name} if source changed":
        cwd         => $dest,
        command     => $make_cmd,
        path        => $::path,
        require     => $build_reqs,
        refreshonly => true,
      }
      exec { "build selinux policy package ${name} if .pp missing":
        cwd     => $dest,
        command => $make_cmd,
        path    => $::path,
        creates => "${dest}/${name}.pp",
        require => flatten([ $build_reqs, Exec["build selinux policy package ${name} if source changed"] ]),
      }

      if $load {
        selmodule { $name:
          ensure      => present,
          syncversion => true,
          require     => Exec["build selinux policy package ${name} if .pp missing"],
        }
      }
    }
    # lint:endignore
    'absent': {
      file {[
        "${dest}/${name}.te",
        "${dest}/${name}.if",
        "${dest}/${name}.fc",
        "${dest}/${name}.pp",
      ]:
        ensure => absent,
      }

      if $load {
        selmodule { $name:
          ensure => absent,
        }
      }
    }
    default: { fail "${ensure} must be 'present' or 'absent'" }
  }

}

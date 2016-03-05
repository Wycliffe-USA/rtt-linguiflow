#
# == Definition: selinux::module::debian
#
# This definition builds a binary SELinux module.
# It should only be called ba the selinux::module definition, in case of
# Debian osfamily.
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
#
#
define selinux::module::debian (
  $ensure=present,
  $workdir='/etc/puppet/selinux',
  $dest='/usr/share/selinux/targeted',
  $content=undef,
  $source=undef,
  $load=true,
) {

  case $ensure {
    'present': {
      if !defined(File[$workdir]) {
        file { $workdir:
          ensure => directory,
          mode   => '0700',
          owner  => 'root',
        }
      }

      file { "${workdir}/${name}.te":
        ensure  => file,
        content => $content,
        source  => $source,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File[$workdir],
        notify  => Exec["build selinux policy module ${name}"],
      }

      exec { "build selinux policy module ${name}":
        cwd     => $workdir,
        command => "checkmodule -M -m ${name}.te -o ${name}.mod",
        path    => $::path,
        onlyif  => "semodule -l | grep -q -P \"^${name}\t\"$(head -n1 ${name}.te | grep -o -e \"[0-9\\.]*\")", # lint:ignore:80chars
        require => [File["${workdir}/${name}.te"], Package['checkpolicy']],
        notify  => Exec["build selinux policy package ${name}"],
      }

      exec { "build selinux policy package ${name}":
        cwd         => $workdir,
        command     => "semodule_package -o ${dest}/${name}.pp -m ${name}.mod",
        path        => $::path,
        refreshonly => true,
        require     => [
          Exec["build selinux policy module ${name}"],
          Package['policycoreutils'],
        ],
      }

      if $load {
        selmodule { $name:
          ensure      => present,
          syncversion => true,
          require     => Exec["build selinux policy package ${name}"],
        }
      }
    }
    'absent': {
      file {[
        "${workdir}/${name}.te",
        "${workdir}/${name}.mod",
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

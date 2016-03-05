# == Class: selinux::base
#
# This class ensures selinux utilities and services are installed and running.
# It will also install the ruby bindings which are required to use puppet's
# selinux resource types.
#
class selinux::base {

  service { 'auditd':
    ensure => running,
    enable => true,
  }

  # required to build custom policy modules.
  package { ['checkpolicy', 'policycoreutils']: ensure => present }

  case $::osfamily {
    'RedHat': {

      case $::operatingsystemmajrelease {

        '7': {
          package { 'policycoreutils-python':
            ensure => present,
          }
          package{ 'selinux-policy-devel':
            ensure => present,
          }
          $rubypkg_alias = 'libselinux-ruby'
        }

        '6': {
          package { 'policycoreutils-python':
            ensure => present,
          }
          $rubypkg_alias = 'libselinux-ruby'
        }

        '5': {

          package{ 'selinux-policy-devel':
            ensure => present,
          }

          case $::lsbdistrelease {
            /^5.0$/, /^5.1$/, /^5.2$/, /^5.3$/: {
              $rubypkg_alias = 'libselinux-ruby-puppet'
            }

            default: {
              package { 'libselinux-ruby-puppet':
                ensure => absent,
                before => Package['selinux-ruby-bindings'],
              }
              $rubypkg_alias = 'libselinux-ruby'
            }
          }

        } # '5'

        '4': { $rubypkg_alias = 'libselinux-ruby-puppet' }

        default: { $rubypkg_alias = 'libselinux-ruby' }

      }
    }

    'Debian': {
      case $::lsbdistcodename {
        'sid', 'squeeze': { $rubypkg_alias = 'libselinux-ruby1.8' }
        default:      { $rubypkg_alias = 'libselinux-puppet-ruby1.8' }
      }
    }

  }

  # if needed, you can fetch and build libselinux-ruby-puppet from
  # http://github.com/twpayne/libselinux-ruby-puppet
  package { 'selinux-ruby-bindings':
    ensure => present,
    name   => $rubypkg_alias,
  }
}

SELinux Puppet module
======================

[![Puppet Forge](http://img.shields.io/puppetforge/v/camptocamp/selinux.svg)](https://forge.puppetlabs.com/camptocamp/selinux)
[![Build Status](https://img.shields.io/travis/camptocamp/puppet-selinux/master.svg)](https://travis-ci.org/camptocamp/puppet-selinux)

Overview
--------

This module allows to manage SELinux with Puppet.

Types
-----

### selinux\_fcontext

Manage file context mapping definitions.

```puppet
selinux_fcontext { '/web(/.*)?':
  seltype => 'httpd_sys_content_t',
}
```

### selinux\_permissive

Manage processes type enforcement mode.

```puppet
selinux_permissive { 'httpd_t':
  ensure => present,
}
```

### selinux\_port

Manage network port type definitions.

```puppet
selinux_port { 'http_port_t/tcp/81':
  ensure => present,
}
```

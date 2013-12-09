# Class: unicorn
#
# This module manages unicorn
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class unicorn {
  if (!defined(Package['rubygems'])) {
    package { 'rubygems': ensure => installed, }
  }

  if (!defined(Package['unicorn'])) {
    package { 'unicorn':
      provider => 'gem',
      ensure   => installed,
      require  => Package['rubygems'],
    }
  }

  file { '/etc/unicorn.d': ensure => directory, }

  file { '/etc/init.d/unicorn':
    source => 'puppet:///modules/unicorn/unicorn',
    owner  => 'root',
    group  => 'root',
  }
}

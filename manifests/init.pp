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
  if (!defined(Package['rubygems']) and (versioncmp($::lsbmajdistrelease,'14') < 0)) {
    package { 'rubygems': ensure => installed } ->
    package { 'unicorn': provider => 'gem', ensure => installed }
  } elsif ((!defined(Package['ruby']) or !defined(Package['ruby-dev'])) and (versioncmp($::lsbmajdistrelease,'14') >= 0)) {
    package { ['ruby','ruby-dev'] : ensure => installed, } ->
    package { 'unicorn': provider => 'gem', ensure => installed }
  }

  file { '/etc/unicorn.d': ensure => directory, }

  file { '/etc/init.d/unicorn':
    source => 'puppet:///modules/unicorn/unicorn',
    owner  => 'root',
    group  => 'root',
  }
}

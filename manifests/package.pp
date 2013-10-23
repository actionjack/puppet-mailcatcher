# class mailcatcher::package
#
class mailcatcher::package {
  package { $package :
    ensure => 'present'
  } ->
  package { 'mailcatcher':
    ensure   => 'present',
    provider => 'gem'
  }
}
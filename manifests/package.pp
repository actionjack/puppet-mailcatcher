# class mailcatcher::package
#
class mailcatcher::package {
  package { $mailcatcher::params::packages :
    ensure => 'present'
  } ->
  package { 'mailcatcher':
    ensure   => 'present',
    provider => 'gem'
  }
}
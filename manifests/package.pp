# class mailcatcher::package
#
class mailcatcher::package {
  include ruby

  package { $mailcatcher::params::packages :
    ensure => 'present'
  } ->
  package { 'mailcatcher':
    ensure   => 'present',
    provider => 'gem',
    require  => Class['ruby'],
  }
}

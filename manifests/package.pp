# class mailcatcher::package
#
class mailcatcher::package {
  include ruby
  include ruby::dev

  package { $mailcatcher::params::packages :
    ensure => 'present'
  } ->
  package { 'mailcatcher':
    ensure   => 'present',
    provider => 'gem',
    require  => Class['ruby::dev'],
  }
}

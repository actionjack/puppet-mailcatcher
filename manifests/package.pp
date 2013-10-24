# class mailcatcher::package
#
class mailcatcher::package {
  package { $mailcatcher::packages :
    ensure => 'present'
  } ->
  package { 'mailcatcher':
    ensure   => 'present',
    provider => 'gem'
  }
}
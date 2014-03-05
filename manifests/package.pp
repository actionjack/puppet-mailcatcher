# class mailcatcher::package
#
class mailcatcher::package {

  package { 'mailcatcher':
    ensure   => 'present',
    provider => 'gem',
  }

}
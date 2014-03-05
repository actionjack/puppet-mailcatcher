# class mailcatcher::package
#
class mailcatcher::package (
  $ruby_dev        = $mailcatcher::params::ruby_dev,
  $sqlite          = $mailcatcher::params::sqlite,
  $sqlite_dev_libs = $mailcatcher::params::sqlite_dev_libs,
  $ruby_gems       = $mailcatcher::params::ruby_gems
){

  anchor { 'mailcatcher::packages::begin': }

  if ! defined(Package[$ruby_dev]) {
    package { $ruby_dev :
      ensure => 'present'
    }
  }

  if ! defined(Package[$sqlite]) {
    package { $sqlite :
      ensure => 'present'
    }
  }

  if ! defined(Package[$sqlite_dev_libs]) {
    package { $sqlite_dev_libs :
      ensure => 'present'
    }
  }

  if ! defined(Package[$ruby_gems]) {
    package { $ruby_gems :
      ensure => 'present'
    }
  }

  anchor { 'mailcatcher::packages::end': } ->

  package { 'mailcatcher':
    ensure   => 'present',
    provider => 'gem',
  }


}
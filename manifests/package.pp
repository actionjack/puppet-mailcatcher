# class mailcatcher::package
#
class mailcatcher::package {

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

  package { 'mailcatcher':
    ensure   => 'present',
    provider => 'gem',
    require  => Package[$ruby_dev,$sqlite,$sqlite_dev_libs,$ruby_gems]
  }
}
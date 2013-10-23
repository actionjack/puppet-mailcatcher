# class mailcatcher::package
#
class mailcatcher::package {
  package { ['ruby-dev','sqlite3','libsqlite3-dev']:
    ensure => 'present'
  } ->
  package { 'mailcatcher':
    ensure   => 'present',
    provider => 'gem'
  }
}
# class mailcatcher::params
#
class mailcatcher::params {
  $smtp_ip          = '0.0.0.0'
  $smtp_port        = '1025'
  $http_ip          = '0.0.0.0'
  $http_port        = '1080'
  $mailcatcher_path = '/usr/local/bin'

  case $::osfamily {

    'Debian': {
      $packages = ['ruby-dev','sqlite3','libsqlite3-dev', 'rubygems']
    }
    'Redhat': {
      fail("${::osfamily} is not supported yet.")
    }
    default: {
      fail("${::osfamily} is not supported.")
    }
  }
}
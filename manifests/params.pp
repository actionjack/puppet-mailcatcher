# class mailcatcher::params
#
class mailcatcher::params {
  $smtp_ip          = '0.0.0.0'
  $smtp_port        = '1025'
  $http_ip          = '0.0.0.0'
  $http_port        = '1080'
  $service_enable   = false

  case $::osfamily {
    'Debian': {
      $packages = ['sqlite3', 'libsqlite3-dev']
      $mailcatcher_path = '/usr/local/bin'

      case $::operatingsystem {
        'Ubuntu': {
          $config_file = '/etc/init/mailcatcher.conf'
          $template = 'mailcatcher/etc/init/mailcatcher.conf.erb'
          $provider = 'upstart'
        }
        default: {
          $config_file = '/etc/init.d/mailcatcher'
          $template    = 'mailcatcher/etc/init/mailcatcher.lsb.erb'
          $provider = 'debian'
        }
      }
    }
    'Redhat': {
      $std_packages = ['sqlite-devel', 'gcc-c++']
      $config_file = '/etc/init.d/mailcatcher'
      $template = 'mailcatcher/etc/init/mailcatcher.sysv.erb'
      $provider = 'redhat'
      case $::operatingsystemmajrelease {
        7: {
          $mailcatcher_path = '/usr/local/bin'
          # runtime requirement which does not get installed with mailcatcher 0.5.12
          $packages = union($std_packages, ['rubygem-json_pure'])
        }
        default: {
          $mailcatcher_path = '/usr/bin'
          # rubygem-mime-types from gem requires ruby >= 1.9.2 which is not avilable on CentOS6, so install package from epel
          $packages = union($std_packages, ['rubygem-mime-types'])
        }
      }
    }
    default: {
      fail("Your OS family '${::osfamily}' is not yet supported.")
    }
  }
}

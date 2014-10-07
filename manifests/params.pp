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
      # rubygem-mime-types from gem requires ruby >= 1.9.2 which is not available on CentOS6, in CentOS7 the gem installed mime-types causes  "Encoding::CompatibilityError", so use the package from EPEL which just works fine for CentOS 6 and 7.
      $std_packages = ['sqlite-devel', 'gcc-c++', 'rubygem-mime-types']
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
          $packages = $std_packages
        }
      }
    }
    default: {
      fail("Your OS family '${::osfamily}' is not yet supported.")
    }
  }
}

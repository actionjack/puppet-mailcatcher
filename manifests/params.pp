# class mailcatcher::params
#
class mailcatcher::params {
  $smtp_ip          = '0.0.0.0'
  $smtp_port        = '1025'
  $http_ip          = '0.0.0.0'
  $http_port        = '1080'
  $service_enable   = false
  $default_version  = 'latest'

  case $::osfamily {
    'Debian': {
      $version          = $default_version
      $packages         = ['sqlite3', 'libsqlite3-dev']
      $mailcatcher_path = '/usr/local/bin'

      case $::operatingsystem {
        'Ubuntu': {
          $config_file = '/etc/init/mailcatcher.conf'
          $template    = 'mailcatcher/etc/init/mailcatcher.conf.erb'
          $provider    = 'upstart'
        }
        default: {
          $config_file = '/etc/init.d/mailcatcher'
          $template    = 'mailcatcher/etc/init/mailcatcher.lsb.erb'
          $provider    = 'debian'
        }
      }
    }
    # RHEL, CentOS
    'Redhat': {
      # rubygem-mime-types from gem requires ruby >= 1.9.2 which is not available on CentOS6, in CentOS7 the gem installed mime-types causes "Encoding::CompatibilityError", so use the package from EPEL which just works fine for CentOS 6 and 7.
      $std_packages = ['sqlite-devel', 'gcc-c++', 'rubygem-mime-types']
      $config_file  = '/etc/init.d/mailcatcher'
      $template     = 'mailcatcher/etc/init/mailcatcher.sysv.erb'
      $provider     = 'redhat'

      # We need to distinguish between major RHEL release versions
      case $::operatingsystemmajrelease {
        7: {
          $mailcatcher_path = '/usr/local/bin'
          # json_pure is a runtime requirement which does not get installed with mailcatcher 0.5.12
          # multi_json from gem causes a crash when receiving a mail: /usr/local/share/ruby/site_ruby/rubygems/core_ext/kernel_require.rb:54:in `require': Did not recognize your adapter specification (cannot load such file -- json/ext/parser). (MultiJson::AdapterError)
          $packages = union($std_packages, ['rubygem-json_pure', 'rubygem-multi_json'])
          $version = $default_version
        }
        6: {
          $mailcatcher_path = '/usr/bin'
          $packages = $std_packages
          # newer mailcatcher versions require gems which require i18n gem which is not compatible with CentOS6's ruby version 1.8.7
          # https://github.com/sj26/mailcatcher/issues/213
          $version = '0.5.12'
          # last version of i18n gem which worked with CentOS6's ruby version
          $fixi18nversion = '0.6.11'
          # newer versions do not accept mails with mailcatcher in background, mailcatcher in foreground works
          # Fixed in mailcatcher 0.6.1, but that one is incompatible with CentOS6
          # https://github.com/sj26/mailcatcher/issues/182
          $fixeventmachineversion = '1.0.3'
        }
      }
    }
    default: {
      fail("Your OS family '${::osfamily}' is not yet supported.")
    }
  }
}

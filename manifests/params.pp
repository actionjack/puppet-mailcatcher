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
          if versioncmp($::operatingsystemmajrelease, '14.10') > 0
            $config_file = '/etc/systemd/system/mailcatcher.service'
            $template    = 'mailcatcher/etc/systemd/system/mailcatcher.service.erb'
            $provider    = 'systemd'
          } else {
            $config_file = '/etc/init/mailcatcher.conf'
            $template    = 'mailcatcher/etc/init/mailcatcher.conf.erb'
            $provider    = 'upstart'
          }
        }
        default: {
          $config_file = '/etc/init.d/mailcatcher'
          $template    = 'mailcatcher/etc/init/mailcatcher.lsb.erb'
          $provider    = 'debian'
        }
      }
    }
    # RHEL/CentOS
    'Redhat': {
      # rubygem-mime-types from gem requires ruby >= 1.9.2 which is not available on CentOS6, in CentOS7 the gem installed mime-types causes "Encoding::CompatibilityError", so use the package from EPEL which just works fine for CentOS 6 and 7.
      $std_packages = ['sqlite-devel', 'rubygem-mime-types']
      $config_file  = '/etc/init.d/mailcatcher'
      $template     = 'mailcatcher/etc/init/mailcatcher.sysv.erb'
      $provider     = 'redhat'

      # We need to distinguish between major RHEL release versions
      case $::operatingsystemmajrelease {
        '7': {
          $mailcatcher_path = '/usr/local/bin'
          # json_pure is a runtime requirement which does not get installed with mailcatcher 0.5.12
          # multi_json from gem causes a crash when receiving a mail: /usr/local/share/ruby/site_ruby/rubygems/core_ext/kernel_require.rb:54:in `require': Did not recognize your adapter specification (cannot load such file -- json/ext/parser). (MultiJson::AdapterError)
          $packages = union($std_packages, ['rubygem-json_pure', 'rubygem-multi_json'])
          $version  = $default_version
        }
        '6': {
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

          # don't ask me why, otherwise everything breaks. This was not yet necessary this morning!!! WTF?!?
          # Execution of '/usr/bin/gem install -v 0.5.12 --no-rdoc --no-ri mailcatcher' returned 1: ERROR: Error installing mailcatcher: sinatra requires tilt (~> 1.3, >= 1.3.4, runtime)
          # but gem chooses to install tilt (2.0.1) ?!?
          # Maybe because of haml?: Error: Could not start Service[mailcatcher]: Execution of '/sbin/service mailcatcher start' returned 1: /usr/lib/ruby/site_ruby/1.8/rubygems.rb:233:in `activate': can't activate tilt (~> 1.3, >= 1.3.4, runtime) for ["sinatra-1.4.5", "mailcatcher-0.5.12"], already activated tilt-2.0.1 for ["haml-4.0.6", "mailcatcher-0.5.12"] (Gem::LoadError)
          # I give up on this mess. It works now, but I have no idea for how long.
          package { 'tilt':
            ensure   => '1.4.1',
            provider => 'gem',
            require  => Class['ruby::dev'],
            before   => Package['mailcatcher'],
          }
        }
      }
    }
    default: {
      fail("Your OS family '${::osfamily}' is not yet supported.")
    }
  }
}

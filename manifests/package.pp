# class mailcatcher::package
#
class mailcatcher::package {
  include ruby
  include ruby::dev
  include gcc

  package { $mailcatcher::params::packages :
    ensure => 'present'
  } ->
  package { 'mailcatcher':
    ensure   => $mailcatcher::version,
    provider => 'gem',
    require  => Class['ruby::dev'],
  }


  # Needed vor Debian
  # See params.pp for more information
  if ($mailcatcher::params::fixactivesupportversion) {
    package { 'activesupport':
      ensure   => $mailcatcher::params::fixactivesupportversion,
      provider => 'gem',
      require  => Class['ruby::dev'],
      before   => Package['mailcatcher'],
    }
  }


  # Needed for CentOS6 backport of older mailcatcher version.
  # See params.pp for more information.
  if ($mailcatcher::params::fixeventmachineversion) {
    package { 'eventmachine':
      ensure   => $mailcatcher::params::fixeventmachineversion,
      provider => 'gem',
      require  => Class['ruby::dev'],
      before   => Package['mailcatcher'],
    }
  }
  if ($mailcatcher::params::fixi18nversion) {
    package { 'i18n':
      ensure   => $mailcatcher::params::fixi18nversion,
      provider => 'gem',
      require  => Class['ruby::dev'],
      before   => Package['mailcatcher'],
    }
  }
}

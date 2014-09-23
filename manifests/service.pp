# class mailcatcher::service
#
class mailcatcher::service {
  service {'mailcatcher':
    ensure     => 'running',
    enable     => $mailcatcher::service_enable,
    provider   => $mailcatcher::params::provider,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['mailcatcher::config'],
  }
}

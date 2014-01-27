# class mailcatcher::service
#
class mailcatcher::service {
  service {'mailcatcher':
    ensure     => 'running',
    provider   => $mailcatcher::params::provider,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['mailcatcher::config'],
  }
}
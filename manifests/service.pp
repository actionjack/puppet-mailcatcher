# class mailcatcher::service
#
class mailcatcher::service {
  service {'mailcatcher':
    ensure     => 'running',
    provider   => 'upstart',
    hasstatus  => true,
    hasrestart => true,
    require    => Class['mailcatcher::config'],
  }
}
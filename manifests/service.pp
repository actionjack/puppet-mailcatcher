# class mailcatcher::service
#
class mailcatcher::service {
  service {'mailcatcher':
    ensure     => 'running',
    provider   => 'upstart',
    require    => Class['mailcatcher::config'],
  }
}
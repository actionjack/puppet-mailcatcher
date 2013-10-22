# class mailcatcher::config
#
class mailcatcher::config {
  user { 'mailcatcher':
    ensure           => 'present',
    comment          => 'Mailcatcher Mock Smtp Service User',
    home             => '/var/spool/mailcatcher',
    shell            => '/bin/true',
  }

  $options = join_keys_to_values({' --smtp-ip'   => $mailcatcher::smtp_ip,
                                  ' --smtp-port' => $mailcatcher::smtp_port,
                                  ' --http-ip'   => $mailcatcher::http_ip,
                                  ' --http-port' => $mailcatcher::http_port,
                                 }, ' ')

  file {'/etc/init/mailcatcher.conf':
    ensure  => 'file',
    content => template('mailcatcher/etc/init/mailcatcher.conf.erb'),
    mode    => '0644',
    notify  => Class['mailcatcher::service']
  }
}
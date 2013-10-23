# == Class: mailcatcher
#
# Install and configure Mailcatcher.
# MailCatcher runs a super simple SMTP server which catches any message sent to it to display in a web interface.
# http://mailcatcher.me/
#
# === Parameters
#
# Document parameters here.
#
# [*smtp_ip*]
#   What IP address the mailcatcher smtp service should listen on.
#   The default is 127.0.0.1
#
# [*smtp_port*]
#   What TCP Port the mailcatcher smtp service should listen on.
#   The default is 1025
#
# [*http_ip*]
#   What IP address the mailcatcher web mail client service should listen on.
#   The default is 0.0.0.0
#
# [*http_port*]
#   What TCP Port the mailcatcher web mail client service should listen on.
#   The default is 1080
#
#
# === Examples
#
# [*default*]
#
#  class { mailcatcher:  }
#
# [*listen on all ethernet adapters*]
#
#  class { mailcatcher:
#   smtp_ip => '0.0.0.0'
#  }
#
# === Authors
#
# Martin Jackson <contact@uncommonsense-uk.com>
#
# === Copyright
#
# Copyright 2013 Martin Jackson, unless otherwise noted.
#
# Todo
# - Mailcatcher doesn't respect shutdown operation in upstart script
# - Only supports debian based distros need support for other distros e.g. redhat, centos, or Amazon.
# - Implement tests and integrate into travis-ci
#
class mailcatcher (
  $smtp_ip   = $mailcatcher::params::smtp_ip,
  $smtp_port = $mailcatcher::params::smtp_port,
  $http_ip   = $mailcatcher::params::http_ip,
  $http_port = $mailcatcher::params::http_port,
  $package   = $mailcatcher::params::package
) inherits mailcatcher::params {

  class {'mailcatcher::package': } ->
  class {'mailcatcher::config': } ->
  class {'mailcatcher::service': }

}

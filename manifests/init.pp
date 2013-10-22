# == Class: mailcatcher
#
# Full description of class mailcatcher here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { mailcatcher:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Martin Jackosn <contact@uncommonsense-uk.com>
#
# === Copyright
#
# Copyright 2013 Martin Jackson, unless otherwise noted.
#
class mailcatcher (
  $smtp_ip   = $mailcatcher::params::smtp_ip,
  $smtp_port = $mailcatcher::params::smtp_port,
  $http_ip   = $mailcatcher::params::http_ip,
  $http_port = $mailcatcher::params::http_port,
) inherits mailcatcher::params {

  class {'mailcatcher::package': } ->
  class {'mailcatcher::config': } ->
  class {'mailcatcher::service': }

}

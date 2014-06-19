# == Class: serf::params
#
# This class exists to
# 1. Declutter the default value assignment for class parameters.
# 2. Manage internally used module variables in a central place.
#
# Therefore, many operating system dependent differences (names, paths, ...)
# are addressed in here.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class is not intended to be used directly.
#
#
class serf::params{
  $version          = '0.3.0'
  $protocol_version = 1
  $bind             = $::ipaddress
  $advertise        = $::ipaddress
  $config_dir       = '/etc/serf'
  $config_file      = "${config_dir}/serf.conf"
  $log_dir          = '/var/log/serf'
  $encrypt          = ''
  $log_level        = 'info'
  $log_file         = "${log_dir}/serf.log"
  $node             = $::fqdn
  $protocol         = $::serf::params::protocol
  $role             = $::serf::params::role
  $rpc_addr         = "${bind}:7373"
  $install_path     = '/usr/local/bin/'
  $install_method   = 'url'
  $sample_handler   = true
  $handler_home     = "{config_dir}/handlers"
  $package_name     = 'serf'
  $package_ensure   = 'present'
  $event_handler    = [
    '/etc/serf/handlers/handler.sh'
  ]
  $join             = [
    '127.0.0.1'
  ]

  # service parameters
  case $::operatingsystem {
    'RedHat', 'CentOS', 'Fedora', 'Scientific', 'Amazon', 'OracleLinux': {
      $service_name       = 'serf'
      $service_hasrestart = true
      $service_hasstatus  = true
      $service_pattern    = $service_name
      $service_providers  = [ 'init' ]
      $defaults_location  = '/etc/sysconfig'
    }
    default: {
      fail("\"${module_name}\" provides no service parameters
            for \"${::operatingsystem}\"")
    }
  }

}
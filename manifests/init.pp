# Class: serf
#
# This module manages serf
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class serf (
  $version          = $::serf::params::version,
  $bind             = $::serf::params::bind,
  $advertise        = $::serf::params::advertise,
  $config_file      = $::serf::params::config_file,
  $config_dir       = $::serf::params::config_dir,
  $encrypt          = $::serf::params::encrypt,
  $event_handler    = $::serf::params::event_handler,
  $join             = $::serf::params::join,
  $log_level        = $::serf::params::log_level,
  $log_file         = $::serf::params::log_file,
  $node             = $::serf::params::node,
  $protocol         = $::serf::params::protocol,
  $role             = $::serf::params::role,
  $rpc_addr         = $::serf::params::rpc_addr,
  $install_url      = $::serf::params::install_url,
  $install_method   = $::serf::params::install_method,
  $sample_handler   = $::serf::params::sample_handler,
  $package_name     = $::serf::params::package_name,
  $package_ensure   = $::serf::params::package_ensure,
  $config_owner     = $::serf::params::config_owner,
  $config_group     = $::serf::params::config_group,
  $service_provider = 'init',
) inherits serf::params
{

  include install
  include config
  include service

  if is_array($serf::params::service_providers) {
    # Verify the service provider given is in the array
    if ! ($service_provider in $elasticsearch::params::service_providers) {
      fail("\"${service_provider}\" is not a valid provider for \"${::operatingsystem}\"")
    }
    $real_service_provider = $service_provider
  } else {
    # There is only one option so simply set it
    $real_service_provider = $elasticsearch::params::service_providers
  }

  Class['install'] ->
  Class['config'] ~>
  Class['service']

  if $sample_handler {
    include handler
    Class['handler'] ->
    Class['service']
  }
}

class serf::service{

  case $serf::real_service_provider {

    init: {
      serf::service::init { 'serf': }
    }
    systemd: {
      serf::service::systemd { 'serf': }
    }
    default: {
      fail("Unknown service provider ${serf::service_provider}")
    }
  }
}
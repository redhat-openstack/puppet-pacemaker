# == Class: pacemaker::params
#
# Description: <TODO>
#
# === Parameters
#
# None
#
# === Examples
#
#  include ::pacemaker::params
#
# === Copyright
#
#
#
class pacemaker::params {

  $hacluster_pwd         = 'CHANGEME'

  case $::osfamily {
    redhat: {
      if $::operatingsystemrelease =~ /^6\..*$/ {
        $package_list     = ['pacemaker', 'pcs', 'fence-agents', 'cman']
        # TODO in el6.6, $pcsd_mode should be true
        $pcsd_mode         = false
        $services_manager  = 'lsb'
        $config_file       = '/etc/cluster/cluster.conf'
        $enabled_check_cmd = '/usr/bin/false'
      } else {
        $package_list     = ['pacemaker', 'pcs', 'fence-agents-all']
        $pcsd_mode        = true
        $services_manager = 'systemd'
        $config_file      = '/etc/corosync/corosync.conf'
        $enabled_check_cmd = '/usr/bin/systemctl is-enabled corosync && /usr/bin/systemctl is-enabled pacemaker'
      }
      $service_name = 'pacemaker'
    }
    default: {
      fail("Unsupported platform: ${::osfamily}/${::operatingsystem}")
    }
  }
}

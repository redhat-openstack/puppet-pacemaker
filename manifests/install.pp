# == Class: pacemaker::install
#
# Description: Install the pacemaker packages
#
# === Parameters
#
# None
#
# === Examples
#
#  include ::pacemaker::install
#
# === Copyright
#
#
class pacemaker::install (
  $ensure = present,
) {

  if $ensure != present and $ensure != absent {
      fail('The only valid values for the ensure parameter are present or absent')
  }

  include pacemaker::params

  package { $pacemaker::params::package_list:
    ensure => $ensure,
  }
}

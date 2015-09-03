# == Define: pacemaker::constraint::location
#
# Description:
#
# === Parameters
#
# None
#
# === Examples
#
#
# === Copyright
#
#
define pacemaker::constraint::location (
$resource,
$location,
$score,
$ensure='present',
) {
  pcmk_constraint {"loc-${resource}-${location}":
    ensure          => $ensure,
    constraint_type => location,
    resource        => $resource,
    location        => $location,
    score           => $score,
    require         => Exec['wait-for-settle'],
  }
}

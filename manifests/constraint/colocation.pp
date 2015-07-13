# == Define: pacemaker::constraint::colocation
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
define pacemaker::constraint::colocation (
$source,
$target,
$score,
$ensure = present
) {
  pcmk_constraint {"colo-${source}-${target}":
    ensure          => $ensure,
    constraint_type => colocation,
    resource        => $source,
    location        => $target,
    score           => $score,
    require         => Exec['wait-for-settle'],
  }
}


define pacemaker::constraint::location_rule ($resource,
                                             $expression,
                                             $score,
                                             $resource_discovery='always',
                                             $ensure='present') {
    pcmk_constraint {"location-$resource-rule":
       constraint_type    => location_rule,
       resource           => $resource,
       expression         => $expression,
       score              => $score,
       resource_discovery => $resource_discovery,
       ensure             => $ensure,
       require => Exec["wait-for-settle"],
   }
}

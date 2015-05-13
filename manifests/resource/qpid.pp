class pacemaker::resource::qpid($name,
                                $cluster_name,
                                $clone=true,
                                $group='',
                                $interval="30s",
                                $stickiness=0,
                                $ensure=present) {

  package { "qpid-cpp-server-cluster":
    ensure => installed,
  }

  file_line { 'Set Qpid Cluster Name':
    path    => '/etc/puppet/puppet.conf',
    match   => '^[ ]*cluster_name=',
    line    => "cluster_name='${cluster_name}'",
  }

  augeas { "jbossas-datasource": 
    lens    => "Xml.lns", 
    incl    => "/etc/qpidd.conf", 
    changes => [ 
      "set uidgid[#attribute/uid='qpidd'] #empty", 
      "set uidgid[#attribute/gid='qpidd'] #empty", 
    ], 
    require => Package['qpid-cpp-server-cluster'],
  } 

  pacemaker::resource::base { "qpidd":
    resource_type   => "lsb:qpidd",
    resource_params => "",
    group           => $group,
    clone           => $clone,
    interval        => "30s",
    ensure          => $ensure,
  }

}

# Resource for fencing virtual machines with a call of virsh over qemu+ssh
define pacemaker::resource::fence_virsh( $name,
                                        $interval='30s',
                                        $ensure=present,
                                        $port=undef,       # the name of the vm
                                        $ipaddr=undef,     # the hostname or IP
                                        $action='reboot',
                                        $login=undef,
                                        $identity_file=undef,
                                        ) {
  if($ensure == absent) {
    exec { "Removing resource::fence_virsh ${name}":
      command => "/usr/sbin/pcs stonith delete fence_virsh-${name }",
      onlyif  => "/usr/sbin/pcs stonith show fence_virsh-${name} > /dev/null 2>&1",
      require => Class['pacemaker::corosync'],
    }
  } else {
    $port_chunk = $port ? {
      ''      => '',
      default => "port=${port}",
    }
    exec { "Creating resource::fence_virsh ${name}":
      command => "/usr/sbin/pcs stonith create fence_virsh-${name} fence_virsh action=${action} ipaddr=${ipaddr} login=${login} identity_file=${identity_file} ${port_chunk} op monitor interval=${interval}",
      unless  => "/usr/sbin/pcs stonith show fence_virsh-${name}  > /dev/null 2>&1",
      require => Class['pacemaker::corosync'],
    }
  }
}


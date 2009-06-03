class debian-updater {

  file { "/etc/debian-updater/":
    ensure => directory,
    mode   => 0755,
    owner  => root,
    group  => wheel,
  }

  file { "/etc/debian-updater/debian-updates":
    ensure  => present,
    source  => "puppet://$servername/debian-updater/debian-updates",
    require => File["/etc/debian-updater/"]
  }

  file { "/usr/local/sbin/package-installed":
    mode    => 755,
    owner   => root,
    group   => root,
    source  => "puppet://$servername/debian-updater/package-installed",
  }

  exec { "apt-get update && apt-get install --yes $( cat /etc/debian-updater/debian-updates | /usr/local/sbin/package-installed )":
    require     => File["/usr/local/sbin/package-installed"],
    subscribe   => File["/etc/debian-updater/debian-updates"],
    refreshonly => true
  }

}

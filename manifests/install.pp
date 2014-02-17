class leiningen::install($user, $version="2") {

  if $version == "2" {
    $executable_url = "https://raw.github.com/technomancy/leiningen/preview/bin/lein"
  }
  else {
    $executable_url = "https://github.com/technomancy/leiningen/raw/stable/bin/lein"
  }

  file { "/home/${user}/bin/lein": 
    mode => 0755,
    require => [Exec["download_leiningen"],
                File["/home/${user}/bin"]]
  }

  exec { "download_leiningen" :
    command => "/usr/bin/wget -q ${executable_url} -O /home/$user/bin/lein",
    creates => "/home/${user}/bin/lein",
    require => Package["wget"]
  }

  package { "wget":
    name   => "wget",
    ensure => present,
  }

  file { "/home/${user}/bin" :
    ensure => directory,
    owner => $user,
    group => $user,
    mode => '755',
    require => File["/etc/profile.d/local_bin_in_path.sh"],
  }

  file { "/etc/profile.d/local_bin_in_path.sh":
    ensure  => present,
    content => 'PATH=${PATH}:~/bin'
  }

}


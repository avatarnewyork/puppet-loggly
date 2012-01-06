##
# Loggly puppet module
#
# Tested Platforms:
# CentOS / Fedora
#
# Requirements:
# curl package
# CentOS requires EPEL package
# 
##

class rsyslog::install {
  $rsyslogpkg = $operatingsystem ? {
    Fedora => "rsyslog",
    CentOS => "rsyslog4",
    default => "rsyslog",
  }
  package {$rsyslogpkg :
    ensure => latest,
    alias => "rsyslog"
  }
  
  #Check if already exists??
  #package {"curl" :
  #  ensure => latest,
  #}
  # CentOS only??
  #package {"curl-devel" :
  #  ensure => latest,
  #}
  
}

class rsyslog::config {
  File {
    require => Class["rsyslog::install"],
    owner => "root",
    group => "root",
    mode => 644
  }

  $rsyslogd = "/etc/rsyslog.d"
  $rsyslogconf = "/etc/rsyslog.conf"
  
  file { $rsyslogd :
    ensure => directory,
  }
  
  file { $rsyslogconf :
    content => template("loggly/rsyslog.conf.erb"),
    notify => Class["rsyslog::service"],
  }
}

class rsyslog::service {
  service{"rsyslog" :
    ensure => running,
    enable => true,
    require => Class["rsyslog::install"]
  }
}

class rsyslog {
  File {
    owner => "root",
    group => "root",
    mode => 644
  }

  #$tmpl_tls = template("loggly/tls.erb")      
  include rsyslog::install, rsyslog::config, rsyslog::service

  define input($port,$username,$password,$inputid){
    file { "/etc/rsyslog.d/input_$port.conf" :
      content => template("loggly/input.conf.erb"),
      notify => [Class["rsyslog::service"],Exec["curl -X POST"]],
    }
    exec { "curl -X POST" :
      command => "curl -X POST -u '$username:$password' -F 'name=$hostname' http://avatarnewyork.loggly.com/api/inputs/$inputid/adddevice",
      cwd => "/usr/bin",
      path => "/usr/bin:/bin",
      refreshonly => true,
    }
  }

  define logfile($logname,$filepath,$severity='info'){
    file { "/etc/rsyslog.d/$logname.conf" :
      content => template("loggly/log.conf.erb"),
      notify => Class["rsyslog::service"],
    }
  }
  

  
}

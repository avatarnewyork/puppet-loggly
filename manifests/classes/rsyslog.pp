##
# Loggly puppet module
# Tested Platforms: CentOS 5.6
# Needs to be moved to rsyslog
##

class rsyslog::install {
  # require CentOS
  # require EPEL package
  package {"rsyslog4" :
    ensure => latest,
  }
  #Check if already exists??
  package {"curl" :
    ensure => latest,
  }
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

  define input($port,$username,$inputid){
    file { "/etc/rsyslog.d/input_$port.conf" :
      content => template("loggly/input.conf.erb"),
      notify => [Class["rsyslog::service"],Exec["curl -X POST"]],
    }
    exec { "curl -X POST" :
      command => "curl -X POST -u $username http://avatarnewyork.loggly.com/api/inputs/$inputid/adddevice",
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

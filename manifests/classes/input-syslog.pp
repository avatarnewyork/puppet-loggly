##
# Loggly puppet module
# Tested Platforms: CentOS 5.6
# Needs to be moved to rsyslog
##

class loggly::install {
  # require CentOS
  # require EPEL package
  package {"rsyslog4" :
    ensure => latest,
  }  
}

class loggly::config {
  File {
    require => Class["loggly::install"],
    owner => "root",
    group => "root",
    mode => 644
  }

  file {"/etc/rsyslog.conf" :
    content => template("loggly/rsyslog.conf.erb"),
    owner => "root",
    group => "root",
    mode => 644,
  }
}

class loggly::service {
  service{"rsyslog" :
    ensure => running,
    enable => true,
    require => Class["loggly::install"]
  }
}

class loggly {
  include loggly::install, loggly::config, loggly::service
}

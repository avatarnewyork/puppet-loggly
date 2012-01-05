class rsyslogtls::install inherits rsyslog::install{
  # require CentOS
  # require EPEL package
  package {"rsyslog4-gnutls" :
    ensure => latest,
  }
}
class rsyslogtls::config inherits rsyslog::config {  
  File {
    require => Class["rsyslogtls::install"],
    owner => "root",
    group => "root",
    mode => 644
  }

  $tlsconf = "tls.conf"
  
  file {"$rsyslogd/$tlsconf" :
    content => template("loggly/tls.conf.erb"),
    require => File[$rsyslogd],
    notify => Class["rsyslog::service"],
  }
}


class rsyslogtls inherits rsyslog {
  include rsyslogtls::install, rsyslogtls::config

}

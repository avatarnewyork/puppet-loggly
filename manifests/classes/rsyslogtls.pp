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
  $logglycrt = "/etc/loggly.com.crt"

  File[$rsyslogconf]{
    content => template("loggly/tls.conf.erb","loggly/rsyslog.conf.erb"),
  }
  
  #file {"$rsyslogd/$tlsconf" :
  #  content => template("loggly/tls.conf.erb"),
  #  require => File[$rsyslogd],
  #  notify => Class["rsyslog::service"],
  #}
  
  file {$logglycrt :
    source => "modules/loggly/loggly.com.crt"
  }
  
}


class rsyslogtls inherits rsyslog {
  include rsyslogtls::install, rsyslogtls::config

  
  
}

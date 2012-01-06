class rsyslogtls::install inherits rsyslog::install{
  $rsyslogtlspkg = $operatingsystem ? {
    Fedora => "rsyslog-gnutls",
    CentOS => "rsyslog4-gnutls",
    default => "rsyslog-gnutls"
  }
  package {$rsyslogtlspkg :
    ensure => latest,
    alias => "rsyslog-gnutls",
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
  
  file {$logglycrt :
    source => "modules/loggly/loggly.com.crt"
  }
  
}


class rsyslogtls inherits rsyslog {
  include rsyslogtls::install, rsyslogtls::config
}

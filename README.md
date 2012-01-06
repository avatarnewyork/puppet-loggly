#puppet-loggly

Puppet module for loggly.com

### Tested Platforms: 
* Fedora 13, 14 
* CentOS 5.6

### Supported Methods:
* rsyslog
* rsyslog with TLS (secure)

### Usage: 
1. Create an admin account to use on loggly (the account must have admin privs)
2. Create a new Syslog Server Input
3. Record the Port number (i.e. it would be 17605 for the line: "*.* @@logs.loggly.com:17605"
4. Record the input id (located either on the input page URL or in the setup - it would be 12314 in: "curl -X POST -u mruser http://avatarnewyork.loggly.com/api/inputs/12314/adddevice"
5. Create a client class or client code and include the class you wish to use:
 * rsyslog 
 * rsyslogtls (encrypted)
6. Create an input in puppet (see example below)
7. Add log files in puppet (see example below)


### Example:

	class client {
	  include rsyslogtls
	
	  rsyslog::input { "rsyslogtls":
	    port => 17605,
	    username => "puppetmaster",
	    password => "asdfkajsdf",
	    inputid => 12314,
	  }
	
	  rsyslog::logfile { "testing-access":
	    logname => "testing-access",
	    filepath => "/var/log/httpd/www.testing.com-access.log"
	  }
	  rsyslog::logfile { "testing-error":
	    logname => "testing-error",
	    filepath => "/var/log/httpd/www.testing.com-error.log"
	  }
	  rsyslog::logfile { "apache-error":
	    logname => "apache-error",
	    filepath => "/var/log/httpd/error.log"
	  }
	  rsyslog::logfile { "mysql":
	    logname => "mysql",
	    filepath => "/var/log/mysqld.log"
	  }  
	}
	

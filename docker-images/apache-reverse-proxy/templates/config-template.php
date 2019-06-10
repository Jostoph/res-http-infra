<?php
/**
 * This file holds the configuration of IPs
 * @author Rueff Christoph, Póvoa Tiago
 */
    $dynamic_app = getenv('DYNAMIC_APP');
    $static_app = getenv('STATIC_APP');
?>

<VirtualHost *:80>
    ServerName demo.res.ch

    # Because of the way the Image is created, this variable
    # has no value yet. So it would make an error
    # ErrorLog ${APACHE_LOG_DIR}/error.log
    # CustomLog ${APACHE_LOG_DIR}/access.log combined

    ProxyPass '/api/animals/' 'http://<?php print "$dynamic_app"?>/'
    ProxyPassReverse '/api/students/' 'http://<?php print "$dynamic_app"?>/'

    ProxyPass '/' 'http://<?php print "$static_app"?>/'
    ProxyPassReverse '/' 'http://<?php print "$static_app"?>/'

</VirtualHost>
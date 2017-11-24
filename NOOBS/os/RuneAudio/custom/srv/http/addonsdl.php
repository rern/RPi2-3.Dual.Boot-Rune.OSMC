<?php
exec( '/srv/http/addonsdl.sh', $output, $exit ); // no sudo here
// clear cache must be before echo
opcache_reset();
echo $exit;

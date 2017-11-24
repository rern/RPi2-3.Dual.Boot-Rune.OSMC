<?php
exec( '/srv/http/addonsdl.sh', $output, $exit );
// clear cache must be before echo
opcache_reset();
echo $exit;

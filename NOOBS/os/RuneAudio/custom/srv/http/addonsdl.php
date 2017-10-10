<?php
exec( '/usr/bin/sudo /srv/http/addonsdl.sh', $output, $exit );

echo $exit;

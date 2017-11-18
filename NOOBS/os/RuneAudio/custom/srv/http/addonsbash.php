<?php require_once( 'addonshead.php' );?>
<!-- ...................................................................................... -->
<script>
// hide <pre> vertical scrollbar on desktop
var div = document.createElement('div');
div.style.cssText = 
	'width: 100px;'
	+'msOverflowStyle: scrollbar;'
	+'overflow: scroll;'
	+'visibility: hidden;'
	;
document.body.appendChild(div);
var scrollbarWidth = div.offsetWidth - div.clientWidth;
document.body.removeChild(div);

if (scrollbarWidth !== 0) {
	var css = 
		'.hidescrollv {\n'
		+'	width: 100%;\n'
		+'	overflow: hidden;\n'
		+'}\n'
		+'pre {\n'
		+'	width: calc(100% + '+ ( scrollbarWidth + 1 ) +'px);\n'
		+'}';
	var style = document.createElement('style');
	style.appendChild(document.createTextNode(css));
	document.head.appendChild(style);
}

// js for '<pre>' must be here before 'function bash()'.
// php 'flush' loop waits for all outputs before going to next lines.
// but must 'setTimeout()' for '<pre>' to load to fix 'undefined'.
setTimeout( function() {
	pre = document.getElementsByTagName( 'pre' )[ 0 ];
	var h0 = pre.scrollHeight;
	var h1;
	intscroll = setInterval( function() {
		h1 = pre.scrollHeight;
		if ( h1 > h0 ) {
			pre.scrollTop = pre.scrollHeight;
			h0 = h1;
		}
	}, 1000 );
}, 1000 );
</script>

<!-- php 'flush' on uninstall 'addo', addonsinfo.js file will be gone if put below 'flush' -->
<script src="assets/js/vendor/jquery-2.1.0.min.js"></script>
<script src="assets/js/addonsinfo.js"></script>

<div class="container">
	
	<h1>ADDONS TERMINAL</h1><a id="close"><i class="fa fa-times fa-2x disabled"></i></a>
	<legend class="bl">Please wait until finished...</legend>

	<div class="hidescrollv">
	<pre>
<!-- ...................................................................................... -->
<?php
$alias = $_POST[ 'alias' ];
$type = $_POST[ 'type' ];
$opt = $_POST[ 'opt' ];
$dash = round( $_POST[ 'prewidth' ] / 7.55 );
$addon = $GLOBALS[ 'addons' ][ $alias ];
$installurl = $addon[ 'installurl' ];

$optarray = explode( ' ', $opt );
if ( end( $optarray ) === '-b' ) $installurl = str_replace( 'raw/master', 'raw/'.prev( $optarray ), $installurl );

$installfile = basename( $installurl );
$title = preg_replace( '/\s*\*$/', '', $addon[ 'title' ] );

$install = <<<cmd
	wget -qN $installurl 
	if [[ $? != 0 ]]; then
		systemctl stop ntpd
		ntpdate pool.ntp.org
		systemctl start ntpd
		if [[ $? != 0 ]]; then 
			echo -e '\e[38;5;7m\e[48;5;1m ! \e[0m Install file download failed.'
			echo 'Please try again.'
			exit
		fi
	fi
	chmod 755 $installfile
	/usr/bin/sudo ./$installfile $opt
cmd;
$uninstall = <<<cmd
	/usr/bin/sudo /usr/local/bin/uninstall_$alias.sh
cmd;

if ( $type === 'Uninstall' ) {
	$command = $uninstall;
	$commandtxt = "uninstall_$alias.sh";
} else if ( $type === 'Update' ) {
	$command = <<<cmd
		wget -qN $installurl
		if [[ $? != 0 ]]; then 
			echo -e '\e[38;5;7m\e[48;5;1m ! \e[0m Install file download failed.'
			echo 'Please try again.'
			exit
		fi
		chmod 755 $installfile
		
		$uninstall u
		
		/usr/bin/sudo ./$installfile u $opt
cmd;
	$commandtxt = <<<cmd
		wget -qN $installurl
		chmod 755 $installfile
		
		uninstall_$alias.sh u
		
		/usr/bin/sudo ./$installfile u $opt
cmd;
} else {
	if ( $alias !== 'bash' ) {
		$command = $install;
		$commandtxt = <<<cmd
			wget -qN $installurl
			chmod 755 $installfile
			./$installfile
cmd;
	} else {
		$command = '/usr/bin/sudo '.$opt;
		$commandtxt = str_replace( '/usr/bin/', '', $opt );
		$commandtxt = preg_replace( '/;\s*/', "\n", $commandtxt );
		$commandtxt .= '<br><br><a class="ck">'.str_repeat( '=', $dash ).'</a>';
	}
}
$commandtxt = preg_replace( '/\t*/', '', $commandtxt );

// if uninstall only - css file will be gone
if ( $alias === 'addo' && $type !== 'Update' ) {
	echo '<style>';
	require_once( 'assets/css/addons.css' );
	require_once( 'assets/css/addonsinfo.css' );
	echo '</style>';
	$close = '/';
} else {
	$close = 'addons.php';
}

echo $commandtxt.'<br>';

// for convert bash stdout to html
$replace = array(
	'/=(=+)=/'               => str_repeat( '=', $dash ), // fit line to width
	'/-(-+)-/'               => str_repeat( '-', $dash ), // fit line to width
	'/.\[38;5;6m.\[48;5;6m/' => '<a class="cc">',         // bar
	'/.\[38;5;0m.\[48;5;3m/' => '<a class="ky">',         // info, yesno
	'/.\[38;5;7m.\[48;5;1m/' => '<a class="wr">',         // warn
	'/.\[38;5;6m.\[48;5;0m/' => '<a class="ck">',         // tcolor
	'/.\[38;5;6m/'           => '<a class="ck">',         // lcolor
	'/.\[0m/'                => '</a>',                   // reset color
);
$skip = array( 'warning:', 'y/n', 'uninstall:' );

ob_implicit_flush(); // start flush: bypass buffer - output to screen
ob_end_flush();      // force flush: current buffer (run after flush started)
	
$popencmd = popen( "$command 2>&1", 'r' );                // start bash
while ( !feof( $popencmd ) ) {                            // each line
	$std = fread( $popencmd, 4096 );                      // read

	$std = preg_replace(                                  // convert to html
		array_keys( $replace ),
		array_values( $replace ),
		$std
	);
	foreach( $skip as $find ) {                           // skip line
		if ( stripos( $std, $find ) !== false ) continue 2;
	}

	echo $std;                                            // stdout to screen
}
pclose( $popencmd );                                      // end bash
?>
<!-- ...................................................................................... -->
	</pre>
	</div>
</div>

<script>
	setTimeout( function() {
		clearInterval( intscroll );
		pre.scrollTop = pre.scrollHeight;
		document.getElementsByTagName( 'legend' )[ 0 ].innerHTML = '&nbsp;';
		var close = document.getElementById( 'close' );
		close.children[ 0 ].classList.remove( 'disabled' );
		close.href = '<?=$close;?>';
		
		if ( '<?=$alias;?>' === 'bash' ) return;
		info( {
			icon:    '<i class="fa fa-info-circle fa-2x">',
			title:   '<?=$title;?>',
			message: 'Please see result information on screen.',
		} );
	}, 1000 );
</script>

</body>
</html>
<!-- ...................................................................................... -->
<?php
opcache_reset();
?>

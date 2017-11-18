<?php
require_once( 'addonshead.php' );

$GLOBALS[ 'available' ] = round( disk_free_space( '/' ) / 1024 / 1024 );
$expandable = round( shell_exec( '/usr/bin/sudo /usr/bin/sfdisk -F | grep mmc | cut -d " " -f6' ) / 1024 / 1024 );
$GLOBALS[ 'expandable' ] = $expandable > 10 ? ' (expandable: '.number_format( $expandable ).' MB)' : '';
// -------------------------------------------------------------------------------------------------
echo '
	<div class="container">
	<h1>ADDONS</h1><a id="close" href="/"><i class="fa fa-times fa-2x"></i></a>
	<legend class="bl">available space: '.number_format( $available ).' MB'.$expandable.'</legend>
	<a id="issues" href="http://www.runeaudio.com/forum/addons-menu-install-addons-the-easy-way-t5370-1000.html" target="_blank">
			issues&ensp;<i class="fa fa-external-link"></i>
	</a>
';
// -------------------------------------------------------------------------------------------------
$redis = new Redis(); 
$redis->pconnect( '127.0.0.1' );

if ( $expandable ) {
	$redis->hDel( 'addons', 'expa' );
}else {
	$redis->hSet( 'addons', 'expa', '1' );
}

$GLOBALS[ 'release' ] = $redis->get( 'release' );
$GLOBALS[ 'redis' ] = $redis->hGetAll( 'addons' );
$GLOBALS[ 'list' ] = '';
$GLOBALS[ 'blocks' ] = '';

// sort
$arraytitle = array_column( $addons, 'title' );
$addoindex = array_search( 'Addons Menu', $arraytitle );
$arraytitle[ $addoindex ] = 0;
array_multisort( $arraytitle, SORT_NATURAL | SORT_FLAG_CASE, $addons );
//$arraytitle[ $addoindex ] = 'Addons Menu';
$arrayalias = array_keys( $addons );

foreach( $arrayalias as $alias ) {
	addonblock( $alias );
}
// -------------------------------------------------------------------------------------------------
echo '
	<ul id="list">'.
		$list.'
	</ul>
	<br>
';
echo $blocks;
// -------------------------------------------------------------------------------------------------
function addonblock( $alias ) {
	$addon = $GLOBALS[ 'addons' ][ $alias ];
	if ( $GLOBALS[ 'release' ] == '0.4b' && isset( $addon[ 'only03' ] ) ) return;
	
	$thumbnail = isset( $addon[ 'thumbnail' ] ) ? $addon[ 'thumbnail' ] : '';
	$buttonlabel = isset( $addon[ 'buttonlabel' ]) ? $addon[ 'buttonlabel' ] : 'Install';
	
	if ( $GLOBALS[ 'redis' ][ $alias ] || file_exists( "/usr/local/bin/uninstall_$alias.sh" ) ) {
		$check = '<i class="fa fa-check"></i> ';
		if ( !isset( $addon[ 'version' ] ) 
			|| $addon[ 'version' ] == $GLOBALS[ 'redis' ][ $alias ] ) {
			// !!! mobile browsers: <button>s submit 'formtemp' with 'get' > 'failed', use <a> instead
			$btnin = '<a class="btn btn-default disabled"><i class="fa fa-check"></i> '.$buttonlabel.'</a>';
		} else {
			$check = '<i class="fa fa-refresh"></i> ';
			$btnin = '<a class="btn btn-primary"><i class="fa fa-refresh"></i> Update</a>';
		}
		$btnun = '<a class="btn btn-default btnbranch"><i class="fa fa-close"></i> Uninstall</a>';
	} else {
		$check = '';
		$needspace = isset( $addon[ 'needspace' ] ) ? $addon[ 'needspace' ] : 1;
		if ( $needspace < $GLOBALS[ 'available' ] ) {
			$btninclass =  'btnbranch';
			$btninattr = '';
		} else {
			$btninclass = 'btnneedspace';
			$btninattr = ' diskspace="Need: '.number_format( $needspace ).' MB - Available: '.number_format( $GLOBALS[ 'available' ] ).' MB<br>'
				.$GLOBALS[ 'expandable' ].'"';
		}
		$btnin = '<a class="btn btn-default '.$btninclass.'"'.$btninattr.'><i class="fa fa-check"></i> '.$buttonlabel.'</a>';
		$btnun = '<a class="btn btn-default disabled"><i class="fa fa-close"></i> Uninstall</a>';
	}
	
	// addon list ---------------------------------------------------------------
	$title = $addon[ 'title' ];
	// hide Addons Menu in list
	if ( $alias !== 'addo' ) {
		$listtitle = preg_replace( '/\*$/', ' <a>●</a>', $title );
		$GLOBALS[ 'list' ] .= '<li alias="'.$alias.'" title="Go to this addon">'.$check.$listtitle.'</li>';
	}
	// addon blocks -------------------------------------------------------------
	$version = isset( $addon[ 'version' ] ) ? $addon[ 'version' ] : '';
	$revisionclass = $version ? 'revision' : 'revisionnone';
	$revision = '<li>'.str_replace( '<br>', '</li><li>', $addon[ 'revision' ] ).'</li>';
	$sourcecode = $addon[ 'sourcecode' ];
	if ( $sourcecode ) {
		$detail = ' <a href="'.$sourcecode.'" target="_blank">&emsp;detail &nbsp;<i class="fa fa-external-link"></i></a>';
	} else {
		$detail = '';
	}
	$GLOBALS[ 'blocks' ] .= '
		<div id="'.$alias.'" class="boxed-group">';
	if ( $thumbnail ) $GLOBALS[ 'blocks' ] .= '
		<div style="float: left; width: calc( 100% - 110px);">';
	$GLOBALS[ 'blocks' ] .= '
			<legend title="Back to top">'
				.$check.'<span>'.preg_replace( '/\s*\*$/', '', $title ).'</span>
				&emsp;<p><a class="'.$revisionclass.'">'.$version.'</a>
				&ensp;by<white>&ensp;'.$addon[ 'maintainer' ].'</white></p>
			</legend>
			<ul style="display: none;">'
				.$revision.'
			</ul>
			<form class="form-horizontal" alias="'.$alias.'">
				<p>'.$addon[ 'description' ].$detail.'</p>'
				.$btnin; if ( $version ) $GLOBALS[ 'blocks' ] .= ' &nbsp; '.$btnun;
	$GLOBALS[ 'blocks' ] .= '
			</form>';
	if ( $thumbnail ) $GLOBALS[ 'blocks' ] .= '
		</div>
		<img src="'.$thumbnail.'" class="thumbnail">
		<div style="clear: both;"></div>';
	$GLOBALS[ 'blocks' ] .= '
		</div>';
}
// -------------------------------------------------------------------------------------------------
?>
</div>
<div id="bottom"></div>

<script>
addons = JSON.parse( '<?php echo json_encode( $GLOBALS[ 'addons' ] );?>' );
</script>
<script src="assets/js/vendor/jquery-2.1.0.min.js"></script>
<script src="assets/js/vendor/hammer.min.js"></script>
<script src="assets/js/addonsinfo.js"></script>
<script src="assets/js/addons.js"></script>
<script src="assets/js/vendor/bootstrap.min.js"></script>
<script src="assets/js/vendor/bootstrap-select.min.js"></script>

</body>
</html>

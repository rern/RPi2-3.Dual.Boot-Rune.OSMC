<?php
require_once( 'addonshead.php' );
// -------------------------------------------------------------------------------------------------
$indexaddo = array_search( 'addo', array_column( $addons, 'alias' ) );
$addonsversion = $addons[ $indexaddo ][ 'version' ];
echo '
	<div class="container">
	<h1>ADDONS</h1><a id="close" href="/"><i class="fa fa-times fa-2x"></i></a>
	<legend>
		<a id="revision"><white>'.$addonsversion.'</white>&ensp;revision</a>
		<a href="http://www.runeaudio.com/forum/addons-menu-install-addons-the-easy-way-t5370-1000.html" target="_blank">
			issues&ensp;<i class="fa fa-external-link"></i>
		</a><br>
		
		<div  id="detail" style="display: none;">
			<ul>'
				.$revision.'
			</ul>
			<a href="https://github.com/rern/RuneAudio_Addons/blob/master/changelog.md" target="_blank">
				changelog&ensp;<i class="fa fa-external-link"></i>
			</a><br>
			<br>
		</div>
	</legend>
';
// -------------------------------------------------------------------------------------------------
$redis = new Redis(); 
$redis->pconnect( '127.0.0.1' );

$GLOBALS[ 'redis' ] = $redis->hGetAll( 'addons' );
$GLOBALS[ 'list' ] = '';
$GLOBALS[ 'blocks' ] = '';

// sort
$arraytitle = array_column( $addons, 'title' );
$arraytitle[ 0 ] = 0;
array_multisort( $arraytitle, SORT_NATURAL | SORT_FLAG_CASE, $addons );
$arraytitle[ 0 ] = 'Addons Menu';

$length = count( $addons );
for ( $i = 0; $i < $length; $i++ ) {
	addonblock( $addons[ $i ] );
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
function addonblock( $addon ) {
	$thumbnail = isset( $addon[ 'thumbnail' ] ) ? $addon[ 'thumbnail' ] : '';
	$buttonlabel = isset( $addon[ 'buttonlabel' ]) ? $addon[ 'buttonlabel' ] : 'Install';
	$alias = $addon[ 'alias' ];
	
	if ( $GLOBALS[ 'redis' ][ $alias ] || file_exists( "/usr/local/bin/uninstall_$alias.sh" ) ) {
		$check = '<i class="fa fa-check"></i> ';
		if ( !isset( $addon[ 'version' ] ) || $addon[ 'version' ] == $GLOBALS[ 'redis' ][ $alias ] ) {
			// !!! mobile browsers: <button>s submit 'formtemp' with 'get' > 'failed', use <a> instead
			$btnin = '<a class="btn btn-default disabled"><i class="fa fa-check"></i> '.$buttonlabel.'</a>';
		} else {
			$btnin = '<a class="btn btn-primary"><i class="fa fa-refresh"></i> Update</a>';
		}
		$btnun = '<a class="btn btn-default btnun"><i class="fa fa-close"></i> Uninstall</a>';
	} else {
		if ( isset( $addon[ 'option' ])) {
			$addonoption = preg_replace( '/\n|\t/', '', $addon[ 'option' ] );
			$addonoption = htmlspecialchars( $addonoption );
			$option = 'option="'.$addonoption.'"';
		} else {
			$option = '';
		}
		$check = '';
		$btnin = '<a class="btn btn-default" '.$option.'><i class="fa fa-check"></i> '.$buttonlabel.'</a>';
		$btnun = '<a class="btn btn-default disabled"><i class="fa fa-close"></i> Uninstall</a>';
	}
	
	// addon list ---------------------------------------------------------------
	$title = $addon[ 'title' ];
	// hide Addons Menu in list
	if ( $alias !== 'addo' ) {
		$listtitle = preg_replace( '/\*$/', ' <a>●</a>', $title );
		$GLOBALS[ 'list' ] .= '<li alias="'.$alias.'" title="Go to this addon">'.$listtitle.'</li>';
	}
	// addon blocks -------------------------------------------------------------
	$version = isset( $addon[ 'version' ] ) ? $addon[ 'version' ] : '';
	$detail = ' <a href="'.$addon[ 'sourcecode' ].'" target="_blank">&emsp;detail &nbsp;<i class="fa fa-external-link"></i></a>';
	if ( !$addon[ 'sourcecode' ] ) $detail = '';
	$GLOBALS[ 'blocks' ] .= '
		<div id="'.$alias.'" class="boxed-group">';
	if ( $thumbnail ) $GLOBALS[ 'blocks' ] .= '
		<div style="float: left; width: calc( 100% - 110px);">';
	$GLOBALS[ 'blocks' ] .= '
			<legend title="Back to top">'.$check.'<span>'.strip_tags( preg_replace( '/\s*\*$/', '', $title ) ).'</span>&emsp;<p>'.$version.'&ensp;●&ensp;by<white>&ensp;'.strip_tags( $addon[ 'maintainer' ] ).'</white></p></legend>
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

<script src="assets/js/vendor/jquery-2.1.0.min.js"></script>
<script src="assets/js/vendor/hammer.min.js"></script>
<script src="assets/js/addonsinfo.js"></script>
<script src="assets/js/addons.js"></script>
<script src="assets/js/vendor/bootstrap.min.js"></script>
<script src="assets/js/vendor/bootstrap-select.min.js"></script>

</body>
</html>

$( '#addons' ).click( function () {
	// fix path if click in other menu pages
	var path = /\/.*\//.test( location.pathname ) ? '../../' : '';
	
	$( '#loadercontent' ).html( '<i class="fa fa-gear fa-spin"></i>Installing...' );
	$( '#loader' ).removeClass( 'hide' );
	
	$.get(
		path +'addonsdl.php',
		function( exit ) {
			if ( exit == 1 ) {
				alert( "Download from Addons server failed.\nPlease try again later." );
				$( '#loader' ).addClass( 'hide' );
				$( '#loadercontent' ).html( '<i class="fa fa-refresh fa-spin"></i>connecting...' );
			} else {
				location.href = path +'addons.php';
			}
		}
	);
} );

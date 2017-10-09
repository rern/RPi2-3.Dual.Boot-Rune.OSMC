$( '#addons' ).click( function () {
	// fix path if click in other menu pages
	var path = /\/.*\//.test( location.pathname ) ? '../../' : '';
	
	$( '#loadercontent' ).html( '<i class="fa fa-gear fa-spin"></i>Installing...' );
	$( '#loader' ).removeClass( 'hide' );
	
	$.get(
		path +'addonsdl.php',
		function( exit ) {
			addonsdl( exit, path );
		}
	);
} );

function addonsdl( exit, path ) {
	if ( exit != 0 ) {
		var error = ( exit == 5 ) ? 'Addons server CA-certficate error.' : 'Download from Addons server failed.';
		
		info( {
			icon   : '<i class="fa fa-info-circle fa-2x">',
			message: error
				+'<br>Please try again later.',
			ok     : function() {
				$( '#loader' ).addClass( 'hide' );
				$( '#loadercontent' ).html( '<i class="fa fa-refresh fa-spin"></i>connecting...' );
			}
		} );
	} else {
		location.href = path +'addons.php';
	}
}

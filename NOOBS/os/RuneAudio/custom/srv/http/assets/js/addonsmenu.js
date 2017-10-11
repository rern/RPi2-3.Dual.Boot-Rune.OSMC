$( '#addons' ).click( function () {
	// fix path if click in other menu pages
	var path = /\/.*\//.test( location.pathname ) ? '../../' : '';
	
	$( '#loadercontent' ).html( '<i class="fa fa-gear fa-spin"></i>Installing...' );
	$( '#loader' ).removeClass( 'hide' );
	
	$.get(
		path +'addonsdl.php',
		function( exit ) {
			if ( exit == 5 ) {
				$.get(
					path +'addonsdl.php',
					function( exit ) {
						addonsdl( exit, path );
					}
				);
			} else {
				addonsdl( exit, path );
			}
		}
	);
} );

function addonsdl( exit, path ) {
	if ( exit == 1 ) {
		info( {
			icon   : '<i class="fa fa-info-circle fa-2x">',
			message: 'Download from Addons server failed.'
				+'<br>Please try again later.',
			ok     : function() {
				$( '#loader' ).addClass( 'hide' );
			}
		} );
	} else {
		location.href = path +'addons.php';
	}
}

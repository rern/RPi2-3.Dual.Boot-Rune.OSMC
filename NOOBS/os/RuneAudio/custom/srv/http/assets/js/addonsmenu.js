$( '#addons' ).click( function () {
	$( '#loadercontent' ).html( '<i class="fa fa-gear fa-spin"></i>Installing...' );
	$( '#loader' ).removeClass( 'hide' );
	
	$.get( '/addonsdl.php', function( exit ) {
		if ( exit == 8 ) {
			info( {
				icon   : '<i class="fa fa-info-circle fa-2x">',
				message: 'Download from Addons server failed.'
					+'<br>Please try again later.',
				ok     : function() {
					$( '#loader' ).addClass( 'hide' );
				}
			} );
		} else {
			location.href = '/addons.php';
		}
	} );
} );

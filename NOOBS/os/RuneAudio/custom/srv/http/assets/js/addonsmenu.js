$( '#addons' ).click( function () {
	// fix path if click in other menu pages
	var path = /\/.*\//.test( location.pathname ) ? '../../' : '';
	
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
				+'<br>Please try again later.' 
		} );
		$( '#loader' ).addClass( 'hide' );
	} else {
		location.href = path +'addons.php';
	}
}

// nginx pushstream websocket
var pushstreamAddons = new PushStream( {
	host: window.location.hostname,
	port: window.location.port,
	modes: GUI.mode
} );
pushstreamAddons.onmessage = function( update ) {
	if ( update == 1 && !$( '#loader' ).hasClass( 'hide' ) ) {
		$( '#loadercontent' ).html( '<i class="fa fa-gear fa-spin"></i>Updating...' );
	}
}
pushstreamAddons.addChannel('addons');
pushstreamAddons.connect();

var hammeraddons = new Hammer( $( '#addons' )[ 0 ] );
hammeraddons.on( 'tap', function () {
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

// for branch testing
hammeraddons.on( 'press', function () {
	var path = /\/.*\//.test( location.pathname ) ? '../../' : '';
	
	info( {
		title    : 'Addons Menu Branch Test',
		textlabel: 'Branch',
		textvalue: 'UPDATE',
		cancel   : function() {
			$( '#loader' ).addClass( 'hide' );
		},
		ok       : function() {
			var branch = $( '#infoTextbox' ).val();
			$( '#loader' ).removeClass( 'hide' );
			if ( branch ) {
				$.get(
					path +'addonsdl.php?branch='+ branch,
					function( exit ) {
						addonsdl( exit, path );
					}
				);
			}
		}
	} );
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

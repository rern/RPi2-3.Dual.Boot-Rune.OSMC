var hammeraddons = new Hammer( $( '#addons' )[ 0 ] );
hammeraddons.on( 'tap', function () {
	// fix path if click in other menu pages
	var path = /\/.*\//.test( location.pathname ) ? '../../' : '';
	
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

// for branch testing
hammeraddons.on( 'press', function () {
	var path = /\/.*\//.test( location.pathname ) ? '../../' : '';
	
	info( {
		  title    : 'Addons Menu Branch Test'
		, textlabel: 'Branch'
		, textvalue: 'UPDATE'
		, cancel   : 1
		, ok       : function() {
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
	if ( exit == 1 ) {
		info( {
			  icon   : '<i class="fa fa-info-circle fa-2x">'
			, message: 'Download from Addons server failed.'
				+'<br>Please try again later.'
			, ok     : function() {
				$( '#loader' ).addClass( 'hide' );
			}
		} );
	} else if ( exit == 2 ) {
		info( {
			  icon   : '<i class="fa fa-info-circle fa-2x">'
			, message: 'Addons Menu cannot be updated.'
				+'<br>Root partition has <white>less than 1 MB free space</white>.'
			, ok     : function() {
				$( '#loader' ).addClass( 'hide' );
				location.href = path +'addons.php';
			}
		} );
	} else {
		PNotify.removeAll();
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
	var txt = ( update == 1 ) ? 'Updating...' : 'Sync Time...';
	$( '#loadercontent' ).html( '<i class="fa fa-gear fa-spin"></i>'+ txt );
};
pushstreamAddons.addChannel('addons');
pushstreamAddons.connect();

// remove previous before new notify
var old_renderMSG = renderMSG;
renderMSG = function( text ) {
	PNotify.removeAll();
	old_renderMSG( text );
}

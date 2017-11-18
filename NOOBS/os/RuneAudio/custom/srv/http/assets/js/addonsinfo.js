$( 'body' ).prepend( '\
<div id="infoOverlay">\
	<div id="infoBox">\
		<div id="infoTopBg">\
			<div id="infoTop">\
				<a id="infoIcon"></a>&emsp;<a id="infoTitle"></a>\
			</div>\
			<div id="infoX"><i class="fa fa-times fa-2x"></i></div>\
			<div style="clear: both"></div>\
		</div>\
		<div id="infoContent">\
			<p id="infoMessage" class="info"></p>\
			<div id="infoText" class="info">\
				<a id="infoTextLabel"></a><input type="text" class="infoBox" id="infoTextbox" spellcheck="false">\
			</div>\
			<div id="infoPassword" class="info">\
				<a id="infoPasswordLabel"></a> <input type="password" class="infoBox" id="infoPasswordbox">\
			</div>\
			<div id="infoRadio" class="info"></div>\
			<div id="infoCheckbox" class="info"></div>\
			<div id="infoSelect" class="info">\
				<a id="infoSelectLabel"></a><select class="infoBox" id="infoSelectbox"></select>\
			</div>\
		</div>\
		<div id="infoButtons">\
			<a id="infoCancel" class="btn btn-default"></a>\
			<a id="infoOk" class="btn btn-primary"></a>\
		</div>\
	</div>\
</div>\
' );

function info( option ) {
	// reset to default
	$( '#infoIcon' ).html( '<i class="fa fa-question-circle fa-2x">' );
	$( '#infoTitle' ).html( 'Information' );
	$( '#infoTextLabel, #infoPasswordLabel, #infoSelectLabel' ).empty();
	$( '#infoRadio, #infoCheckbox, #infoSelectbox' ).empty();
	$( '.infoBox' ).width( 200 ).val('');
	$( '.info, #infoCancel' ).hide();
	$( '#infoOk' ).html( 'Ok' );
	$( '#infoCancel' ).html( 'Cancel' );
	$( 'body' ).unbind( 'keypress' );

	// simple use as info('message')
	if ( typeof option != 'object' ) {
		$( '#infoOk' ).off( 'click' ).on( 'click', function () {
			$( '#infoOverlay' ).hide();
		});
		$( '#infoMessage' ).html( option ).show();
	} else {
		// option use as info({x: 'x', y: 'y'})
		var icon = option.icon;
		var title = option.title;
		var message = option.message;
		var textlabel = option.textlabel;
		var textvalue = option.textvalue;
		var passwordlabel = option.passwordlabel;
		var radiohtml = option.radiohtml;
		var checkboxhtml = option.checkboxhtml;
		var selectlabel = option.selectlabel;
		var selecthtml = option.selecthtml;
		var boxwidth = option.boxwidth;
		var ok = option.ok;
		var oklabel = option.oklabel;
		var okcolor = option.okcolor;
		var cancel = option.cancel;
		var cancellabel = option.cancellabel;
		
		if ( icon ) $( '#infoIcon' ).html( icon );
		if ( title ) $( '#infoTitle' ).html( title );
		if ( message ) {
			$( '#infoMessage' ).html( message ).show();
		}
		if ( textlabel ) {
			$( '#infoTextLabel' ).html( textlabel +' ' );
			$( '#infoTextbox' ).val( textvalue );
			$( '#infoText' ).show();
			var $infofocus = $( '#infoTextbox' );
			if ( textvalue ) $( '#infoTextbox' ).select();
		}
		if ( passwordlabel ) {
			$( '#infoPasswordLabel' ).html( passwordlabel +' ' );
			$( '#infoPassword' ).show().focus();
			var $infofocus = $( '#infoPasswordbox' );
		}
		if ( radiohtml ) setboxwidth( $( '#infoRadio' ), radiohtml );
		if ( checkboxhtml ) setboxwidth( $( '#infoCheckbox' ), checkboxhtml );
		if ( selecthtml ) {
			$( '#infoSelectLabel' ).html( selectlabel +' ' );
			$( '#infoSelectbox' ).html( selecthtml );
			$( '#infoSelect' ).show();
		}
		if ( boxwidth ) $( '.infoBox' ).width( boxwidth );
		
		if ( oklabel ) $( '#infoOk' ).html( oklabel );
		if ( okcolor ) $( '#infoOk' ).css( 'background', okcolor );
		if ( cancel ) {
			$( '#infoCancel' ).show();
			$( '#infoCancel' ).off( 'click' ).on( 'click', function() {
				$( '#infoOverlay' ).hide();
				if ( typeof cancel === 'function' ) cancel();
			});
		}
		if ( cancellabel ) $( '#infoCancel' ).html( cancellabel );
	}
	
	$( '#infoOverlay' ).show();
	if ( $infofocus ) $infofocus.focus();
	
	$( '#infoOk' ).off( 'click' ).on( 'click', function() {
		$('#infoOverlay').hide();
		if (ok && typeof ok === 'function') ok();
	} );
	$( 'body' ).keypress( function( e ) {
		if ( $( '#infoOverlay' ).is( ':visible' ) && e.which == 13 ) $( '#infoOk' ).click();
	} );
	$( '#infoX' ).click( function() {
		$( '#infoCancel' ).click();
		$( '#infoOverlay' ).hide();
		$( '#infoTextbox, #infoPasswordbox' ).val( '' );
	} );
}

function setboxwidth( $box, html ) {
	var contentW = $( '#infoBox' ).width();
	var maxW = 0;
	var spanW = 0;
	$( '#infoBox' ).css('left', '-100%' );      // move out of screen
	$box.html( html ).show();                   // show to get width
	setTimeout( function() {                    // wait for radiohtml ready
		$box.find( 'label' ).each( function() { // get max width
				spanW = $( this ).width();
				maxW = ( spanW > maxW ) ? spanW : maxW;
		} );
		var pad = ( contentW - 20 - maxW ) / 2; // 15 = button width
		$box.css('padding-left', pad +'px');    // set padding-left
		$( '#infoBox' ).css('left', '50%' );    // move back
	}, 100);
}
function verifypassword( msg, pwd, fn ) {
	$( '#infoPasswordbox' ).val( '' );
	info( {
		message:     msg,
		passwordlabel: 'Retype password',
		ok:          function() {
			if ( $( '#infoPasswordbox' ).val() !== pwd ) {
				info( {
					message      : 'Passwords not matched. Please try again.',
					ok           : function() {
						verifypassword( msg, pwd, fn )
					}
				} );
			} else {
				fn()
			}
		}
	} );
}

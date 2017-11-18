// revision show/hide
$( '.revision' ).click( function(e) {
	e.stopPropagation();
	$( this ).parent().parent().next().toggle();
	$( this ).toggleClass( 'revisionup' );
} );
// sroll up click
$( '#list li' ).click( function() {
	var alias = this.getAttribute( 'alias' );
	document.getElementById( alias ).scrollIntoView( true );
	window.scrollBy( 0, -15 );
} );
// sroll top
$( 'legend' ).click( function() {
	window.scrollTo( 0, 0 );
} );

// branch test
$( '.btnbranch' ).each( function() {
	var $thisbtn = $( this );
	var hammerbtn = new Hammer( this );
	hammerbtn.on( 'press', function () {
		opt = '';
		branch = '';
		alias = $thisbtn.parent().attr( 'alias' );
		type = $thisbtn.text().trim() === 'Install' ? 'Install' : 'Update';
		title = $thisbtn.parent().prev().prev().find( 'span' ).text();
		info( {
			  title    : title
			, message  : type +' Branch Test?'
			, textlabel: 'Branch'
			, textvalue: 'UPDATE'
			, cancel   : 1
			, ok       : function() {
				branch = $( '#infoTextbox' ).val() +' -b';
				option = addons[ alias ].option;
				if ( type === 'Install' && option ) {
					j = 0;
					getoptions();
				} else {
					opt += branch;
					formtemp();
				}
			}
		} );
	} );
} );	
$( '.boxed-group .btn' ).click( function () {
	if ( $( this ).hasClass( 'btnneedspace' ) ) {
		
		info( {
			  icon   : '<i class="fa fa-info-circle fa-2x"></i>'
			, title  : 'Warning'
			, message: 'Disk space not enough.<br>'
					+ $( this ).attr( 'diskspace' )
		} );
		return
	}
	var $thisbtn = $( this );
	opt = '';
	branch = '';
	alias = $thisbtn.parent().attr( 'alias' );
	type = $thisbtn.text().trim();
	title = $thisbtn.parent().prev().prev().find( 'span' ).text();
	
	if ( alias === 'bash' ) {
		option = addons[ alias ].option;
		j = 0;
		getoptions();
	} else if ( type === 'Link' ) {
		window.open( $thisbtn.prev().find( 'a' ).attr( 'href' ), '_blank' );
	} else {
		info( {
			  title  : title
			, message: type +'?'
			, cancel : 1
			, ok     : function () {
				option = addons[ alias ].option;
				if ( type === 'Update' || type === 'Uninstall' || !option ) {
					formtemp();
				} else {
					j = 0;
					getoptions();
				}
			}
		} );
	}
} );
$( '.thumbnail' ).click( function() {
	$sourcecode = $( this ).prev().find('form a').attr( 'href');
	if ( $sourcecode ) window.open( $sourcecode, '_blank' );
} );

function getoptions() {
	okey = Object.keys( option );
	olength = okey.length;
	oj = okey[ j ];
	oj0 = oj.replace( /[0-9]/, '' ); // remove trailing # from option keys
	switch( oj0 ) {
// -------------------------------------------------------------------------------------------------
		case 'wait':
			info( {
				  icon         : '<i class="fa fa-info-circle fa-2x">'
				, title        : title
				, message      : option[ oj ]
				, ok           : function() {
					sendcommand();
				}
			} );
			break;
// -------------------------------------------------------------------------------------------------
		case 'confirm':
			info( {
				  title        : title
				, message      : option[ oj ]
				, cancel       : 1
				, ok           : function() {
					sendcommand();
				}
			} );
			break;
// -------------------------------------------------------------------------------------------------
		case 'yesno':
			info( {
				  title        : title
				, message      : option[ oj ]
				, cancellabel  : 'No'
				, cancel       : function() {
					opt += '0 ';
					sendcommand();
				}
				, oklabel      : 'Yes'
				, ok           : function() {
					opt += '1 ';
					sendcommand();
				}
			} );
			break;
// -------------------------------------------------------------------------------------------------
		case 'text':
			var ojson = option[ oj ];
			info( {
				  title        : title
				, message      : ojson.message
				, textlabel    : ojson.label
				, textvalue    : ojson.value
				, ok         : function() {
					var input = $( '#infoTextbox' ).val();
					opt += ( input ? input : 0 ) +' ';
					sendcommand();
				}
			} );
			break;
// -------------------------------------------------------------------------------------------------
		case 'password':
			ojson = option[ oj ];
			var msg = ojson.message;
			info( {
				  title        : title
				, message      : msg
				, passwordlabel: ojson.label
				, ok:          function() {
					var pwd = $( '#infoPasswordbox' ).val();
					if ( pwd ) {
						verifypassword( msg, pwd, function() {
							opt += pwd +' ';
							sendcommand();
						} );
					} else {
						opt += '0 ';
						sendcommand();
					}
				}
			} );
			break;
// -------------------------------------------------------------------------------------------------
		case 'radio':
			ojson = option[ oj ];
			info( {
				  title        : title
				, message      : ojson.message
				, radiohtml    : function() {
					var list = ojson.list;
					var radiohtml = '';
					for ( var key in list ) {
						var checked = ( key[ 0 ] === '*' ) ? ' checked' : '';
						radiohtml += '<label><input type="radio" name="inforadio" value="'+ list[ key ] +'"'+ checked +'>&ensp;'+ key.replace( /^\*/, '' ) +'</label><br>';
					}
					return radiohtml
				}
				, ok           : function() {
					var radiovalue = $( '#infoRadio input[type=radio]:checked').val();
					opt += radiovalue +' ';
					sendcommand();
				}
			} );
			$( '#infoRadio input' ).change( function() { // cutom value
				if ( $( this ).val() === '?' ) {
					info( {
						  title       : title
						, message     : ojson.message
						, textlabel   : 'Custom'
						, ok          : function() {
							var input = $( '#infoTextbox' ).val();
							opt += ( input ? input : 0 ) +' ';
							sendcommand();
						}
					} );
				}
			} );
			break;
// -------------------------------------------------------------------------------------------------
		case 'checkbox':
			ojson = option[ oj ];
			info( {
				  title        : title
				, message      : ojson.message
				, checkboxhtml : function() {
					var list = ojson.list;
					var checkboxhtml = '';
					for ( var key in list ) {
						var checked = ( key[ 0 ] === '*' ) ? ' checked' : '';
						checkboxhtml += '<label><input type="checkbox" value="'+ list[ key ] +'"'+ checked +'>\
							&ensp;'+ key.replace( /^\*/, '' ) +'</label><br>';
					}
					return checkboxhtml
				}
				, ok:       function() {
					$( '#infoCheckbox input[type=checkbox]').each( function() {
						opt += ( $( this ).is( ':checked' ) ? 1 : 0 ) +' ';
					} );
					sendcommand();
				}
			} );
			break;
// -------------------------------------------------------------------------------------------------
		case 'select':
			ojson = option[ oj ];
			info( {
				  title        : title
				, message      : ojson.message
				, selectlabel  : ojson.label
				, selecthtml   : function() {
					var list = ojson.list;
					var selecthtml = '';
					for ( var key in list ) {
						var selected = ( key[ 0 ] === '*' ) ? ' selected' : '';
						selecthtml += '<option value="'+ list[ key ] +'"'+ selected +'>'+ key.replace( /^\*/, '' ) +'</option>';
					}
					return selecthtml
				}
				, ok           : function() {
					opt += $( '#infoSelectbox').val() +' ';
					sendcommand();
				}
			} );
			$( '#infoSelectbox' ).change( function() { // cutom value
				if ( $( '#infoSelectbox :selected' ).val() === '?' ) {
					info( {
						  title        : title
						, message      : ojson.message
						, textlabel    : 'Custom'
						, ok           : function() {
							var input = $( '#infoTextbox' ).val();
							opt += ( input ? input : 0 ) +' ';
							sendcommand();
						}
					} );
				}
			} );
			break;
// -------------------------------------------------------------------------------------------------
	}
}

function sendcommand() {
	j++;
	if ( j < olength ) {
		getoptions();
	} else {
		if ( alias === 'bash' ) {
			if ( opt[ 0 ] !== '/' ) {
				opt = '/usr/bin/'+ opt;
				opt = opt.replace( /\s*;\s*/g, '; /usr/bin/' );
			}
		}
		$( '#loader' ).show();
		opt += branch;
		formtemp();
	}
}
// post submit with temporary form (separate option to hide password)
function formtemp() {
	var prewidth = document.getElementsByClassName( 'container' )[ 0 ].offsetWidth - 50; // width for title lines
	
	$( 'body' ).append( '\
		<form id="formtemp" action="addonsbash.php" method="post">\
			<input type="hidden" name="alias" value="'+ alias +'">\
			<input type="hidden" name="type" value="'+ type +'">\
			<input type="hidden" name="opt" value="'+ opt +'">\
			<input type="hidden" name="prewidth" value="'+ prewidth +'">\
		</form>\
	' );
	$( '#formtemp' ).submit();
}

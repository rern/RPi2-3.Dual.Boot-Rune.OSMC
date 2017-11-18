#!/bin/bash

# default variables and functions for addons install/uninstall scripts

lcolor() {
	local color=6
	[[ $2 ]] && color=$2
	tty -s && col=$( tput cols ) || col=80 # [[ -t 1 ]] not work
	printf "\e[38;5;${color}m%*s\e[0m\n" $col | tr ' ' "$1"
}
tcolor() { 
	local color=6 back=0  # default
	[[ $2 ]] && color=$2
	[[ $3 ]] && back=$3
	echo -e "\e[38;5;${color}m\e[48;5;${back}m${1}\e[0m"
}

bar=$( tcolor ' . ' 6 6 )   # [   ]     (cyan on cyan)
info=$( tcolor ' i ' 0 3 )  # [ i ]     (black on yellow)
yn=$( tcolor ' ? ' 0 3 )  # [ i ]       (black on yellow)
warn=$( tcolor ' ! ' 7 1 )  # [ ! ]     (white on red)

title() {
	local ctop=6
	local cbottom=6
	local ltop='-'
	local lbottom='-'
	local notop=0
	local nobottom=0
	
	while :; do
		case $1 in
			-c) ctop=$2
				cbottom=$2
				shift;; # 1st shift
			-ct) ctop=$2
				shift;;
			-cb) cbottom=$2
				shift;;
			-l) ltop=$2
				lbottom=$2
				shift;;
			-lt) ltop=$2
				shift;;
			-lb) lbottom=$2
				shift;;
			-nt) notop=1;;        # no 'shift' for option without value
			-nb) nobottom=1;;
			-h|-\?|--help) usage
				return 0;;
			-?*) echo "$info unknown option: $1"
				echo $( tcolor 'title -h' 3 ) for information
				echo
				return 0;;
			*) break
		esac
		# shift 1 out of argument array '$@'
		# 1.option + 1.value - shift twice
		# 1.option + 0.without value - shift once
		shift
	done
	
	echo
	[[ $notop == 0 ]] && echo $( lcolor $ltop $ctop )
	echo -e "${@}" # $@ > "${@}" - preserve spaces 
	[[ $nobottom == 0 ]] && echo $( lcolor $lbottom $cbottom )
}

# for install/uninstall scripts ##############################################################

yesno() { # $1: header string; $2 : optional return variable (default - answer)
	echo
	echo -e "$yn $1"
	echo -e '  \e[36m0\e[m No'
	echo -e '  \e[36m1\e[m Yes'
	echo
	echo -e '\e[36m0\e[m / 1 ? '
	read -n 1 answer
	echo
	[[ $2 ]] && eval $2=$answer
}
setpwd() { #1 : optional return variable (default - pwd1)
	echo
	echo -e "$yn Password: "
	read -s pwd1
	echo
	echo 'Retype password: '
	read -s pwd2
	echo
	if [[ $pwd1 != $pwd2 ]]; then
		echo
		echo "$info Passwords not matched. Try again."
		setpwd
	fi
	[[ $1 ]] && eval $1=$pwd1
}

timestart() { # timelapse: any argument
	time0=$( date +%s )
	[[ $1 ]] && timelapse0=$( date +%s )
}
timestop() { # timelapse: any argument
	time1=$( date +%s )
	if [[ $1 ]]; then
		dif=$(( $time1 - $timelapse0 ))
		stringlapse=' (timelapse)'
	else
		dif=$(( $time1 - $time0 ))
		stringlapse=''
	fi
	min=$(( $dif / 60 ))
	(( ${#min} == 1 )) && min=0$min
	sec=$(( $dif % 60 ))
	(( ${#sec} == 1 )) && sec=0$sec
	echo -e "\nDuration$stringlapse ${min}:$sec"
}

wgetnc() {
	[[ -t 1 ]] && progress='--show-progress'
	wget -qN $progress $@
}
getvalue() { # $1-key
	echo "$addonslist" |
		grep $1'.*=>' |
		cut -d '>' -f 2 |
		sed $'s/^ [\'"]//; s/[\'"],$//; s/\s*\*$//'
}
rankmirrors() {
	if grep -q 'Server = http://mirror.archlinuxarm.org/' /etc/pacman.d/mirrorlist; then
		wgetnc https://github.com/rern/RuneAudio/raw/master/rankmirrors/rankmirrors.sh
		chmod +x rankmirrors.sh
		./rankmirrors.sh
	else
		pacman -Sy
	fi
}
getinstallzip() {
	installurl=$( getvalue installurl )
	installzip=${installurl/raw\/master\/install.sh/archive\/$branch.zip}
	
	echo -e "$bar Get files ..."
	wgetnc $installzip

	echo -e "$bar Install new files ..."
	rm -rf  /tmp/install
	mkdir -p /tmp/install
	bsdtar -xvf $branch.zip --strip 1 --exclude '.*' --exclude '*.md' --exclude 'install.sh' -C /tmp/install

	rm $branch.zip /tmp/install/* &> /dev/null
	
	if [[ -e /tmp/install/root && -L /root ]]; then # fix 0.4b /root as symlink
		mkdir /tmp/install/home
		mv /tmp/install/{,home/}root
	fi
	chown -R http:http /tmp/install/srv
	chmod -R 755 /tmp/install
	if [[ -e /tmp/install/etc/systemd/system ]]; then
		chown -R root:root /tmp/install/etc/systemd/system
		chmod -R 644 /tmp/install/etc/systemd/system
	fi
	
	cp -rfp /tmp/install/* /
	rm -rf /tmp/install
}
getuninstall() {
	installurl=$( getvalue installurl )
	installurl=${installurl/raw\/master/raw\/$branch}
	uninstallurl=${installurl/install.sh/uninstall_$alias.sh}
	wgetnc $uninstallurl -P /usr/local/bin
	if [[ $? != 0 ]]; then
		title -l '=' "$warn Uninstall file download failed."
		title -nt "Please try install again."
		exit
	fi
	chmod +x /usr/local/bin/uninstall_$alias.sh
}
notify() { # $1-i=install $2-s=start
	[[ $alias == addo ]] && return
	[[ $2 == i ]] && type='Install' || type='Uninstall'
	if [[ $3 == s ]]; then
		data=$( cat <<EOF
			{
				  "icon" : "fa fa-info-circle fa-lg"
				, "title": "${type}ing ..."
				, "text" : "$1 \nRuneAudio may not response until finished."
				, "hide" : false
			}
EOF
		)
	else
		data=$( cat <<EOF
			{
				  "icon" : "fa fa-check"
				, "title": "Done"
				, "text" : "$1 \n${type}ation."
			}
EOF
		)
	fi

	curl -s -v -X POST 'http://localhost/pub?id=notify' -d "$data" &> /dev/null
}
installstart() { # $1-'u'=update
	rm $0
	
	addonslist=$( sed -n "/'$alias'/,/^),/p" /srv/http/addonslist.php )
	title0=$( getvalue title )
	title=$( tcolor "$title0" )
	
	if [[ -e /usr/local/bin/uninstall_$alias.sh ]]; then
	  title -l '=' "$info $title already installed."
	  title -nt "Please try update instead."
	  redis-cli hset addons $alias 1 &> /dev/null
	  exit
	fi
	
	timestart
	notify "$title0" i s
	
	# for testing branch
	if [[ ${@:$#} == '-b' ]]; then
		branch=${@:(-2):1}
	else
		branch=master
	fi
	
	[[ $1 != u ]] && title -l '=' "$bar Install $title ..."
}
installfinish() { # $1-'u'=update
	version=$( getvalue version )
	redis-cli hset addons $alias $version &> /dev/null
	
	timestop
	notify "$title0" i
	
	if [[ $1 != u ]]; then
		title -l '=' "$bar $title installed successfully."
	else
		title -l '=' "$bar $title updated successfully."
	fi
}

uninstallstart() { # $1-'u'=update
	addonslist=$( sed -n "/'$alias'/,/^),/p" /srv/http/addonslist.php )
	title0=$( getvalue title )
	title=$( tcolor "$title0" )
	
	if [[ ! -e /usr/local/bin/uninstall_$alias.sh ]]; then
	  echo -e "$info $title not found."
	  redis-cli hdel addons $alias &> /dev/null
	  exit 1
	fi
	
	notify "$title0" u s

	[[ $1 != u ]] && type=Uninstall || type=Update
	title -l '=' "$bar $type $title ..."
}
uninstallfinish() { # $1-'u'=update
	rm $0
	
	redis-cli hdel addons $alias &> /dev/null

	notify "$title0" u

	[[ $1 == u ]] && exit
	
	title -l '=' "$bar $title uninstalled successfully."
}
clearcache() {
	[[ -t 1 ]] && systemctl reload php-fpm
	title -nt "$bar Restart local browser ..."
	if pgrep midori > /dev/null; then
		killall midori
		sleep 1
		xinit &> /dev/null &
	fi
}

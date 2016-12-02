if [ -d "$HOME/bin" ]; then
	PATH="$HOME/bin:$PATH"
fi

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
export VISUAL=vim
export EDITOR="$VISUAL"
export BROWSER="qutebrowser"
export PATH="$JAVA_HOME/bin:/home/ace/.gem/ruby/2.3.0/bin:$PATH"

color_fg="#ebdbb2"
color_icon="#cc4b47"

export notify_color_fg=$color_fg
export notify_icon_fg=$color_icon

function icon {
	export $1="%{F$color_icon}$2%{F$color_fg}"
}

icon VOL_ICON		"\uf028"
icon MUTE_ICON		"\uf026"
icon KEYBOARD_ICON	"\uf11c"
icon CLOCK_ICON		"\uf017"
icon CALENDAR_ICON	"\uf073"
icon REDSHIFT_ICON	"\uf042"
icon TV_ICON		"\uf26c"
icon VPN_ICON		"\uf0ac"
icon B_FULL_ICON	"\uf240"
icon B_MOST_ICON	"\uf241"
icon B_HALF_ICON	"\uf242"
icon B_LESS_ICON	"\uf243"
icon B_EMPTY_ICON	"\uf244"
icon UNLOCKED		"\uf084 \uf13e"
